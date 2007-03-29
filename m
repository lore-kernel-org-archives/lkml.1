Return-Path: <linux-kernel-owner+w=401wt.eu-S1753782AbXC2PkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbXC2PkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 11:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbXC2PkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 11:40:18 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:33305 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbXC2PkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 11:40:17 -0400
Date: Thu, 29 Mar 2007 08:39:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Jan Beulich" <jbeulich@novell.com>
Cc: <sam@ravnborg.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix dependency generation
Message-Id: <20070329083947.d9ba87e0.randy.dunlap@oracle.com>
In-Reply-To: <460BA292.76E4.0078.0@novell.com>
References: <460BA292.76E4.0078.0@novell.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2007 10:27:14 +0100 Jan Beulich wrote:

> Commit 2e3646e51b2d6415549b310655df63e7e0d7a080 changed the way
> the split config tree is built, but failed to also adjust fixdep
> accordingly - if changing a config option from or to m, files
> referencing the respective CONFIG_..._MODULE (but not the
> corresponding CONFIG_...) didn't get rebuilt.
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

I don't see why you deleted the line above.

> + * e.g. include/config/his/driver.h, consiting of empty files.

                                        consisting

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


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
