Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbXJ1Rb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbXJ1Rb6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 13:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbXJ1Rbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 13:31:48 -0400
Received: from smtp803.mail.ird.yahoo.com ([217.146.188.63]:39281 "HELO
	smtp803.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752237AbXJ1Rbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 13:31:47 -0400
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Oct 2007 13:31:47 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=btinternet.com;
  h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding;
  b=bfTzP373bGoHjha1w/mcbBXCT6Pr2sqZU82K28aHNzmnQwk5KRIiSV7B1oqw4Dze7JsFnnM33vmyaZCm3ZbjKIE+qX0BYnGIIsjCQoF1ABlVZGRPV9ZBbKagaoP2HI1ZzEIhtbLcWjJRVibVlpl2DEUUifxbE40wmy9z2sBOk2o=  ;
Date: Sun, 28 Oct 2007 17:25:19 +0000
From: Bradley Smith <bradjsmith@btinternet.com>
To: linux-kernel@vger.kernel.org, dz@debian.org
Subject: [PATCH 1/2] I8K: Allow i8k driver to be built on x86_64 systems
Message-ID: <20071028172519.371dbbe8@debian.hob>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bradley Smith <bradjsmith@btinternet.com>

Adds #if clause and additional inline assembly so that the driver
builds on x86_64 systems.

Signed-off-by: Bradley Smith <bradjsmith@btinternet.com>

---

--- linux-2.6/drivers/char/i8k.c.orig	2007-10-28 12:27:34.000000000 +0000
+++ linux-2.6/drivers/char/i8k.c	2007-10-28 14:27:56.000000000 +0000
@@ -113,6 +113,33 @@ static int i8k_smm(struct smm_regs *regs
 	int rc;
 	int eax = regs->eax;
 
+#if defined(__x86_64__)
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
 
