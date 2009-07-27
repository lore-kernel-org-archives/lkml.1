Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbZG0VWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbZG0VWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbZG0VWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:22:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:38220 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbZG0VWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:22:01 -0400
Date: Mon, 27 Jul 2009 21:21:37 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       robert.richter@amd.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       robert.richter@amd.com, tglx@linutronix.de
In-Reply-To: <1248716632-26844-1-git-send-email-robert.richter@amd.com>
References: <1248716632-26844-1-git-send-email-robert.richter@amd.com>
Subject: [tip:x86/urgent] x86: fix section mismatch for i386 init code
Message-ID: <tip-0e83815be719d3391bf5ea24b7fe696c07dbd417@git.kernel.org>
Git-Commit-ID: 0e83815be719d3391bf5ea24b7fe696c07dbd417
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 27 Jul 2009 21:21:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e83815be719d3391bf5ea24b7fe696c07dbd417
Gitweb:     http://git.kernel.org/tip/0e83815be719d3391bf5ea24b7fe696c07dbd417
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Mon, 27 Jul 2009 19:43:52 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 27 Jul 2009 14:18:46 -0700

x86: fix section mismatch for i386 init code

Startup code for i386 in arch/x86/kernel/head_32.S is using the
reference variable initial_code that is located in the .cpuinit.data
section. If CONFIG_HOTPLUG_CPU is enabled, startup code is not in an
init section and can be called later too. In this case the reference
initial_code must be kept too. This patch fixes this. See below for
the section mismatch warning.

 WARNING: vmlinux.o(.cpuinit.data+0x0): Section mismatch in reference
 from the variable initial_code to the function
 .init.text:i386_start_kernel()
 The variable __cpuinitdata initial_code references
 a function __init i386_start_kernel().
 If i386_start_kernel is only used by initial_code then
 annotate i386_start_kernel with a matching annotation.

Signed-off-by: Robert Richter <robert.richter@amd.com>
LKML-Reference: <1248716632-26844-1-git-send-email-robert.richter@amd.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/kernel/head_32.S |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 8663afb..0d98a01 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -602,7 +602,11 @@ ignore_int:
 #endif
 	iret
 
-.section .cpuinit.data,"wa"
+#ifndef CONFIG_HOTPLUG_CPU
+	__CPUINITDATA
+#else
+	__REFDATA
+#endif
 .align 4
 ENTRY(initial_code)
 	.long i386_start_kernel
