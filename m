Return-Path: <linux-kernel-owner+w=401wt.eu-S1760421AbXJaUB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760421AbXJaUB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 16:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759517AbXJaUAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 16:00:05 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:48821 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759487AbXJaUAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 16:00:01 -0400
Date: Wed, 31 Oct 2007 15:59:39 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Magotari <magotari@gmail.com>
Subject: [PATCH 3/4] UML - Fix build for !CONFIG_TCP
Message-ID: <20071031195939.GA9640@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make UML build in the absence of CONFIG_INET by making the
inetaddr_notifier registration depend on it.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/net_kern.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

Index: linux-2.6.22/arch/um/drivers/net_kern.c
===================================================================
--- linux-2.6.22.orig/arch/um/drivers/net_kern.c	2007-10-12 12:09:00.000000000 -0400
+++ linux-2.6.22/arch/um/drivers/net_kern.c	2007-10-18 23:43:39.000000000 -0400
@@ -753,6 +753,7 @@ static struct mc_device net_mc = {
 	.remove		= net_remove,
 };
 
+#ifdef CONFIG_INET
 static int uml_inetaddr_event(struct notifier_block *this, unsigned long event,
 			      void *ptr)
 {
@@ -789,14 +790,13 @@ struct notifier_block uml_inetaddr_notif
 	.notifier_call		= uml_inetaddr_event,
 };
 
-static int uml_net_init(void)
+static void inet_register(void)
 {
 	struct list_head *ele;
 	struct uml_net_private *lp;
 	struct in_device *ip;
 	struct in_ifaddr *in;
 
-	mconsole_register_dev(&net_mc);
 	register_inetaddr_notifier(&uml_inetaddr_notifier);
 
 	/* Devices may have been opened already, so the uml_inetaddr_notifier
@@ -816,7 +816,17 @@ static int uml_net_init(void)
 		}
 	}
 	spin_unlock(&opened_lock);
+}
+#else
+static inline void inet_register(void)
+{
+}
+#endif
 
+static int uml_net_init(void)
+{
+	mconsole_register_dev(&net_mc);
+	inet_register();
 	return 0;
 }
 
