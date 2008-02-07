Return-Path: <linux-kernel-owner+w=401wt.eu-S1762881AbYBGVlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762881AbYBGVlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964923AbYBGVjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:39:43 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:31073 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965117AbYBGVjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:39:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=T+aLTA0Y+xWmnmzlnZaWPIoNPoDHtEePxpAEgl716k9VP7bzPElt6T1RGClk5QGB0gVBMHV3wIGyIGJ5pf/0dwxgoEB8g2Qq3ViBdbO5g+XdRW+LLXYUTjc/cLuMlEAzTzPyScfuZ9v1EtEna/gZ/HeVAMUPV5shjBlwwwZJrK4=
Message-ID: <47AB7A95.9090807@gmail.com>
Date: Thu, 07 Feb 2008 22:39:33 +0100
From: Vegard Nossum <vegard.nossum@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andi Kleen <andi@firstfloor.org>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 2/2] kmemcheck v3
References: <47AB79D4.2070605@gmail.com>
In-Reply-To: <47AB79D4.2070605@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applies on top of kmemcheck patch. Fixes/silences some reports of
use of uninitialized memory.


From: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>

diff --git a/include/asm-generic/siginfo.h b/include/asm-generic/siginfo.h
index 8786e01..b70cd97 100644
--- a/include/asm-generic/siginfo.h
+++ b/include/asm-generic/siginfo.h
@@ -278,11 +278,19 @@ void do_schedule_next_timer(struct siginfo *info);

  static inline void copy_siginfo(struct siginfo *to, struct siginfo *from)
  {
+#ifdef CONFIG_KMEMCHECK
+	memcpy(to, from, sizeof(*to));
+#else
+	/*
+	 * Optimization, only copy up to the size of the largest known
+	 * union member:
+	 */
  	if (from->si_code < 0)
  		memcpy(to, from, sizeof(*to));
  	else
  		/* _sigchld is currently the largest know union member */
  		memcpy(to, from, __ARCH_SI_PREAMBLE_SIZE + sizeof(from->_sifields._sigchld));
+#endif
  }

  #endif
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 109734b..fb6f6ec 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -875,8 +875,8 @@ struct file_lock {
  	struct pid *fl_nspid;
  	wait_queue_head_t fl_wait;
  	struct file *fl_file;
-	unsigned char fl_flags;
-	unsigned char fl_type;
+	unsigned int fl_flags;
+	unsigned int fl_type;
  	loff_t fl_start;
  	loff_t fl_end;

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 047d432..d4cc6ee 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -193,8 +193,8 @@ struct dev_addr_list
  {
  	struct dev_addr_list	*next;
  	u8			da_addr[MAX_ADDR_LEN];
-	u8			da_addrlen;
-	u8			da_synced;
+	unsigned int		da_addrlen;
+	unsigned int		da_synced;
  	int			da_users;
  	int			da_gusers;
  };
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 412672a..7bdb37f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1294,7 +1294,11 @@ static inline void __skb_queue_purge(struct sk_buff_head *list)
  static inline struct sk_buff *__dev_alloc_skb(unsigned int length,
  					      gfp_t gfp_mask)
  {
-	struct sk_buff *skb = alloc_skb(length + NET_SKB_PAD, gfp_mask);
+	struct sk_buff *skb;
+#ifdef CONFIG_KMEMCHECK
+	gfp_mask |= __GFP_ZERO;
+#endif
+	skb = alloc_skb(length + NET_SKB_PAD, gfp_mask);
  	if (likely(skb))
  		skb_reserve(skb, NET_SKB_PAD);
  	return skb;
diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 70013c5..a575171 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -73,7 +73,8 @@ struct inet_request_sock {
  				sack_ok	   : 1,
  				wscale_ok  : 1,
  				ecn_ok	   : 1,
-				acked	   : 1;
+				acked	   : 1,
+				__filler   : 3;
  	struct ip_options	*opt;
  };

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 7de4ea3..4d522f6 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -951,6 +951,17 @@ static inline void tcp_openreq_init(struct request_sock *req,
  	tcp_rsk(req)->rcv_isn = TCP_SKB_CB(skb)->seq;
  	req->mss = rx_opt->mss_clamp;
  	req->ts_recent = rx_opt->saw_tstamp ? rx_opt->rcv_tsval : 0;
+#ifdef CONFIG_KMEMCHECK
+	/* bitfield init */
+	ireq->snd_wscale =
+	ireq->rcv_wscale =
+	ireq->tstamp_ok =
+	ireq->sack_ok =
+	ireq->wscale_ok =
+	ireq->ecn_ok =
+	ireq->acked =
+	ireq->__filler = 0;
+#endif
  	ireq->tstamp_ok = rx_opt->tstamp_ok;
  	ireq->sack_ok = rx_opt->sack_ok;
  	ireq->snd_wscale = rx_opt->snd_wscale;
diff --git a/init/do_mounts.c b/init/do_mounts.c
index f865731..87b1b0f 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -201,9 +201,13 @@ static int __init do_mount_root(char *name, char *fs, int flags, void *data)
  	return 0;
  }

+#if PAGE_SIZE < PATH_MAX
+# error increase the fs_names allocation size here
+#endif
+
  void __init mount_block_root(char *name, int flags)
  {
-	char *fs_names = __getname();
+	char *fs_names = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
  	char *p;
  #ifdef CONFIG_BLOCK
  	char b[BDEVNAME_SIZE];
@@ -251,7 +255,7 @@ retry:
  #endif
  	panic("VFS: Unable to mount root fs on %s", b);
  out:
-	putname(fs_names);
+	free_pages((unsigned long)fs_names, 1);
  }

  #ifdef CONFIG_ROOT_NFS
diff --git a/kernel/signal.c b/kernel/signal.c
index 5d30ff5..ece53b0 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -691,6 +691,12 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
  		list_add_tail(&q->list, &signals->list);
  		switch ((unsigned long) info) {
  		case (unsigned long) SEND_SIG_NOINFO:
+			/*
+			 * Make sure we always have a fully initialized
+			 * siginfo struct:
+			 */
+			memset(&q->info, 0, sizeof(q->info));
+
  			q->info.si_signo = sig;
  			q->info.si_errno = 0;
  			q->info.si_code = SI_USER;
@@ -698,6 +704,12 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
  			q->info.si_uid = current->uid;
  			break;
  		case (unsigned long) SEND_SIG_PRIV:
+			/*
+			 * Make sure we always have a fully initialized
+			 * siginfo struct:
+			 */
+			memset(&q->info, 0, sizeof(q->info));
+
  			q->info.si_signo = sig;
  			q->info.si_errno = 0;
  			q->info.si_code = SI_KERNEL;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4e35422..855b6fa 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -223,6 +223,9 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
  		struct sk_buff *child = skb + 1;
  		atomic_t *fclone_ref = (atomic_t *) (child + 1);

+#ifdef CONFIG_KMEMCHECK
+		memset(child, 0, offsetof(struct sk_buff, tail));
+#endif
  		skb->fclone = SKB_FCLONE_ORIG;
  		atomic_set(fclone_ref, 1);

@@ -255,6 +258,9 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *dev,
  	int node = dev->dev.parent ? dev_to_node(dev->dev.parent) : -1;
  	struct sk_buff *skb;

+#ifdef CONFIG_KMEMCHECK
+	gfp_mask |= __GFP_ZERO;
+#endif
  	skb = __alloc_skb(length + NET_SKB_PAD, gfp_mask, 0, node);
  	if (likely(skb)) {
  		skb_reserve(skb, NET_SKB_PAD);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index ed750f9..47bb63b 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -333,6 +333,10 @@ static inline void TCP_ECN_send(struct sock *sk, struct sk_buff *skb,
  static void tcp_init_nondata_skb(struct sk_buff *skb, u32 seq, u8 flags)
  {
  	skb->csum = 0;
+	skb->local_df = skb->cloned = skb->ip_summed = skb->nohdr =
+		skb->nfctinfo = 0;
+	skb->pkt_type = skb->fclone = skb->ipvs_property = skb->peeked =
+		skb->nf_trace = 0;

  	TCP_SKB_CB(skb)->flags = flags;
  	TCP_SKB_CB(skb)->sacked = 0;

