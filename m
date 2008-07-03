Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbYGCOqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbYGCOqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYGCOqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:46:32 -0400
Received: from adelie.canonical.com ([91.189.90.139]:34345 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbYGCOqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:46:31 -0400
Subject: Re: [PATCH] Config option to disable info from decompression of
	the kernel
From: Ben Collins <ben.collins@canonical.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080703123642.GB9733@elte.hu>
References: <1213812275.6575.25.camel@cunning>
	 <20080703123642.GB9733@elte.hu>
Content-Type: text/plain
Organization: Canonical
Date: Thu, 03 Jul 2008 10:46:28 -0400
Message-Id: <1215096389.7068.687.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-03 at 14:36 +0200, Ingo Molnar wrote:
> * Ben Collins <ben.collins@canonical.com> wrote:
> 
> > I submitted a similar patch some time ago, but rightfully it didn't 
> > get accepted, as it just disabled all output from the decompress stage 
> > (without a boot time option to enable it).
> > 
> > This patch just disables the information output from this stage, but 
> > not the error output.
> 
> > +config NO_BZ_CHATTER
> > +	bool "Disable decompress info messages"
> > +	default n
> > +	help
> > +	  Disables just the informational output from the decompression stage
> > +	  (e.g. bzImage) of the boot. You will still see errors. Do this if you
> > +	  want to cleanup the bootup process.
> 
> applied to tip/x86/setup - thanks Ben.
> 
> Note that i've flipped around the name (i.e. got rid of the 'NO_'), and 
> i renamed it to the bit more generic X86_VERBOSE_BOOTUP config variable. 
> We might want to make other output dependent on that flag, not just the 
> decompressor messages. Find the commit below. (please double-check it)

Looks good, thanks.

> 	Ingo
> 
> ----------------------->
> commit 6bcb13b35a2ea39be6c7cc0292b8ad1191b1a748
> Author: Ben Collins <ben.collins@canonical.com>
> Date:   Wed Jun 18 14:04:35 2008 -0400
> 
>     x86: config option to disable info from decompression of the kernel
>     
>     This patch allows the disabling of decompression messages during
>     x86 bootup.
>     
>     Signed-off-by: Ben Collins <ben.collins@canonical.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index ac1e31b..14abaa5 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -16,6 +16,14 @@ config NONPROMISC_DEVMEM
>  	  obviously disasterous, but specific access can be used by people
>  	  debugging the kernel.
>  
> +config X86_VERBOSE_BOOTUP
> +	bool "Enable verbose x86 bootup info messages"
> +	default y
> +	help
> +	  Enables the informational output from the decompression stage
> +	  (e.g. bzImage) of the boot. If you disable this you will still
> +	  see errors. Disable this if you want silent bootup.
> +
>  config EARLY_PRINTK
>  	bool "Early printk" if EMBEDDED
>  	default y
> diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
> index d10e727..11629e9 100644
> --- a/arch/x86/boot/compressed/misc.c
> +++ b/arch/x86/boot/compressed/misc.c
> @@ -202,7 +202,8 @@ static void free(void *where);
>  static void *memset(void *s, int c, unsigned n);
>  static void *memcpy(void *dest, const void *src, unsigned n);
>  
> -static void putstr(const char *);
> +static void __putstr(int, const char *);
> +#define putstr(__x)  __putstr(0, __x)
>  
>  #ifdef CONFIG_X86_64
>  #define memptr long
> @@ -266,11 +267,16 @@ static void scroll(void)
>  		vidmem[i] = ' ';
>  }
>  
> -static void putstr(const char *s)
> +static void __putstr(int error, const char *s)
>  {
>  	int x, y, pos;
>  	char c;
>  
> +#ifndef CONFIG_X86_VERBOSE_BOOTUP
> +	if (!error)
> +		return;
> +#endif
> +
>  #ifdef CONFIG_X86_32
>  	if (real_mode->screen_info.orig_video_mode == 0 &&
>  	    lines == 0 && cols == 0)
> @@ -363,9 +369,9 @@ static void flush_window(void)
>  
>  static void error(char *x)
>  {
> -	putstr("\n\n");
> -	putstr(x);
> -	putstr("\n\n -- System halted");
> +	__putstr(1, "\n\n");
> +	__putstr(1, x);
> +	__putstr(1, "\n\n -- System halted");
>  
>  	while (1)
>  		asm("hlt");

