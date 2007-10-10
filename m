Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbXJIRfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbXJIRfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 13:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbXJIRfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 13:35:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:57866 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbXJIRfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 13:35:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=hqcNKnn9IdUb1D18cUoo2SXQtwCeAy0sh20l8bGSpWf8FewMV25qoBQ1IQjgmFpxkJtFjLSqjbUDtfG9tgw5RSBSL/iAiXVQKtir5NtOWCXxsPxXE66egANbe7gVMIeVZcQL6i31yMin6akZm6/gzva05XKIgxaq/5Unmx+fip0=
Date: Tue, 9 Oct 2007 19:35:42 -0700
To: Sam Ravnborg <sam@ravnborg.org>
Cc: kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT] kbuild: save ARCH & CROSS_COMPILE
Message-Id: <20071009193542.b3bc7012.Kristoffer.ericson@gmail.com>
In-Reply-To: <20071008200255.GA16497@uranus.ravnborg.org>
References: <20071008200255.GA16497@uranus.ravnborg.org>
Organization: JLime
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.10.14; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Oct 2007 22:02:55 +0200
Sam Ravnborg <sam@ravnborg.org> wrote:

> One of the complaints that I continue to hear is that kbuild
> is lacking a way to 'remember' the ARCH and CROSS_COMPILE
> values originally used.
> Likewise we have people that change ARCH settings and get
> a lot of build errors due to asm symlink pointing at the
> wrong directory.
Yeah, almost happens at daily basis for me :)

> 
> This patch tries to address this by saving ARCH and
> CROSS_COMPILE settings and error out if user specify
> anohter ARCH or CROSS_COMPILE setting.
> If there is inconsistency then error out and suggest
> to run make mrproper.
> 
> This will as a side-effect prevent a build with the wrong
> asm symlink.
Sounds like a good idea.

> 
> The settings are stored in the build directory in a file
> named "Kbuild.config" (should it be a .dot file?).
> 
> I have tested it here with success - but please give
> it a try in your setup and let me know if anything breaks.
> 
> The patch is on top of latest linus tree but should apply
> with some fuzz to -mm too (at least it apply on top of 
> my kbuild.git tree).
> 
> PS. I do not like adding additional cruft to the top-level
> Makefile but did not find an easy way to push this to
> kconfig.
> 
> 	Sam
> 
> diff --git a/Makefile b/Makefile
> index 6fc97bf..9f6d03f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -182,8 +182,33 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
>  # Default value for CROSS_COMPILE is not to prefix executables
>  # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
>  
> -ARCH		?= $(SUBARCH)
> -CROSS_COMPILE	?=
> +# Kbuild save the ARCH and CROSS_COMPILE setting in Kbuild.config
> +# Restore these settings and check that user did not specify
> +# conflicting values.
> +Kbuild.config: ;
> +noconfigcheck-targets := clean mrproper distclean help %config
> +
> +ifneq ($(wildcard Kbuild.config),)
> +        -include Kbuild.config
> +        ifeq ($(filter $(noconfigcheck-targets),$(MAKECMDGOALS)),)
> +                ifneq ($(CROSS_COMPILE),)
> +                        ifneq ($(CROSS_COMPILE),$(KBUILD_CROSS_COMPILE))
> +                                $(error CROSS_COMPILE changed from "$(KBUILD_CROSS_COMPILE)" \
> +                                        to "$(CROSS_COMPILE)". Use "make mrproper" to fix it up)
> +                        endif
> +                endif
> +                ifneq ($(ARCH),)
> +                        ifneq ($(KBUILD_ARCH),$(ARCH))
> +                                $(error ARCH changed from "$(KBUILD_ARCH)" \
> +                                        to "$(ARCH)". Use "make mrproper" to fix it up)
> +                        endif
> +                endif   
> +        endif
> +        CROSS_COMPILE := $(KBUILD_CROSS_COMPILE)
> +        ARCH := $(KBUILD_ARCH)
> +else
> +        ARCH ?= $(SUBARCH)
> +endif
>  
>  # Architecture as present in compile.h
>  UTS_MACHINE := $(ARCH)
> @@ -351,6 +376,12 @@ scripts_basic:
>  # To avoid any implicit rule to kick in, define an empty command.
>  scripts/basic/%: scripts_basic ;
>  
> +# Save CROSS_COMPILE and ARCH for subsequent make invocations
> +PHONY += Kbuild.config.save
> +Kbuild.config.save:
> +	$(Q)echo KBUILD_ARCH := $(ARCH)                   >  Kbuild.config
> +	$(Q)echo KBUILD_CROSS_COMPILE := $(CROSS_COMPILE) >> Kbuild.config
> +
>  PHONY += outputmakefile
>  # outputmakefile generates a Makefile in the output directory, if using a
>  # separate output directory. This allows convenient use of make in the
> @@ -413,7 +444,7 @@ ifeq ($(config-targets),1)
>  include $(srctree)/arch/$(ARCH)/Makefile
>  export KBUILD_DEFCONFIG
>  
> -config %config: scripts_basic outputmakefile FORCE
> +config %config: scripts_basic outputmakefile Kbuild.config.save FORCE
>  	$(Q)mkdir -p include/linux include/config
>  	$(Q)$(MAKE) $(build)=scripts/kconfig $@
>  
> @@ -853,7 +884,10 @@ PHONY += prepare archprepare prepare0 prepare1 prepare2 prepare3
>  # and if so do:
>  # 1) Check that make has not been executed in the kernel src $(srctree)
>  # 2) Create the include2 directory, used for the second asm symlink
> -prepare3: include/config/kernel.release
> +prepare3: include/config/kernel.release Kbuild.config.save
> +ifneq ($(KBUILD_CROSS_COMPILE)$(KBUILD_ARCH),)
> +	$(Q)echo '  Using ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE)'
> +endif
>  ifneq ($(KBUILD_SRC),)
>  	@echo '  Using $(srctree) as source for kernel'
>  	$(Q)if [ -f $(srctree)/.config -o -d $(srctree)/include/config ]; then \
> @@ -919,10 +953,10 @@ define filechk_version.h
>  	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';)
>  endef
>  
> -include/linux/version.h: $(srctree)/Makefile FORCE
> +include/linux/version.h: $(srctree)/Makefile prepare2 FORCE
>  	$(call filechk,version.h)
>  
> -include/linux/utsrelease.h: include/config/kernel.release FORCE
> +include/linux/utsrelease.h: include/config/kernel.release prepare2 FORCE
>  	$(call filechk,utsrelease.h)
>  
>  # ---------------------------------------------------------------------------
> @@ -1050,7 +1084,7 @@ CLEAN_FILES +=	vmlinux System.map \
>  MRPROPER_DIRS  += include/config include2 usr/include
>  MRPROPER_FILES += .config .config.old include/asm .version .old_version \
>                    include/linux/autoconf.h include/linux/version.h      \
> -                  include/linux/utsrelease.h                            \
> +                  include/linux/utsrelease.h Kbuild.config              \
>  		  Module.symvers tags TAGS cscope*
>  
>  # clean - Delete most, but leave enough to build external modules
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
