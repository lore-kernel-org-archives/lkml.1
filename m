Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbYFRWbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbYFRWbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 18:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbYFRWb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 18:31:28 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:63190 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774AbYFRWb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 18:31:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rIJKXuhOaHXxOBV4a4d1/MtuPxPwxnGg+Vw3FI7+PKOIfRjJAvzPjS1Z2vb/ge8tVz
         RWr4Eir1qdAwEGPruMeCMBh8wolNjQRb5OUShprz1+7fbqmnmZbXhWyVTeWZOswJBbS6
         RdGi6bgPCpybczF0vua9EpD1h3yq+I9ak5C84=
Message-ID: <48598CB7.2000507@gmail.com>
Date: Thu, 19 Jun 2008 00:31:19 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Swiftdove 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Carl Henrik Lunde <chlunde@ping.uio.no>
CC: balbir@linux.vnet.ibm.com, menage@google.com, matt@bluehost.com,
       roberto@unbit.it, randy.dunlap@oracle.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] i/o bandwidth controller infrastructure
References: <1212791250-32320-3-git-send-email-righi.andrea@gmail.com> <20080618175710.GA2737@ping.uio.no>
In-Reply-To: <20080618175710.GA2737@ping.uio.no>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carl Henrik Lunde wrote:
> On Sat, Jun 07, 2008 at 12:27:29AM +0200, Andrea Righi wrote:
>> This is the core io-throttle kernel infrastructure. It creates the basic
>> interfaces to cgroups and implements the I/O measurement and throttling
>> functions.
> [...]
>> +void cgroup_io_account(struct block_device *bdev, size_t bytes)
> [...]
>> +	/* Account the I/O activity  */
>> +	node->req += bytes;
>> +
>> +	/* Evaluate if we need to throttle the current process */
>> +	delta = (long)jiffies - (long)node->last_request;
>> +	if (!delta)
>> +		goto out;
>> +
>> +	t = msecs_to_jiffies(node->req / node->iorate);
>> +	if (!t)
>> +		goto out;
>> +
>> +	sleep = t - delta;
>> +	if (unlikely(sleep > 0)) {
>> +		spin_unlock_irq(&iot->lock);
>> +		if (__cant_sleep())
>> +			return;
>> +		pr_debug("io-throttle: task %p (%s) must sleep %lu jiffies\n",
>> +			 current, current->comm, sleep);
>> +		schedule_timeout_killable(sleep);
>> +		return;
>> +	}
>> +
>> +	/* Reset I/O accounting */
>> +	node->req = 0;
>> +	node->last_request = jiffies;
> [...]
> 
> Did you consider using token bucket instead of this (leaky bucket?)?
> 
> I've attached a patch which implements token bucket.  Although not as
> precise as the leaky bucket the performance is better at high bandwidth
> streaming loads.

Interesting! it could be great to have both available at runtime and
just switch between leaky or token bucket, e.g. by echo-ing "leaky" or
"token" to a file in the cgroup filesystem, ummm, block.limiting-algorithm?

> 
> The leaky bucket stops at around 53 MB/s while token bucket works for
> up to 64 MB/s.  The baseline (no cgroups) is 66 MB/s.
> 
> benchmark:
> two streaming readers (fio) with block size 128k, bucket size 4 MB
> 90% of the bandwidth was allocated to one process, the other gets 10%

Thanks for posting the results, I'll look closely at your patch, test
it as well and try merge your work.

I also did some improvements in v2 in terms of scalability, in
particular I've replaced the rbtree with a liked list, in order to
remove the spinlocks and replace them by RCU to protect the list
structure. I need to do some stress tests before, but I'll post a v3
soon.

Some minor comments below for now.

> diff --git a/block/blk-io-throttle.c b/block/blk-io-throttle.c
> index 804df88..9ed0c7c 100644
> --- a/block/blk-io-throttle.c
> +++ b/block/blk-io-throttle.c
> @@ -40,7 +40,8 @@ struct iothrottle_node {
>  	struct rb_node node;
>  	dev_t dev;
>  	unsigned long iorate;
> -	unsigned long req;
> +	long bucket_size; /* Max value for t */
> +	long t;
>  	unsigned long last_request;
>  };
>  
> @@ -180,18 +181,20 @@ static ssize_t iothrottle_read(struct cgroup *cont,
>  	iothrottle_for_each(n, &iot->tree) {
>  		struct iothrottle_node *node =
>  				rb_entry(n, struct iothrottle_node, node);
> -		unsigned long delta = (long)jiffies - (long)node->last_request;
> +		unsigned long delta = (((long)jiffies - (long)node->last_request) * 1000) / HZ;

Better to use jiffies_to_msecs() here.

>  
>  		BUG_ON(!node->dev);
>  		s += snprintf(s, nbytes - (s - buffer),
>  				  "=== device (%u,%u) ===\n"
>  				  "bandwidth-max: %lu KiB/sec\n"
> -				  "    requested: %lu bytes\n"
> -				  " last request: %lu jiffies\n"
> -				  "        delta: %lu jiffies\n",
> +				  "bucket size  : %ld KiB\n"
> +				  "bucket fill  : %ld KiB (after last request)\n"
> +				  "last request : %lu ms ago\n",
>  				  MAJOR(node->dev), MINOR(node->dev),
> -				  node->iorate, node->req,
> -				  node->last_request, delta);
> +				  node->iorate,
> +				  node->bucket_size / 1024,
> +				  node->t / 1024,
> +				  delta);
>  	}
>  	spin_unlock_irq(&iot->lock);
>  	buffer[nbytes] = '\0';
> @@ -220,21 +223,33 @@ static inline dev_t devname2dev_t(const char *buf)
>  	return ret;
>  }
>  
> -static inline int iothrottle_parse_args(char *buf, size_t nbytes,
> -					dev_t *dev, unsigned long *val)
> +static inline int iothrottle_parse_args(char *buf, size_t nbytes, dev_t *dev,
> +					unsigned long *iorate,
> +					unsigned long *bucket_size)
>  {
> -	char *p;
> +	char *ioratep, *bucket_sizep;
>  
> -	p = memchr(buf, ':', nbytes);
> -	if (!p)
> +	ioratep = memchr(buf, ':', nbytes);
> +	if (!ioratep)
>  		return -EINVAL;
> -	*p++ = '\0';
> +	*ioratep++ = '\0';
> +
> +	bucket_sizep = memchr(ioratep, ':', nbytes + ioratep - buf);
> +	if (!bucket_sizep)
> +		return -EINVAL;
> +	*bucket_sizep++ = '\0';
>  
>  	*dev = devname2dev_t(buf);
>  	if (!*dev)
>  		return -ENOTBLK;
>  
> -	return strict_strtoul(p, 10, val);
> +	if (strict_strtoul(ioratep, 10, iorate))
> +		return -EINVAL;
> +
> +	if (strict_strtoul(bucket_sizep, 10, bucket_size))
> +		return -EINVAL;
> +
> +	return 0;
>  }
>  
>  static ssize_t iothrottle_write(struct cgroup *cont,
> @@ -247,7 +262,7 @@ static ssize_t iothrottle_write(struct cgroup *cont,
>  	struct iothrottle_node *node, *tmpn = NULL;
>  	char *buffer, *tmpp;
>  	dev_t dev;
> -	unsigned long val;
> +	unsigned long iorate, bucket_size;
>  	int ret;
>  
>  	if (unlikely(!nbytes))
> @@ -265,7 +280,7 @@ static ssize_t iothrottle_write(struct cgroup *cont,
>  	buffer[nbytes] = '\0';
>  	tmpp = strstrip(buffer);
>  
> -	ret = iothrottle_parse_args(tmpp, nbytes, &dev, &val);
> +	ret = iothrottle_parse_args(tmpp, nbytes, &dev, &iorate, &bucket_size);
>  	if (ret)
>  		goto out1;
>  
> @@ -284,7 +299,7 @@ static ssize_t iothrottle_write(struct cgroup *cont,
>  	iot = cgroup_to_iothrottle(cont);
>  
>  	spin_lock_irq(&iot->lock);
> -	if (!val) {
> +	if (!iorate) {
>  		/* Delete a block device limiting rule */
>  		iothrottle_delete_node(iot, dev);
>  		ret = nbytes;
> @@ -293,8 +308,9 @@ static ssize_t iothrottle_write(struct cgroup *cont,
>  	node = iothrottle_search_node(iot, dev);
>  	if (node) {
>  		/* Update a block device limiting rule */
> -		node->iorate = val;
> -		node->req = 0;
> +		node->iorate = iorate;
> +		node->bucket_size = bucket_size * 1024;
> +		node->t = 0;
>  		node->last_request = jiffies;
>  		ret = nbytes;
>  		goto out3;
> @@ -307,8 +323,9 @@ static ssize_t iothrottle_write(struct cgroup *cont,
>  	node = tmpn;
>  	tmpn = NULL;
>  
> -	node->iorate = val;
> -	node->req = 0;
> +	node->iorate = iorate;
> +	node->bucket_size = bucket_size * 1024;
> +	node->t = 0;
>  	node->last_request = jiffies;
>  	node->dev = dev;
>  	ret = iothrottle_insert_node(iot, node);
> @@ -355,7 +372,7 @@ void cgroup_io_account(struct block_device *bdev, size_t bytes)
>  {
>  	struct iothrottle *iot;
>  	struct iothrottle_node *node;
> -	unsigned long delta, t;
> +	unsigned long delta;
>  	long sleep;
>  
>  	if (unlikely(!bdev))
> @@ -370,36 +387,37 @@ void cgroup_io_account(struct block_device *bdev, size_t bytes)
>  	spin_lock_irq(&iot->lock);
>  
>  	node = iothrottle_search_node(iot, bdev->bd_inode->i_rdev);
> -	if (!node || !node->iorate)
> -		goto out;
> -
> -	/* Account the I/O activity  */
> -	node->req += bytes;
> +	if (!node || !node->iorate) {
> +		spin_unlock_irq(&iot->lock);
> +		return;
> +	}
>  
> -	/* Evaluate if we need to throttle the current process */
> +	/* Add tokens for time elapsed since last read */
>  	delta = (long)jiffies - (long)node->last_request;
> -	if (!delta)
> -		goto out;
> +	if (delta) {
> +		node->last_request = jiffies;
> +		node->t += (node->iorate * 1024 * delta) / HZ;

The same here:
		node->t += node->iorate * 1024
			 * jiffies_to_msec(delta) * MSEC_PER_SEC;

>  
> -	t = msecs_to_jiffies(node->req / node->iorate);
> -	if (!t)
> -		goto out;
> +		if (node->t > node->bucket_size)
> +			node->t = node->bucket_size;
> +	}
>  
> -	sleep = t - delta;
> -	if (unlikely(sleep > 0)) {
> -		spin_unlock_irq(&iot->lock);
> -		if (__cant_sleep())
> -			return;
> -		pr_debug("io-throttle: task %p (%s) must sleep %lu jiffies\n",
> -			 current, current->comm, sleep);
> -		schedule_timeout_killable(sleep);
> -		return;
> +	/* Account the I/O activity  */
> +	node->t -= bytes;
> +
> +	if (node->t < 0) {
> +		sleep = (-node->t) * HZ / (node->iorate * 1024);

And again:
		sleep = msec_to_jiffies(-node->t / (node->iorate * 1024)
					* MSEC_PER_SEC);

> +	} else {
> +		sleep = 0;
>  	}
>  
> -	/* Reset I/O accounting */
> -	node->req = 0;
> -	node->last_request = jiffies;
> -out:
>  	spin_unlock_irq(&iot->lock);
> +
> +	if (sleep && !__cant_sleep()) {
> +		pr_debug("io-throttle: %s[%d] must sleep %ld jiffies\n",
> +			 current->comm, current->pid, sleep);
> +
> +		schedule_timeout_killable(sleep);
> +	}
>  }
>  EXPORT_SYMBOL(cgroup_io_account);

Thanks,
-Andrea
