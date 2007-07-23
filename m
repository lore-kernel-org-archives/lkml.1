Return-Path: <linux-kernel-owner+w=401wt.eu-S1762285AbXGWGl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762285AbXGWGl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758065AbXGWGlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:41:21 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:59056 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbXGWGlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:41:21 -0400
Date: Mon, 23 Jul 2007 08:42:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Move --build-id option
Message-ID: <20070723064235.GA4129@uranus.ravnborg.org>
References: <20070723060155.2B3824D0489@magilla.localdomain> <20070723061446.5DAAC4D0489@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723061446.5DAAC4D0489@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 11:14:46PM -0700, Roland McGrath wrote:
> 
> My original makefile patch to use ld --build-id wound up using it in too
> many places.  We want it only for the .ko and vmlinux links (and vmlinux
> temporary links that determine the vmlinux layout).
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  Makefile                 |    8 +++-----
>  scripts/Makefile.modpost |    4 ++--
>  2 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index cd47845..fe6c5dd 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -518,8 +518,6 @@ CFLAGS += $(call cc-option,-Wno-pointer-sign,)
>  # Use --build-id when available.
>  LDFLAGS_BUILD_ID = $(patsubst -Wl$(comma)%,%,\
>  			      $(call ld-option, -Wl$(comma)--build-id,))
> -LDFLAGS_MODULE += $(LDFLAGS_BUILD_ID)
As noted below keep this line.

> -LDFLAGS_vmlinux += $(LDFLAGS_BUILD_ID)
This needed to go otherwise you had to rely on all arch makefiles 
used += for LDFLAGS_vmlinux assignments.
>  
>  # Default kernel image to build when no specific target is given.
>  # KBUILD_IMAGE may be overruled on the command line or
> @@ -616,9 +614,9 @@ export KBUILD_VMLINUX_OBJS := $(vmlinux-all)
>  # Rule to link vmlinux - also used during CONFIG_KALLSYMS
>  # May be overridden by arch/$(ARCH)/Makefile
>  quiet_cmd_vmlinux__ ?= LD      $@
> -      cmd_vmlinux__ ?= $(LD) $(LDFLAGS) $(LDFLAGS_vmlinux) -o $@ \
> -      -T $(vmlinux-lds) $(vmlinux-init)                          \
> -      --start-group $(vmlinux-main) --end-group                  \
> +      cmd_vmlinux__ ?= $(LD) $(LDFLAGS) $(LDFLAGS_BUILD_ID) $(LDFLAGS_vmlinux) \
> +      -o $@ -T $(vmlinux-lds) $(vmlinux-init)		\
> +      --start-group $(vmlinux-main) --end-group		\
>        $(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o FORCE ,$^)
This is OK.
>  
>  # Generate new vmlinux version
> diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
> index c6fcc59..a86a3b1 100644
> --- a/scripts/Makefile.modpost
> +++ b/scripts/Makefile.modpost
> @@ -97,8 +97,8 @@ targets += $(modules:.ko=.mod.o)
>  
>  # Step 6), final link of the modules
>  quiet_cmd_ld_ko_o = LD [M]  $@
> -      cmd_ld_ko_o = $(LD) $(LDFLAGS) $(LDFLAGS_MODULE) -o $@		\
> -			  $(filter-out FORCE,$^)
> +      cmd_ld_ko_o = $(LD) $(LDFLAGS) $(LDFLAGS_BUILD_ID) $(LDFLAGS_MODULE) \
> +      		    	  -o $@ $(filter-out FORCE,$^)

This will not work as LDFLAGS_BUILD_ID is not exported.
Please make the change as outlined in earlier mail so we actually start
using LDFALGS_MODULE as documented.

Thanks,
	Sam
