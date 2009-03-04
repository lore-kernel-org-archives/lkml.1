Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbZCDR6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbZCDR6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 12:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbZCDR6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 12:58:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:59986 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755682AbZCDR6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 12:58:03 -0500
Date: Wed, 4 Mar 2009 17:57:33 GMT
From: Brian Maly <bmaly@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, bmaly@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, bmaly@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49ADEDA3.1030406@redhat.com>
References: <49ADEDA3.1030406@redhat.com>
Subject: [tip:x86/urgent] x86: fix DMI on EFI
Message-ID: <tip-ff0c0874905fb312ca1491bbdac2653b0b48c20b@git.kernel.org>
Git-Commit-ID: ff0c0874905fb312ca1491bbdac2653b0b48c20b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 17:57:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff0c0874905fb312ca1491bbdac2653b0b48c20b
Gitweb:     http://git.kernel.org/tip/ff0c0874905fb312ca1491bbdac2653b0b48c20b
Author:     "Brian Maly" <bmaly@redhat.com>
AuthorDate: Tue, 3 Mar 2009 21:55:31 -0500
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Mar 2009 18:55:56 +0100

x86: fix DMI on EFI

Impact: reactivate DMI quirks on EFI hardware

DMI tables are loaded by EFI, so the dmi calls must happen after
efi_init() and not before.

Currently Apple hardware uses DMI to determine the framebuffer mappings
for efifb. Without DMI working you also have no video on MacBook Pro.

This patch resolves the DMI issue for EFI hardware (DMI is now properly
detected at boot), and additionally efifb now loads on Apple hardware
(i.e. video works).

Signed-off-by: Brian Maly <bmaly@redhat>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: ying.huang@intel.com
LKML-Reference: <49ADEDA3.1030406@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

 arch/x86/kernel/setup.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


---
 arch/x86/kernel/setup.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c461f6d..6a8811a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -770,6 +770,9 @@ void __init setup_arch(char **cmdline_p)
 
 	finish_e820_parsing();
 
+	if (efi_enabled)
+		efi_init();
+
 	dmi_scan_machine();
 
 	dmi_check_system(bad_bios_dmi_table);
@@ -789,8 +792,6 @@ void __init setup_arch(char **cmdline_p)
 	insert_resource(&iomem_resource, &data_resource);
 	insert_resource(&iomem_resource, &bss_resource);
 
-	if (efi_enabled)
-		efi_init();
 
 #ifdef CONFIG_X86_32
 	if (ppro_with_ram_bug()) {
