Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbYJSUK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbYJSUK6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 16:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbYJSUKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 16:10:51 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:41947 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbYJSUKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 16:10:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=SXyfY+cpm08Gxa3tKIkTeZVIOIl3mfVLwvh+mjgywm9/3w8b0ylo2e87pXnrSfWStd
         iTkUqj9v/KNe2A9ev5NPo10jqt2U+Yr3a9ovc1m3+sxdsSTN8K4IBpPJz8yHi26Hz4zM
         eRF3HzRvse3TUZEn6+zDU/G4bdAkSLZpvr2R8=
Date: Sun, 19 Oct 2008 22:11:09 +0200
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Cc: Ye Janboe <janboe.ye@gmail.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Steve VanDeBogart <vandebo-lkml@nerdbox.net>,
       John Reiser <jreiser@bitwagon.com>
Subject: What's in kmemcheck.git (for v2.6.28?)
Message-ID: <20081019201109.GA5058@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I present the current kmemcheck repository. It's been almost exactly a
year since I started working on the first version, and we've come very
far since then. (And I've learned so much.) Most of it has been working
out the rough edges and (lately) getting rid of the false positive
reports. There's still a lot of work to be done for extended
functionality, but the basics are definitely in place now.

We have been offering kmemcheck for mainline inclusion for the past
couple of releases. My hope is that kmemcheck would get broader testing
if it were to be included in the kernel. That would undoubtedly result
in many false positive reports, probably reveal some errors on my part,
but hopefully also uncover those real cases of use of uninitialized
memory which are currently present in the kernel.

Here's a list of REAL errors (in the mainline kernel) that kmemcheck
found and fixed so far:

62f75532b583c03840f31e40386ce2df73be9ca0 slub: Initialize per-cpu stats
8410565f540db87ca938f56f92780d251e4f157d ACPICA: Fix for access to deleted object <regression>
adeed48090fc370afa0db8d007748ee72a40b578 rc80211_pid: Fix fast_start parameter handling
1045b03e07d85f3545118510a587035536030c1c netlink: fix overrun in attribute iteration

Pending patches include these:

http://lkml.org/lkml/2008/10/5/73
http://lkml.org/lkml/2008/10/10/115

In addition to the real errors, there are also false positives. Since
memory accesses are reported eagerly, certain operations simply cannot
be checked reliably. This means that we must annotate those memory
accesses in order to get rid of the false-positive warnings. So far,
we have collected a set of patches that will result in a mostly
warning-free system. See the bottom of this e-mail for the combined
patch that annotates (and silences) these false-positive warnings.


Here's a list of things which we could/should do for the future:

 - Self-tests, using some kind of counter or notifier system. This
would check whether we set the shadow bits correctly for various
cases of tracked-to-tracked copies, non-tracked-to-tracked copies,
etc. The self-tests would also include checking that we decode/handle
various opcodes correctly.

 - Correctly handle SLAB_DESTROY_BY_RCU. Currently, these allocations
are not checked at all. Since RCU allocations should retain their
initializedness across alloc/free, we should detect (illegal)
accesses to freed (but initialized) RCU allocations.

 - Delayed freeing. On kfree(), the allocation should not be given
back out before a certain amount of time has elapsed. This makes it
easier to find use-after-free errors.

 - Catch (illegal) writes to unallocated/freed memory. Also all
accesses to slab redzone/padding. These are also illegal, and
kmemcheck could discover possible memory corruption the moment it
happens.

 - Tracking for page/vmalloc allocations.

 - Tracking stack variables (I'm currently not sure whether this is
possible at all -- #PF and #DB would have to use a different,
untracked stack).

 - Per-cpu page tables. This one is still far off, but it would
allow us to run kmemcheck on SMP.

 - kmemcheck does not play nicely along with ftrace, probably not CPU
hotplug or oprofile either.

 - Ye Janboe has submitted a port of kmemcheck to ARM (!!!) It
would be nice if we could split out the common code and integrate
the ARM bits as well.


Ingo Molnar will probably make a pull request after all the other
x86/tip stuff is upstream. In the mean-time, a preview may be found
in the branch 'preview-20081019' of

git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git

A complete and combined patch (applies to mainline!) may be found at:

http://userweb.kernel.org/~vegard/kmemcheck/kmemcheck-preview-20081019.patch

Thanks to everybody who helped out! Enjoy :-)


Sincerely,
Vegard Nossum


 drivers/ieee1394/csr1212.c       |    2 +
 drivers/ieee1394/nodemgr.c       |    7 +++++-
 include/linux/kmemcheck.h        |   39 ++++++++++++++++++++++++++++++++++++++
 include/linux/skbuff.h           |   31 ++++++++++++++++++-----------
 include/net/inet_sock.h          |   26 +++++++++++++++---------
 include/net/inet_timewait_sock.h |   11 ++++++---
 net/core/skbuff.c                |    8 +++++++
 net/ipv4/inet_timewait_sock.c    |    3 ++
 8 files changed, 100 insertions(+), 27 deletions(-)

diff --git a/drivers/ieee1394/csr1212.c b/drivers/ieee1394/csr1212.c
index 9f95337..1e4a962 100644
--- a/drivers/ieee1394/csr1212.c
+++ b/drivers/ieee1394/csr1212.c
@@ -35,6 +35,7 @@
 
 #include <linux/errno.h>
 #include <linux/kernel.h>
+#include <linux/kmemcheck.h>
 #include <linux/string.h>
 #include <asm/bug.h>
 #include <asm/byteorder.h>
@@ -387,6 +388,7 @@ csr1212_new_descriptor_leaf(u8 dtype, u32 specifier_id,
 	if (!kv)
 		return NULL;
 
+	kmemcheck_annotate_bitfield(kv->value.leaf.data[0]);
 	CSR1212_DESCRIPTOR_LEAF_SET_TYPE(kv, dtype);
 	CSR1212_DESCRIPTOR_LEAF_SET_SPECIFIER_ID(kv, specifier_id);
 
diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index 16240a7..3e28b72 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -10,6 +10,7 @@
 
 #include <linux/bitmap.h>
 #include <linux/kernel.h>
+#include <linux/kmemcheck.h>
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
@@ -39,7 +40,10 @@ struct nodemgr_csr_info {
 	struct hpsb_host *host;
 	nodeid_t nodeid;
 	unsigned int generation;
-	unsigned int speed_unverified:1;
+
+	kmemcheck_define_bitfield(flags, {
+		unsigned int speed_unverified:1;
+	});
 };
 
 
@@ -1327,6 +1331,7 @@ static void nodemgr_node_scan_one(struct host_info *hi,
 	ci = kmalloc(sizeof(*ci), GFP_KERNEL);
 	if (!ci)
 		return;
+	kmemcheck_annotate_bitfield(ci->flags);
 
 	ci->host = host;
 	ci->nodeid = nodeid;
diff --git a/include/linux/kmemcheck.h b/include/linux/kmemcheck.h
index 57bb125..7073121 100644
--- a/include/linux/kmemcheck.h
+++ b/include/linux/kmemcheck.h
@@ -4,6 +4,38 @@
 #include <linux/mm_types.h>
 #include <linux/types.h>
 
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
+ *             kmemcheck_define_bitfield(flags, {
+ *                     int x:8, y:8;
+ *             });
+ *     };
+ *
+ * Now the "flags" member may be used to refer to the bitfield (and things
+ * like &x.flags is allowed). As soon as the struct is allocated, the bit-
+ * fields should be annotated:
+ *
+ *     struct a *a = kmalloc(sizeof(struct a), GFP_KERNEL);
+ *     if (a)
+ *             kmemcheck_annotate_bitfield(a->flags);
+ *
+ * Note: We provide the same definitions for both kmemcheck and non-
+ * kmemcheck kernels. This makes it harder to introduce accidental errors.
+ */
+#define kmemcheck_define_bitfield(name, fields...)	\
+	union {						\
+		struct fields name;			\
+		struct fields;				\
+	};
+
 #ifdef CONFIG_KMEMCHECK
 extern int kmemcheck_enabled;
 
@@ -32,6 +64,11 @@ void kmemcheck_mark_uninitialized_pages(struct page *p, unsigned int n);
 
 int kmemcheck_show_addr(unsigned long address);
 int kmemcheck_hide_addr(unsigned long address);
+
+#define kmemcheck_annotate_bitfield(field)		\
+	do {						\
+		memset(&(field), 0, sizeof(field));	\
+	} while (0)
 #else
 #define kmemcheck_enabled 0
 
@@ -81,6 +118,8 @@ static inline void kmemcheck_mark_initialized(void *address, unsigned int n)
 static inline void kmemcheck_mark_freed(void *address, unsigned int n)
 {
 }
+
+#define kmemcheck_annotate_bitfield(field) do { } while (0)
 #endif /* CONFIG_KMEMCHECK */
 
 #endif /* LINUX_KMEMCHECK_H */
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 2725f4e..523f7cf 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -15,6 +15,7 @@
 #define _LINUX_SKBUFF_H
 
 #include <linux/kernel.h>
+#include <linux/kmemcheck.h>
 #include <linux/compiler.h>
 #include <linux/time.h>
 #include <linux/cache.h>
@@ -291,16 +292,18 @@ struct sk_buff {
 		};
 	};
 	__u32			priority;
-	__u8			local_df:1,
-				cloned:1,
-				ip_summed:2,
-				nohdr:1,
-				nfctinfo:3;
-	__u8			pkt_type:3,
-				fclone:2,
-				ipvs_property:1,
-				peeked:1,
-				nf_trace:1;
+	kmemcheck_define_bitfield(flags1, {
+		__u8			local_df:1,
+					cloned:1,
+					ip_summed:2,
+					nohdr:1,
+					nfctinfo:3;
+		__u8			pkt_type:3,
+					fclone:2,
+					ipvs_property:1,
+					peeked:1,
+					nf_trace:1;
+	});
 	__be16			protocol;
 
 	void			(*destructor)(struct sk_buff *skb);
@@ -320,12 +323,16 @@ struct sk_buff {
 	__u16			tc_verd;	/* traffic control verdict */
 #endif
 #endif
+
+	kmemcheck_define_bitfield(flags2, {
 #ifdef CONFIG_IPV6_NDISC_NODETYPE
-	__u8			ndisc_nodetype:2;
+		__u8			ndisc_nodetype:2;
 #endif
 #if defined(CONFIG_MAC80211) || defined(CONFIG_MAC80211_MODULE)
-	__u8			do_not_encrypt:1;
+		__u8			do_not_encrypt:1;
 #endif
+	});
+
 	/* 0/13/14 bit hole */
 
 #ifdef CONFIG_NET_DMA
diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index de0ecc7..9d172f7 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -17,6 +17,7 @@
 #define _INET_SOCK_H
 
 
+#include <linux/kmemcheck.h>
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/jhash.h>
@@ -66,14 +67,16 @@ struct inet_request_sock {
 	__be32			loc_addr;
 	__be32			rmt_addr;
 	__be16			rmt_port;
-	u16			snd_wscale : 4, 
-				rcv_wscale : 4, 
-				tstamp_ok  : 1,
-				sack_ok	   : 1,
-				wscale_ok  : 1,
-				ecn_ok	   : 1,
-				acked	   : 1,
-				no_srccheck: 1;
+	kmemcheck_define_bitfield(flags, {
+		u16			snd_wscale : 4,
+					rcv_wscale : 4,
+					tstamp_ok  : 1,
+					sack_ok	   : 1,
+					wscale_ok  : 1,
+					ecn_ok	   : 1,
+					acked	   : 1,
+					no_srccheck: 1;
+	});
 	struct ip_options	*opt;
 };
 
@@ -198,9 +201,12 @@ static inline int inet_sk_ehashfn(const struct sock *sk)
 static inline struct request_sock *inet_reqsk_alloc(struct request_sock_ops *ops)
 {
 	struct request_sock *req = reqsk_alloc(ops);
+	struct inet_request_sock *ireq = inet_rsk(req);
 
-	if (req != NULL)
-		inet_rsk(req)->opt = NULL;
+	if (req != NULL) {
+		kmemcheck_annotate_bitfield(ireq->flags);
+		ireq->opt = NULL;
+	}
 
 	return req;
 }
diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
index 80e4977..9e2a1d4 100644
--- a/include/net/inet_timewait_sock.h
+++ b/include/net/inet_timewait_sock.h
@@ -16,6 +16,7 @@
 #define _INET_TIMEWAIT_SOCK_
 
 
+#include <linux/kmemcheck.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/timer.h>
@@ -127,10 +128,12 @@ struct inet_timewait_sock {
 	__be32			tw_rcv_saddr;
 	__be16			tw_dport;
 	__u16			tw_num;
-	/* And these are ours. */
-	__u8			tw_ipv6only:1,
-				tw_transparent:1;
-	/* 15 bits hole, try to pack */
+	kmemcheck_define_bitfield(flags, {
+		/* And these are ours. */
+		__u8			tw_ipv6only:1,
+					tw_transparent:1;
+		/* 14 bits hole, try to pack */
+	});
 	__u16			tw_ipv6_offset;
 	unsigned long		tw_ttd;
 	struct inet_bind_bucket	*tw_tb;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7f7bb1a..a76168d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -39,6 +39,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/kmemcheck.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/in.h>
@@ -209,6 +210,8 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 	skb->data = data;
 	skb_reset_tail_pointer(skb);
 	skb->end = skb->tail + size;
+	kmemcheck_annotate_bitfield(skb->flags1);
+	kmemcheck_annotate_bitfield(skb->flags2);
 	/* make sure we initialize shinfo sequentially */
 	shinfo = skb_shinfo(skb);
 	atomic_set(&shinfo->dataref, 1);
@@ -223,6 +226,8 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 		struct sk_buff *child = skb + 1;
 		atomic_t *fclone_ref = (atomic_t *) (child + 1);
 
+		kmemcheck_annotate_bitfield(child->flags1);
+		kmemcheck_annotate_bitfield(child->flags2);
 		skb->fclone = SKB_FCLONE_ORIG;
 		atomic_set(fclone_ref, 1);
 
@@ -599,6 +604,9 @@ struct sk_buff *skb_clone(struct sk_buff *skb, gfp_t gfp_mask)
 		n = kmem_cache_alloc(skbuff_head_cache, gfp_mask);
 		if (!n)
 			return NULL;
+
+		kmemcheck_annotate_bitfield(n->flags1);
+		kmemcheck_annotate_bitfield(n->flags2);
 		n->fclone = SKB_FCLONE_UNAVAILABLE;
 	}
 
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index 1c5fd38..d178d2d 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/kmemcheck.h>
 #include <net/inet_hashtables.h>
 #include <net/inet_timewait_sock.h>
 #include <net/ip.h>
@@ -113,6 +114,8 @@ struct inet_timewait_sock *inet_twsk_alloc(const struct sock *sk, const int stat
 	if (tw != NULL) {
 		const struct inet_sock *inet = inet_sk(sk);
 
+		kmemcheck_annotate_bitfield(tw->flags);
+
 		/* Give us an identity. */
 		tw->tw_daddr	    = inet->daddr;
 		tw->tw_rcv_saddr    = inet->rcv_saddr;
