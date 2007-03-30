Return-Path: <linux-kernel-owner+w=401wt.eu-S1751234AbXC3PIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbXC3PIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 11:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbXC3PIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 11:08:01 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:37316 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbXC3PIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 11:08:00 -0400
Date: Fri, 30 Mar 2007 17:08:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix dependency generation
Message-ID: <20070330150843.GA3520@uranus.ravnborg.org>
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
Do you have a test case for this?
I want to play a little with this before I submit it.

> 
> Once at it, also eliminate false dependencies due to use of
> ...CONFIG_... identifiers.
But that will break UM - no??
See following note from fixdep:
 * Note 2: if somebody writes HELLO_CONFIG_BOOM in a file, it will depend onto
 * CONFIG_BOOM. This could seem a bug (not too hard to fix), but please do not
 * fix it! Some UserModeLinux files (look at arch/um/) call CONFIG_BOOM as
 * UML_CONFIG_BOOM, to avoid conflicts with /usr/include/linux/autoconf.h,
 * through arch/um/include/uml-config.h; this fixdep "bug" makes sure that
 * those files will have correct dependencies.

	Sam

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
