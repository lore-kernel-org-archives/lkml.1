Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbYFLSI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbYFLSI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 14:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbYFLSIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 14:08:19 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:45741 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbYFLSIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 14:08:18 -0400
Date: Thu, 12 Jun 2008 20:08:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild breaks um - fails to find util when linking
Message-ID: <20080612180859.GA2271@uranus.ravnborg.org>
References: <20080610190307.GA15983@uranus.ravnborg.org> <20080611154816.GA8167@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080611154816.GA8167@c2.user-mode-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 11:48:16AM -0400, Jeff Dike wrote:
> This patch obviously isn't usable for anyone else, but UML needs a
> hook or something to add libgcc and libc to the ld commands:
> 
> Index: linux-2.6-git/scripts/link-vmlinux.sh
> ===================================================================
> --- linux-2.6-git.orig/scripts/link-vmlinux.sh	2008-06-11 11:26:07.000000000 -0400
> +++ linux-2.6-git/scripts/link-vmlinux.sh	2008-06-11 11:41:04.000000000 -0400
> @@ -122,7 +122,7 @@ fi
>  # First stage of fully linked vmlinux
>  tell LD ${VMLINUX}
>  ${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -o ${VMLINUX} \
> -      -T ${KBUILD_VMLINUX_LDS} vmlinux.o
> +      -T ${KBUILD_VMLINUX_LDS} vmlinux.o `gcc -print-libgcc-file-name` -lc
>  
>  if [ "${CONFIG_KALLSYMS}" = "y" ]; then
>  
> @@ -133,7 +133,8 @@ if [ "${CONFIG_KALLSYMS}" = "y" ]; then
>          # link in kalll symbols
>  	tell LD vmlinux
>          ${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -o vmlinux \
> -         -T ${KBUILD_VMLINUX_LDS} vmlinux.o .tmp_kallsyms.o
> +         -T ${KBUILD_VMLINUX_LDS} vmlinux.o .tmp_kallsyms.o \
> +	    `gcc -print-libgcc-file-name` -lc
>  fi
>  
>  tell SYSMAP System.map
> 
> This fixes the flood of undefined symbols, but I still get this on the
> link:
>     ld: warning: Cannot create .note.gnu.build-id section, --build-id ignored.
>     ld: warning: cannot find entry symbol _start; defaulting to 08056320
> 
> And when I run the result, I get this, which I don't understand at
> all:
> 
>     -bash: ./uml/linux: /usr/lib/libc.so.1: bad ELF interpreter: No
> such file or directory

Hi Jeff.
Following patch will result in a building ARCH=um kernel.
If it works I dunno.

I tried a build with allnoconfig and defconfig.

Could you please review/test this patch and let me know
if this works. It is on top of the first patch I sent.

Note: It includes a unrelated powerpc fix too (AFLAGS_KERNEL).

Thanks,
	Sam

diff --git a/arch/um/Makefile b/arch/um/Makefile
index 06cbc09..4eb0b07 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -104,7 +104,7 @@ archprepare: $(ARCH_SYMLINKS) $(ARCH_DIR)/include/user_constants.h
 prepare: $(ARCH_DIR)/include/kern_constants.h
 
 LINK-$(CONFIG_LD_SCRIPT_STATIC) += -static
-LINK-$(CONFIG_LD_SCRIPT_DYN) += -rpath /lib -rpath /usr/lib
+LINK-$(CONFIG_LD_SCRIPT_DYN) += -L/lib -L/usr/lib
 
 CFLAGS_NO_HARDENING := $(call cc-option, -fno-PIC,) $(call cc-option, -fno-pic,) \
 	$(call cc-option, -fno-stack-protector,) \
@@ -118,7 +118,13 @@ CPPFLAGS_vmlinux.lds = -U$(SUBARCH) -DSTART=$(START) -DELF_ARCH=$(ELF_ARCH) \
 
 # The wrappers will select whether using "malloc" or the kernel allocator.
 LDFLAGS_vmlinux := $(LINK-y) --wrap malloc --wrap free --wrap calloc
-KBUILD_VMLINUX_EXTRA := -lutil
+KBUILD_VMLINUX_EXTRA := \
+$(shell $(CC) -print-file-name=crt1.o)        \
+$(shell $(CC) -print-file-name=crti.o)        \
+$(shell $(CC) -print-file-name=libgcc_s.so)   \
+$(shell $(CC) -print-file-name=ld-linux.so.2) \
+$(shell $(CC) -print-file-name=libutil.so)    \
+$(shell $(CC) -print-file-name=libc.so)
 
 # When cleaning we don't include .config, so we don't include
 # TT or skas makefiles and don't clean skas_ptregs.h.
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index b9ecff5..e8fc6ab 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -95,8 +95,7 @@ mksysmap()
 tell LD vmlinux.o
 ${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -r -o vmlinux.o      \
 	${KBUILD_VMLINUX_INIT}                           \
-        --start-group ${KBUILD_VMLINUX_MAIN} --end-group \
-	${KBUILD_VMLINUX_EXTRA}
+        --start-group ${KBUILD_VMLINUX_MAIN} --end-group
 
 # modpost vmlinux.o
 ${MAKE} -f ${srctree}/scripts/Makefile.modpost vmlinux.o
@@ -121,19 +120,19 @@ fi
 
 # First stage of fully linked vmlinux
 tell LD ${VMLINUX}
-${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -o ${VMLINUX} \
-      -T ${KBUILD_VMLINUX_LDS} vmlinux.o
+${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} ${KBUILD_VMLINUX_EXTRA} \
+        -o ${VMLINUX} -T ${KBUILD_VMLINUX_LDS} vmlinux.o
 
 if [ "${CONFIG_KALLSYMS}" = "y" ]; then
 
 	# Do an extra pass to link in kallsyms data
 	${NM} -n .tmp_vmlinux | scripts/kallsyms > .tmp_kallsyms.S
-        ${CC} ${KBUILD_AFLAGS} ${KBUILD_CPPFLAGS} -c -o .tmp_kallsyms.o \
-	      .tmp_kallsyms.S
+        ${CC} ${KBUILD_AFLAGS} ${AFLAGS_KERNEL} ${KBUILD_CPPFLAGS} -c \
+	      -o .tmp_kallsyms.o .tmp_kallsyms.S
         # link in kalll symbols
 	tell LD vmlinux
-        ${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -o vmlinux \
-         -T ${KBUILD_VMLINUX_LDS} vmlinux.o .tmp_kallsyms.o
+        ${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} ${KBUILD_VMLINUX_EXTRA} \
+	      -o vmlinux -T ${KBUILD_VMLINUX_LDS} vmlinux.o .tmp_kallsyms.o
 fi
 
 tell SYSMAP System.map
