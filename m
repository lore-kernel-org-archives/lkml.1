Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbZBQALD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbZBQALD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 19:11:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbZBQAKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 19:10:53 -0500
Received: from byss.tchmachines.com ([208.76.80.75]:37477 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbZBQAKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 19:10:52 -0500
Date: Mon, 16 Feb 2009 16:10:49 -0800
From: Josh Hunt <josh@scalex86.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       kiran@scalex86.org, mingo@elte.hu
Subject: Re: [PATCH] Fix 'make rpm' when CONFIG_LOCALVERSION_AUTO=y and
	using SCM tree
Message-ID: <20090217001049.GA16713@localhost.localdomain>
References: <20090212181605.GA7696@localhost.localdomain> <20090215090301.GA29048@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090215090301.GA29048@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 15, 2009 at 10:03:01AM +0100, Sam Ravnborg wrote:
> 
> I had to hand apply your patch and ended up with the following.

Sorry, not sure what happened there. 

> 
> Changes:
> - renamed from autoversion to scmversion
> - simpler logic in top-level Makefile
> - removed "set -e;" in scripts/package/Makefile - they are not needed
> 
> Please test.

The changes look good. All tested and works fine.

I'm still a little new to this - let me know if I need to resubmit
with your changes or if I need to provide anything else. 

Thanks
Josh

> 
> diff --git a/Makefile b/Makefile
> index 22d7584..3824446 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -903,12 +903,18 @@ localver = $(subst $(space),, $(string) \
>  # and if the SCM is know a tag from the SCM is appended.
>  # The appended tag is determined by the SCM used.
>  #
> -# Currently, only git is supported.
> -# Other SCMs can edit scripts/setlocalversion and add the appropriate
> -# checks as needed.
> +# .scmversion is used when generating rpm packages so we do not loose
> +# the version information from the SCM when we do the build of the kernel
> +# from the copied source
>  ifdef CONFIG_LOCALVERSION_AUTO
> -	_localver-auto = $(shell $(CONFIG_SHELL) \
> -	                  $(srctree)/scripts/setlocalversion $(srctree))
> +
> +ifeq ($(wildcard .scmversion),)
> +        _localver-auto = $(shell $(CONFIG_SHELL) \
> +                         $(srctree)/scripts/setlocalversion $(srctree))
> +else
> +        _localver-auto = $(shell cat .scmversion 2> /dev/null)
> +endif
> +
>  	localver-auto  = $(LOCALVERSION)$(_localver-auto)
>  endif
>  
> diff --git a/scripts/package/Makefile b/scripts/package/Makefile
> index 8c6b7b0..fa4a0a1 100644
> --- a/scripts/package/Makefile
> +++ b/scripts/package/Makefile
> @@ -35,9 +35,10 @@ $(objtree)/kernel.spec: $(MKSPEC) $(srctree)/Makefile
>  rpm-pkg rpm: $(objtree)/kernel.spec FORCE
>  	$(MAKE) clean
>  	$(PREV) ln -sf $(srctree) $(KERNELPATH)
> +	$(CONFIG_SHELL) $(srctree)/scripts/setlocalversion > $(objtree)/.scmversion
>  	$(PREV) tar -cz $(RCS_TAR_IGNORE) -f $(KERNELPATH).tar.gz $(KERNELPATH)/.
>  	$(PREV) rm $(KERNELPATH)
> -
> +	rm -f $(objtree)/.scmversion
>  	set -e; \
>  	$(CONFIG_SHELL) $(srctree)/scripts/mkversion > $(objtree)/.tmp_version
>  	set -e; \
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
