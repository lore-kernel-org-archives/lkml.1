Return-Path: <linux-kernel-owner+w=401wt.eu-S1759634AbXFQJsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634AbXFQJsh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759489AbXFQJou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:44:50 -0400
Received: from il.qumranet.com ([82.166.9.18]:55160 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758003AbXFQJom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:42 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 07/58] KVM: Be more careful restoring fs on lightweight vmexit
Date: Sun, 17 Jun 2007 12:43:48 +0300
Message-Id: <1182073480501-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i386 wants fs for accessing the pda even on a lightweight exit, so ensure
we can always restore it.  This fixes a regression on i386 introduced by
the lightweight vmexit patch.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 9ebb18d..49cadd3 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1832,16 +1832,21 @@ preempted:
 	 * Set host fs and gs selectors.  Unfortunately, 22.2.3 does not
 	 * allow segment selectors with cpl > 0 or ti == 1.
 	 */
-	fs_sel = read_fs();
-	gs_sel = read_gs();
 	ldt_sel = read_ldt();
-	fs_gs_ldt_reload_needed = (fs_sel & 7) | (gs_sel & 7) | ldt_sel;
-	if (!fs_gs_ldt_reload_needed) {
+	fs_gs_ldt_reload_needed = ldt_sel;
+	fs_sel = read_fs();
+	if (!(fs_sel & 7))
 		vmcs_write16(HOST_FS_SELECTOR, fs_sel);
-		vmcs_write16(HOST_GS_SELECTOR, gs_sel);
-	} else {
+	else {
 		vmcs_write16(HOST_FS_SELECTOR, 0);
+		fs_gs_ldt_reload_needed = 1;
+	}
+	gs_sel = read_gs();
+	if (!(gs_sel & 7))
+		vmcs_write16(HOST_GS_SELECTOR, gs_sel);
+	else {
 		vmcs_write16(HOST_GS_SELECTOR, 0);
+		fs_gs_ldt_reload_needed = 1;
 	}
 
 #ifdef CONFIG_X86_64
@@ -2035,11 +2040,6 @@ again:
 	}
 
 out:
-	/*
-	 * Reload segment selectors ASAP. (it's needed for a functional
-	 * kernel: x86 relies on having __KERNEL_PDA in %fs and x86_64
-	 * relies on having 0 in %gs for the CPU PDA to work.)
-	 */
 	if (fs_gs_ldt_reload_needed) {
 		load_ldt(ldt_sel);
 		load_fs(fs_sel);
-- 
1.5.0.6

