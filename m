Return-Path: <linux-kernel-owner+w=401wt.eu-S1757402AbYHBPOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbYHBPOX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 11:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754971AbYHBPOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 11:14:01 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:37834 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbYHBPOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 11:14:00 -0400
Date: Sat, 2 Aug 2008 17:13:57 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 5/10] drivers/misc: Use DIV_ROUND_UP
Message-ID: <Pine.LNX.4.64.0808021713350.20095@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/misc/sgi-gru/grukservices.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/misc/sgi-gru/grukservices.c b/drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c
+++ b/drivers/misc/sgi-gru/grukservices.c
@@ -466,7 +466,7 @@ int gru_send_message_gpa(unsigned long m
 	STAT(mesq_send);
 	BUG_ON(bytes < sizeof(int) || bytes > 2 * GRU_CACHE_LINE_BYTES);
 
-	clines = (bytes + GRU_CACHE_LINE_BYTES - 1) / GRU_CACHE_LINE_BYTES;
+	clines = DIV_ROUND_UP(bytes, GRU_CACHE_LINE_BYTES);
 	if (gru_get_cpu_resources(bytes, &cb, &dsr))
 		return MQE_BUG_NO_RESOURCES;
 	memcpy(dsr, mesg, bytes);
