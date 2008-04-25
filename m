Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbYDYIzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbYDYIzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 04:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbYDYIzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 04:55:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50529
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757105AbYDYIzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 04:55:08 -0400
Date: Fri, 25 Apr 2008 01:55:08 -0700 (PDT)
Message-Id: <20080425.015508.254917794.davem@davemloft.net>
To: shigeonx@gmail.com
Cc: ilpo.jarvinen@helsinki.fi, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: XTP for 2.6.25
From: David Miller <davem@davemloft.net>
In-Reply-To: <18b669d80804250151h516788cdqc7931a7ab5a195de@mail.gmail.com>
References: <18b669d80804250059m793f3f56xc4fdb8bad949fa3@mail.gmail.com>
	<Pine.LNX.4.64.0804251115470.2363@wrl-59.cs.helsinki.fi>
	<18b669d80804250151h516788cdqc7931a7ab5a195de@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Shigeo N" <shigeonx@gmail.com>
Date: Fri, 25 Apr 2008 17:51:49 +0900

> One host(sender) is 2.6.25, but the other(receiver) is 2.6.18.
> I will evaluate again after I upgrade it to 2.6.25.

The bug fix isn't in 2.6.25 either.

Here is the patch in question, please add it to the kernel
during your tests.

>From 3c0390e1a6d8a5d0cdae57959f0be37a236b474d Mon Sep 17 00:00:00 2001
From: John Heffner <jheffner@napa.(none)>
Date: Fri, 25 Apr 2008 01:43:57 -0700
Subject: [PATCH] [TCP]: Increase the max_burst threshold from 3 to tp->reordering.

[ Upstream commit: dd9e0dda66ba38a2ddd1405ac279894260dc5c36 ]

This change is necessary to allow cwnd to grow during persistent
reordering.  Cwnd moderation is applied when in the disorder state
and an ack that fills the hole comes in.  If the hole was greater
than 3 packets, but less than tp->reordering, cwnd will shrink when
it should not have.

Signed-off-by: John Heffner <jheffner@napa.(none)>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/net/tcp.h |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4fd3eb2..d69d12e 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -776,11 +776,14 @@ extern void tcp_enter_cwr(struct sock *sk, const int set_ssthresh);
 extern __u32 tcp_init_cwnd(struct tcp_sock *tp, struct dst_entry *dst);
 
 /* Slow start with delack produces 3 packets of burst, so that
- * it is safe "de facto".
+ * it is safe "de facto".  This will be the default - same as
+ * the default reordering threshold - but if reordering increases,
+ * we must be able to allow cwnd to burst at least this much in order
+ * to not pull it back when holes are filled.
  */
 static __inline__ __u32 tcp_max_burst(const struct tcp_sock *tp)
 {
-	return 3;
+	return tp->reordering;
 }
 
 /* Returns end sequence number of the receiver's advertised window */
-- 
1.5.5.1.57.g5909c

