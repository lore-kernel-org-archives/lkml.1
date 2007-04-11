Return-Path: <linux-kernel-owner+w=401wt.eu-S1030754AbXDKCPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030754AbXDKCPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 22:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030756AbXDKCPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 22:15:42 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:57719 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030754AbXDKCPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 22:15:41 -0400
Subject: Re: Build error : 2.6.21-rc6-mm1 on sparc64
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
In-Reply-To: <20070410181854.7d532c59.akpm@linux-foundation.org>
References: <20070411004838.GD15262@Krystal>
	 <20070410181854.7d532c59.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 11 Apr 2007 11:15:39 +0900
Message-Id: <1176257739.19452.13.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-10 at 18:18 -0700, Andrew Morton wrote:
> On Tue, 10 Apr 2007 20:48:38 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > I get the following build error when building 2.6.21-rc6-mm1 for
> > sparc64:
> > 
> >   /opt/crosstool/gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu/bin/sparc64-unknown-linux-gnu-gcc -Wp,-MD,arch/sparc64/kernel/.traps.o.d  -nostdinc -isystem /opt/crosstool/gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu/lib/gcc/sparc64-unknown-linux-gnu/3.4.5/include -D__KERNEL__ -Iinclude -Iinclude2 -I/home/compudj/git/linux-2.6-lttng/include -include include/linux/autoconf.h -I/home/compudj/git/linux-2.6-lttng/arch/sparc64/kernel -Iarch/sparc64/kernel -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Os -m64 -pipe -mno-fpu -mcpu=ultrasparc -mcmodel=medlow -ffixed-g4 -ffixed-g5 -fcall-used-g7 -Wno-sign-compare -Wa,--undeclared-regs -fomit-frame-pointer -Wdeclaration-after-statement -Werror  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(traps)"  -D"KBUILD_MODNAME=KBUILD_STR(traps)" -c -o arch/sparc64/kernel/traps.o /home/compudj/git/linux-2.6-lttng/arch/sparc64/kernel/traps.c
> > /home/compudj/git/linux-2.6-lttng/arch/sparc64/kernel/traps.c: In function `init_cur_cpu_trap':
> > /home/compudj/git/linux-2.6-lttng/arch/sparc64/kernel/traps.c:2497: warning: implicit declaration of function `hard_smp_processor_id'
> > make[2]: *** [arch/sparc64/kernel/traps.o] Error 1
> > make[1]: *** [arch/sparc64/kernel] Error 2
> > make: *** [_all] Error 2
> 
> Not sure what the approved fix is here.  Fernando, please take a look, and
> review all other architectures?
The problem is that to use hard_smp_processor_id in UP kernels just
including linux/smp.h does not suffice anymore. Now
hard_smp_processor_id is architecture specific code and consequently
asm/smp.h should be included explicitly.

Mathieu, does the (untested) patch below fix this issue?

[PATCH] Remove hardcoding of hard_smp_processor_id on UP systems -
sparc64 fix

To use hard_smp_processor_id in UP kernels just including linux/smp.h
does not suffice anymore. Now hard_smp_processor_id is architecture
specific code and consequently asm/smp.h should be included explicitly.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.21-rc6-mm1-orig/arch/sparc64/kernel/traps.c linux-2.6.21-rc6-mm1/arch/sparc64/kernel/traps.c
--- linux-2.6.21-rc6-mm1-orig/arch/sparc64/kernel/traps.c	2007-04-11 10:48:09.000000000 +0900
+++ linux-2.6.21-rc6-mm1/arch/sparc64/kernel/traps.c	2007-04-11 10:57:06.000000000 +0900
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/kdebug.h>
 
+#include <asm/smp.h>
 #include <asm/delay.h>
 #include <asm/system.h>
 #include <asm/ptrace.h>


