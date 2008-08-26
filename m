Return-Path: <linux-kernel-owner+w=401wt.eu-S1751822AbYHZF2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbYHZF2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 01:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbYHZF2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 01:28:14 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:37235 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751555AbYHZF2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 01:28:13 -0400
Date: Tue, 26 Aug 2008 14:28:12 +0900
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       linux-ia64@vger.kernel.org, xen-devel@lists.xensource.com,
       xen-ia64-devel@lists.xensource.com
Subject: [PATCH] xen: wrap load_cr3() in manage.c for ia64 support.
Message-ID: <20080826052812.GD1496%yamahata@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wrap load_cr3() in manage.c by xen_pre_device_suspend()
because it is x86 dependent.

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 arch/x86/xen/suspend.c |    5 +++++
 drivers/xen/manage.c   |    3 +--
 include/xen/xen-ops.h  |    1 +
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index 2a234db..ac139a2 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -10,6 +10,11 @@
 #include "xen-ops.h"
 #include "mmu.h"
 
+void xen_pre_device_suspend(void)
+{
+        load_cr3(swapper_pg_dir);
+}
+
 void xen_pre_suspend(void)
 {
 	xen_start_info->store_mfn = mfn_to_pfn(xen_start_info->store_mfn);
diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index a5bc91a..c7f2953 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -39,8 +39,7 @@ static int xen_suspend(void *data)
 
 	BUG_ON(!irqs_disabled());
 
-	load_cr3(swapper_pg_dir);
-
+	xen_pre_device_suspend();
 	err = device_power_down(PMSG_SUSPEND);
 	if (err) {
 		printk(KERN_ERR "xen_suspend: device_power_down failed: %d\n",
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index 883a21b..a26db6f 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -5,6 +5,7 @@
 
 DECLARE_PER_CPU(struct vcpu_info *, xen_vcpu);
 
+void xen_pre_device_suspend(void);
 void xen_pre_suspend(void);
 void xen_post_suspend(int suspend_cancelled);
 
-- 
1.6.0.rc0.42.g186458


