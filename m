Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0BSPQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:16:33 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:36684 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab0BSPQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:16:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=deGqyXtK1Bv59JFW6pDzlDPHM/ulDn5tvbGCmSs43u336TsYuzlu1OE9dM9mOWrwKr
         I7WVShx+PxfYUrgUgx32qcTrLgCYaANz+asWFnXuY812d/T9COrRqchd7cvr0ABEEq55
         T+ibNE2hdaraWQgv45803ZknZvxR5+Afuy2Bs=
Subject: Re: [PATCH 2/2] packet: convert socket list to RCU
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: "David S. Miller" <davem@davemloft.net>, Li Zefan <lizf@cn.fujitsu.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100219054201.501571315@vyatta.com>
References: <20100219054145.959067404@vyatta.com>
	 <20100219054201.501571315@vyatta.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Feb 2010 16:16:24 +0100
Message-ID: <1266592584.3136.41.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 18 février 2010 à 21:41 -0800, Stephen Hemminger a écrit :

> Convert AF_PACKET to use RCU, eliminating one more reader/writer lock.
> 
> I needed to create some minor additional socket list RCU infrastructure
> to make this work. Note: there is no need for a real sk_del_node_init_rcu(), 
> because sk_del_node_init is doing the equivalent thing to 
> hlst_del_init_rcu already; but added some comments to try and make that obvious.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 

Stephen, I am a bit worried by the interaction between packet_release()
and packet_notifier()

With your version, packet_notifier() can run and let another cpu run
packet_release() un-contented. Both cpus could manipulate same po (and
particularly po->running)

Before your patch, the read_lock() done in packet_notifier() was
preventing packet_release() runnning at the same time.

Maybe packet_release() should lock po->bind_lock before manipulating
po->running, avoiding a refcount error.

Something like this preliminary patch :

[PATCH] packet: fix a race in packet_release

packet_release() has a potential race with packet_notifier(NETDEV_DOWN),
leading to a double __sock_put(). (dev_remove_pack() is safe)

Fix is to always use po->bind_lock before accessing po->running

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 10f7295..b706031 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1271,15 +1271,15 @@ static int packet_release(struct socket *sock)
 	 *	Unhook packet receive handler.
 	 */
 
+	spin_lock(&po->bind_lock);
 	if (po->running) {
-		/*
-		 *	Remove the protocol hook
-		 */
-		dev_remove_pack(&po->prot_hook);
+		__sock_put(sk);
 		po->running = 0;
 		po->num = 0;
-		__sock_put(sk);
-	}
+		spin_unlock(&po->bind_lock);
+		dev_remove_pack(&po->prot_hook);
+	} else
+		spin_unlock(&po->bind_lock);
 
 	packet_flush_mclist(sk);
 


