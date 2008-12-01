Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbYLANSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbYLANSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 08:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbYLANSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 08:18:44 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36149 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbYLANSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 08:18:44 -0500
Date: Mon, 1 Dec 2008 13:18:07 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Tony Luck <tony.luck@intel.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>, Ralf Baechle <ralf@linux-mips.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Paul Mackerras <paulus@samba.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
       Ingo Molnar <mingo@redhat.com>, Chris Zankel <chris@zankel.net>
Subject: Re: [RFC 5/8] param: arch_get_boot_command_line()
Message-ID: <20081201131807.GD28971@flint.arm.linux.org.uk>
References: <200812012326.03151.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812012326.03151.rusty@rustcorp.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 11:26:01PM +1030, Rusty Russell wrote:
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -414,9 +414,11 @@ __early_param("mem=", early_mem);
>  
>  /*
>   * Initial parsing of the command line.
> + * FIXME: Use generic early_param / core_param code here.
>   */
> -static void __init parse_cmdline(char **cmdline_p, char *from)
> +static void __init parse_cmdline(void)
>  {
> +	const char *from = boot_command_line;
>  	char c = ' ', *to = command_line;
>  	int len = 0;
>  
> @@ -448,7 +450,6 @@ static void __init parse_cmdline(char **
>  		*to++ = c;
>  	}
>  	*to = '\0';
> -	*cmdline_p = command_line;
>  }
>  
>  static void __init
> @@ -673,11 +674,24 @@ static int __init customize_machine(void
>  }
>  arch_initcall(customize_machine);
>  
> -void __init setup_arch(char **cmdline_p)
> +void arch_get_boot_command_line(void)
> +{
> +	struct machine_desc *mdesc;
> +	const char *from;
> +
> +	mdesc = setup_machine(machine_arch_type);
> +	if (mdesc->cmdline)
> +		from = mdesc->cmdline();
> +	else
> +		from = default_command_line;
> +
> +	strlcpy(boot_command_line, from, COMMAND_LINE_SIZE);

This is only half the story I'm afraid.  It doesn't take account of the
fact that the command line can be passed from the boot loader via the
ATAG structures, which are only parsed after the machine specific
fixup has happened (which can also modify the ATAGs).

You're also not guaranteed to have an ATAG list before setup_arch() is
called - it might be a param_struct, and we convert that to an ATAG list
before ATAG parsing.

So there's quite a bit which needs to be done to get at the command line.
Basically, what's required is:

- convert param struct to tag list
- if no tag list, use default tag list
- run machine specific fixups which may set memory layout
- if memory layout has been set, kill off any memory atags to prevent it
  being overwritten
- parse all atags which includes setting the command line if such a tag
  is found

Then, and only then can you be sure that you have the right command line.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
