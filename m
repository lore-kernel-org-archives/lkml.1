Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbZBOVrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbZBOVrk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 16:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZBOVr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 16:47:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48276 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbZBOVr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 16:47:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 2/2] x86_64: Fix S3 fail path
Date: Sun, 15 Feb 2009 22:46:45 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>, Cyrill Gorcunov <gorcunov@openvz.org>,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <200902152244.47326.rjw@sisk.pl>
In-Reply-To: <200902152244.47326.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902152246.46583.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

As acpi_enter_sleep_state can fail, take this into account in
do_suspend_lowlevel and don't return to the do_suspend_lowlevel's
caller. This would break (currently) fpu status and preempt count.

Technically, this means use `call' instead of `jmp' and `jmp' to
the `resume_point' after the `call' (i.e. if
acpi_enter_sleep_state returns=fails). `resume_point' will handle
the restore of fpu and preempt count gracefully.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/acpi/wakeup_64.S |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/acpi/wakeup_64.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/wakeup_64.S
+++ linux-2.6/arch/x86/kernel/acpi/wakeup_64.S
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
