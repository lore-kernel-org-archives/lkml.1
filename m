Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbZJaJUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbZJaJUc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 05:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbZJaJUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 05:20:32 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:37362 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbZJaJUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 05:20:30 -0400
Message-ID: <4AEC015D.80601@gmail.com>
Date: Sat, 31 Oct 2009 10:20:29 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: francis.moro@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: WARNING: at net/ipv4/af_inet.c:154 inet_sock_destruct
References: <38b2ab8a0910300144i7a3c190fi9aa3d079c9cdb754@mail.gmail.com>	<4AEACD88.8080108@gmail.com>	<4AEB0059.1050400@gmail.com> <20091030.122640.137286305.davem@davemloft.net>
In-Reply-To: <20091030.122640.137286305.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sat, 31 Oct 2009 10:20:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller a écrit :
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Fri, 30 Oct 2009 16:03:53 +0100
> 
>> [PATCH take2] net: fix sk_forward_alloc corruption
>>
>> On UDP sockets, we must call skb_free_datagram() with socket locked,
>> or risk sk_forward_alloc corruption. This requirement is not respected
>> in SUNRPC.
>>
>> Add a convenient helper, skb_free_datagram_locked() and use it in SUNRPC
>>
>> Reported-by: Francis Moreau <francis.moro@gmail.com>
>> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> 
> I've tentatively applied this to my net-2.6 tree, I won't
> push it out until we have positive testing results.

I tested nfs/nfsd with fillowing additional debugging patch.

Without the fix (net: fix sk_forward_alloc corruption), I got warnings,
while with fix applied, I got no warnings. Its probably hard to hit
original bug since its a very small race window.

Trace without fix :

[  226.686788] RPC: Registered udp transport module.
[  226.686791] RPC: Registered tcp transport module.
[  226.686792] RPC: Registered tcp NFSv4.1 backchannel transport module.
[  226.851677] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[  226.869381] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[  226.869443] NFSD: unable to find recovery directory /var/lib/nfs/v4recovery
[  226.869488] NFSD: starting 90-second grace period
[  226.870564] svc: failed to register lockdv1 RPC service (errno 97).
[  244.401237] ------------[ cut here ]------------
[  244.401288] WARNING: at include/net/sock.h:886 sock_rfree+0x54/0x70()
[  244.401334] Hardware name: ProLiant BL460c G1
[  244.401379] Modules linked in: nfsd lockd auth_rpcgss sunrpc exportfs bonding ipv6
[  244.401699] Pid: 5295, comm: nfsd Not tainted 2.6.32-rc3-00920-gbdd6be3-dirty #342
[  244.401745] Call Trace:
[  244.401784]  [<c055355a>] ? printk+0x1d/0x23
[  244.401827]  [<c023c3f2>] warn_slowpath_common+0x72/0xa0
[  244.401869]  [<c04b0d54>] ? sock_rfree+0x54/0x70
[  244.401909]  [<c04b0d54>] ? sock_rfree+0x54/0x70
[  244.401950]  [<c023c43a>] warn_slowpath_null+0x1a/0x20
[  244.401991]  [<c04b0d54>] sock_rfree+0x54/0x70
[  244.402033]  [<c04b4cf5>] skb_release_head_state+0x45/0xe0
[  244.402084]  [<c04b49f0>] __kfree_skb+0x10/0x90
[  244.402125]  [<c04b4a8c>] consume_skb+0x1c/0x40
[  244.402166]  [<c04b7c62>] skb_free_datagram+0x12/0x70
[  244.402217]  [<fc9fa177>] svc_release_skb+0x37/0x60 [sunrpc]
[  244.402261]  [<c026f452>] ? module_put+0x62/0xf0
[  244.402308]  [<fca05c98>] svc_send+0x28/0xc0 [sunrpc]
[  244.402356]  [<fc9f8acb>] svc_process+0x22b/0x770 [sunrpc]
[  244.402416]  [<fd04895c>] nfsd+0xac/0x140 [nfsd]
[  244.402484]  [<fd0488b0>] ? nfsd+0x0/0x140 [nfsd]
[  244.402543]  [<c0257ab4>] kthread+0x74/0x80
[  244.402602]  [<c0257a40>] ? kthread+0x0/0x80
[  244.402656]  [<c020390f>] kernel_thread_helper+0x7/0x10
[  244.402711] ---[ end trace e202cdb1b491aa15 ]---


Debugging patch :

Intent is to make sure sock is locked by user or by softirq handler,
unless we are currently dismantling socket (sk_refcnt==0)

To speedup this test, we could use several bits of sk_lock.owned instead 
of one for the user case.
(one for lock owned by user, one for lowk owned by softirq, one in dismantle phase)

diff --git a/include/net/sock.h b/include/net/sock.h
index 55de3bd..08ecb0e 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -849,10 +849,15 @@ static inline int sk_rmem_schedule(struct sock *sk, int size)
 		__sk_mem_schedule(sk, size, SK_MEM_RECV);
 }
 
+#define sock_owned_by_user(sk)	((sk)->sk_lock.owned)
+#define sock_owned(sk)		((sk)->sk_lock.owned ||		\
+				 spin_is_locked(&(sk)->sk_lock.slock))
+
 static inline void sk_mem_reclaim(struct sock *sk)
 {
 	if (!sk_has_account(sk))
 		return;
+	WARN_ON(!(sock_owned(sk) || atomic_read(&sk->sk_refcnt) == 0));
 	if (sk->sk_forward_alloc >= SK_MEM_QUANTUM)
 		__sk_mem_reclaim(sk);
 }
@@ -861,6 +866,7 @@ static inline void sk_mem_reclaim_partial(struct sock *sk)
 {
 	if (!sk_has_account(sk))
 		return;
+	WARN_ON(!(sock_owned(sk) || atomic_read(&sk->sk_refcnt) == 0));
 	if (sk->sk_forward_alloc > SK_MEM_QUANTUM)
 		__sk_mem_reclaim(sk);
 }
@@ -869,6 +875,7 @@ static inline void sk_mem_charge(struct sock *sk, int size)
 {
 	if (!sk_has_account(sk))
 		return;
+	WARN_ON(!sock_owned(sk));
 	sk->sk_forward_alloc -= size;
 }
 
@@ -876,6 +883,7 @@ static inline void sk_mem_uncharge(struct sock *sk, int size)
 {
 	if (!sk_has_account(sk))
 		return;
+	WARN_ON(!sock_owned(sk));
 	sk->sk_forward_alloc += size;
 }
 
@@ -900,7 +908,6 @@ static inline void sk_wmem_free_skb(struct sock *sk, struct sk_buff *skb)
  * Since ~2.3.5 it is also exclusive sleep lock serializing
  * accesses from user process context.
  */
-#define sock_owned_by_user(sk)	((sk)->sk_lock.owned)
 
 /*
  * Macro so as to not evaluate some arguments when

