Return-Path: <linux-kernel-owner+w=401wt.eu-S1761337AbYGRWSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761337AbYGRWSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760805AbYGRWRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:17:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:47967 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760705AbYGRWRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:17:39 -0400
Date: Fri, 18 Jul 2008 15:16:53 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu
Subject: [patch 2/3] fastboot: turn the USB hostcontroller initcalls into
 async initcalls
Message-ID: <20080718151653.459dc37d@infradead.org>
In-Reply-To: <20080718151524.5ef9e29b@infradead.org>
References: <20080718151524.5ef9e29b@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] fastboot: turn the USB hostcontroller initcalls into async initcalls

the USB host controller init calls take a long time, mostly due to a
"minimally 100 msec" delay *per port* during initialization.
These are prime candidates for going in parallel to everything else.

The USB device ordering is not affected by this due to the
serialized-within-eachother property of async initcalls.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/usb/host/ehci-hcd.c |    2 +-
 drivers/usb/host/ohci-hcd.c |    2 +-
 drivers/usb/host/uhci-hcd.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 369a8a5..8f84b17 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1101,7 +1101,7 @@ clean0:
 #endif
 	return retval;
 }
-module_init(ehci_hcd_init);
+module_init_async(ehci_hcd_init);
 
 static void __exit ehci_hcd_cleanup(void)
 {
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index a8160d6..e060ed1 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -1165,7 +1165,7 @@ static int __init ohci_hcd_mod_init(void)
 
 	return retval;
 }
-module_init(ohci_hcd_mod_init);
+module_init_async(ohci_hcd_mod_init);
 
 static void __exit ohci_hcd_mod_exit(void)
 {
diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index 3a7bfe7..f2a05ac 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -999,7 +999,7 @@ static void __exit uhci_hcd_cleanup(void)
 	kfree(errbuf);
 }
 
-module_init(uhci_hcd_init);
+module_init_async(uhci_hcd_init);
 module_exit(uhci_hcd_cleanup);
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
-- 
1.5.5.1

