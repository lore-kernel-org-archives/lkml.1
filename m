Return-Path: <linux-kernel-owner+w=401wt.eu-S1762258AbYD2NBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762258AbYD2NBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762070AbYD2NB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:01:29 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:48750 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761967AbYD2NB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:01:28 -0400
Date: Tue, 29 Apr 2008 18:31:11 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: linux-kernel@vger.kernel.org, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4/8] net: af_netlink: deadlock
Message-ID: <20080429130111.GE23562@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080429125659.GA23562@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429125659.GA23562@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: net: af_netlink: deadlock

From: Gautham R Shenoy <ego@in.ibm.com>

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: David S. Miller <davem@davemloft.net>
---

 net/netlink/af_netlink.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

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
