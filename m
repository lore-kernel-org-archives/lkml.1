Return-Path: <linux-kernel-owner+w=401wt.eu-S1031269AbXDZPUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031269AbXDZPUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031268AbXDZPUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:20:42 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:53644 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031259AbXDZPUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:20:41 -0400
Date: Thu, 26 Apr 2007 16:20:39 +0100
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.21-rc7-mm2 -- x86_64 VDSO compile error II
Message-ID: <20070426152039.GF16909@skynet.ie>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <4630980D.7010904@shadowen.org> <20070426132736.GA16909@skynet.ie> <200704261613.41717.ak@suse.de> <20070426143902.GD16909@skynet.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070426143902.GD16909@skynet.ie>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (26/04/07 15:39), Mel Gorman didst pronounce:
> On (26/04/07 16:13), Andi Kleen didst pronounce:
> > On Thursday 26 April 2007 15:27:36 Mel Gorman wrote:
> > > On (26/04/07 13:16), Andy Whitcroft didst pronounce:
> > > > Getting the following on an x86_64 numa box:
> > > > 
> > > >   CC      arch/x86_64/vdso/vclock_gettime.o
> > > > arch/x86_64/vdso/vclock_gettime.c:1: error: code model `small' not
> > > > supported in the 32 bit mode
> > > > make[1]: *** [arch/x86_64/vdso/vclock_gettime.o] Error 1
> > > > make: *** [arch/x86_64/vdso] Error 2
> > > > 
> > > > Kernel config here: http://test.kernel.org/abat/85358/build/dotconfig
> > > > 
> > > 
> > > Hi Andi,
> > > 
> > > Backing out x86_64-mm-vdso.patch allowed this kernel to build and boot
> > > successful on the machine in question (elm3b6). The backout caused one reject
> > > in Documentation/kernel-parameters but otherwise backed out easily. It's
> > > not super-clear why it fails to build. If you want me to try another patch,
> > > make sure I'm cc'd and I'll give it a spin.
> > 
> > 
> > Or please try this simple patch.
> > 
> > -Andi
> > 
> > Index: linux/arch/x86_64/vdso/Makefile
> > ===================================================================
> > --- linux.orig/arch/x86_64/vdso/Makefile
> > +++ linux/arch/x86_64/vdso/Makefile
> > @@ -32,7 +32,7 @@ $(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso
> >  $(obj)/vdso.so: $(src)/vdso.lds $(vobjs) FORCE
> >  	$(call if_changed,syscall)
> >  
> > -CF := $(PROFILING) -mcmodel=small -fPIC -g0 -O2 -fasynchronous-unwind-tables
> > +CF := $(PROFILING) -mcmodel=small -fPIC -g0 -O2 -fasynchronous-unwind-tables -m64
> >  
> >  $(obj)/vclock_gettime.o: CFLAGS = $(CF)
> >  $(obj)/vgetcpu.o: CFLAGS = $(CF)
> 
> make -f scripts/Makefile.build obj=arch/x86_64/vdso
>   gcc -Wp,-MD,arch/x86_64/vdso/.vma.o.d  -nostdinc -isystem /usr/lib/gcc/i486-linux/3.4.4/include -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Os  -march=k8 -m64 -mno-red-zone -mcmodel=kernel -pipe -Wno-sign-compare -fno-asynchronous-unwind-tables -funit-at-a-time -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -maccumulate-outgoing-args -DCONFIG_AS_CFI=1  -fno-omit-frame-pointer -fno-optimize-sibling-calls  -Wdeclaration-after-statement      -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(vma)"  -D"KBUILD_MODNAME=KBUILD_STR(vma)" -c -o arch/x86_64/vdso/vma.o arch/x86_64/vdso/vma.c
>   gcc -Wp,-MD,arch/x86_64/vdso/.vdso-start.o.d  -nostdinc -isystem /usr/lib/gcc/i486-linux/3.4.4/include -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h -D__ASSEMBLY__ -DCONFIG_AS_CFI=1  -m64    -c -o arch/x86_64/vdso/vdso-start.o arch/x86_64/vdso/vdso-start.S
>   gcc -Wp,-MD,arch/x86_64/vdso/.vdso-note.o.d  -nostdinc -isystem /usr/lib/gcc/i486-linux/3.4.4/include -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h -D__ASSEMBLY__ -DCONFIG_AS_CFI=1  -m64    -c -o arch/x86_64/vdso/vdso-note.o arch/x86_64/vdso/vdso-note.S
>   gcc -Wp,-MD,arch/x86_64/vdso/.vclock_gettime.o.d  -nostdinc -isystem /usr/lib/gcc/i486-linux/3.4.4/include -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h  -mcmodel=small -fPIC -g0 -O2 -fasynchronous-unwind-tables -m64     -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(vclock_gettime)"  -D"KBUILD_MODNAME=KBUILD_STR(vclock_gettime)" -c -o arch/x86_64/vdso/vclock_gettime.o arch/x86_64/vdso/vclock_gettime.c
>   gcc -Wp,-MD,arch/x86_64/vdso/.vgetcpu.o.d  -nostdinc -isystem /usr/lib/gcc/i486-linux/3.4.4/include -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h  -mcmodel=small -fPIC -g0 -O2 -fasynchronous-unwind-tables -m64     -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(vgetcpu)"  -D"KBUILD_MODNAME=KBUILD_STR(vgetcpu)" -c -o arch/x86_64/vdso/vgetcpu.o arch/x86_64/vdso/vgetcpu.c
>   gcc -Wp,-MD,arch/x86_64/vdso/.vvar.o.d  -nostdinc -isystem /usr/lib/gcc/i486-linux/3.4.4/include -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Os  -march=k8 -m64 -mno-red-zone -mcmodel=kernel -pipe -Wno-sign-compare -fno-asynchronous-unwind-tables -funit-at-a-time -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -maccumulate-outgoing-args -DCONFIG_AS_CFI=1  -fno-omit-frame-pointer -fno-optimize-sibling-calls  -Wdeclaration-after-statement      -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(vvar)"  -D"KBUILD_MODNAME=KBUILD_STR(vvar)" -c -o arch/x86_64/vdso/vvar.o arch/x86_64/vdso/vvar.c
>   gcc -m elf_x86_64 -nostdlib -fPIC -shared -Wl,-soname=linux-vdso.so.1  -Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096 -Wl,-T,arch/x86_64/vdso/vdso.lds arch/x86_64/vdso/vdso-start.o arch/x86_64/vdso/vdso-note.o arch/x86_64/vdso/vclock_gettime.o arch/x86_64/vdso/vgetcpu.o arch/x86_64/vdso/vvar.o -o arch/x86_64/vdso/vdso.so
> /usr/bin/ld: section .text [ffffffffff700400 -> ffffffffff700687] overlaps section .dynsym [ffffffffff7001d0 -> ffffffffff700427]
> collect2: ld returned 1 exit status
> make[1]: *** [arch/x86_64/vdso/vdso.so] Error 1
> make: *** [arch/x86_64/vdso] Error 2
> 

If I add the following patch on top of yours, it builds and boots. It's
your call on whether it's a valid fix or not but it might point out the
Right Way to fix this

--- build/arch/x86_64/vdso/vdso.lds-orig	2007-04-26 08:18:19.000000000 -0700
+++ build/arch/x86_64/vdso/vdso.lds	2007-04-26 08:18:23.000000000 -0700
@@ -33,7 +33,7 @@
      For the layouts to match, we need to skip more than enough
      space for the dynamic symbol table et al.  If this amount
      is insufficient, ld -shared will barf.  Just increase it here.  */
-  . = 0xffffffffff700000 + 0x500;
+  . = 0xffffffffff700000 + 0x400;
 
   .text : { *(.text) } :text
   .text.ptr : { *(.text.ptr) } :text
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
