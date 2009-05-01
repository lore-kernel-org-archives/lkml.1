Return-Path: <linux-kernel-owner+w=401wt.eu-S1758160AbZEAMHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbZEAMHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 08:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbZEAMHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 08:07:15 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:40119 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbZEAMHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 08:07:13 -0400
Date: Fri, 1 May 2009 14:09:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] initconst adjustments
Message-ID: <20090501120922.GB23672@uranus.ravnborg.org>
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
Applied to kbuild-next.

	Sam

[Kept rest of mail for reference as this is a fairly old patch by now].

> 
> ---
>  include/asm-generic/vmlinux.lds.h |    5 ++-
>  include/linux/init.h              |    3 +-
>  scripts/mod/modpost.c             |   50 +++++++++++++++++++++++++++++---------
>  3 files changed, 44 insertions(+), 14 deletions(-)
> 
> --- linux-2.6.29-rc7/include/asm-generic/vmlinux.lds.h	2009-03-04 09:10:56.000000000 +0100
> +++ 2.6.29-rc7-initconst/include/asm-generic/vmlinux.lds.h	2009-02-13 12:17:25.000000000 +0100
> @@ -305,10 +305,11 @@
>  #define INIT_DATA							\
>  	*(.init.data)							\
>  	DEV_DISCARD(init.data)						\
> -	DEV_DISCARD(init.rodata)					\
>  	CPU_DISCARD(init.data)						\
> -	CPU_DISCARD(init.rodata)					\
>  	MEM_DISCARD(init.data)						\
> +	*(.init.rodata)							\
> +	DEV_DISCARD(init.rodata)					\
> +	CPU_DISCARD(init.rodata)					\
>  	MEM_DISCARD(init.rodata)					\
>  	/* implement dynamic printk debug */				\
>  	VMLINUX_SYMBOL(__start___verbose_strings) = .;                  \
> --- linux-2.6.29-rc7/include/linux/init.h	2008-12-25 00:26:37.000000000 +0100
> +++ 2.6.29-rc7-initconst/include/linux/init.h	2009-02-13 12:17:25.000000000 +0100
> @@ -231,7 +231,8 @@ struct obs_kernel_param {
>   * obs_kernel_param "array" too far apart in .init.setup.
>   */
>  #define __setup_param(str, unique_id, fn, early)			\
> -	static char __setup_str_##unique_id[] __initdata __aligned(1) = str; \
> +	static const char __setup_str_##unique_id[] __initconst	\
> +		__aligned(1) = str; \
>  	static struct obs_kernel_param __setup_##unique_id	\
>  		__used __section(.init.setup)			\
>  		__attribute__((aligned((sizeof(long)))))	\
> --- linux-2.6.29-rc7/scripts/mod/modpost.c	2008-12-25 00:26:37.000000000 +0100
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
>  
>  /* init data sections */
>  static const char *init_data_sections[] = { ALL_INIT_DATA_SECTIONS, NULL };
> @@ -868,12 +872,36 @@ const struct sectioncheck sectioncheck[]
>  	.tosec   = { INIT_SECTIONS, NULL },
>  	.mismatch = XXXINIT_TO_INIT,
>  },
> +/* Do not reference cpuinit code/data from meminit code/data */
> +{
> +	.fromsec = { MEM_INIT_SECTIONS, NULL },
> +	.tosec   = { CPU_INIT_SECTIONS, NULL },
> +	.mismatch = XXXINIT_TO_INIT,
> +},
> +/* Do not reference meminit code/data from cpuinit code/data */
> +{
> +	.fromsec = { CPU_INIT_SECTIONS, NULL },
> +	.tosec   = { MEM_INIT_SECTIONS, NULL },
> +	.mismatch = XXXINIT_TO_INIT,
> +},
>  /* Do not reference exit code/data from devexit/cpuexit/memexit code/data */
>  {
>  	.fromsec = { DEV_EXIT_SECTIONS, CPU_EXIT_SECTIONS, MEM_EXIT_SECTIONS, NULL },
>  	.tosec   = { EXIT_SECTIONS, NULL },
>  	.mismatch = XXXEXIT_TO_EXIT,
>  },
> +/* Do not reference cpuexit code/data from memexit code/data */
> +{
> +	.fromsec = { MEM_EXIT_SECTIONS, NULL },
> +	.tosec   = { CPU_EXIT_SECTIONS, NULL },
> +	.mismatch = XXXEXIT_TO_EXIT,
> +},
> +/* Do not reference memexit code/data from cpuexit code/data */
> +{
> +	.fromsec = { CPU_EXIT_SECTIONS, NULL },
> +	.tosec   = { MEM_EXIT_SECTIONS, NULL },
> +	.mismatch = XXXEXIT_TO_EXIT,
> +},
>  /* Do not use exit code/data from init code */
>  {
>  	.fromsec = { ALL_INIT_SECTIONS, NULL },
> 
> 
