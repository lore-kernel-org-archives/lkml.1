Return-Path: <linux-kernel-owner+w=401wt.eu-S933270AbXA2Ihg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270AbXA2Ihg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 03:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933271AbXA2Ihg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 03:37:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45433 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933270AbXA2Ihe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 03:37:34 -0500
Date: Mon, 29 Jan 2007 09:35:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@osdl.org>, "David S. Miller" <davem@davemloft.net>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: 2.6.20-rc6-mm1
Message-ID: <20070129083526.GA6492@elte.hu>
References: <45BD2424.7020604@googlemail.com> <E1HBOtk-0007dS-00@gondolin.me.apana.org.au> <20070129052929.GA29456@gondor.apana.org.au> <20070128224312.50f89360.akpm@osdl.org> <20070129072146.GA30334@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129072146.GA30334@gondor.apana.org.au>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Actually, maybe I was confusing this with the fixes Ingo had for 
> local_bh_disable vs. preemption in the -rt tree.  Ingo, do you have 
> preemptible RCU support in your -rt tree and if so did you have to fix 
> the networking stack to behave correctly with it?

yeah, -rt is the main prototyping tree for PREEMPT_RCU, and it has been 
included in -rt for 1.5 years or so. There were only some small things 
here and there, but with Paul's latest design i dont remember anything 
but the occasional place that needs to be marked raw_smp_processor_id(). 
CONFIG_DEBUG_PREEMPT ought to catch those. I dont remember any big 
breakage.

i've just reviewed all changes to net/* in -rt, and the changes below 
are the ones that seem to be upstream-relevant.

	Ingo

Index: linux/net/ipv4/multipath_wrandom.c
===================================================================
--- linux.orig/net/ipv4/multipath_wrandom.c
+++ linux/net/ipv4/multipath_wrandom.c
@@ -301,6 +301,7 @@ static void wrandom_flush(void)
 	for (i = 0; i < MULTIPATH_STATE_SIZE; ++i) {
 		struct multipath_route *r;
 
+		rcu_read_lock();
 		spin_lock_bh(&state[i].lock);
 		list_for_each_entry_rcu(r, &state[i].head, list) {
 			struct multipath_dest *d;
@@ -315,6 +316,7 @@ static void wrandom_flush(void)
 		}
 
 		spin_unlock_bh(&state[i].lock);
+		rcu_read_unlock();
 	}
 }
 
Index: linux/net/ipv4/netfilter/arp_tables.c
===================================================================
--- linux.orig/net/ipv4/netfilter/arp_tables.c
+++ linux/net/ipv4/netfilter/arp_tables.c
@@ -245,7 +245,7 @@ unsigned int arpt_do_table(struct sk_buf
 
 	read_lock_bh(&table->lock);
 	private = table->private;
-	table_base = (void *)private->entries[smp_processor_id()];
+	table_base = (void *)private->entries[raw_smp_processor_id()];
 	e = get_entry(table_base, private->hook_entry[hook]);
 	back = get_entry(table_base, private->underflow[hook]);
 
@@ -955,7 +955,7 @@ static int do_add_counters(void __user *
 
 	i = 0;
 	/* Choose the copy that is on our node */
-	loc_cpu_entry = private->entries[smp_processor_id()];
+	loc_cpu_entry = private->entries[raw_smp_processor_id()];
 	ARPT_ENTRY_ITERATE(loc_cpu_entry,
 			   private->size,
 			   add_counter_to_entry,
Index: linux/net/ipv4/netfilter/ip_tables.c
===================================================================
--- linux.orig/net/ipv4/netfilter/ip_tables.c
+++ linux/net/ipv4/netfilter/ip_tables.c
@@ -246,7 +246,7 @@ ipt_do_table(struct sk_buff **pskb,
 	read_lock_bh(&table->lock);
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
 	private = table->private;
-	table_base = (void *)private->entries[smp_processor_id()];
+	table_base = (void *)private->entries[raw_smp_processor_id()];
 	e = get_entry(table_base, private->hook_entry[hook]);
 
 	/* For return from builtin chain */
Index: linux/net/ipv4/tcp.c
===================================================================
--- linux.orig/net/ipv4/tcp.c
+++ linux/net/ipv4/tcp.c
@@ -1138,10 +1138,10 @@ int tcp_recvmsg(struct kiocb *iocb, stru
 	preempt_disable();
 	if ((len > sysctl_tcp_dma_copybreak) && !(flags & MSG_PEEK) &&
 	    !sysctl_tcp_low_latency && __get_cpu_var(softnet_data).net_dma) {
-		preempt_enable_no_resched();
+		preempt_enable();
 		tp->ucopy.pinned_list = dma_pin_iovec_pages(msg->msg_iov, len);
 	} else
-		preempt_enable_no_resched();
+		preempt_enable();
 #endif
 
 	do {
Index: linux/net/ipv6/netfilter/ip6_tables.c
===================================================================
--- linux.orig/net/ipv6/netfilter/ip6_tables.c
+++ linux/net/ipv6/netfilter/ip6_tables.c
@@ -282,7 +282,7 @@ ip6t_do_table(struct sk_buff **pskb,
 	read_lock_bh(&table->lock);
 	private = table->private;
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
-	table_base = (void *)private->entries[smp_processor_id()];
+	table_base = (void *)private->entries[raw_smp_processor_id()];
 	e = get_entry(table_base, private->hook_entry[hook]);
 
 	/* For return from builtin chain */
@@ -1097,7 +1097,7 @@ do_add_counters(void __user *user, unsig
 
 	i = 0;
 	/* Choose the copy that is on our node */
-	loc_cpu_entry = private->entries[smp_processor_id()];
+	loc_cpu_entry = private->entries[raw_smp_processor_id()];
 	IP6T_ENTRY_ITERATE(loc_cpu_entry,
 			  private->size,
 			  add_counter_to_entry,
Index: linux/net/xfrm/xfrm_user.c
===================================================================
--- linux.orig/net/xfrm/xfrm_user.c
+++ linux/net/xfrm/xfrm_user.c
@@ -1273,13 +1273,12 @@ static int xfrm_get_policy(struct sk_buf
 		xp = xfrm_policy_bysel_ctx(type, p->dir, &p->sel, tmp.security, delete);
 		security_xfrm_policy_free(&tmp);
 	}
-	if (delete)
-		xfrm_audit_log(NETLINK_CB(skb).loginuid, NETLINK_CB(skb).sid,
-			       AUDIT_MAC_IPSEC_DELSPD, (xp) ? 1 : 0, xp, NULL);
-
 	if (xp == NULL)
 		return -ENOENT;
 
+	xfrm_audit_log(NETLINK_CB(skb).loginuid, NETLINK_CB(skb).sid,
+		       AUDIT_MAC_IPSEC_DELSPD, delete, xp, NULL);
+
 	if (!delete) {
 		struct sk_buff *resp_skb;
 
