Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbYG3Tkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbYG3Tkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbYG3TkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:40:22 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:11907 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073AbYG3TkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:40:20 -0400
Date: Wed, 30 Jul 2008 21:39:21 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jeff Dike <jdike@addtoit.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] x86: use arch/x86/include
Message-ID: <20080730193921.GA4475@uranus.ravnborg.org>
References: <20080730124952.GA23413@uranus.ravnborg.org> <20080730180411.GA7896@elte.hu> <20080730184700.GA29710@uranus.ravnborg.org> <20080730191907.GD26389@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730191907.GD26389@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > How we do it in the best way for such a fragile codebase as x86 is I 
> > am not sure. [...]
> 
> huh, fragile codebase? Is that a flamebait? :-) What do you mean 
> exactly?
I only wanted to say that x86 see more changes than any other arch
in the kernel like you also nicely says below.
> 
> The timing problems come from the fact that 90% of Linux development and 
> 95% of Linux testing happens on x86. So we've already got a ton of stuff 
> queued up for the next merge window. (and some cleanups for this cycle 
> as well)
> 
> But fortunately you've scripted all this, so i guess we can do it at any 
> stage. Could you send the script we should run?

It is a combination of a scrip and a patch.
The script:
#####
set -e
for D in include/asm-x86/mach-*; do
	echo $D
	DD=$(echo $D | cut -d '-' -f 3)
        mkdir -p arch/x86/include/mach-$DD/arch
        git mv include/asm-x86/mach-$DD/* arch/x86/include/mach-$DD
        rmdir include/asm-x86/mach-$DD
done

mkdir -p arch/x86/include/asm
git mv include/asm-x86/* arch/x86/include/asm
#####

And the patch (same as I included in the original posting:
diff --git a/arch/um/Makefile b/arch/um/Makefile
index ca40397..4a19886 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -156,9 +156,21 @@ include/asm-um/arch:
 	@echo '  SYMLINK $@'
 ifneq ($(KBUILD_SRC),)
 	$(Q)mkdir -p $(objtree)/include/asm-um
-	$(Q)ln -fsn $(srctree)/include/asm-$(HEADER_ARCH) include/asm-um/arch
+	$(Q)if [ -d $(srctree)/arch/$(HEADER_ARCH)/include/asm ]; then  \
+		ln -fsn $(srctree)/arch/$(HEADER_ARCH)/include/asm      \
+		        include/asm-um/arch;                            \
+	else                                                            \
+		ln -fsn $(srctree)/include/asm-$(HEADER_ARCH)           \
+		        include/asm-um/arch;                            \
+	fi
 else
-	$(Q)cd $(srctree)/include/asm-um && ln -fsn ../asm-$(HEADER_ARCH) arch
+	$(Q)if [ -d arch/$(HEADER_ARCH)/include/asm ]; then             \
+		ln -fsn $(srctree)/arch/$(HEADER_ARCH)/include/asm      \
+                        include/asm-um/arch;                            \
+	else                                                            \
+		cd $(srctree)/include/asm-um &&                         \
+		ln -fsn ../asm-$(HEADER_ARCH) arch;                     \
+	fi
 endif
 
 $(objtree)/$(ARCH_DIR)/include:
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index f5631da..c7493e7 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -110,16 +110,16 @@ KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
 mcore-y  := arch/x86/mach-default/
 
 # Voyager subarch support
-mflags-$(CONFIG_X86_VOYAGER)	:= -Iinclude/asm-x86/mach-voyager
+mflags-$(CONFIG_X86_VOYAGER)	:= -Iarch/x86/include/mach-voyager
 mcore-$(CONFIG_X86_VOYAGER)	:= arch/x86/mach-voyager/
 
 # generic subarchitecture
-mflags-$(CONFIG_X86_GENERICARCH):= -Iinclude/asm-x86/mach-generic
+mflags-$(CONFIG_X86_GENERICARCH):= -Iarch/x86/include/mach-generic
 fcore-$(CONFIG_X86_GENERICARCH)	+= arch/x86/mach-generic/
 mcore-$(CONFIG_X86_GENERICARCH)	:= arch/x86/mach-default/
 
 # default subarch .h files
-mflags-y += -Iinclude/asm-x86/mach-default
+mflags-y += -Iarch/x86/include/mach-default
 
 # 64 bit does not support subarch support - clear sub arch variables
 fcore-$(CONFIG_X86_64)  :=
diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
index 366f8c7..41564b1 100755
--- a/scripts/checksyscalls.sh
+++ b/scripts/checksyscalls.sh
@@ -119,5 +119,5 @@ sed -n -e '/^\#define/ { s/[^_]*__NR_\([^[:space:]]*\).*/\
 \#endif/p }' $1
 }
 
-(ignore_list && syscall_list ${srctree}/include/asm-x86/unistd_32.h) | \
+(ignore_list && syscall_list ${srctree}/arch/x86/include/asm/unistd_32.h) | \
 $* -E -x c - > /dev/null


I by the way tried a simple git grep asm-x86:
[Manually edited to remove where asm-x86 occured in comments]

Documentation/DocBook/deviceiobook.tmpl:!Iinclude/asm-x86/io_32.h
Documentation/DocBook/kernel-api.tmpl:!Iinclude/asm-x86/atomic_32.h
Documentation/DocBook/kernel-api.tmpl:!Iinclude/asm-x86/unaligned.h
Documentation/DocBook/kernel-api.tmpl:!Iinclude/asm-x86/bitops.h
Documentation/DocBook/kernel-api.tmpl:!Iinclude/asm-x86/uaccess_32.h
Documentation/DocBook/kernel-api.tmpl:!Iinclude/asm-x86/mca_dma.h
Documentation/DocBook/kernel-hacking.tmpl:   <filename>include/asm-x86/delay_32.h:</filename>
Documentation/DocBook/kernel-hacking.tmpl:   <filename>include/asm-x86/uaccess_32.h:</filename>
Documentation/DocBook/mcabook.tmpl:!Iinclude/asm-x86/mca_dma.h
Documentation/kernel-parameters.txt:                    include/asm-x86/cpufeature.h for the valid
Documentation/lguest/lguest.c:#include "asm-x86/bootparam.h"
Documentation/x86/i386/zero-page.txt:  include/asm-x86/bootparam.h

arch/ia64/ia32/audit.c:#include <asm-x86/unistd_32.h>

arch/um/sys-x86_64/syscall_table.c:#include <asm-x86/unistd_64.h>
arch/um/sys-x86_64/syscall_table.c:#include <asm-x86/unistd_64.h>

So um needs a few more changes to build.
And ia64 needs a fix too.
Documentation is trivial and can be done in a seperate commit.

	Sam
