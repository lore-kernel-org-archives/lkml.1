Return-Path: <linux-kernel-owner+w=401wt.eu-S965756AbXCHBL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965756AbXCHBL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 20:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965763AbXCHBL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 20:11:56 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43107 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965756AbXCHBLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 20:11:55 -0500
Date: Wed, 7 Mar 2007 17:07:31 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Willy Tarreau <w@1wt.eu>, David Miller <davem@davemloft.net>
Cc: rkuhn@e18.physik.tu-muenchen.de, andi@firstfloor.org, dada1@cosmosbay.com,
       jengelh@linux01.gwdg.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [PATCH] tcp_cubic: use 32 bit math
Message-ID: <20070307170731.2b4397e3@freekitty>
In-Reply-To: <20070307060838.GI943@1wt.eu>
References: <20070306144529.GA2004@one.firstfloor.org>
	<84C47260-4B57-4568-8197-58F438A6F737@e18.physik.tu-muenchen.de>
	<20070306102941.32471d57@freekitty>
	<20070306.135834.26100913.davem@davemloft.net>
	<20070306144706.4585c079@freekitty>
	<20070306145842.7d7fea84@freekitty>
	<20070307060838.GI943@1wt.eu>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The basic calculation has to be done in 32 bits to avoid
doing 64 bit divide by 3. The value x is only 22bits max
so only need full 64 bits only for x^2.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

---
 net/ipv4/tcp_cubic.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- net-2.6.22.orig/net/ipv4/tcp_cubic.c	2007-03-07 15:51:37.000000000 -0800
+++ net-2.6.22/net/ipv4/tcp_cubic.c	2007-03-07 17:06:02.000000000 -0800
@@ -96,7 +96,7 @@
  */
 static u32 cubic_root(u64 a)
 {
-	u64 x;
+	u32 x;
 
 	/* Initial estimate is based on:
 	 * cbrt(x) = exp(log(x) / 3)
@@ -104,9 +104,9 @@
 	x = 1u << (fls64(a)/3);
 
 	/* converges to 32 bits in 3 iterations */
-	x = (2 * x + div64_64(a, x*x)) / 3;
-	x = (2 * x + div64_64(a, x*x)) / 3;
-	x = (2 * x + div64_64(a, x*x)) / 3;
+	x = (2 * x + (u32)div64_64(a, (u64)x*(u64)x)) / 3;
+	x = (2 * x + (u32)div64_64(a, (u64)x*(u64)x)) / 3;
+	x = (2 * x + (u32)div64_64(a, (u64)x*(u64)x)) / 3;
 
 	return x;
 }
