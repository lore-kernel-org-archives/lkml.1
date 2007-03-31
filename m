Return-Path: <linux-kernel-owner+w=401wt.eu-S965131AbXCaGlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965131AbXCaGlp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 02:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933586AbXCaGlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 02:41:45 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:37733 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183AbXCaGlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 02:41:44 -0400
Date: Sat, 31 Mar 2007 08:42:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>, Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH] fix dependency generation
Message-ID: <20070331064228.GA11023@uranus.ravnborg.org>
References: <460BA292.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <460BA292.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2007 at 10:27:14AM +0100, Jan Beulich wrote:
> Commit 2e3646e51b2d6415549b310655df63e7e0d7a080 changed the way
> the split config tree is built, but failed to also adjust fixdep
> accordingly - if changing a config option from or to m, files
> referencing the respective CONFIG_..._MODULE (but not the
> corresponding CONFIG_...) didn't get rebuilt.

The problem is that tristate symbol represent three values.
=n => CONFIG_SYMBOL is undefined
=y => CONFIG_SYMBOL is defined
=m => COMFIG_SYMBOL_MODULE is defined

The function split_config does not take into account the
different values and 'fixing' this in fixdep is wrong.
Because fixdep does not know if the variable is a tristate symbol or not
so it can either blindly remove _MODULE (your patch)
or each time it encounters _MODULE check for a symbol with and
without _MODULE.

The better fix is to teach the split_config function that
for tristate symbols two files shall be created in the include/config
hirachy. So for apm this gets:
include/config/apm.h
include/config/apm/module.h

This will make kconfig behave correct the day that someone add a config
symbol with a _MODULE suffix.

I will follow-up with two patches that implement the changes to split_config.
The first is a pure code refactoring preparing for the second patch.

Roman - please ack/nack these this since they touches kconfig backend.

	Sam


> 
> Once at it, also eliminate false dependencies due to use of
> ...CONFIG_... identifiers.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> --- linux-2.6.21-rc5/scripts/basic/fixdep.c	2007-02-04 19:44:54.000000000 +0100
> +++ 2.6.21-rc5-fixdep-mod/scripts/basic/fixdep.c	2007-03-29 11:11:10.000000000 +0200
> @@ -29,8 +29,7 @@
>   * option which is mentioned in any of the listed prequisites.
>   *
>   * To be exact, split-include populates a tree in include/config/,
> - * e.g. include/config/his/driver.h, which contains the #define/#undef
> - * for the CONFIG_HIS_DRIVER option.
> + * e.g. include/config/his/driver.h, consiting of empty files.
>   *
>   * So if the user changes his CONFIG_HIS_DRIVER option, only the objects
>   * which depend on "include/linux/config/his/driver.h" will be rebuilt,
> @@ -223,7 +222,7 @@ void use_config(char *m, int slen)
>  void parse_config_file(char *map, size_t len)
>  {
>  	int *end = (int *) (map + len);
> -	/* start at +1, so that p can never be < map */
> +	/* start at +1, so that p can never be <= map */
>  	int *m   = (int *) map + 1;
>  	char *p, *q;
>  
> @@ -235,6 +234,8 @@ void parse_config_file(char *map, size_t
>  		continue;
>  	conf:
>  		if (p > map + len - 7)
> +			break;
> +		if (isalnum(p[-1]) || p[-1] == '_')
>  			continue;
>  		if (memcmp(p, "CONFIG_", 7))
>  			continue;
> @@ -245,6 +246,8 @@ void parse_config_file(char *map, size_t
>  		continue;
>  
>  	found:
> +		if (!memcmp(q - 7, "_MODULE", 7))
> +			q -= 7;
>  		use_config(p+7, q-p-7);
>  	}
>  }
> 
> 
