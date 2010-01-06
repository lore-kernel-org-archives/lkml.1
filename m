Return-Path: <linux-kernel-owner+w=401wt.eu-S933086Ab0AFXsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086Ab0AFXsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933066Ab0AFXrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:47:39 -0500
Received: from kroah.org ([198.145.64.141]:34535 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932897Ab0AFXrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:47:37 -0500
Date: Wed, 6 Jan 2010 15:43:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.43
Message-ID: <20100106234347.GB1960@kroah.com>
References: <20100106234332.GA1960@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106234332.GA1960@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 552618b..dfd6ec4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .42
+EXTRAVERSION = .43
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 12fe589..a0db19c 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -416,14 +416,14 @@ static int genregs_get(struct task_struct *target,
 {
 	if (kbuf) {
 		unsigned long *k = kbuf;
-		while (count > 0) {
+		while (count >= sizeof(*k)) {
 			*k++ = getreg(target, pos);
 			count -= sizeof(*k);
 			pos += sizeof(*k);
 		}
 	} else {
 		unsigned long __user *u = ubuf;
-		while (count > 0) {
+		while (count >= sizeof(*u)) {
 			if (__put_user(getreg(target, pos), u++))
 				return -EFAULT;
 			count -= sizeof(*u);
@@ -442,14 +442,14 @@ static int genregs_set(struct task_struct *target,
 	int ret = 0;
 	if (kbuf) {
 		const unsigned long *k = kbuf;
-		while (count > 0 && !ret) {
+		while (count >= sizeof(*k) && !ret) {
 			ret = putreg(target, pos, *k++);
 			count -= sizeof(*k);
 			pos += sizeof(*k);
 		}
 	} else {
 		const unsigned long  __user *u = ubuf;
-		while (count > 0 && !ret) {
+		while (count >= sizeof(*u) && !ret) {
 			unsigned long word;
 			ret = __get_user(word, u++);
 			if (ret)
@@ -1159,14 +1159,14 @@ static int genregs32_get(struct task_struct *target,
 {
 	if (kbuf) {
 		compat_ulong_t *k = kbuf;
-		while (count > 0) {
+		while (count >= sizeof(*k)) {
 			getreg32(target, pos, k++);
 			count -= sizeof(*k);
 			pos += sizeof(*k);
 		}
 	} else {
 		compat_ulong_t __user *u = ubuf;
-		while (count > 0) {
+		while (count >= sizeof(*u)) {
 			compat_ulong_t word;
 			getreg32(target, pos, &word);
 			if (__put_user(word, u++))
@@ -1187,14 +1187,14 @@ static int genregs32_set(struct task_struct *target,
 	int ret = 0;
 	if (kbuf) {
 		const compat_ulong_t *k = kbuf;
-		while (count > 0 && !ret) {
+		while (count >= sizeof(*k) && !ret) {
 			ret = putreg32(target, pos, *k++);
 			count -= sizeof(*k);
 			pos += sizeof(*k);
 		}
 	} else {
 		const compat_ulong_t __user *u = ubuf;
-		while (count > 0 && !ret) {
+		while (count >= sizeof(*u) && !ret) {
 			compat_ulong_t word;
 			ret = __get_user(word, u++);
 			if (ret)
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 95c65e3..839d0f9 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1995,6 +1995,14 @@ EXPORT_SYMBOL_GPL(kvm_disable_tdp);
 
 static void free_mmu_pages(struct kvm_vcpu *vcpu)
 {
+	struct kvm_mmu_page *sp;
+
+	while (!list_empty(&vcpu->kvm->arch.active_mmu_pages)) {
+		sp = container_of(vcpu->kvm->arch.active_mmu_pages.next,
+				  struct kvm_mmu_page, link);
+		kvm_mmu_zap_page(vcpu->kvm, sp);
+		cond_resched();
+	}
 	free_page((unsigned long)vcpu->arch.mmu.pae_root);
 }
 
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index ddd09b7..9eb5f85 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -219,7 +219,7 @@ static void cmd64x_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 		regU |= udma_data[adev->dma_mode - XFER_UDMA_0] << shift;
 		/* Merge the control bits */
 		regU |= 1 << adev->devno; /* UDMA on */
-		if (adev->dma_mode > 2)	/* 15nS timing */
+		if (adev->dma_mode > XFER_UDMA_2) /* 15nS timing */
 			regU |= 4 << adev->devno;
 	} else {
 		regU &= ~ (1 << adev->devno);	/* UDMA off */
diff --git a/drivers/i2c/chips/tsl2550.c b/drivers/i2c/chips/tsl2550.c
index b96f302..ec0a7ca 100644
--- a/drivers/i2c/chips/tsl2550.c
+++ b/drivers/i2c/chips/tsl2550.c
@@ -277,6 +277,7 @@ static DEVICE_ATTR(operating_mode, S_IWUSR | S_IRUGO,
 
 static ssize_t __tsl2550_show_lux(struct i2c_client *client, char *buf)
 {
+	struct tsl2550_data *data = i2c_get_clientdata(client);
 	u8 ch0, ch1;
 	int ret;
 
@@ -296,6 +297,8 @@ static ssize_t __tsl2550_show_lux(struct i2c_client *client, char *buf)
 	ret = tsl2550_calculate_lux(ch0, ch1);
 	if (ret < 0)
 		return ret;
+	if (data->operating_mode == 1)
+		ret *= 5;
 
 	return sprintf(buf, "%d\n", ret);
 }
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 8b3ed77..d9fca29 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -1899,10 +1899,8 @@ static int lbs_get_essid(struct net_device *dev, struct iw_request_info *info,
 	if (priv->connect_status == LBS_CONNECTED) {
 		memcpy(extra, priv->curbssparams.ssid,
 		       priv->curbssparams.ssid_len);
-		extra[priv->curbssparams.ssid_len] = '\0';
 	} else {
 		memset(extra, 0, 32);
-		extra[priv->curbssparams.ssid_len] = '\0';
 	}
 	/*
 	 * If none, we may want to get the one that was set
diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index 85fcb43..b4ae447 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -143,6 +143,15 @@ dasd_diag_erp(struct dasd_device *device)
 
 	mdsk_term_io(device);
 	rc = mdsk_init_io(device, device->block->bp_block, 0, NULL);
+	if (rc == 4) {
+		if (!(device->features & DASD_FEATURE_READONLY)) {
+			dev_warn(&device->cdev->dev,
+				 "The access mode of a DIAG device changed"
+				 " to read-only");
+			device->features |= DASD_FEATURE_READONLY;
+		}
+		rc = 0;
+	}
 	if (rc)
 		DEV_MESSAGE(KERN_WARNING, device, "DIAG ERP unsuccessful, "
 			    "rc=%d", rc);
@@ -432,16 +441,20 @@ dasd_diag_check_device(struct dasd_device *device)
 	for (sb = 512; sb < bsize; sb = sb << 1)
 		block->s2b_shift++;
 	rc = mdsk_init_io(device, block->bp_block, 0, NULL);
-	if (rc) {
+	if (rc && (rc != 4)) {
 		DEV_MESSAGE(KERN_WARNING, device, "DIAG initialization "
 			"failed (rc=%d)", rc);
 		rc = -EIO;
 	} else {
+		if (rc == 4)
+			device->features |= DASD_FEATURE_READONLY;
 		DEV_MESSAGE(KERN_INFO, device,
-			    "(%ld B/blk): %ldkB",
+			    "(%ld B/blk): %ldkB%s",
 			    (unsigned long) block->bp_block,
 			    (unsigned long) (block->blocks <<
-				block->s2b_shift) >> 1);
+				block->s2b_shift) >> 1,
+				(rc == 4) ? ", read-only device" : "");
+		rc = 0;
 	}
 out_label:
 	free_page((long) label);
diff --git a/fs/namei.c b/fs/namei.c
index 2259d21..e6c73de 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -220,6 +220,7 @@ int generic_permission(struct inode *inode, int mask,
 	/*
 	 * Searching includes executable on directories, else just read.
 	 */
+	mask &= MAY_READ | MAY_WRITE | MAY_EXEC;
 	if (mask == MAY_READ || (S_ISDIR(inode->i_mode) && !(mask & MAY_WRITE)))
 		if (capable(CAP_DAC_READ_SEARCH))
 			return 0;
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 113028f..2444076 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -342,8 +342,15 @@ static inline int ipv6_prefix_equal(const struct in6_addr *a1,
 
 struct inet_frag_queue;
 
+enum ip6_defrag_users {
+	IP6_DEFRAG_LOCAL_DELIVER,
+	IP6_DEFRAG_CONNTRACK_IN,
+	IP6_DEFRAG_CONNTRACK_OUT,
+};
+
 struct ip6_create_arg {
 	__be32 id;
+	u32 user;
 	struct in6_addr *src;
 	struct in6_addr *dst;
 };
diff --git a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
index abc55ad..1ee717e 100644
--- a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
+++ b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
@@ -9,7 +9,7 @@ extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6;
 
 extern int nf_ct_frag6_init(void);
 extern void nf_ct_frag6_cleanup(void);
-extern struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb);
+extern struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb, u32 user);
 extern void nf_ct_frag6_output(unsigned int hooknum, struct sk_buff *skb,
 			       struct net_device *in,
 			       struct net_device *out,
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 85050c0..3abaec7 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -183,6 +183,16 @@ out:
 	return nf_conntrack_confirm(skb);
 }
 
+static enum ip6_defrag_users nf_ct6_defrag_user(unsigned int hooknum,
+						struct sk_buff *skb)
+{
+	if (hooknum == NF_INET_PRE_ROUTING)
+		return IP6_DEFRAG_CONNTRACK_IN;
+	else
+		return IP6_DEFRAG_CONNTRACK_OUT;
+
+}
+
 static unsigned int ipv6_defrag(unsigned int hooknum,
 				struct sk_buff *skb,
 				const struct net_device *in,
@@ -195,8 +205,7 @@ static unsigned int ipv6_defrag(unsigned int hooknum,
 	if (skb->nfct)
 		return NF_ACCEPT;
 
-	reasm = nf_ct_frag6_gather(skb);
-
+	reasm = nf_ct_frag6_gather(skb, nf_ct6_defrag_user(hooknum, skb));
 	/* queued */
 	if (reasm == NULL)
 		return NF_STOLEN;
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 52d06dd..6011bad 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -198,13 +198,14 @@ out:
 /* Creation primitives. */
 
 static __inline__ struct nf_ct_frag6_queue *
-fq_find(__be32 id, struct in6_addr *src, struct in6_addr *dst)
+fq_find(__be32 id, u32 user, struct in6_addr *src, struct in6_addr *dst)
 {
 	struct inet_frag_queue *q;
 	struct ip6_create_arg arg;
 	unsigned int hash;
 
 	arg.id = id;
+	arg.user = user;
 	arg.src = src;
 	arg.dst = dst;
 
@@ -589,7 +590,7 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp, int *prevhoff, int *fhoff)
 	return 0;
 }
 
-struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb)
+struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb, u32 user)
 {
 	struct sk_buff *clone;
 	struct net_device *dev = skb->dev;
@@ -635,7 +636,7 @@ struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb)
 	if (atomic_read(&nf_init_frags.mem) > nf_init_frags.high_thresh)
 		nf_ct_frag6_evictor();
 
-	fq = fq_find(fhdr->identification, &hdr->saddr, &hdr->daddr);
+	fq = fq_find(fhdr->identification, user, &hdr->saddr, &hdr->daddr);
 	if (fq == NULL) {
 		pr_debug("Can't find and can't create new queue\n");
 		goto ret_orig;
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 89184b5..d2fff41 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -72,6 +72,7 @@ struct frag_queue
 	struct inet_frag_queue	q;
 
 	__be32			id;		/* fragment id		*/
+	u32			user;
 	struct in6_addr		saddr;
 	struct in6_addr		daddr;
 
@@ -140,7 +141,7 @@ int ip6_frag_match(struct inet_frag_queue *q, void *a)
 	struct ip6_create_arg *arg = a;
 
 	fq = container_of(q, struct frag_queue, q);
-	return (fq->id == arg->id &&
+	return (fq->id == arg->id && fq->user == arg->user &&
 			ipv6_addr_equal(&fq->saddr, arg->src) &&
 			ipv6_addr_equal(&fq->daddr, arg->dst));
 }
@@ -162,6 +163,7 @@ void ip6_frag_init(struct inet_frag_queue *q, void *a)
 	struct ip6_create_arg *arg = a;
 
 	fq->id = arg->id;
+	fq->user = arg->user;
 	ipv6_addr_copy(&fq->saddr, arg->src);
 	ipv6_addr_copy(&fq->daddr, arg->dst);
 }
@@ -243,6 +245,7 @@ fq_find(struct net *net, __be32 id, struct in6_addr *src, struct in6_addr *dst,
 	unsigned int hash;
 
 	arg.id = id;
+	arg.user = IP6_DEFRAG_LOCAL_DELIVER;
 	arg.src = src;
 	arg.dst = dst;
 
diff --git a/sound/mips/sgio2audio.c b/sound/mips/sgio2audio.c
index 4c63504..c1b777d 100644
--- a/sound/mips/sgio2audio.c
+++ b/sound/mips/sgio2audio.c
@@ -609,7 +609,7 @@ static int snd_sgio2audio_pcm_hw_params(struct snd_pcm_substream *substream,
 	/* alloc virtual 'dma' area */
 	if (runtime->dma_area)
 		vfree(runtime->dma_area);
-	runtime->dma_area = vmalloc(size);
+	runtime->dma_area = vmalloc_user(size);
 	if (runtime->dma_area == NULL)
 		return -ENOMEM;
 	runtime->dma_bytes = size;
diff --git a/sound/pcmcia/pdaudiocf/pdaudiocf_pcm.c b/sound/pcmcia/pdaudiocf/pdaudiocf_pcm.c
index 01066c9..51fd452 100644
--- a/sound/pcmcia/pdaudiocf/pdaudiocf_pcm.c
+++ b/sound/pcmcia/pdaudiocf/pdaudiocf_pcm.c
@@ -51,7 +51,7 @@ static int snd_pcm_alloc_vmalloc_buffer(struct snd_pcm_substream *subs, size_t s
 			return 0; /* already enough large */
 		vfree(runtime->dma_area);
 	}
-	runtime->dma_area = vmalloc_32(size);
+	runtime->dma_area = vmalloc_32_user(size);
 	if (! runtime->dma_area)
 		return -ENOMEM;
 	runtime->dma_bytes = size;
diff --git a/sound/usb/usbaudio.c b/sound/usb/usbaudio.c
index 915a131..04e5d2e 100644
--- a/sound/usb/usbaudio.c
+++ b/sound/usb/usbaudio.c
@@ -740,7 +740,7 @@ static int snd_pcm_alloc_vmalloc_buffer(struct snd_pcm_substream *subs, size_t s
 			return 0; /* already large enough */
 		vfree(runtime->dma_area);
 	}
-	runtime->dma_area = vmalloc(size);
+	runtime->dma_area = vmalloc_user(size);
 	if (!runtime->dma_area)
 		return -ENOMEM;
 	runtime->dma_bytes = size;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index db062b5..cecfc13 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -406,8 +406,6 @@ static void kvm_destroy_vm(struct kvm *kvm)
 #endif
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 	mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
-#else
-	kvm_arch_flush_shadow(kvm);
 #endif
 	kvm_arch_destroy_vm(kvm);
 	mmdrop(mm);
