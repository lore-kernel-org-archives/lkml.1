Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbZGQWSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbZGQWSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 18:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbZGQWSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 18:18:48 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:56716 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbZGQWSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 18:18:48 -0400
Date: Sat, 18 Jul 2009 00:18:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Frans Pop <elendil@planet.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kbuild@vger.kernel.org, barryn@pobox.com,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [PATCH,v2] Only add '-fwrapv' to gcc CFLAGS for gcc 4.2 and
	later
Message-ID: <20090717221846.GA7347@merkur.ravnborg.org>
References: <200907100928.07369.elendil@planet.nl> <200907102205.49642.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907102205.49642.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 10:05:47PM +0200, Frans Pop wrote:
> On Friday 10 July 2009, Frans Pop wrote:
> > The discussion on issue looks to have died, but it has bitten Debian
> > stable ("Lenny") [1] as it causes init to die on s390 after a kernel
> > update.
> >
> > Here's a possible patch. The exact gcc version to check for is still a
> > bit open I guess. For the s390 issue I've confirmed that 4.2.4 is OK,
> > but for safety and because of Andrew's comment above I've set the test
> > for 4.3 in the patch.
> 
> Here's an updated patch as I found the gcc version check was incorrect 
> (0430 should have been 0403; sorry).
> 
> I've now changed the check to allow -fwrapv for gcc 4.2 as that has been 
> shown to work and because of the consideration mentioned in my previous 
> mail.
> 
> ---
> From: Frans Pop <elendil@planet.nl>
> Subject: Only add '-fwrapv' to gcc CFLAGS for gcc 4.2 and later
> 
> This flag has been shown to cause init to segfault for kernels
> compiled with gcc-4.1. gcc version 4.2.4 has been shown to be OK.
> 
> This fixes http://bugzilla.kernel.org/show_bug.cgi?id=13012.
> 
> Reported-by: Barry K. Nathan <barryn@pobox.com>
> Signed-off-by: Frans Pop <elendil@planet.nl>
> 
> diff --git a/Makefile b/Makefile
> index 0aeec59..2519fde 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -565,7 +565,8 @@ KBUILD_CFLAGS += $(call 
> cc-option,-Wdeclaration-after-statement,)
>  KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)
>  
>  # disable invalid "can't wrap" optimizations for signed / pointers
> -KBUILD_CFLAGS	+= $(call cc-option,-fwrapv)
> +KBUILD_CFLAGS  += $(shell if [ $(call cc-version) -ge 0402 ]; then \
> +		    echo $(call cc-option,-fwrapv); fi ;)

This would be simpler if you use:
# cc-ifversion
# Usage:  EXTRA_CFLAGS += $(call cc-ifversion, -lt, 0402, -O1)
cc-ifversion = $(shell [ $(call cc-version, $(CC)) $(1) $(2) ] && echo $(3))

We have only one user at the moment so I understand why you missed it.

	Sam
