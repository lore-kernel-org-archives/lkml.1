Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbXJ1XTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbXJ1XTn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 19:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbXJ1XTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 19:19:35 -0400
Received: from smtp811.mail.ird.yahoo.com ([217.146.188.71]:25171 "HELO
	smtp811.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752870AbXJ1XTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 19:19:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=btinternet.com;
  h=Received:X-YMail-OSG:Date:From:To:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding;
  b=vvwaZ6asx7sGjeYEaaP22vXuoPNviPu8gUDaMPlorbuuQmA+nd+7LRo93btzYntSoFKYijVfXsIlTRMGA0zDzCRQVyV8rrO2sFR4zEkBvsfPhhyAxZD/rEWyqLVE2uYMa0+CoEmU0EZAtTHmJbHqkVsINY02zsD/KYSErBTMOLg=  ;
X-YMail-OSG: e94tvDMVM1mN_TSh_4NxhvmAtwhN5GIV2Z2g58m84YPtgP93Z99zxvkoa4W2XnSN4oTgtXkMNg--
Date: Sun, 28 Oct 2007 23:19:54 +0000
From: Bradley Smith <bradjsmith@btinternet.com>
To: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org, dz@debian.org
Subject: Re: [PATCH 1/2] I8K: Allow i8k driver to be built on x86_64 systems
Message-ID: <20071028231954.31767a7e@debian.hob>
In-Reply-To: <20071028173724.GE7227@stusta.de>
References: <20071028172519.371dbbe8@debian.hob>
	<20071028173724.GE7227@stusta.de>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007 18:37:24 +0100
Adrian Bunk <bunk@kernel.org> wrote:

> 
> Please use CONFIG_X86_64.
> 
> cu
> Adrian
> 

Now uses CONFIG_X86_64.

Brad.

--- linux-2.6/drivers/char/i8k.c.orig	2007-10-28 12:27:34.000000000 +0000
+++ linux-2.6/drivers/char/i8k.c	2007-10-28 14:27:56.000000000 +0000
@@ -113,6 +113,33 @@ static int i8k_smm(struct smm_regs *regs
 	int rc;
 	int eax = regs->eax;
 
+#if defined(CONFIG_X86_64)
+	asm("pushq %%rax\n\t"
+		"movl 0(%%rax),%%edx\n\t"
+		"pushq %%rdx\n\t"
+		"movl 4(%%rax),%%ebx\n\t"
+		"movl 8(%%rax),%%ecx\n\t"
+		"movl 12(%%rax),%%edx\n\t"
+		"movl 16(%%rax),%%esi\n\t"
+		"movl 20(%%rax),%%edi\n\t"
+		"popq %%rax\n\t"
+		"out %%al,$0xb2\n\t"
+		"out %%al,$0x84\n\t"
+		"xchgq %%rax,(%%rsp)\n\t"
+		"movl %%ebx,4(%%rax)\n\t"
+		"movl %%ecx,8(%%rax)\n\t"
+		"movl %%edx,12(%%rax)\n\t"
+		"movl %%esi,16(%%rax)\n\t"
+		"movl %%edi,20(%%rax)\n\t"
+		"popq %%rdx\n\t"
+		"movl %%edx,0(%%rax)\n\t"
+		"lahf\n\t"
+		"shrl $8,%%eax\n\t"
+		"andl $1,%%eax\n"
+		:"=a"(rc)
+		:    "a"(regs)
+		:    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
+#else
 	asm("pushl %%eax\n\t"
 	    "movl 0(%%eax),%%edx\n\t"
 	    "push %%edx\n\t"
@@ -137,7 +164,7 @@ static int i8k_smm(struct smm_regs *regs
 	    "andl $1,%%eax\n":"=a"(rc)
 	    :    "a"(regs)
 	    :    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
-
+#endif
 	if (rc != 0 || (regs->eax & 0xffff) == 0xffff || regs->eax == eax)
 		return -EINVAL;
 
