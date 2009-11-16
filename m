Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbZKPWH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbZKPWH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbZKPWHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:07:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:49514 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327AbZKPWHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:07:54 -0500
Date: Mon, 16 Nov 2009 22:06:56 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       kees.cook@canonical.com, tglx@linutronix.de, rjw@sisk.pl,
       nigel@tuxonice.net, pavel@ucw.cz
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, nigel@tuxonice.net, kees.cook@canonical.com,
       tglx@linutronix.de, rjw@sisk.pl
In-Reply-To: <1258154897-6770-3-git-send-email-hpa@zytor.com>
References: <1258154897-6770-3-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, sleep: Always save the value of EFER
Message-ID: <tip-a7c4c0d934c6cbc58de262d090d4a715445453f0@git.kernel.org>
Git-Commit-ID: a7c4c0d934c6cbc58de262d090d4a715445453f0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7c4c0d934c6cbc58de262d090d4a715445453f0
Gitweb:     http://git.kernel.org/tip/a7c4c0d934c6cbc58de262d090d4a715445453f0
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 13 Nov 2009 15:28:14 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 16 Nov 2009 13:44:57 -0800

x86, sleep: Always save the value of EFER

Always save the value of EFER, regardless of the state of NX.  Since
EFER may not actually exist, use rdmsr_safe() to do so.

v2: check the return value from rdmsr_safe() instead of relying on
    the output values being unchanged on error.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@tuxonice.net>
LKML-Reference: <1258154897-6770-3-git-send-email-hpa@zytor.com>
Acked-by: Kees Cook <kees.cook@canonical.com>
---
 arch/x86/kernel/acpi/sleep.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 4a41145..82e5086 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -78,12 +78,9 @@ int acpi_save_state_mem(void)
 #ifndef CONFIG_64BIT
 	store_gdt((struct desc_ptr *)&header->pmode_gdt);
 
-	header->pmode_efer_low = nx_enabled;
-	if (header->pmode_efer_low & 1) {
-		/* This is strange, why not save efer, always? */
-		rdmsr(MSR_EFER, header->pmode_efer_low,
-			header->pmode_efer_high);
-	}
+	if (rdmsr_safe(MSR_EFER, &header->pmode_efer_low,
+		       &header->pmode_efer_high))
+		header->pmode_efer_low = header->pmode_efer_high = 0;
 #endif /* !CONFIG_64BIT */
 
 	header->pmode_cr0 = read_cr0();
