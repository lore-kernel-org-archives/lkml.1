Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbZBIOga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbZBIOga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 09:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbZBIOgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 09:36:22 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:40731 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbZBIOgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 09:36:21 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: lenb@kernel.org
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 1/1] x86_64: fix s3 fail path
Date: Mon,  9 Feb 2009 15:35:20 +0100
Message-Id: <1234190120-6268-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As acpi_enter_sleep_state can fail, take this into account in
do_suspend_lowlevel and don't return to the do_suspend_lowlevel's
caller. This would break (currently) fpu status and preempt count.

Technically, this means use `call' instead of `jmp' and `jmp' to
the `resume_point' after the `call' (i.e. if
acpi_enter_sleep_state returns=fails). `resume_point' will handle
the restore of fpu and preempt count gracefully.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/acpi/wakeup_64.S |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/acpi/wakeup_64.S b/arch/x86/kernel/acpi/wakeup_64.S
index b5dee6a..96258d9 100644
--- a/arch/x86/kernel/acpi/wakeup_64.S
+++ b/arch/x86/kernel/acpi/wakeup_64.S
@@ -73,7 +73,9 @@ ENTRY(do_suspend_lowlevel)
 	addq	$8, %rsp
 	movl	$3, %edi
 	xorl	%eax, %eax
-	jmp	acpi_enter_sleep_state
+	call	acpi_enter_sleep_state
+	/* in case something went wrong, restore the machine status and go on */
+	jmp	resume_point
 
 	.align 4
 resume_point:
-- 
1.6.1.3

