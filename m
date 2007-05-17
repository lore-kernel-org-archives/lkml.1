Return-Path: <linux-kernel-owner+w=401wt.eu-S1759549AbXEQWZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549AbXEQWZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 18:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbXEQWZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 18:25:50 -0400
Received: from smtpa1.mediabeam.com ([194.25.41.13]:6221 "EHLO
	smtpa1.mediabeam.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbXEQWZt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 18:25:49 -0400
X-Greylist: delayed 1124 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 May 2007 18:25:48 EDT
Date: Fri, 18 May 2007 00:06:38 +0200
From: Philipp Kohlbecher <pk031698@uni-greifswald.de>
To: Dave Jones <davej@codemonkey.org.uk>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       linux-assembly@vger.kernel.org
Subject: [PATCH 2.6.21.1] i386: save registers before intra-privilege syscall
Message-ID: <20070517220638.GA6532@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Content-Transfer-Encoding: 8BIT
X-mediaBEAM-MailScanner-Information: Spam-/VirusProtection V1.1
X-mediaBEAM-VirusProtection: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philipp Kohlbecher <pk031698@uni-greifswald.de>

The kernel_execve function issues a software interrupt (int 0x80) to make
a system call to sys_execve. This function expects to find the stack segment
and stack pointer of the function that issued the system call in the pt_regs
struct. The syscall entry code that sets up this struct expects the stack
segment and the stack pointer of the issuing function already on the stack.
But the Intel processor saves these registers only if a stack-switch occurs,
i.e. for inter-privilege interrupts and exceptions (cf. Intel Software
Developer’s Manual, Vol. 3A, p. 5-17,
http://www.intel.com/design/processor/manuals/253668.pdf).
For an intra-privilege interrupt like the one issued in kernel_execve, these
registers must be saved manually.

Signed-off-by: Philipp Kohlbecher <pk031698@uni-greifswald.de>

---

I am a total newbie and this is my first patch, so please be merciful...
Also, please CC me, I am not on the list.

--- a/arch/i386/kernel/sys_i386.c	2007-05-13 18:40:33.000000000 +0200
+++ b/arch/i386/kernel/sys_i386.c	2007-05-13 17:23:10.000000000 +0200
@@ -258,7 +258,8 @@ int kernel_execve(const char *filename,
 int kernel_execve(const char *filename, char *const argv[], char *const envp[])
 {
 	long __res;
-	asm volatile ("push %%ebx ; movl %2,%%ebx ; int $0x80 ; pop %%ebx"
+	asm volatile ("push %%ebx ; movl %2,%%ebx ; push %%ss ; push %%esp;"
+				"int $0x80 ; addl $(4*2),%%esp ; pop %%ebx"
 	: "=a" (__res)
 	: "0" (__NR_execve),"ri" (filename),"c" (argv), "d" (envp) : "memory");
 	return __res;
