Return-Path: <linux-kernel-owner+w=401wt.eu-S934881AbZLGJq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934881AbZLGJq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 04:46:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934826AbZLGJqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 04:46:25 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:38968 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759298AbZLGJqX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 04:46:23 -0500
From: Nicolas Palix <npalix@diku.dk>
To: Paul Mundt <lethal@linux-sh.org>, kernel-janitors@vger.kernel.org,
       Stuart Menefy <stuart.menefy@st.com>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] arch/sh: Replace an explicit computation by the use of the container_of macro
Date: Mon, 7 Dec 2009 10:46:26 +0100
User-Agent: KMail/1.11.2 (Linux/2.6.28-17-generic; KDE/4.2.2; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200912071046.27330.npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 945e75c0e3202ab4cd0b8f185ea4be5609806edb Mon Sep 17 00:00:00 2001
From: Nicolas Palix <npalix@diku.dk>
Date: Mon, 7 Dec 2009 10:38:55 +0100

The macro container_of from kernel.h performs the same
pointer arithmetic operation.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
expression mptr;
expression member;
@@

- (void *)((char *)mptr - offsetof(T, member))
+ container_of(mptr, T, member)
// </smpl>

Signed-off-by: Nicolas Palix <npalix@diku.dk>
---
 arch/sh/kernel/cpu/irq/ipr.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/sh/kernel/cpu/irq/ipr.c b/arch/sh/kernel/cpu/irq/ipr.c
index c1508a9..9282d96 100644
--- a/arch/sh/kernel/cpu/irq/ipr.c
+++ b/arch/sh/kernel/cpu/irq/ipr.c
@@ -17,16 +17,17 @@
  * for more details.
  */
 #include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
 #include <linux/irq.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/io.h>
-#include <linux/interrupt.h>
 #include <linux/topology.h>
 
 static inline struct ipr_desc *get_ipr_desc(unsigned int irq)
 {
 	struct irq_chip *chip = get_irq_chip(irq);
-	return (void *)((char *)chip - offsetof(struct ipr_desc, chip));
+	return container_of(chip, struct ipr_desc, chip);
 }
 
 static void disable_ipr_irq(unsigned int irq)
-- 
1.6.0.4

