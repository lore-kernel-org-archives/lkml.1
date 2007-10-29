Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbXJ2WMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbXJ2WMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbXJ2WMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:12:39 -0400
Received: from www.tglx.de ([62.245.132.106]:38837 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306AbXJ2WMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:12:38 -0400
Date: Mon, 29 Oct 2007 23:12:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc1-82798a1 compile failure (x86_64)
In-Reply-To: <fg5kar$d70$1@ger.gmane.org>
Message-ID: <alpine.LFD.0.9999.0710292310040.3186@localhost.localdomain>
References: <fg5kar$d70$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-29271638-1193695948=:3186"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-29271638-1193695948=:3186
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Thomas,

On Mon, 29 Oct 2007, Thomas Bächler wrote:
> x86_64 fails to compile for me with this error:
> 
>   CC      arch/x86/kernel/vsyscall_64.o
> {standard input}: Assembler messages:
> {standard input}:434: Error: symbol `vsysc2' is already defined
> make[1]: *** [arch/x86/kernel/vsyscall_64.o] Error 1
> make: *** [arch/x86/kernel] Error 2
> 
> The .config is attached. What's wrong?

Very recent gcc I guess ? Patch below should fix this.

Thanks,

     tglx

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index ad4005c..1a658a2 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -102,7 +102,7 @@ static __always_inline void do_get_tz(struct timezone * tz)
 static __always_inline int gettimeofday(struct timeval *tv, struct timezone *tz)
 {
 	int ret;
-	asm volatile("vsysc2: syscall"
+	asm volatile(".globl vsysc2\n vsysc2: syscall"
 		: "=a" (ret)
 		: "0" (__NR_gettimeofday),"D" (tv),"S" (tz)
 		: __syscall_clobber );
@@ -112,7 +112,7 @@ static __always_inline int gettimeofday(struct timeval *tv, struct timezone *tz)
 static __always_inline long time_syscall(long *t)
 {
 	long secs;
-	asm volatile("vsysc1: syscall"
+	asm volatile(".globl vsysc1\n vsysc1: syscall"
 		: "=a" (secs)
 		: "0" (__NR_time),"D" (t) : __syscall_clobber);
 	return secs;
 
--8323328-29271638-1193695948=:3186--
