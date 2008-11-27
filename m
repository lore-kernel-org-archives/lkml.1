Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbYK0Qto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbYK0Qto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 11:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYK0Qte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 11:49:34 -0500
Received: from servatis.alsatis.com ([62.193.233.66]:46459 "EHLO
	smtp.alsatis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbYK0Qtd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 11:49:33 -0500
X-Greylist: delayed 1833 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Nov 2008 11:49:33 EST
Date: Thu, 27 Nov 2008 17:18:51 +0100
From: =?UTF-8?B?RnLDqWTDqXJpYw==?= Moulins 
	<frederic.moulins@alsatis.com>
To: jchapman@katalix.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [PPPOL2TP] Add missing sock_put() in pppol2tp_release()
Message-ID: <20081127171851.3fe7db5a@iter>
Organization: als@tis
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pppol2tp_sock_to_session() do sock_hold() if the session to release is
not NULL.

Signed-off-by: Frédéric Moulins <frederic.moulins@alsatis.com>
---
Patch is applicable to kernels 2.6.26 and following.

Tested with a 2.6.26 stable kernel:
without this patch, a session in a persistent tunnel cannot be
established again (connect failed: -17), and the pppol2tp kernel module
cannot be removed because still considered in use after stopping all
userspace daemons.

diff --git a/drivers/net/pppol2tp.c b/drivers/net/pppol2tp.c
index ff175e8..de80ba4 100644
--- a/drivers/net/pppol2tp.c
+++ b/drivers/net/pppol2tp.c
@@ -1353,6 +1353,7 @@ static int pppol2tp_release(struct socket *sock)
 			kfree_skb(skb);
 			sock_put(sk);
 		}
+		sock_put(sk);
 	}
 
 	release_sock(sk);
