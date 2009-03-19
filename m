Return-Path: <linux-kernel-owner+w=401wt.eu-S1760763AbZCSW1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760763AbZCSW1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 18:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761525AbZCSW0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 18:26:51 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:42987 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761570AbZCSW0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 18:26:50 -0400
Date: Thu, 19 Mar 2009 23:28:48 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: git-commits-head@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Add '-fwrapv' to gcc CFLAGS
Message-ID: <20090319222848.GA26278@uranus.ravnborg.org>
References: <200903192159.n2JLx1Bu020711@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903192159.n2JLx1Bu020711@hera.kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 09:59:01PM +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/68df3755e383e6fecf2354a67b08f92f18536594
> Commit:     68df3755e383e6fecf2354a67b08f92f18536594
> Parent:     a1e4ee22863d41a6fbb24310d7951836cb6dafe7
> Author:     Linus Torvalds <torvalds@linux-foundation.org>
> AuthorDate: Thu Mar 19 11:10:17 2009 -0700
> Committer:  Linus Torvalds <torvalds@linux-foundation.org>
> CommitDate: Thu Mar 19 11:10:17 2009 -0700
> 
>     Add '-fwrapv' to gcc CFLAGS
>     
>     This makes sure that gcc doesn't try to optimize away wrapping
>     arithmetic, which the kernel occasionally uses for overflow testing, ie
>     things like
>     
>     	if (ptr + offset < ptr)
>     
>     which technically is undefined for non-unsigned types. See
>     
>     	http://bugzilla.kernel.org/show_bug.cgi?id=12597
>     
>     for details.
>     
>     Not all versions of gcc support it, so we need to make it conditional
>     (it looks like it was introduced in gcc-3.4).
>     
>     Reminded-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  Makefile |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 2e2f4a4..f607658 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -347,6 +347,7 @@ KBUILD_CPPFLAGS := -D__KERNEL__
>  KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
>  		   -fno-strict-aliasing -fno-common \
>  		   -Werror-implicit-function-declaration
> +KBUILD_CFLAGS	+= $(call cc-option,-fwrapv)
>  KBUILD_AFLAGS   := -D__ASSEMBLY__
>  
>  # Read KERNELRELEASE from include/config/kernel.release (if it exists)

Path is buggy.
We have several architectures that plays strange games with $(CC)
and $(CROSS_COMPILE).
So we need to postpone any use of $(call cc-option..)
until we have included the arch specific Makefile so
we try with the correct $(CC) version.

If you move it below the include at around line 530 you
should be safe.

	Sam
