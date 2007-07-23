Return-Path: <linux-kernel-owner+w=401wt.eu-S1765968AbXGWINj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765968AbXGWINj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757782AbXGWINX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:13:23 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:54698 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbXGWINV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:13:21 -0400
Date: Mon, 23 Jul 2007 10:14:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>, Alan Modra <amodra@bigpond.net.au>,
       David Miller <davem@davemloft.net>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org
Subject: Re: "build-id" changes break sparc64
Message-ID: <20070723081435.GA4644@uranus.ravnborg.org>
References: <20070723062759.GB3933@uranus.ravnborg.org> <20070723072613.E3A504D0489@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723072613.E3A504D0489@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 12:26:13AM -0700, Roland McGrath wrote:
> > Should be doable without to much pain.
> > Alan can you please share with us exactly why this is better and what we may
> > run into of problems doing so.
> > A sample script would be nice too....
> 
> This about does it.  Polish left as an exercise to the reader.
> ld does "interesting" things if the linker scripts are inside --start-group.

Thanks - will take a look during the week.
I will most likely rename built-in.o to something else and reflect this
in Makefile.build. Just to make it clear this is now a linker script file.

But I would still like to hear from Alan what the benefits are.
I foresee that with this change it will take longer to build a kernel
after a single change but that a full kernel build is shorter.
And thats the wrong way to optimze...

	Sam
> 
> diff --git a/Makefile b/Makefile
> index cd47845..0000000 100644  
> --- a/Makefile
> +++ b/Makefile
> @@ -613,12 +613,15 @@ vmlinux-all  := $(vmlinux-init) $(vmlinu
>  vmlinux-lds  := arch/$(ARCH)/kernel/vmlinux.lds
>  export KBUILD_VMLINUX_OBJS := $(vmlinux-all)
>  
> +vmlinux-link-main = $(filter-out %.a,$(vmlinux-main)) \
> +		    --start-group $(filter %.a,$(vmlinux-main)) --end-group
> +
>  # Rule to link vmlinux - also used during CONFIG_KALLSYMS
>  # May be overridden by arch/$(ARCH)/Makefile
>  quiet_cmd_vmlinux__ ?= LD      $@
>        cmd_vmlinux__ ?= $(LD) $(LDFLAGS) $(LDFLAGS_vmlinux) -o $@ \
>        -T $(vmlinux-lds) $(vmlinux-init)                          \
> -      --start-group $(vmlinux-main) --end-group                  \
> +      $(vmlinux-link-main) \
>        $(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o FORCE ,$^)
>  
>  # Generate new vmlinux version
> @@ -747,7 +750,7 @@ endif # ifdef CONFIG_KALLSYMS
>  # relevant sections renamed as per the linker script.
>  quiet_cmd_vmlinux-modpost = LD      $@
>        cmd_vmlinux-modpost = $(LD) $(LDFLAGS) -r -o $@                          \
> -	 $(vmlinux-init) --start-group $(vmlinux-main) --end-group             \
> +	 $(vmlinux-init) $(vmlinux-link-main) \
>  	 $(filter-out $(vmlinux-init) $(vmlinux-main) $(vmlinux-lds) FORCE ,$^)
>  define rule_vmlinux-modpost
>  	:
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 3f7b451..0000000 100644  
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -274,11 +274,11 @@ $(sort $(subdir-obj-y)): $(subdir-ym) ;
>  # Rule to compile a set of .o files into one .o file
>  #
>  ifdef builtin-target
> -quiet_cmd_link_o_target = LD      $@
> +quiet_cmd_link_o_target = LDS      $@
>  # If the list of objects to link is empty, just create an empty built-in.o
> -cmd_link_o_target = $(if $(strip $(obj-y)),\
> -		      $(LD) $(ld_flags) -r -o $@ $(filter $(obj-y), $^),\
> -		      rm -f $@; $(AR) rcs $@)
> +cmd_link_o_target = echo > $@.new $(if $(strip $(obj-y)),\
> +		    	   	       'INPUT($(filter $(obj-y), $^))') && \
> + 		    mv -f $@.new $@
>  
>  $(builtin-target): $(obj-y) FORCE
>  	$(call if_changed,link_o_target)
> @@ -311,11 +311,11 @@ $(filter $(addprefix $(obj)/,         \
>  $($(subst $(obj)/,,$(@:.o=-objs)))    \
>  $($(subst $(obj)/,,$(@:.o=-y)))), $^)
>   
> -quiet_cmd_link_multi-y = LD      $@
> -cmd_link_multi-y = $(LD) $(ld_flags) -r -o $@ $(link_multi_deps)
> +quiet_cmd_link_multi-y = LDS     $@
> +cmd_link_multi-y = echo > $@.new 'INPUT($(link_multi_deps))' && mv -f $@.new $@
>  
>  quiet_cmd_link_multi-m = LD [M]  $@
> -cmd_link_multi-m = $(LD) $(ld_flags) $(LDFLAGS_MODULE) -o $@ $(link_multi_deps)
> +cmd_link_multi-m = $(cmd_link_multi-y)
This signel change looks wrong. We do not want to generate a linker
script for modules.

	Sam
