Return-Path: <linux-kernel-owner+w=401wt.eu-S1756368AbXKUGA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbXKUGA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 01:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbXKUGAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 01:00:20 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:52495 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbXKUGAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 01:00:19 -0500
Date: Wed, 21 Nov 2007 07:02:01 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/18] x86 vDSO: vdso32 build
Message-ID: <20071121060201.GA32304@uranus.ravnborg.org>
References: <20071119215944.01B7C26F8BE@magilla.localdomain> <20071119220532.029FC26F8BE@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119220532.029FC26F8BE@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland.

Some minor things below.
In general I like the simplification of this
area and having it moved out of kernel/Makefile is the-right-thing.

	Sam

On Mon, Nov 19, 2007 at 02:05:32PM -0800, Roland McGrath wrote:
> 
> This builds the 32-bit vDSO images in the arch/x86/vdso subdirectory.
> Nothing uses the images yet, but this paves the way for consolidating
> the vDSO build logic all in one place.  The new images use a linker
> script sharing the layout parts from vdso-layout.lds.S with the 64-bit
> vDSO.  A new vdso32-syms.lds is generated in the style of vdso-syms.lds.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  arch/x86/vdso/Makefile            |   76 +++++++++++++++++++++++++++++++++++-
>  arch/x86/vdso/vdso32/vdso32.lds.S |   37 ++++++++++++++++++
>  2 files changed, 110 insertions(+), 3 deletions(-)
>  create mode 100644 arch/x86/vdso/vdso32/vdso32.lds.S
> 
> diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
> index 6a665dd..a1e0418 100644
> --- a/arch/x86/vdso/Makefile
> +++ b/arch/x86/vdso/Makefile
> @@ -1,7 +1,15 @@
>  #
> -# x86-64 vDSO.
> +# Building vDSO images for x86.
>  #
>  
> +VDSO64-$(CONFIG_X86_64)		:= y
> +VDSO32-$(CONFIG_X86_32)		:= y
> +VDSO32-$(CONFIG_COMPAT)		:= y
> +
> +vdso-install-$(VDSO64-y)	+= vdso.so
> +vdso-install-$(VDSO32-y)	+= $(vdso32-y:=.so)
> +
> +
>  # files to link into the vdso
>  vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o vvar.o
>  
> @@ -57,10 +65,72 @@ quiet_cmd_vdsosym = VDSOSYM $@
>  $(obj)/%-syms.lds: $(obj)/%.so.dbg FORCE
>  	$(call if_changed,vdsosym)
>  
> +#
> +# Build multiple 32-bit vDSO images to choose from at boot time.
> +#
> +vdso32.so-$(CONFIG_X86_32)	+= int80
> +vdso32.so-$(VDSO32-y)		+= sysenter
> +
> +CPPFLAGS_vdso32.lds = $(CPPFLAGS_vdso.lds)
> +VDSO_LDFLAGS_vdso32.lds = -m elf_i386 -Wl,-soname=linux-gate.so.1
> +
> +# This makes sure the $(obj) subdirectory exists even though vdso32/
> +# is not a kbuild sub-make subdirectory.
> +override obj-dirs = $(dir $(obj)) $(obj)/vdso32/

Should we teach kbuild to create dirs specified in targets?
Or we could 'fix' it so you do not need the override.

> +
> +targets += vdso32/vdso32.lds
> +targets += $(vdso32.so-y:%=vdso32-%.so.dbg) $(vdso32.so-y:%=vdso32-%.so)
> +targets += vdso32/note.o $(vdso32.so-y:%=vdso32/%.o)
> +
> +extra-y	+= $(vdso32.so-y:%=vdso32-%.so)
> +
> +$(vdso32.so-y:%=$(obj)/vdso32-%.so.dbg): asflags-$(CONFIG_X86_64) += -m32
> +
> +$(vdso32.so-y:%=$(obj)/vdso32-%.so.dbg): $(obj)/vdso32-%.so.dbg: FORCE \
> +					 $(obj)/vdso32/vdso32.lds \
> +					 $(obj)/vdso32/note.o \
> +					 $(obj)/vdso32/%.o
> +	$(call if_changed,vdso)
> +
> +# Make vdso32-*-syms.lds from each image, and then make sure they match.
> +# The only difference should be that some do not define VDSO32_SYSENTER_RETURN.
> +
> +targets += vdso32-syms.lds $(vdso32.so-y:%=vdso32-%-syms.lds)
> +
> +quiet_cmd_vdso32sym = VDSOSYM $@
> +define cmd_vdso32sym
> +	if LC_ALL=C sort -u $(filter-out FORCE,$^) > $(@D)/.tmp_$(@F) && \
> +	   $(foreach H,$(filter-out FORCE,$^),\
> +		     if grep -q VDSO32_SYSENTER_RETURN $H; \
> +		     then diff -u $(@D)/.tmp_$(@F) $H; \
> +		     else sed /VDSO32_SYSENTER_RETURN/d $(@D)/.tmp_$(@F) | \
> +			  diff -u - $H; fi &&) : ;\
> +	then mv -f $(@D)/.tmp_$(@F) $@; \
> +	else rm -f $(@D)/.tmp_$(@F); exit 1; \
> +	fi
> +endef

use "set -e; in front of this shell script to bail out early
in case of errors.


> +
> +$(obj)/vdso32-syms.lds: $(vdso32.so-y:%=$(obj)/vdso32-%-syms.lds) FORCE
> +	$(call if_changed,vdso32sym)
> +
> +#
> +# The DSO images are built using a special linker script.
> +#
> +quiet_cmd_vdso = VDSO    $@
> +      cmd_vdso = $(CC) -nostdlib -o $@ \
> +		       $(VDSO_LDFLAGS) $(VDSO_LDFLAGS_$(filter %.lds,$(^F))) \
> +		       -Wl,-T,$(filter %.lds,$^) $(filter %.o,$^)
> +
> +VDSO_LDFLAGS = -fPIC -shared $(call ld-option, -Wl$(comma)--hash-style=sysv)

Do you need to specify soname for 64-bit - seems missing?

> +
> +#
> +# Install the unstripped copy of vdso*.so listed in $(vdso-install-y).
> +#
>  quiet_cmd_vdso_install = INSTALL $@
>        cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
> -vdso.so:
> +$(vdso-install-y): %.so: $(obj)/%.so.dbg FORCE
>  	@mkdir -p $(MODLIB)/vdso
>  	$(call cmd,vdso_install)
Please use $(Q) in preference for @
Then it is easier to debug using make V=1

> -vdso_install: vdso.so
> +PHONY += vdso_install $(vdso-install-y)
> +vdso_install: $(vdso-install-y)

