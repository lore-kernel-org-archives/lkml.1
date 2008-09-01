Return-Path: <linux-kernel-owner+w=401wt.eu-S1752423AbYIAXjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbYIAXjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbYIAXid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:38:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:52971 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbYIAXic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:38:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CDT5LVyvhwGAkfjs0y/YuwmAD+6hA4/JOeK6VA3lRtXNRqszVGiC3aoXxUrq6efPdE
         aqQfOT0bdY3hq2w6XOZk7z8F4pKEVHWbL4sXXuBsVDmPzyBuoZHYaLqsENDttVE9Qv/T
         j512voDJzO8I3WM66Uo50EQn+s955ucxBgiwQ=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 3/6] x86: unify using pci_mmcfg_insert_resource
Date: Mon,  1 Sep 2008 16:37:23 -0700
Message-Id: <1220312246-30879-3-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220312246-30879-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220312246-30879-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

even with known_bridge insert them late too.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
+++ linux-2.6/arch/x86/pci/mmconfig-shared.c
@@ -209,7 +209,7 @@ static int __init pci_mmcfg_check_hostbr
 	return name != NULL;
 }
 
-static void __init pci_mmcfg_insert_resources(unsigned long resource_flags)
+static void __init pci_mmcfg_insert_resources(void)
 {
 #define PCI_MMCFG_RESOURCE_NAME_LEN 19
 	int i;
@@ -233,7 +233,7 @@ static void __init pci_mmcfg_insert_reso
 			 cfg->pci_segment);
 		res->start = cfg->address;
 		res->end = res->start + (num_buses << 20) - 1;
-		res->flags = IORESOURCE_MEM | resource_flags;
+		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 		insert_resource(&iomem_resource, res);
 		names += PCI_MMCFG_RESOURCE_NAME_LEN;
 	}
@@ -434,11 +434,9 @@ static void __init __pci_mmcfg_init(int
 	    (pci_mmcfg_config[0].address == 0))
 		return;
 
-	if (pci_mmcfg_arch_init()) {
-		if (known_bridge)
-			pci_mmcfg_insert_resources(IORESOURCE_BUSY);
+	if (pci_mmcfg_arch_init())
 		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
-	} else {
+	else {
 		/*
 		 * Signal not to attempt to insert mmcfg resources because
 		 * the architecture mmcfg setup could not initialize.
@@ -475,7 +473,7 @@ static int __init pci_mmcfg_late_insert_
 	 * marked so it won't cause request errors when __request_region is
 	 * called.
 	 */
-	pci_mmcfg_insert_resources(0);
+	pci_mmcfg_insert_resources();
 
 	return 0;
 }
