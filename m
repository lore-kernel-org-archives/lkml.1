Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbZABJHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbZABJHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 04:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbZABJHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 04:07:37 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:47116 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbZABJHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 04:07:36 -0500
Date: Fri, 2 Jan 2009 10:09:14 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Rob Landley <rob@landley.net>
Cc: Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/3]: Remove perl from make headers_install
Message-ID: <20090102090914.GB3057@uranus.ravnborg.org>
References: <200901020207.30359.rob@landley.net> <200901020214.33123.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901020214.33123.rob@landley.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 02:14:32AM -0600, Rob Landley wrote:
> From: Rob Landley <rob@landley.net>
> 
> Remove perl from make headers_install by replacing a perl script (doing
> a simple regex search and replace) with a smaller and faster shell script
> implementation.  The new shell script is a single for loop calling sed and
> piping its output through unifdef to produce the target file.

OK
> 
> Sam Ravnborg added this perl to 2.6.27.

Drop this part - this is just to make you happy and for no use for others.

> 
> Signed-off-by: Rob Landley <rob@landley.net>
> ---
> 
>  scripts/Makefile.headersinst |    6 ++--
>  scripts/headers_install.pl   |   46 ---------------------------------
>  scripts/headers_install.sh   |   23 ++++++++++++++++
>  3 files changed, 26 insertions(+), 49 deletions(-)
> 
> --- /dev/null	2008-11-21 04:46:41.000000000 -0600
> +++ b/scripts/headers_install.sh	2008-12-15 22:09:45.000000000 -0600
> @@ -0,0 +1,23 @@
> +#!/bin/bash
> +
> +# Grab arguments
> +
> +INDIR="$1"
> +shift
> +OUTDIR="$1"
> +shift
> +ARCH="$1"
> +shift

Please add a short explanation what this file is used for
and what it does.
You can take more or less a direct copy from headers_install.pl

> +
> +# Iterate through files listed on command line
> +
> +for i in "$@"
> +do
> +	sed -r \
> +		-e 's/([ \t(])(__user|__force|__iomem)[ \t]/\1/g' \
> +		-e 's/__attribute_const__([ \t]|$)/\1/g' \
> +		-e 's@^#include <linux/compiler.h>@@' "$INDIR/$i" |
> +	scripts/unifdef -U__KERNEL__ - > "$OUTDIR/$i"
> +done
> +
> +exit 0
> diff -r d9b501c91442 scripts/Makefile.headersinst
> --- a/scripts/Makefile.headersinst	Sun Dec 14 16:25:19 2008 -0800
> +++ b/scripts/Makefile.headersinst	Mon Dec 15 23:30:15 2008 -0600
> @@ -44,8 +44,8 @@
>  quiet_cmd_install = INSTALL $(printdir) ($(words $(all-files))\
>                              file$(if $(word 2, $(all-files)),s))
>        cmd_install = \
> -        $(PERL) $< $(srctree)/$(obj) $(install) $(SRCARCH) $(header-y); \
> -        $(PERL) $< $(objtree)/$(obj) $(install) $(SRCARCH) $(objhdr-y); \
> +		$(CONFIG_SHELL) $< $(srctree)/$(obj) $(install) $(SRCARCH) $(header-y); \
> +		$(CONFIG_SHELL) $< $(objtree)/$(obj) $(install) $(SRCARCH) $(objhdr-y); \

Stick to the coding style i the file and do not add your own.
Makefile.headersinst uses tabs for commands and not for indent.



	Sam
