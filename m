Return-Path: <linux-kernel-owner+w=401wt.eu-S1761528AbXJYD7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761528AbXJYD7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 23:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758883AbXJYD7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 23:59:22 -0400
Received: from ozlabs.org ([203.10.76.45]:52931 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758575AbXJYD7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 23:59:21 -0400
To: <netdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 25 Oct 2007 13:59:08 +1000
Subject: [PATCH] napi: use non-interruptible sleep in napi_disable
Message-Id: <20071025035920.C2D39DDECE@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The current napi_disable() uses msleep_interruptible() but doesn't
(and can't) exit in case there's a signal, thus ending up doing a
hot spin without a cpu_relax. Use uninterruptible sleep instead.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 include/linux/netdevice.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-work/include/linux/netdevice.h
===================================================================
--- linux-work.orig/include/linux/netdevice.h	2007-10-17 12:39:16.000000000 +1000
+++ linux-work/include/linux/netdevice.h	2007-10-17 12:45:00.000000000 +1000
@@ -390,7 +390,7 @@ static inline void napi_complete(struct 
 static inline void napi_disable(struct napi_struct *n)
 {
 	while (test_and_set_bit(NAPI_STATE_SCHED, &n->state))
-		msleep_interruptible(1);
+		msleep(1);
 }
 
 /**
