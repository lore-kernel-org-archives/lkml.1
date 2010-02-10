Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab0BJPSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 10:18:00 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:44015 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab0BJPR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 10:17:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lvxi2zHHd74g9hb9bLBj9OGqL4sp8f9gmTlgz3AHh/HjsQcezYnAk5IoDohVC/Y5Fr
         ym9plC0I/sB42XBGeWdCtppYEQ+xyivJ8klVxOWtiugaZTXmdyY2gLbiqW0kYEQBUxnb
         ednNCAkxT08njiu5PldDNvOp6NfQDADyUQ76E=
Subject: Re: [PATCH 1/3] A device for zero-copy based on KVM virtio-net.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Xin Xiaohui <xiaohui.xin@intel.com>
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, mst@redhat.com, jdike@c2.user-mode-linux.org,
       Zhao Yu <yzhao81@gmail.com>
In-Reply-To: <1265802540-6122-2-git-send-email-xiaohui.xin@intel.com>
References: <1265802540-6122-1-git-send-email-xiaohui.xin@intel.com>
	 <1265802540-6122-2-git-send-email-xiaohui.xin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Feb 2010 16:17:51 +0100
Message-ID: <1265815071.3047.96.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 10 février 2010 à 19:48 +0800, Xin Xiaohui a écrit :
> Add a device to utilize the vhost-net backend driver for
> copy-less data transfer between guest FE and host NIC.
> It pins the guest user space to the host memory and
> provides proto_ops as sendmsg/recvmsg to vhost-net.
> 
> Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
> Signed-off-by: Zhao Yu <yzhao81@gmail.com>
> Sigend-off-by: Jeff Dike <jdike@c2.user-mode-linux.org>


> +static int page_ctor_attach(struct mp_struct *mp)
> +{
> +	int rc;
> +	struct page_ctor *ctor;
> +	struct net_device *dev = mp->dev;
> +
> +	rcu_read_lock();
> +	if (rcu_dereference(mp->ctor)) {
> +		rcu_read_unlock();
> +		return -EBUSY;
> +	}
> +	rcu_read_unlock();

Strange read locking here, for an obvious writer role.
What do you really want to do ?
If writer are serialized by mp_mutex, you dont need this
recu_read_lock()/rcu_read_unlock() stuff.

> +
> +	ctor = kzalloc(sizeof(*ctor), GFP_KERNEL);
> +	if (!ctor)
> +		return -ENOMEM;
> +	rc = netdev_page_ctor_prep(dev, &ctor->ctor);
> +	if (rc)
> +		goto fail;
> +
> +	ctor->cache = kmem_cache_create("skb_page_info",
> +			sizeof(struct page_info), 0,
> +			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);


SLAB_PANIC here means : crash whole system in case of error.
This is not what you want in a driver.

> +
> +	if (!ctor->cache)
> +		goto cache_fail;
> +
> +	INIT_LIST_HEAD(&ctor->readq);
> +	spin_lock_init(&ctor->read_lock);
> +
> +	ctor->w_len = 0;
> +	ctor->r_len = 0;
> +
> +	dev_hold(dev);
> +	ctor->dev = dev;
> +	ctor->ctor.ctor = page_ctor;
> +	ctor->ctor.sock = &mp->socket;
> +	atomic_set(&ctor->refcnt, 1);
> +
> +	rc = netdev_page_ctor_attach(dev, &ctor->ctor);
> +	if (rc)
> +		goto fail;
> +
> +	/* locked by mp_mutex */
> +	rcu_assign_pointer(mp->ctor, ctor);
> +
> +	/* XXX:Need we do set_offload here ? */
> +
> +	return 0;
> +
> +fail:
> +	kmem_cache_destroy(ctor->cache);
> +cache_fail:
> +	kfree(ctor);
> +	dev_put(dev);
> +
> +	return rc;
> +}
> +
> +
> +static inline void get_page_ctor(struct page_ctor *ctor)
> +{
> +       atomic_inc(&ctor->refcnt);
> +}
> +
> +static inline void put_page_ctor(struct page_ctor *ctor)
> +{
> +	if (atomic_dec_and_test(&ctor->refcnt))
> +		kfree(ctor);

Are you sure a RCU grace period is not needed before freeing ?


> +
> +static int page_ctor_detach(struct mp_struct *mp)
> +{
> +	struct page_ctor *ctor;
> +	struct page_info *info;
> +	int i;
> +
> +	rcu_read_lock();
> +	ctor = rcu_dereference(mp->ctor);
> +	rcu_read_unlock();

Strange locking again here


> +
> +	if (!ctor)
> +		return -ENODEV;
> +
> +	while ((info = info_dequeue(ctor))) {
> +		for (i = 0; i < info->pnum; i++)
> +			if (info->pages[i])
> +				put_page(info->pages[i]);
> +		kmem_cache_free(ctor->cache, info);
> +	}
> +	kmem_cache_destroy(ctor->cache);
> +	netdev_page_ctor_detach(ctor->dev);
> +	dev_put(ctor->dev);
> +
> +	/* locked by mp_mutex */
> +	rcu_assign_pointer(mp->ctor, NULL);
> +	synchronize_rcu();
> +
> +	put_page_ctor(ctor);
> +
> +	return 0;
> +}
> +
> +/* For small user space buffers transmit, we don't need to call
> + * get_user_pages().
> + */
> +static struct page_info *alloc_small_page_info(struct page_ctor *ctor,
> +		int total)
> +{
> +	struct page_info *info = kmem_cache_alloc(ctor->cache, GFP_KERNEL);
kmem_cache_zalloc() ?
> +
> +	if (!info)
> +		return NULL;
> +	memset(info, 0, sizeof(struct page_info));
> +	memset(info->pages, 0, sizeof(info->pages));

redundant memset() whole structure already cleared one line above

> +
> +	info->header = 0;
already cleared
> +	info->total = total;
> +	info->skb = NULL;
already cleared 
> 
> +	info->user.dtor = page_dtor;
> +	info->ctor = ctor;
> +	info->flags = INFO_WRITE;
> +	info->pnum = 0;
already cleared 
> 
> +	return info;
> +}
> +
> +/* The main function to transform the guest user space address
> + * to host kernel address via get_user_pages(). Thus the hardware
> + * can do DMA directly to the user space address.
> + */
> +static struct page_info *alloc_page_info(struct page_ctor *ctor,
> +			struct iovec *iov, int count, struct frag *frags,
> +			int npages, int total)
> +{
> +	int rc;
> +	int i, j, n = 0;
> +	int len;
> +	unsigned long base;
> +	struct page_info *info = kmem_cache_alloc(ctor->cache, GFP_KERNEL);
kmem_cache_zalloc() ? 
> 
> +
> +	if (!info)
> +		return NULL;
> +	memset(info, 0, sizeof(struct page_info));
kmem_cache_zalloc() ?
> +	memset(info->pages, 0, sizeof(info->pages));
already cleared 
> 
> +
> +	down_read(&current->mm->mmap_sem);
> +	for (i = j = 0; i < count; i++) {
> +		base = (unsigned long)iov[i].iov_base;
> +		len = iov[i].iov_len;
> +
> +		if (!len)
> +			continue;
> +		n = ((base & ~PAGE_MASK) + len + ~PAGE_MASK) >> PAGE_SHIFT;
> +
> +		rc = get_user_pages(current, current->mm, base, n,
> +				npages ? 1 : 0, 0, &info->pages[j], NULL);
> +		if (rc != n) {
> +			up_read(&current->mm->mmap_sem);
> +			goto failed;
> +		}
> +
> +		while (n--) {
> +			frags[j].offset = base & ~PAGE_MASK;
> +			frags[j].size = min_t(int, len,
> +					PAGE_SIZE - frags[j].offset);
> +			len -= frags[j].size;
> +			base += frags[j].size;
> +			j++;
> +		}
> +	}
> +	up_read(&current->mm->mmap_sem);
> +
> +#ifdef CONFIG_HIGHMEM
> +	if (npages && !(dev->features & NETIF_F_HIGHDMA)) {
> +		for (i = 0; i < j; i++) {
> +			if (PageHighMem(info->pages[i]))
> +				goto failed;
> +		}
> +	}
> +#endif
> +
> +	info->header = 0;
> +	info->total = total;
> +	info->skb = NULL;
> +	info->user.dtor = page_dtor;
> +	info->ctor = ctor;
> +	info->pnum = j;
> +
> +	if (!npages)
> +		info->flags = INFO_WRITE;
> +	if (info->flags == INFO_READ) {
> +		info->user.start = (u8 *)(((unsigned long)
> +				(pfn_to_kaddr(page_to_pfn(info->pages[0]))) +
> +				frags[0].offset) - NET_IP_ALIGN - NET_SKB_PAD);
> +		info->user.size = iov[0].iov_len + NET_IP_ALIGN + NET_SKB_PAD;
> +	}
> +	return info;
> +
> +failed:
> +	for (i = 0; i < j; i++)
> +		put_page(info->pages[i]);
> +
> +	kmem_cache_free(ctor->cache, info);
> +
> +	return NULL;
> +}
> +
> +struct page_ctor *mp_rcu_get_ctor(struct page_ctor *ctor)
> +{
> +	struct page_ctor *_ctor = NULL;
> +
> +	rcu_read_lock();
> +	_ctor = rcu_dereference(ctor);
> +	rcu_read_unlock();
strange locking. After rcu_read_unlock() you have no guarantee _ctor
points to something not freed.
> +
> +	if (!_ctor) {
> +		DBG(KERN_INFO "Device %s cannot do mediate passthru.\n",
> +				ctor->dev->name);
> +		return NULL;
> +	}
> +	if (_ctor)
redundant test
> +		get_page_ctor(_ctor);
> +	return _ctor;
> +}
> +

I stopped my review at this point. Please check your RCU usages. It is
not sufficient to hold rcu read lock just to fetch the pointer, you also
must hold the lock while using the object itself, or get a reference on
object before release RCU lock, to make sure object wont disappear under
you...

for example :

rcu_read_lock();
ptr = rcu_dereference(...);
if (ptr)
	atomic_inc(&ptr->refcnt);
rcu_read_unlock();






