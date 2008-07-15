Return-Path: <linux-kernel-owner+w=401wt.eu-S1762354AbYGOUkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762354AbYGOUkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbYGOUjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:39:53 -0400
Received: from www.tglx.de ([62.245.132.106]:39089 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbYGOUjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:39:52 -0400
Date: Tue, 15 Jul 2008 22:11:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: mingo <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alok N Kataria <akataria@vmware.com>,
       Alok N Kataria <akataria@vmware.com>, Dan Hecht <dhecht@vmware.com>
Subject: Re: vread_tsc() compile error (post 2.6.26)
In-Reply-To: <1216151261.25942.24.camel@nimitz>
Message-ID: <alpine.LFD.1.10.0807152208380.3283@apollo.tec.linutronix.de>
References: <1216151261.25942.24.camel@nimitz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2051528598-1216152667=:3283"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2051528598-1216152667=:3283
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 15 Jul 2008, Dave Hansen wrote:
> $ git describe
> v2.6.26-2465-g1c0fea9
> 
> This looks like it was caused by:
> ﻿
> 	8fbbc4b45ce3e4c0eeb15004c79c72b6896a79c2
> 
> Did this get any testing on x86-32?  It looks like this symbol has no
> 32-bit equivalent.

Doh, that's odd. It compiles, links and boots here. Looks like the my gcc just
optimizes it out without the usual "...., but not used warning"

Patch below.

Thanks,

	tglx

> ...
>   MODPOST vmlinux.o
> WARNING: modpost: Found 11 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> arch/x86/kernel/built-in.o: In function `vread_tsc':
> /home/dave/kernels/linux-2.6.git/arch/x86/kernel/tsc.c:365: undefined reference to `__vsyscall_gtod_data'
> /home/dave/kernels/linux-2.6.git/arch/x86/kernel/tsc.c:365: undefined reference to `__vsyscall_gtod_data'
> make: *** [.tmp_vmlinux1] Error 1
> ﻿
> My config:
> 
> http://sr71.net/~dave/linux/config-2.6.26-rc8-00089-ge1441b9

----------------->

Subject: x86: fix tsc unification fallout
From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 15 Jul 2008 22:08:04 +0200

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/tsc.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/arch/x86/kernel/tsc.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tsc.c
+++ linux-2.6/arch/x86/kernel/tsc.c
@@ -358,6 +358,7 @@ static cycle_t read_tsc(void)
 		ret : clocksource_tsc.cycle_last;
 }
 
+#ifdef CONFIG_X86_64
 static cycle_t __vsyscall_fn vread_tsc(void)
 {
 	cycle_t ret = (cycle_t)vget_cycles();
@@ -365,6 +366,7 @@ static cycle_t __vsyscall_fn vread_tsc(v
 	return ret >= __vsyscall_gtod_data.clock.cycle_last ?
 		ret : __vsyscall_gtod_data.clock.cycle_last;
 }
+#endif
 
 static struct clocksource clocksource_tsc = {
 	.name                   = "tsc",
--8323328-2051528598-1216152667=:3283--
