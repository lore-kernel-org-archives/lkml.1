Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbYGaUOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbYGaUOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYGaUNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:13:53 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:29787 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210AbYGaUNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:13:50 -0400
Date: Thu, 31 Jul 2008 22:13:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       David Howells <dhowells@redhat.com>, Greg Ungerer <gerg@snapgear.com>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       uClinux list <uclinux-dev@uclinux.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Message-ID: <20080731201352.GB25305@uranus.ravnborg.org>
References: <200807300907.25186.arnd@arndb.de> <Pine.LNX.4.64.0807301422380.3316@anakin> <20080731032338.GA14296@linux-sh.org> <200807312147.25837.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807312147.25837.arnd@arndb.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 09:47:25PM +0200, Arnd Bergmann wrote:
> On Thursday 31 July 2008, Paul Mundt wrote:
> > This sort of merging is fairly easy to do incrementally, at least by
> > someone that has both platforms available. An easy first step would be to
> > move the m68knommu stuff that are implemented differently over as _nommu
> > files, similar to how the _32/_64 renames happened, and then set about
> > converging the two little by little. This is what I've been doing with
> > sh64->sh integration for example, despite fundamental differences like
> > having a totally different register layout and instruction set.
>  
> I've played around with the purely mechanical side of merging the
> m68k{,nommu} header files and came up with a script to do it.
> All headers that are identical are used from their m68k variant, the
> others get an #include magic like x86 has it for 32/64.
> 
> This assumes that the kernel ABI is compatible and that user space
> can actually use the m68k headers for m68knommu as well.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> TARGET=arch/m68k/include/asm
> SOURCE1=include/asm-m68k
> SOURCE2=include/asm-m68knommu
> FILES="atomic.h bitops.h bootinfo.h bug.h bugs.h byteorder.h cache.h \
> cacheflush.h checksum.h cputime.h current.h delay.h div64.h \
> dma-mapping.h dma.h elf.h entry.h fb.h fpu.h hardirq.h hw_irq.h io.h \
> irq.h kmap_types.h local.h machdep.h mc146818rtc.h mmu.h mmu_context.h \
> module.h page.h page_offset.h param.h pci.h percpu.h pgalloc.h \
> pgtable.h processor.h ptrace.h scatterlist.h sections.h segment.h \
> setup.h sigcontext.h siginfo.h signal.h string.h system.h \
> thread_info.h timex.h tlbflush.h traps.h uaccess.h ucontext.h \
> unaligned.h unistd.h"
> EXPORTS="byteorder param ptrace sigcontext siginfo signal unistd"
> 
> mergefile() {
> 	BASE=${1%.h}
> 	mv $SOURCE1/$1 $TARGET/${BASE}_mmu.h
> 	mv $SOURCE2/$1 $TARGET/${BASE}_nommu.h
> cat << EOF > $TARGET/$1
> #ifdef __KERNEL__
> #ifdef CONFIG_MMU
> #include "${BASE}_mmu.h"
> #else
> #include "${BASE}_nommu.h"
> #endif
> #else
> #include "${BASE}_mmu.h"
> #endif
> EOF
> }

This will leak a CONFIG_ symbol if the header file
is exported. Can we do it with a gcc defined symbol?
[See how I did it for sparc for instance]

> 
> mergefile2() {
> 	if [ -e ${TARGET}/$1 ] ; then
> 		rm $SOURCE2/$1
> 	else
> 		mv $SOURCE2/$1 ${TARGET}
> 	fi
> }
> 
> addexport() {
> 	echo "unifdef-y += ${1}_mmu.h" >> $TARGET/Kbuild
> }
unifdef is deprecated. Plese use "header-y".
They have same effect these days.

	Sam
