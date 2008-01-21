Return-Path: <linux-kernel-owner+w=401wt.eu-S1756439AbYAUWPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbYAUWPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 17:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYAUWPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 17:15:41 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:3143 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751775AbYAUWPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 17:15:40 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       =?utf-8?q?Mika=20Penttil=C3=A4?= <mika.penttila@kolumbus.fi>
Date: Mon, 21 Jan 2008 22:15:19 +0000
Message-Id: <1200953721-3815-2-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: 479510CE.7010706@zytor.com
References: 479510CE.7010706@zytor.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCH] x86_32: Remove unnecessary use of %ebx as the boot cpu flag
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently in head_32.S there are two ways we test to see if we
are the boot cpu.  By looking at %ebx and by looking at the
static variable ready.  When changing things around I have
found that it gets tricky to preserve %ebx.  So this
patch just switches head.S over to the more reliable
test of always using ready.

Hopefully later we can kill these tests entirely.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Mika Penttilä <mika.penttila@kolumbus.fi>
---
 arch/x86/kernel/head_32.S |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index f409fe2..7b9b256 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -199,7 +199,6 @@ default_entry:
 	addl $0x67, %eax			/* 0x67 == _PAGE_TABLE */
 	movl %eax, 4092(%edx)
 
-	xorl %ebx,%ebx				/* This is the boot CPU (BSP) */
 	jmp 3f
 /*
  * Non-boot CPU entry point; entered from trampoline.S
@@ -268,10 +267,6 @@ ENTRY(startup_32_smp)
 	wrmsr
 
 6:
-	/* This is a secondary processor (AP) */
-	xorl %ebx,%ebx
-	incl %ebx
-
 #endif /* CONFIG_SMP */
 3:
 
@@ -297,7 +292,7 @@ ENTRY(startup_32_smp)
 	popfl
 
 #ifdef CONFIG_SMP
-	andl %ebx,%ebx
+	cmpb $0, ready
 	jz  1f				/* Initial CPU cleans BSS */
 	jmp checkCPUtype
 1:
-- 
1.5.3.8

