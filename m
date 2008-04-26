Return-Path: <linux-kernel-owner+w=401wt.eu-S1759090AbYDZRW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbYDZRW4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 13:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759449AbYDZRWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 13:22:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43059 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759586AbYDZRWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 13:22:44 -0400
Date: Sat, 26 Apr 2008 19:22:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>, jdike@addtoit.com
Subject: Re: [git pull] generic bitops, take 2
Message-ID: <20080426172222.GD17345@elte.hu>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 26 Apr 2008, Ingo Molnar wrote:
> > 
> > i've added Alexander's patch that does the cleanup suggested by you
> 
> Well.. Not really:
> 
> > diff --git a/arch/um/Kconfig.x86_64 b/arch/um/Kconfig.x86_64
> > index 3fbe69e..7a75043 100644
> > --- a/arch/um/Kconfig.x86_64
> > +++ b/arch/um/Kconfig.x86_64
> > @@ -27,6 +27,14 @@ config SMP_BROKEN
> >  	bool
> >  	default y
> >  
> > +config GENERIC_FIND_FIRST_BIT
> > +	bool
> > +	default y
> > +
> > +config GENERIC_FIND_NEXT_BIT
> > +	bool
> > +	default y
> > +
> 
> It still declares this GENERIC_FIND_*_BIT thing separately for UM.
> 
> Yes, that may _work_, but it's wrong to define it in two different places. 
> 
> It also makes me wonder why Kconfig.i386 can just include 
> arch/x86/Kconfig.cpu, but x86_64 cannot?

hm, indeed arch/um/Kconfig.i386 is assymetric to Kconfig.x86_64. Jeff 
Cc:-ed.

trying to see whether changing that would still result in a working UML 
arch i found that current UML doesnt seem to build here:

 arch/um/os-Linux/helper.c: In function 'run_helper':
 arch/um/os-Linux/helper.c:73: error: 'PATH_MAX' undeclared (first use in this function)

it needs the patch below.

then it fails with:

 mm/filemap.c: In function '__generic_file_aio_write_nolock':
 mm/filemap.c:1831: sorry, unimplemented: inlining failed in call to 'generic_write_checks': function body not available

i used:

   make ARCH=um SUBARCH=x86_64 -j64 linux

on x86-64, gcc-4.3.0-0.13. Config is:

   http://redhat.com/~mingo/misc/.config.um

i also tried gcc 4.2.3, that built it fine but didnt link it:

/opt/crosstool/gcc-4.2.3-glibc-2.3.6/x86_64-unknown-linux-gnu/lib/gcc/x86_64-unknown-linux-gnu/4.2.3/../../../../x86_64-unknown-linux-gnu/bin/ld: 
warning: ld-linux-x86-64.so.2, needed by 
/opt/crosstool/gcc-4.2.3-glibc-2.3.6/x86_64-unknown-linux-gnu/x86_64-unknown-linux-gnu/sys-root/lib/../lib64/libc.so.6, 
not found (try using -rpath or -rpath-link)
/opt/crosstool/gcc-4.2.3-glibc-2.3.6/x86_64-unknown-linux-gnu/x86_64-unknown-linux-gnu/sys-root/lib/../lib64/libc.so.6: 
undefined reference to `_dl_argv@GLIBC_PRIVATE'

...
/opt/crosstool/gcc-4.2.3-glibc-2.3.6/x86_64-unknown-linux-gnu/lib/gcc/x86_64-unknown-linux-gnu/4.2.3/../../../../x86_64-unknown-linux-gnu/bin/ld: 
warning: .fini_array section has zero size collect2: ld returned 1 exit 
status
distcc[29125] ERROR: compile (null) on localhost failed
  KSYM    .tmp_kallsyms1.S
/opt/crosstool/gcc-4.2.3-glibc-2.3.6/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu-nm: 
'.tmp_vmlinux1': No such file

perhaps the combination of distcc and crosscompilers doesnt work well on 
UML? (it works fine with other architectures)

	Ingo

--------------->
Subject: uml: fix
From: Ingo Molnar <mingo@elte.hu>
Date: Sat Apr 26 18:59:42 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/um/os-Linux/helper.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-x86.q/arch/um/os-Linux/helper.c
===================================================================
--- linux-x86.q.orig/arch/um/os-Linux/helper.c
+++ linux-x86.q/arch/um/os-Linux/helper.c
@@ -14,6 +14,7 @@
 #include "os.h"
 #include "um_malloc.h"
 #include "user.h"
+#include <linux/limits.h>
 
 struct helper_data {
 	void (*pre_exec)(void*);
