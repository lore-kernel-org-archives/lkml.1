Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbZDYFYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbZDYFYp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 01:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbZDYFYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 01:24:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:47811 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbZDYFYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 01:24:36 -0400
Date: Sat, 25 Apr 2009 07:24:34 +0200
From: Nick Piggin <npiggin@suse.de>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org
Subject: Re: mmotm 2009-04-24-18-14 uploaded - NVidia indigestion
Message-ID: <20090425052434.GE10088@wotan.suse.de>
References: <200904250133.n3P1XBJn006790@imap1.linux-foundation.org> <5622.1240628800@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5622.1240628800@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 11:06:40PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 24 Apr 2009 18:14:22 PDT, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2009-04-24-18-14 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> This jumped out and asked if I wanted SLQB as the default allocator (even
> though I've had SLAB defined for ages).  I said to myself "what the heck"
> and accepted the change...

Heh, it was a sneaky trick to get more testing before merging. Worked
well :)

 
> Tried to build the NVidia binary, and it choked during config on something
> that will likely give a *lot* of programs indigestion.
> 
> The test program:
> 
> #include <linux/autoconf.h>
>     #if defined(CONFIG_XEN) &&         defined(CONFIG_XEN_INTERFACE_VERSION) &&  !defined(__XEN_INTERFACE_VERSION__)
>     #define __XEN_INTERFACE_VERSION__ CONFIG_XEN_INTERFACE_VERSION
>     #endif
>             #include <linux/version.h>
>             #include <linux/utsname.h>
>             int main() {
>               if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)) {
>                 return 0;
>               } else {
>                 return 1;
>               }
>             }
> 
> The command line:
> 
> cc -D__KERNEL__ -DKBUILD_BASENAME="#conftest23112" -DKBUILD_MODNAME="#conftest23112" -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.4.0/include -I/lib/modules/2.6.30-rc3-mmotm0424/source/include/asm-x86_64/mach-default -I/lib/modules/2.6.30-rc3-mmotm0424/source/include/asm-x86/mach-default -I/lib/modules/2.6.30-rc3-mmotm0424/source/arch/x86/include/asm/mach-default -I/lib/modules/2.6.30-rc3-mmotm0424/build/include2 -I/lib/modules/2.6.30-rc3-mmotm0424/build/include -I/lib/modules/2.6.30-rc3-mmotm0424/source/include -I/lib/modules/2.6.30-rc3-mmotm0424/source/arch/x86/include -o conftest23112 conftest23112.c
> 
> and the joy it got me:
> 
> In file included from /lib/modules/2.6.30-rc3-mmotm0424/build/include/linux/slab.h:161,
>                  from /lib/modules/2.6.30-rc3-mmotm0424/build/include/linux/percpu.h:5,
>                  from /lib/modules/2.6.30-rc3-mmotm0424/build/include/linux/sched.h:76,
>                  from /lib/modules/2.6.30-rc3-mmotm0424/build/include/linux/utsname.h:35,
>                  from conftest2465.c:6:
> /lib/modules/2.6.30-rc3-mmotm0424/build/include/linux/slqb_def.h: In function ???kmalloc_slab???:
> /lib/modules/2.6.30-rc3-mmotm0424/build/include/linux/slqb_def.h:240: error: size of array ???type name??? is negative
> 
> Why does utsname.h care about SLAB versus SLUB?  (Looks to me like somebody
> forgot to add a #include to slqb_def.h for all the headers it needed, and
> it choked.  Interestingly enough, line 240 reads:
> 
>         BUILD_BUG_ON(!__builtin_constant_p(size));
> 
> but I didn't think this was the way BUILD_BUG_ON worked?

Yeah BUILD_BUG_ON does work like that. I can't for the life of me
understand why it triggered though. Is anything in your external
code calling kmalloc_slab directly?

What's the preprocessor output look like?

