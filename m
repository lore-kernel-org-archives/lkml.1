Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab0CCOq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 09:46:56 -0500
Received: from mail.gmx.net ([213.165.64.20]:48823 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754467Ab0CCOqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 09:46:54 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+V1Aou62aVfEaI6R9kbCUti3UHJ1yyz4OHlGTF7d
	QEGRncISBriMlW
Subject: Re: [rfc/rft][patch] should use scheduler sync hint in
 tcp_prequeue()?
From: Mike Galbraith <efault@gmx.de>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <20100303.060529.195713861.davem@davemloft.net>
References: <1267522901.25906.101.camel@marge.simson.net>
	 <1267529273.2964.111.camel@edumazet-laptop>
	 <20100303.060529.195713861.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 03 Mar 2010 15:46:50 +0100
Message-Id: <1267627610.6264.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46999999999999997
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 06:05 -0800, David Miller wrote:

> It definitely looks like an oversight to me and we should add
> be using wake_up_interruptible_sync_poll() in tcp_prequeue()
> as above.
> 
> Ingo?

Implied ack from network maintainer implies ship it to me.

net: add scheduler sync hint to tcp_prequeue().

Decreases the odds wakee will suffer from frequent cache misses.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: David Miller <davem@davemloft.net>
LKML-Reference: <new-submission>

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 34f5cc2..ba3fc64 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -939,7 +939,7 @@ static inline int tcp_prequeue(struct sock *sk, struct sk_buff *skb)
 
 		tp->ucopy.memory = 0;
 	} else if (skb_queue_len(&tp->ucopy.prequeue) == 1) {
-		wake_up_interruptible_poll(sk->sk_sleep,
+		wake_up_interruptible_sync_poll(sk->sk_sleep,
 					   POLLIN | POLLRDNORM | POLLRDBAND);
 		if (!inet_csk_ack_scheduled(sk))
 			inet_csk_reset_xmit_timer(sk, ICSK_TIME_DACK,


