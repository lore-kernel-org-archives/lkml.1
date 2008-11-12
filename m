Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbYKLODI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbYKLODI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 09:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbYKLOC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 09:02:56 -0500
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:49259 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbYKLOCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 09:02:55 -0500
Date: Wed, 12 Nov 2008 14:02:50 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: try to catch missing VMLINUX_SYMBOL() in
	vmlinux.lds.h
Message-ID: <20081112140250.GF8302@shadowen.org>
References: <1226184965-13502-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226184965-13502-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2008 at 05:56:05PM -0500, Mike Frysinger wrote:
> Seems like every other release we have someone who updates vmlinux.lds.h and
> adds C-visible symbols without VMLINUX_SYMBOL() around them.  So start
> checking the file and only allow assignments that use one of the following
> symbols on a side:
> 	.
> 	ALIGN(...)
> 	VMLINUX_SYMBOL(...)
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  scripts/checkpatch.pl |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index f88bb3e..8e96b42 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2189,6 +2189,19 @@ sub process {
>  			}
>  		}
>  
> +# make sure symbols are always wrapped with VMLINUX_SYMBOL() ...
> +# all assignments may have only one of the following with an assignment:
> +#	.
> +#	ALIGN(...)
> +#	VMLINUX_SYMBOL(...)
> +		if ($realfile =~ /vmlinux.lds.h$/) {
> +			if ($line =~ /=/ &&
> +			    !($line =~ /([.]|(ALIGN|VMLINUX_SYMBOL)[(][^=]*[)])\s*=\s*([.]|(ALIGN|VMLINUX_SYMBOL)[(][^=]*[)])/))
> +			{
> +				WARN("vmlinux.lds.h needs VMLINUX_SYMBOL() around C-visible symbols\n" . $herecurr);
> +			}
> +		}
> +
>  # check for redundant bracing round if etc
>  		if ($line =~ /(^.*)\bif\b/ && $1 !~ /else\s*$/) {
>  			my ($level, $endln, @chunks) =
> -- 

Ok, that seems like a sane check.  I think what we are really wanting
to check for is assigments with plain identifiers on either side?  I've
pushed a softened version of this check to my tree for testing.

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

-apw
