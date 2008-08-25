Return-Path: <linux-kernel-owner+w=401wt.eu-S1755803AbYHYKLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbYHYKLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 06:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbYHYKL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 06:11:29 -0400
Received: from il.qumranet.com ([212.179.150.194]:20842 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808AbYHYKL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 06:11:28 -0400
From: Avi Kivity <avi@qumranet.com>
To: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] x86: default to reboot via ACPI
Date: Mon, 25 Aug 2008 13:11:27 +0300
Message-Id: <1219659087-17536-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.6.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Triple-fault and keyboard reset may assert INIT instead of RESET; however
INIT is blocked when Intel VT is enabled.  This leads to a partially reset
machine when invoking emergency_restart via sysrq-b: the processor is still
working but other parts of the system are dead.

Default to rebooting via ACPI, which correctly asserts RESET and reboots the
machine.

This is safe since we will fall back to keyboard reset and triple fault if
acpi is not enabled or if the reset is not successful.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kernel/reboot.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 724adfc..f4c93f1 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -29,7 +29,11 @@ EXPORT_SYMBOL(pm_power_off);
 
 static const struct desc_ptr no_idt = {};
 static int reboot_mode;
-enum reboot_type reboot_type = BOOT_KBD;
+/*
+ * Keyboard reset and triple fault may result in INIT, not RESET, which
+ * doesn't work when we're in vmx root mode.  Try ACPI first.
+ */
+enum reboot_type reboot_type = BOOT_ACPI;
 int reboot_force;
 
 #if defined(CONFIG_X86_32) && defined(CONFIG_SMP)
-- 
1.6.0

