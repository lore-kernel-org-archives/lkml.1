Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbYKPMGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbYKPMGr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 07:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbYKPMGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 07:06:38 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:33369 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbYKPMGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 07:06:37 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] checkpatch: try to catch missing VMLINUX_SYMBOL() in vmlinux.lds.h
Date: Sun, 16 Nov 2008 07:06:34 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.27.4; KDE/4.1.3; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1226184965-13502-1-git-send-email-vapier@gentoo.org> <20081112140250.GF8302@shadowen.org>
In-Reply-To: <20081112140250.GF8302@shadowen.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811160706.34901.vapier@gentoo.org>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 November 2008 09:02:50 Andy Whitcroft wrote:
> On Sat, Nov 08, 2008 at 05:56:05PM -0500, Mike Frysinger wrote:
> > Seems like every other release we have someone who updates vmlinux.lds.h
> > and adds C-visible symbols without VMLINUX_SYMBOL() around them.  So
> > start checking the file and only allow assignments that use one of the
> > following symbols on a side:
> > 	.
> > 	ALIGN(...)
> > 	VMLINUX_SYMBOL(...)
> >
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> > ---
> >  scripts/checkpatch.pl |   13 +++++++++++++
> >  1 files changed, 13 insertions(+), 0 deletions(-)
> >
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > index f88bb3e..8e96b42 100755
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -2189,6 +2189,19 @@ sub process {
> >  			}
> >  		}
> >
> > +# make sure symbols are always wrapped with VMLINUX_SYMBOL() ...
> > +# all assignments may have only one of the following with an assignment:
> > +#	.
> > +#	ALIGN(...)
> > +#	VMLINUX_SYMBOL(...)
> > +		if ($realfile =~ /vmlinux.lds.h$/) {
> > +			if ($line =~ /=/ &&
> > +			    !($line =~
> > /([.]|(ALIGN|VMLINUX_SYMBOL)[(][^=]*[)])\s*=\s*([.]|(ALIGN|VMLINUX_SYMBOL
> >)[(][^=]*[)])/)) +			{
> > +				WARN("vmlinux.lds.h needs VMLINUX_SYMBOL() around C-visible
> > symbols\n" . $herecurr); +			}
> > +		}
> > +
> >  # check for redundant bracing round if etc
> >  		if ($line =~ /(^.*)\bif\b/ && $1 !~ /else\s*$/) {
> >  			my ($level, $endln, @chunks) =
> > --
>
> Ok, that seems like a sane check.  I think what we are really wanting
> to check for is assigments with plain identifiers on either side?  I've
> pushed a softened version of this check to my tree for testing.
>
>  
> http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-
>testing

perl isnt my thing so i'm going to assume what you added does as intended (i 
dont really get the regex statement you've added)

all i was using to test was to edit the file and remove VMLINUX_SYMBOL() from 
a place or two and then do:
diff -Nur /dev/null include/asm-generic/vmlinux.lds.h | 
./scripts/checkpatch.pl

thanks for adding this ... it'll save me consistent pain :)
-mike

