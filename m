Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbZEOTze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbZEOTze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 15:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbZEOTzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 15:55:25 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:59137 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbZEOTzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 15:55:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=cCmuo+b1W3VF0kjgHSq3iNUX//5pzqQNETuHS2+QWA5ea4oBSIgv4zFkS6miT0ev8l
         DyMLW0Z5wDC5o1V6ZqehffxT8SFLOuFXa6JPIybDUtdat3vGhfcM2aA6DLGjGWBrlGmu
         JhWClttCp2Hz1jwOXnMBPEuu5mKD+46MZDm5o=
Date: Fri, 15 May 2009 21:55:20 +0200
From: Vegard Nossum <vegard.nossum@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] kmemcheck: make bitfield annotations be valid C
Message-ID: <20090515195520.GA7715@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bb8926742d87da95aeb373bc2d4b35a554c5001b Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 15 May 2009 21:34:36 +0200
Subject: [PATCH] kmemcheck: make bitfield annotations be valid C

According to Al Viro, the syntax we were using (putting #ifdef inside
macro arguments) was not valid C. He also suggested using begin/end
markers instead, which is what we do now.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 drivers/ieee1394/csr1212.c       |    2 +-
 drivers/ieee1394/nodemgr.c       |    8 ++--
 drivers/misc/c2port/core.c       |    2 +-
 include/linux/c2port.h           |    8 ++--
 include/linux/kmemcheck.h        |   91 +++++++++++++++++++------------------
 include/linux/ring_buffer.h      |    6 +-
 include/linux/skbuff.h           |   34 +++++++-------
 include/net/inet_sock.h          |   22 +++++-----
 include/net/inet_timewait_sock.h |   12 +++---
 include/net/sock.h               |   10 ++--
 kernel/trace/ring_buffer.c       |    4 +-
 net/core/skbuff.c                |   12 +++---
 net/core/sock.c                  |    2 +-
 net/ipv4/inet_timewait_sock.c    |    2 +-
 14 files changed, 109 insertions(+), 106 deletions(-)

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
-- 
1.6.0.6

