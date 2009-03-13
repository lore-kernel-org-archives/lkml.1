Return-Path: <linux-kernel-owner+w=401wt.eu-S1759123AbZCMIWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbZCMIWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757906AbZCMIMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:12:42 -0400
Received: from gw.goop.org ([64.81.55.164]:34830 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757214AbZCMIMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:12:36 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 21/24] xen: drop kexec bits from /sys/hypervisor since kexec isn't implemented yet
Date: Fri, 13 Mar 2009 01:11:57 -0700
Message-Id: <1236931920-6861-22-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236931920-6861-1-git-send-email-jeremy@goop.org>
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <Ian.Campbell@citrix.com>

I needed this to compile since there is no kexec yet in pvops kernel
  CC      drivers/xen/sys-hypervisor.o
drivers/xen/sys-hypervisor.c: In function 'hyper_sysfs_init':
drivers/xen/sys-hypervisor.c:405: error: 'vmcoreinfo_size_xen' undeclared (first use in this function)
drivers/xen/sys-hypervisor.c:405: error: (Each undeclared identifier is reported only once
drivers/xen/sys-hypervisor.c:405: error: for each function it appears in.)
drivers/xen/sys-hypervisor.c:406: error: implicit declaration of function 'xen_sysfs_vmcoreinfo_init'
drivers/xen/sys-hypervisor.c: In function 'hyper_sysfs_exit':
drivers/xen/sys-hypervisor.c:433: error: 'vmcoreinfo_size_xen' undeclared (first use in this function)
drivers/xen/sys-hypervisor.c:434: error: implicit declaration of function 'xen_sysfs_vmcoreinfo_destroy'

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/xen/sys-hypervisor.c |   41 -----------------------------------------
 1 files changed, 0 insertions(+), 41 deletions(-)

diff --git a/drivers/xen/sys-hypervisor.c b/drivers/xen/sys-hypervisor.c
index 1267d6f..88a60e0 100644
--- a/drivers/xen/sys-hypervisor.c
+++ b/drivers/xen/sys-hypervisor.c
@@ -353,32 +353,6 @@ static void xen_properties_destroy(void)
 	sysfs_remove_group(hypervisor_kobj, &xen_properties_group);
 }
 
-#ifdef CONFIG_KEXEC
-
-extern size_t vmcoreinfo_size_xen;
-extern unsigned long paddr_vmcoreinfo_xen;
-
-static ssize_t vmcoreinfo_show(struct hyp_sysfs_attr *attr, char *page)
-{
-	return sprintf(page, "%lx %zx\n",
-		paddr_vmcoreinfo_xen, vmcoreinfo_size_xen);
-}
-
-HYPERVISOR_ATTR_RO(vmcoreinfo);
-
-static int __init xen_sysfs_vmcoreinfo_init(void)
-{
-	return sysfs_create_file(hypervisor_kobj,
-				 &vmcoreinfo_attr.attr);
-}
-
-static void xen_sysfs_vmcoreinfo_destroy(void)
-{
-	sysfs_remove_file(hypervisor_kobj, &vmcoreinfo_attr.attr);
-}
-
-#endif
-
 static int __init hyper_sysfs_init(void)
 {
 	int ret;
@@ -401,20 +375,9 @@ static int __init hyper_sysfs_init(void)
 	ret = xen_properties_init();
 	if (ret)
 		goto prop_out;
-#ifdef CONFIG_KEXEC
-	if (vmcoreinfo_size_xen != 0) {
-		ret = xen_sysfs_vmcoreinfo_init();
-		if (ret)
-			goto vmcoreinfo_out;
-	}
-#endif
 
 	goto out;
 
-#ifdef CONFIG_KEXEC
-vmcoreinfo_out:
-#endif
-	xen_properties_destroy();
 prop_out:
 	xen_sysfs_uuid_destroy();
 uuid_out:
@@ -429,10 +392,6 @@ out:
 
 static void __exit hyper_sysfs_exit(void)
 {
-#ifdef CONFIG_KEXEC
-	if (vmcoreinfo_size_xen != 0)
-		xen_sysfs_vmcoreinfo_destroy();
-#endif
 	xen_properties_destroy();
 	xen_compilation_destroy();
 	xen_sysfs_uuid_destroy();
-- 
1.6.0.6

