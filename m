Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbYGaTsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbYGaTsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbYGaTsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:48:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:52461 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374AbYGaTr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:47:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Date: Thu, 31 Jul 2008 21:47:25 +0200
User-Agent: KMail/1.9.9
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       David Howells <dhowells@redhat.com>, Greg Ungerer <gerg@snapgear.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       uClinux list <uclinux-dev@uclinux.org>
References: <200807300907.25186.arnd@arndb.de> <Pine.LNX.4.64.0807301422380.3316@anakin> <20080731032338.GA14296@linux-sh.org>
In-Reply-To: <20080731032338.GA14296@linux-sh.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807312147.25837.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19Uy2T7Z2PwICxMk1sM2lpG11JklZ7WrfD2yeT
 oAh+0Cuj9Tx98DwpFTbykoTE99twmfLw+VRucUK7o/4vde+nWO
 lYXHr7QTuswZCzBpcOKBw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 July 2008, Paul Mundt wrote:
> This sort of merging is fairly easy to do incrementally, at least by
> someone that has both platforms available. An easy first step would be to
> move the m68knommu stuff that are implemented differently over as _nommu
> files, similar to how the _32/_64 renames happened, and then set about
> converging the two little by little. This is what I've been doing with
> sh64->sh integration for example, despite fundamental differences like
> having a totally different register layout and instruction set.
 
I've played around with the purely mechanical side of merging the
m68k{,nommu} header files and came up with a script to do it.
All headers that are identical are used from their m68k variant, the
others get an #include magic like x86 has it for 32/64.

This assumes that the kernel ABI is compatible and that user space
can actually use the m68k headers for m68knommu as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
TARGET=arch/m68k/include/asm
SOURCE1=include/asm-m68k
SOURCE2=include/asm-m68knommu
FILES="atomic.h bitops.h bootinfo.h bug.h bugs.h byteorder.h cache.h \
cacheflush.h checksum.h cputime.h current.h delay.h div64.h \
dma-mapping.h dma.h elf.h entry.h fb.h fpu.h hardirq.h hw_irq.h io.h \
irq.h kmap_types.h local.h machdep.h mc146818rtc.h mmu.h mmu_context.h \
module.h page.h page_offset.h param.h pci.h percpu.h pgalloc.h \
pgtable.h processor.h ptrace.h scatterlist.h sections.h segment.h \
setup.h sigcontext.h siginfo.h signal.h string.h system.h \
thread_info.h timex.h tlbflush.h traps.h uaccess.h ucontext.h \
unaligned.h unistd.h"
EXPORTS="byteorder param ptrace sigcontext siginfo signal unistd"

mergefile() {
	BASE=${1%.h}
	mv $SOURCE1/$1 $TARGET/${BASE}_mmu.h
	mv $SOURCE2/$1 $TARGET/${BASE}_nommu.h
cat << EOF > $TARGET/$1
#ifdef __KERNEL__
#ifdef CONFIG_MMU
#include "${BASE}_mmu.h"
#else
#include "${BASE}_nommu.h"
#endif
#else
#include "${BASE}_mmu.h"
#endif
EOF
}

mergefile2() {
	if [ -e ${TARGET}/$1 ] ; then
		rm $SOURCE2/$1
	else
		mv $SOURCE2/$1 ${TARGET}
	fi
}

addexport() {
	echo "unifdef-y += ${1}_mmu.h" >> $TARGET/Kbuild
}

mkdir -p ${TARGET}
# first the incompatible files
for i in $FILES ; do mergefile $i ; done
# move all the remaining m68k files
mv include/asm-m68k/* arch/m68k/include/asm/
# add a few files that are present only on nommu,
# remove the duplicate nommu files.
for i in `ls include/asm-m68knommu/` ; do mergefile2 $i ; done
# make sure the new files get exported where needed.
for i in $EXPORTS ; do addexport $i ; done
