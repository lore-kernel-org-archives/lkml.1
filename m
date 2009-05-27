Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbZE0Fn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbZE0Fn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 01:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZE0FnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 01:43:22 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:2399 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbZE0FnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 01:43:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=nGnSY5DtZjy5sMuX1jjVXttg+vSM0tSf8h+CD5Zo9tuCd80YRvBPHpPwdakrjC56km
         rypbNAxNMOJDfnLeOgv0GVA48fWxpuzoE+BUTdmwIniuQ03aozVeib1SZ3ambZ2a1v9S
         l5F415Ii6dEgm3I7h0s3K05TyUi62m2EGk9GE=
Date: Wed, 27 May 2009 07:43:17 +0200
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] kmemcheck fixes for -tip
Message-ID: <20090527054317.GA31443@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These are the patches I posted to LKML a while ago. Full diff included.

With this, we should be able to resume linux-next integration. It also gets
rid of the two most frequent false positives, so automatic testing should be
more useful.

The following changes since commit 12d77a12affc8310e09598fb5a35605549eb9730:
  Ingo Molnar (1):
        Merge commit 'v2.6.30-rc5' into kmemcheck

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git for-tip

Vegard Nossum (5):
      kmemcheck: make bitfield annotations be valid C
      fs: introduce __getname_gfp()
      kmemcheck: add __GFP_NOTRACK_FALSE_POSITIVE flag
      kmemcheck: fix do_mount_root() false positive
      kmemcheck: fix __send_signal() false positive

 drivers/ieee1394/csr1212.c       |    2 +-
 drivers/ieee1394/nodemgr.c       |    8 ++--
 drivers/misc/c2port/core.c       |    2 +-
 include/linux/c2port.h           |    8 ++--
 include/linux/fs.h               |    5 +-
 include/linux/gfp.h              |    6 +++
 include/linux/kmemcheck.h        |   91 +++++++++++++++++++------------------
 include/linux/ring_buffer.h      |    6 +-
 include/linux/skbuff.h           |   34 +++++++-------
 include/net/inet_sock.h          |   22 +++++-----
 include/net/inet_timewait_sock.h |   12 +++---
 include/net/sock.h               |   10 ++--
 init/do_mounts.c                 |    3 +-
 kernel/signal.c                  |   11 +++-
 kernel/trace/ring_buffer.c       |    4 +-
 net/core/skbuff.c                |   12 +++---
 net/core/sock.c                  |    2 +-
 net/ipv4/inet_timewait_sock.c    |    2 +-
 18 files changed, 128 insertions(+), 112 deletions(-)


Vegard


diff --git a/drivers/ieee1394/csr1212.c b/drivers/ieee1394/csr1212.c
index 5e0fab1..e76cac6 100644
--- a/drivers/ieee1394/csr1212.c
+++ b/drivers/ieee1394/csr1212.c
@@ -388,7 +388,7 @@ csr1212_new_descriptor_leaf(u8 dtype, u32 specifier_id,
 	if (!kv)
 		return NULL;
 
-	kmemcheck_annotate_bitfield(kv->value.leaf.data[0]);
+	kmemcheck_annotate_variable(kv->value.leaf.data[0]);
 	CSR1212_DESCRIPTOR_LEAF_SET_TYPE(kv, dtype);
 	CSR1212_DESCRIPTOR_LEAF_SET_SPECIFIER_ID(kv, specifier_id);
 
diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index 065f249..5122b5a 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -41,9 +41,9 @@ struct nodemgr_csr_info {
 	nodeid_t nodeid;
 	unsigned int generation;
 
-	kmemcheck_define_bitfield(flags, {
-		unsigned int speed_unverified:1;
-	});
+	kmemcheck_bitfield_begin(flags);
+	unsigned int speed_unverified:1;
+	kmemcheck_bitfield_end(flags);
 };
 
 
@@ -1297,9 +1297,9 @@ static void nodemgr_node_scan_one(struct hpsb_host *host,
 	u8 *speed;
 
 	ci = kmalloc(sizeof(*ci), GFP_KERNEL);
+	kmemcheck_annotate_bitfield(ci, flags);
 	if (!ci)
 		return;
-	kmemcheck_annotate_bitfield(ci->flags);
 
 	ci->host = host;
 	ci->nodeid = nodeid;
diff --git a/drivers/misc/c2port/core.c b/drivers/misc/c2port/core.c
index fc15042..b5346b4 100644
--- a/drivers/misc/c2port/core.c
+++ b/drivers/misc/c2port/core.c
@@ -892,9 +892,9 @@ struct c2port_device *c2port_device_register(char *name,
 		return ERR_PTR(-EINVAL);
 
 	c2dev = kmalloc(sizeof(struct c2port_device), GFP_KERNEL);
+	kmemcheck_annotate_bitfield(c2dev, flags);
 	if (unlikely(!c2dev))
 		return ERR_PTR(-ENOMEM);
-	kmemcheck_annotate_bitfield(c2dev->flags);
 
 	ret = idr_pre_get(&c2port_idr, GFP_KERNEL);
 	if (!ret) {
diff --git a/include/linux/c2port.h b/include/linux/c2port.h
index 2556499..2a5cd86 100644
--- a/include/linux/c2port.h
+++ b/include/linux/c2port.h
@@ -21,10 +21,10 @@
 /* Main struct */
 struct c2port_ops;
 struct c2port_device {
-	kmemcheck_define_bitfield(flags, {
-		unsigned int access:1;
-		unsigned int flash_access:1;
-	});
+	kmemcheck_bitfield_begin(flags);
+	unsigned int access:1;
+	unsigned int flash_access:1;
+	kmemcheck_bitfield_end(flags);
 
 	int id;
 	char name[C2PORT_NAME_LEN];
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5bed436..e45ad64 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1924,8 +1924,9 @@ extern void __init vfs_caches_init(unsigned long);
 
 extern struct kmem_cache *names_cachep;
 
-#define __getname()	kmem_cache_alloc(names_cachep, GFP_KERNEL)
-#define __putname(name) kmem_cache_free(names_cachep, (void *)(name))
+#define __getname_gfp(gfp)	kmem_cache_alloc(names_cachep, (gfp))
+#define __getname()		__getname_gfp(GFP_KERNEL)
+#define __putname(name)		kmem_cache_free(names_cachep, (void *)(name))
 #ifndef CONFIG_AUDITSYSCALL
 #define putname(name)   __putname(name)
 #else
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 2700097..3885e7f 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -58,6 +58,12 @@ struct vm_area_struct;
 #define __GFP_NOTRACK	((__force gfp_t)0)
 #endif
 
+/*
+ * This may seem redundant, but it's a way of annotating false positives vs.
+ * allocations that simply cannot be supported (e.g. page tables).
+ */
+#define __GFP_NOTRACK_FALSE_POSITIVE (__GFP_NOTRACK)
+
 #define __GFP_BITS_SHIFT 22	/* Room for 22 __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
diff --git a/include/linux/kmemcheck.h b/include/linux/kmemcheck.h
index bc88808..0efbaac 100644
--- a/include/linux/kmemcheck.h
+++ b/include/linux/kmemcheck.h
@@ -4,45 +4,6 @@
 #include <linux/mm_types.h>
 #include <linux/types.h>
 
-/*
- * How to use: If you have a struct using bitfields, for example
- *
- *     struct a {
- *             int x:8, y:8;
- *     };
- *
- * then this should be rewritten as
- *
- *     struct a {
- *             kmemcheck_define_bitfield(flags, {
- *                     int x:8, y:8;
- *             });
- *     };
- *
- * Now the "flags" member may be used to refer to the bitfield (and things
- * like &x.flags is allowed). As soon as the struct is allocated, the bit-
- * fields should be annotated:
- *
- *     struct a *a = kmalloc(sizeof(struct a), GFP_KERNEL);
- *     if (a)
- *             kmemcheck_annotate_bitfield(a->flags);
- *
- * Note: We provide the same definitions for both kmemcheck and non-
- * kmemcheck kernels. This makes it harder to introduce accidental errors.
- */
-#define kmemcheck_define_bitfield(name, fields...)	\
-	union {						\
-		struct fields name;			\
-		struct fields;				\
-	};						\
-							\
-	/*						\
-	 * Erk. Due to gcc bug, we'll get a "error:	\
-	 * flexible array member in otherwise empty	\
-	 * struct without this.				\
-	 */						\
-	int kmemcheck_dummy_##name##_[0];
-
 #ifdef CONFIG_KMEMCHECK
 extern int kmemcheck_enabled;
 
@@ -75,10 +36,6 @@ void kmemcheck_mark_initialized_pages(struct page *p, unsigned int n);
 int kmemcheck_show_addr(unsigned long address);
 int kmemcheck_hide_addr(unsigned long address);
 
-#define kmemcheck_annotate_bitfield(field)				\
-	do {								\
-		kmemcheck_mark_initialized(&(field), sizeof(field));	\
-	} while (0)
 #else
 #define kmemcheck_enabled 0
 
@@ -148,7 +105,53 @@ static inline void kmemcheck_mark_initialized_pages(struct page *p,
 {
 }
 
-#define kmemcheck_annotate_bitfield(field) do { } while (0)
 #endif /* CONFIG_KMEMCHECK */
 
+/*
+ * How to use: If you have a struct using bitfields, for example
+ *
+ *     struct a {
+ *             int x:8, y:8;
+ *     };
+ *
+ * then this should be rewritten as
+ *
+ *     struct a {
+ *             kmemcheck_bitfield_begin(flags);
+ *             int x:8, y:8;
+ *             kmemcheck_bitfield_end(flags);
+ *     };
+ *
+ * Now the "flags_begin" and "flags_end" members may be used to refer to the
+ * beginning and end, respectively, of the bitfield (and things like
+ * &x.flags_begin is allowed). As soon as the struct is allocated, the bit-
+ * fields should be annotated:
+ *
+ *     struct a *a = kmalloc(sizeof(struct a), GFP_KERNEL);
+ *     kmemcheck_annotate_bitfield(a, flags);
+ *
+ * Note: We provide the same definitions for both kmemcheck and non-
+ * kmemcheck kernels. This makes it harder to introduce accidental errors. It
+ * is also allowed to pass NULL pointers to kmemcheck_annotate_bitfield().
+ */
+#define kmemcheck_bitfield_begin(name)	\
+	int name##_begin[0];
+
+#define kmemcheck_bitfield_end(name)	\
+	int name##_end[0];
+
+#define kmemcheck_annotate_bitfield(ptr, name)				\
+	do if (ptr) {							\
+		int _n = (long) &((ptr)->name##_end)			\
+			- (long) &((ptr)->name##_begin);		\
+		BUILD_BUG_ON(_n < 0);					\
+									\
+		kmemcheck_mark_initialized(&((ptr)->name##_begin), _n);	\
+	} while (0)
+
+#define kmemcheck_annotate_variable(var)				\
+	do {								\
+		kmemcheck_mark_initialized(&(var), sizeof(var));	\
+	} while (0)							\
+
 #endif /* LINUX_KMEMCHECK_H */
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index ae5b210..771ee90 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -12,9 +12,9 @@ struct ring_buffer_iter;
  * Don't refer to this struct directly, use functions below.
  */
 struct ring_buffer_event {
-	kmemcheck_define_bitfield(bitfield, {
-		u32		type:2, len:3, time_delta:27;
-	});
+	kmemcheck_bitfield_begin(bitfield);
+	u32		type:2, len:3, time_delta:27;
+	kmemcheck_bitfield_end(bitfield);
 
 	u32		array[];
 };
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e0ce2e0..ed6537f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -347,18 +347,18 @@ struct sk_buff {
 		};
 	};
 	__u32			priority;
-	kmemcheck_define_bitfield(flags1, {
-		__u8			local_df:1,
-					cloned:1,
-					ip_summed:2,
-					nohdr:1,
-					nfctinfo:3;
-		__u8			pkt_type:3,
-					fclone:2,
-					ipvs_property:1,
-					peeked:1,
-					nf_trace:1;
-	});
+	kmemcheck_bitfield_begin(flags1);
+	__u8			local_df:1,
+				cloned:1,
+				ip_summed:2,
+				nohdr:1,
+				nfctinfo:3;
+	__u8			pkt_type:3,
+				fclone:2,
+				ipvs_property:1,
+				peeked:1,
+				nf_trace:1;
+	kmemcheck_bitfield_end(flags1);
 	__be16			protocol;
 
 	void			(*destructor)(struct sk_buff *skb);
@@ -379,15 +379,15 @@ struct sk_buff {
 #endif
 #endif
 
-	kmemcheck_define_bitfield(flags2, {
+	kmemcheck_bitfield_begin(flags2);
 #ifdef CONFIG_IPV6_NDISC_NODETYPE
-		__u8			ndisc_nodetype:2;
+	__u8			ndisc_nodetype:2;
 #endif
 #if defined(CONFIG_MAC80211) || defined(CONFIG_MAC80211_MODULE)
-		__u8			do_not_encrypt:1;
-		__u8			requeue:1;
+	__u8			do_not_encrypt:1;
+	__u8			requeue:1;
 #endif
-	});
+	kmemcheck_bitfield_end(flags2);
 
 	/* 0/13/14 bit hole */
 
diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 9d172f7..cbcda0b 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -67,16 +67,16 @@ struct inet_request_sock {
 	__be32			loc_addr;
 	__be32			rmt_addr;
 	__be16			rmt_port;
-	kmemcheck_define_bitfield(flags, {
-		u16			snd_wscale : 4,
-					rcv_wscale : 4,
-					tstamp_ok  : 1,
-					sack_ok	   : 1,
-					wscale_ok  : 1,
-					ecn_ok	   : 1,
-					acked	   : 1,
-					no_srccheck: 1;
-	});
+	kmemcheck_bitfield_begin(flags);
+	u16			snd_wscale : 4,
+				rcv_wscale : 4,
+				tstamp_ok  : 1,
+				sack_ok	   : 1,
+				wscale_ok  : 1,
+				ecn_ok	   : 1,
+				acked	   : 1,
+				no_srccheck: 1;
+	kmemcheck_bitfield_end(flags);
 	struct ip_options	*opt;
 };
 
@@ -204,7 +204,7 @@ static inline struct request_sock *inet_reqsk_alloc(struct request_sock_ops *ops
 	struct inet_request_sock *ireq = inet_rsk(req);
 
 	if (req != NULL) {
-		kmemcheck_annotate_bitfield(ireq->flags);
+		kmemcheck_annotate_bitfield(ireq, flags);
 		ireq->opt = NULL;
 	}
 
diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
index a88cb10..b63b80f 100644
--- a/include/net/inet_timewait_sock.h
+++ b/include/net/inet_timewait_sock.h
@@ -128,12 +128,12 @@ struct inet_timewait_sock {
 	__be32			tw_rcv_saddr;
 	__be16			tw_dport;
 	__u16			tw_num;
-	kmemcheck_define_bitfield(flags, {
-		/* And these are ours. */
-		__u8			tw_ipv6only:1,
-					tw_transparent:1;
-		/* 14 bits hole, try to pack */
-	});
+	kmemcheck_bitfield_begin(flags);
+	/* And these are ours. */
+	__u8			tw_ipv6only:1,
+				tw_transparent:1;
+	/* 14 bits hole, try to pack */
+	kmemcheck_bitfield_end(flags);
 	__u16			tw_ipv6_offset;
 	unsigned long		tw_ttd;
 	struct inet_bind_bucket	*tw_tb;
diff --git a/include/net/sock.h b/include/net/sock.h
index da2ea5f..d933da0 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -218,11 +218,11 @@ struct sock {
 #define sk_hash			__sk_common.skc_hash
 #define sk_prot			__sk_common.skc_prot
 #define sk_net			__sk_common.skc_net
-	kmemcheck_define_bitfield(flags, {
-		unsigned char		sk_shutdown : 2,
-					sk_no_check : 2,
-					sk_userlocks : 4;
-	});
+	kmemcheck_bitfield_begin(flags);
+	unsigned char		sk_shutdown : 2,
+				sk_no_check : 2,
+				sk_userlocks : 4;
+	kmemcheck_bitfield_end(flags);
 	unsigned char		sk_protocol;
 	unsigned short		sk_type;
 	int			sk_rcvbuf;
diff --git a/init/do_mounts.c b/init/do_mounts.c
index dd7ee5f..093f659 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -231,7 +231,8 @@ static int __init do_mount_root(char *name, char *fs, int flags, void *data)
 
 void __init mount_block_root(char *name, int flags)
 {
-	char *fs_names = __getname();
+	char *fs_names = __getname_gfp(GFP_KERNEL
+		| __GFP_NOTRACK_FALSE_POSITIVE);
 	char *p;
 #ifdef CONFIG_BLOCK
 	char b[BDEVNAME_SIZE];
diff --git a/kernel/signal.c b/kernel/signal.c
index d803473..57c7440 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -829,6 +829,7 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 {
 	struct sigpending *pending;
 	struct sigqueue *q;
+	int override_rlimit;
 
 	trace_sched_signal_send(sig, t);
 
@@ -860,9 +861,13 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 	   make sure at least one signal gets delivered and don't
 	   pass on the info struct.  */
 
-	q = __sigqueue_alloc(t, GFP_ATOMIC, (sig < SIGRTMIN &&
-					     (is_si_special(info) ||
-					      info->si_code >= 0)));
+	if (sig < SIGRTMIN)
+		override_rlimit = (is_si_special(info) || info->si_code >= 0);
+	else
+		override_rlimit = 0;
+
+	q = __sigqueue_alloc(t, GFP_ATOMIC | __GFP_NOTRACK_FALSE_POSITIVE,
+		override_rlimit);
 	if (q) {
 		list_add_tail(&q->list, &pending->list);
 		switch ((unsigned long) info) {
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d26c74a..c22506f 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1259,7 +1259,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		if (tail < BUF_PAGE_SIZE) {
 			/* Mark the rest of the page with padding */
 			event = __rb_page_index(tail_page, tail);
-			kmemcheck_annotate_bitfield(event->bitfield);
+			kmemcheck_annotate_bitfield(event, bitfield);
 			rb_event_set_padding(event);
 		}
 
@@ -1289,7 +1289,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		return NULL;
 
 	event = __rb_page_index(tail_page, tail);
-	kmemcheck_annotate_bitfield(event->bitfield);
+	kmemcheck_annotate_bitfield(event, bitfield);
 	rb_update_event(event, type, length);
 
 	/*
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 8052d32..54d3e2f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -202,8 +202,8 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 	skb->data = data;
 	skb_reset_tail_pointer(skb);
 	skb->end = skb->tail + size;
-	kmemcheck_annotate_bitfield(skb->flags1);
-	kmemcheck_annotate_bitfield(skb->flags2);
+	kmemcheck_annotate_bitfield(skb, flags1);
+	kmemcheck_annotate_bitfield(skb, flags2);
 	/* make sure we initialize shinfo sequentially */
 	shinfo = skb_shinfo(skb);
 	atomic_set(&shinfo->dataref, 1);
@@ -220,8 +220,8 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 		struct sk_buff *child = skb + 1;
 		atomic_t *fclone_ref = (atomic_t *) (child + 1);
 
-		kmemcheck_annotate_bitfield(child->flags1);
-		kmemcheck_annotate_bitfield(child->flags2);
+		kmemcheck_annotate_bitfield(child, flags1);
+		kmemcheck_annotate_bitfield(child, flags2);
 		skb->fclone = SKB_FCLONE_ORIG;
 		atomic_set(fclone_ref, 1);
 
@@ -637,8 +637,8 @@ struct sk_buff *skb_clone(struct sk_buff *skb, gfp_t gfp_mask)
 		if (!n)
 			return NULL;
 
-		kmemcheck_annotate_bitfield(n->flags1);
-		kmemcheck_annotate_bitfield(n->flags2);
+		kmemcheck_annotate_bitfield(n, flags1);
+		kmemcheck_annotate_bitfield(n, flags2);
 		n->fclone = SKB_FCLONE_UNAVAILABLE;
 	}
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 9730820..ce72c0a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -941,7 +941,7 @@ static struct sock *sk_prot_alloc(struct proto *prot, gfp_t priority,
 		sk = kmalloc(prot->obj_size, priority);
 
 	if (sk != NULL) {
-		kmemcheck_annotate_bitfield(sk->flags);
+		kmemcheck_annotate_bitfield(sk, flags);
 
 		if (security_sk_alloc(sk, family, priority))
 			goto out_free;
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index 3369237..03169fc 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -118,7 +118,7 @@ struct inet_timewait_sock *inet_twsk_alloc(const struct sock *sk, const int stat
 	if (tw != NULL) {
 		const struct inet_sock *inet = inet_sk(sk);
 
-		kmemcheck_annotate_bitfield(tw->flags);
+		kmemcheck_annotate_bitfield(tw, flags);
 
 		/* Give us an identity. */
 		tw->tw_daddr	    = inet->daddr;
