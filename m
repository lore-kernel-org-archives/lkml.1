Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbYCQVd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbYCQVd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 17:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbYCQVdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 17:33:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbYCQVdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 17:33:50 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>,
       Ravikiran Thirumalai <kiran@scalemp.com>
Subject: [PATCH] vsmp build fixes
Date: Mon, 17 Mar 2008 18:30:12 -0300
Message-Id: <1205789412-26851-1-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VSMP depends on PCI, but the file is now compiled conditionally
on PARAVIRT, no VSMP, so enclose everything in an ifdef CONFIG_PCI.

We have to be careful enough to let is_vsmp_box and vsmp_init defined,
since they are used outside this file

Signed-off-by: Glauber Costa <gcosta@redhat.com>
CC: Ravikiran Thirumalai <kiran@scalemp.com>
---
 arch/x86/kernel/vsmp_64.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index a00961d..ccf23ae 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -19,6 +19,7 @@ #include <asm/pci-direct.h>
 #include <asm/io.h>
 #include <asm/paravirt.h>
 
+#ifdef CONFIG_PCI
 /*
  * Interrupt control on vSMPowered systems:
  * ~AC is a shadow of IF.  If IF is 'on' AC should be 'off'
@@ -87,12 +88,18 @@ int is_vsmp_box(void)
 	if (read_pci_config(0, 0x1f, 0, PCI_VENDOR_ID) ==
 	     (PCI_VENDOR_ID_SCALEMP || (PCI_DEVICE_ID_SCALEMP_VSMP_CTL << 16)))
 		vsmp = 1;
-
 	return vsmp;
 }
+#else
+int is_vsmp_box(void)
+{
+	return 0;
+}
+#endif
 
 void __init vsmp_init(void)
 {
+#ifdef CONFIG_PCI
 	void *address;
 	unsigned int cap, ctl, cfg;
 
@@ -125,5 +132,6 @@ void __init vsmp_init(void)
 	}
 
 	early_iounmap(address, 8);
+#endif
 	return;
 }
-- 
1.4.2

