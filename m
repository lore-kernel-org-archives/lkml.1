Return-Path: <linux-kernel-owner+w=401wt.eu-S933208AbZFQL6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208AbZFQL6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 07:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764063AbZFQL43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 07:56:29 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:39105 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763385AbZFQL42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 07:56:28 -0400
Message-ID: <4A38D9BE.3020403@gmail.com>
Date: Wed, 17 Jun 2009 13:55:42 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [bug] __nf_ct_refresh_acct(): WARNING: at lib/list_debug.c:30
 __list_add+0x7d/0xad()
References: <20090615.050449.144947903.davem@davemloft.net> <20090616091538.GA4184@elte.hu> <20090616.034752.226811527.davem@davemloft.net> <20090616105304.GA3579@elte.hu> <20090616122415.GA16630@elte.hu> <20090617092152.GA17449@elte.hu> <4A38C2F3.3000009@gmail.com> <4A38D5BD.2040502@trash.net>
In-Reply-To: <4A38D5BD.2040502@trash.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 17 Jun 2009 13:55:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy a écrit :
> Eric Dumazet wrote:
>> IPS_CONFIRMED_BIT is set under nf_conntrack_lock (in
>> __nf_conntrack_confirm()),
>> we probably want to add a synchronisation under ct->lock as well,
>> or __nf_ct_refresh_acct() could set ct->timeout.expires to extra_jiffies,
>> while a different cpu could confirm the conntrack.
> 
> Before the conntrack is confirmed, it is exclusively handled by a
> single CPU. I agree that we need to make sure the IPS_CONFIRMED_BIT
> is visible before we add the conntrack to the hash table since the
> lookup is lockless, but simply moving the set_bit before the hash
> insertion should be fine I think.
> 

Hmm...  now we could have the reverse case :

__nf_conntrack_confirm() could be "interrupted" by __nf_ct_refresh_acct()

index 5f72b94..22755fa 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -425,6 +425,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	/* Remove from unconfirmed list */
 	hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
 
+	set_bit(IPS_CONFIRMED_BIT, &ct->status);
 	__nf_conntrack_hash_insert(ct, hash, repl_hash);
 	/* Timer relative to confirmation time, not original
 	   setting time, otherwise we'd get timer wrap in
@@ -432,7 +433,6 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	ct->timeout.expires += jiffies;

<< What happens if another packet is handled by __nf_ct_refresh_acct here >>
(seeing or not the IPS_CONFIRMED_BIT) >>

 	add_timer(&ct->timeout);

<< or here ? >>


 	atomic_inc(&ct->ct_general.use);
-	set_bit(IPS_CONFIRMED_BIT, &ct->status);
 	NF_CT_STAT_INC(net, insert);
 	spin_unlock_bh(&nf_conntrack_lock);
 	help = nfct_help(ct);



Problem is timeout.expires is either a relative or absolute timeout, and changes happen
in __nf_conntrack_confirm() or __nf_ct_refresh_acct().

We must have a synchronization (an barriers), a single bit wont be enough.

