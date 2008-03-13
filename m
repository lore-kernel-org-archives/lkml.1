Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbYCMDu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYCMDu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 23:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYCMDuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 23:50:46 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:52960 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753874AbYCMDup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 23:50:45 -0400
Date: Thu, 13 Mar 2008 09:20:41 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Hugh Dickins <hugh@veritas.com>, Eric Dumazet <dada1@cosmosbay.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] net/lockdep: Make nl_table_lock read acquire softirq safe.
Message-ID: <20080313035041.GA23325@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080312120920.929901000@chello.nl> <20080312121323.959513000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312121323.959513000@chello.nl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 01:09:22PM +0100, Peter Zijlstra wrote:
> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 2.6.25-rc4-sched-devel.git #56
> ---------------------------------------------------------
> swapper/0 just changed the state of lock:
>  (&rt_hash_locks[i]){-+..}, at: [<ffffffff804721ac>] rt_intern_hash+0x8c/0x3b0
> but this lock took another, soft-read-irq-unsafe lock in the past:
>  (fib_hash_lock){-.-?}
> 
> and interrupts could create inverse lock ordering between them.
> 
> 

I found one more of these during the bootup.

It appears as though rwlocks totally missed lockdep validation because
of jumping their dependency chains!

-->

   From: Gautham R Shenoy <ego@in.ibm.com>
   
   net: Make nl_table_lock read acquire softirq safe.

    =========================================================
    [ INFO: possible irq lock inversion dependency detected ]
    2.6.25-rc3 #61
    ---------------------------------------------------------
    swapper/0 just changed the state of lock:
     (&tb->tb6_lock){-+..}, at: [<c049a5ab>] __ip6_ins_rt+0x1e/0x3c
    but this lock took another, soft-read-irq-unsafe lock in the past:
     (nl_table_lock){..-?}
    
    and interrupts could create inverse lock ordering between them.
    
    Full lockdep report at
    http://gautham.shenoy.googlepages.com/nl_table_lock_irq_inversion.log
    
    This patch fixes the problem by making the read acquire of nl_table_lock
    softirq safe.
    
    Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
    Cc: Peter Ziljstra <a.p.zijlstra@chello.nl>
    Cc: Eric Dumazet <dada1@cosmosbay.com>
    Cc: David S. Miller <davem@davemloft.net>

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 1ab0da2..7ade317 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -205,9 +205,9 @@ netlink_lock_table(void)
 {
 	/* read_lock() synchronizes us to netlink_table_grab */
 
-	read_lock(&nl_table_lock);
+	read_lock_bh(&nl_table_lock);
 	atomic_inc(&nl_table_users);
-	read_unlock(&nl_table_lock);
+	read_unlock_bh(&nl_table_lock);
 }
 
 static inline void
@@ -225,7 +225,7 @@ static inline struct sock *netlink_lookup(struct net *net, int protocol,
 	struct sock *sk;
 	struct hlist_node *node;
 
-	read_lock(&nl_table_lock);
+	read_lock_bh(&nl_table_lock);
 	head = nl_pid_hashfn(hash, pid);
 	sk_for_each(sk, node, head) {
 		if ((sk->sk_net == net) && (nlk_sk(sk)->pid == pid)) {
@@ -235,7 +235,7 @@ static inline struct sock *netlink_lookup(struct net *net, int protocol,
 	}
 	sk = NULL;
 found:
-	read_unlock(&nl_table_lock);
+	read_unlock_bh(&nl_table_lock);
 	return sk;
 }
 
@@ -1078,12 +1078,12 @@ void netlink_set_err(struct sock *ssk, u32 pid, u32 group, int code)
 	info.group = group;
 	info.code = code;
 
-	read_lock(&nl_table_lock);
+	read_lock_bh(&nl_table_lock);
 
 	sk_for_each_bound(sk, node, &nl_table[ssk->sk_protocol].mc_list)
 		do_one_set_err(sk, &info);
 
-	read_unlock(&nl_table_lock);
+	read_unlock_bh(&nl_table_lock);
 }
 
 /* must be called with netlink table grabbed */
@@ -1776,7 +1776,7 @@ static struct sock *netlink_seq_socket_idx(struct seq_file *seq, loff_t pos)
 static void *netlink_seq_start(struct seq_file *seq, loff_t *pos)
 	__acquires(nl_table_lock)
 {
-	read_lock(&nl_table_lock);
+	read_lock_bh(&nl_table_lock);
 	return *pos ? netlink_seq_socket_idx(seq, *pos - 1) : SEQ_START_TOKEN;
 }
 
@@ -1825,7 +1825,7 @@ static void *netlink_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 static void netlink_seq_stop(struct seq_file *seq, void *v)
 	__releases(nl_table_lock)
 {
-	read_unlock(&nl_table_lock);
+	read_unlock_bh(&nl_table_lock);
 }
 
 
-- 
Thanks and Regards
gautham
