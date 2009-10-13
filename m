Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbZJMCBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbZJMCBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 22:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbZJMCBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 22:01:35 -0400
Received: from smtp-out.google.com ([216.239.45.13]:22816 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbZJMCBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 22:01:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=i9WqVbzzxz0fu+QyGk6p1wUHQMDIBBscnbb/+9XiMOGeVLDqN/if1Xq9jYSzvyLrO
	WAtczuSjrZTWqvA1rcENw==
Date: Mon, 12 Oct 2009 19:00:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Dirk Hohndel <hohndel@infradead.org>,
       Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic
In-Reply-To: <20091012195733.GA7351@elte.hu>
Message-ID: <alpine.DEB.1.00.0910121853050.26949@chino.kir.corp.google.com>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
 <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
 <20091006173508.GA4786@elte.hu> <20091012195733.GA7351@elte.hu>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009, Ingo Molnar wrote:

> diff --git a/Makefile b/Makefile
> index 927d7a3..5dab509 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -963,8 +963,6 @@ localver = $(subst $(space),, $(string) \
>  # .scmversion is used when generating rpm packages so we do not loose
>  # the version information from the SCM when we do the build of the kernel
>  # from the copied source
> -ifdef CONFIG_LOCALVERSION_AUTO
> -
>  ifeq ($(wildcard .scmversion),)
>          _localver-auto = $(shell $(CONFIG_SHELL) \
>                           $(srctree)/scripts/setlocalversion $(srctree))
> @@ -972,7 +970,14 @@ else
>          _localver-auto = $(shell cat .scmversion 2> /dev/null)
>  endif
>  
> +ifdef CONFIG_LOCALVERSION_AUTO
>  	localver-auto  = $(LOCALVERSION)$(_localver-auto)
> +else
> +	ifeq ($_localver-auto,)
> +		localver-auto = $(LOCALVERSION)
> +	else
> +		localver-auto = $(LOCALVERSION)+
> +	endif
>  endif
>  
>  localver-full = $(localver)$(localver-auto)

I don't see where the `+' is dropped between -rc tags; 
scripts/setlocalversion should return -00000-rc5 for v2.6.32-rc5, for 
example, so _localver-auto will always be non-NULL and the `+' is 
appended.

I think scripts/setlocalversion should also be modified as I earlier 
suggested to suppress output when git-describe shows no additional 
commits beyond the tag.  Then, CONFIG_LOCALVERSION_AUTO would not be 
v2.6.32-rc4-00000-rc4, for example, when 2.6.32-rc4 is released.

Your patch also adds the make LOCALVERSION= string to the version without 
requiring CONFIG_LOCALVERSION_AUTO.  That's a change from prior behavior, 
but I think it's helpful for user-specified version tags.
