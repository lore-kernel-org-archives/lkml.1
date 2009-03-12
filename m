Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbZCLWP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbZCLWP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 18:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbZCLWPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 18:15:51 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:40380 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbZCLWPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 18:15:50 -0400
Date: Thu, 12 Mar 2009 23:17:47 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] initconst adjustments
Message-ID: <20090312221747.GA14921@uranus.ravnborg.org>
References: <49B8F8E9.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B8F8E9.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 10:58:33AM +0000, Jan Beulich wrote:
> - add .init.rodata to INIT_DATA, and group all initconst flavors
>   together
> - move strings generated from __setup_param() into .init.rodata
> - add .*init.rodata to modpost's sets of init sections
> - make modpost warn about references between meminit and cpuinit
>   as well as memexit and cpuexit sections (as CPU and memory
>   hotplug are independently selectable features)
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  include/asm-generic/vmlinux.lds.h |    5 ++-
>  include/linux/init.h              |    3 +-
>  scripts/mod/modpost.c             |   50 +++++++++++++++++++++++++++++---------
>  3 files changed, 44 insertions(+), 14 deletions(-)
> 
> +++ 2.6.29-rc7-initconst/scripts/mod/modpost.c	2009-02-13 12:17:25.000000000 +0100
> @@ -753,6 +753,8 @@ static int check_section(const char *mod
>  
>  
>  #define ALL_INIT_DATA_SECTIONS \
> +	".init.setup$", ".init.rodata$", \
> +	".devinit.rodata$", ".cpuinit.rodata$", ".meminit.rodata$" \
>  	".init.data$", ".devinit.data$", ".cpuinit.data$", ".meminit.data$"
>  #define ALL_EXIT_DATA_SECTIONS \
>  	".exit.data$", ".devexit.data$", ".cpuexit.data$", ".memexit.data$"
> @@ -762,21 +764,23 @@ static int check_section(const char *mod
>  #define ALL_EXIT_TEXT_SECTIONS \
>  	".exit.text$", ".devexit.text$", ".cpuexit.text$", ".memexit.text$"
>  
> -#define ALL_INIT_SECTIONS ALL_INIT_DATA_SECTIONS, ALL_INIT_TEXT_SECTIONS
> -#define ALL_EXIT_SECTIONS ALL_EXIT_DATA_SECTIONS, ALL_EXIT_TEXT_SECTIONS
> +#define ALL_INIT_SECTIONS INIT_SECTIONS, DEV_INIT_SECTIONS, \
> +	CPU_INIT_SECTIONS, MEM_INIT_SECTIONS
> +#define ALL_EXIT_SECTIONS EXIT_SECTIONS, DEV_EXIT_SECTIONS, \
> +	CPU_EXIT_SECTIONS, MEM_EXIT_SECTIONS
>  
>  #define DATA_SECTIONS ".data$", ".data.rel$"
>  #define TEXT_SECTIONS ".text$"
>  
> -#define INIT_SECTIONS      ".init.data$", ".init.text$"
> -#define DEV_INIT_SECTIONS  ".devinit.data$", ".devinit.text$"
> -#define CPU_INIT_SECTIONS  ".cpuinit.data$", ".cpuinit.text$"
> -#define MEM_INIT_SECTIONS  ".meminit.data$", ".meminit.text$"
> -
> -#define EXIT_SECTIONS      ".exit.data$", ".exit.text$"
> -#define DEV_EXIT_SECTIONS  ".devexit.data$", ".devexit.text$"
> -#define CPU_EXIT_SECTIONS  ".cpuexit.data$", ".cpuexit.text$"
> -#define MEM_EXIT_SECTIONS  ".memexit.data$", ".memexit.text$"
> +#define INIT_SECTIONS      ".init.*"
> +#define DEV_INIT_SECTIONS  ".devinit.*"
> +#define CPU_INIT_SECTIONS  ".cpuinit.*"
> +#define MEM_INIT_SECTIONS  ".meminit.*"
> +
> +#define EXIT_SECTIONS      ".exit.*"
> +#define DEV_EXIT_SECTIONS  ".devexit.*"
> +#define CPU_EXIT_SECTIONS  ".cpuexit.*"
> +#define MEM_EXIT_SECTIONS  ".memexit.*"

The abvoe simplification now makes us math all sections that starts with
for example .init. - and we have seen sections named .init.1 for example.
So I'm afraid that we will simply match too many sections here on the various
architectures.

A quick grep showed for example:
arch/blackfin/kernel/vmlinux.lds.S:     .init.setup :
arch/blackfin/kernel/vmlinux.lds.S:             *(.init.setup)
arch/blackfin/kernel/vmlinux.lds.S:     .init.ramfs :
arch/blackfin/kernel/vmlinux.lds.S:             *(.init.ramfs)

We should be on the safe side and avoid this optimization.

	Sam
