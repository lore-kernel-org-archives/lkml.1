Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbZBAEtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbZBAEtJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 23:49:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZBAEs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 23:48:56 -0500
Received: from kroah.org ([198.145.64.141]:50986 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751517AbZBAEs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 23:48:56 -0500
Date: Sat, 31 Jan 2009 20:46:14 -0800
From: Greg KH <greg@kroah.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch.pl is getting too slow
Message-ID: <20090201044614.GA8589@kroah.com>
References: <20090131185507.GA3280@kroah.com> <20090131210220.GA25811@shadowen.org> <1233449877.5903.48.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233449877.5903.48.camel@desktop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 31, 2009 at 04:57:57PM -0800, Daniel Walker wrote:
> On Sat, 2009-01-31 at 21:02 +0000, Andy Whitcroft wrote:
> > On Sat, Jan 31, 2009 at 10:55:07AM -0800, Greg KH wrote:
> > > Hi Andy,
> > > 
> > > I've noticed that checkpatch.pl is getting slower and slower when run on
> > > a whole file, but yesterday I realized that it now is pretty much
> > > unusable:
> > > 
> > > $ time ./scripts/checkpatch.pl --file drivers/staging/uc2322/aten2011.c
> > > 
> > > <snip>
> > > total: 168 errors, 126 warnings, 3939 lines checked
> > > 
> > > drivers/staging/uc2322/aten2011.c has style problems, please review.  If any of these errors
> > > are false positives report them to the maintainer, see
> > > CHECKPATCH in MAINTAINERS.
> > > 
> > > real	8m7.924s
> > > user	8m7.058s
> > > sys	0m0.116s
> > 
> > That is scarey indeed.  Something is very wrong in there if it went back
> > to a more reasonable 10's of seconds with a few patches.  I will have a
> > look at the file you attached and see what I can find.
> > 
> > Thanks for the heads up.
> 
> After some debugging it looks like it takes a long time to processes
> lines similar to,
> 
> /*************************************
>  * Bit definitions for each register *
>  *************************************/
> #define LCR_BITS_5              0x00    /* 5 bits/char */
> #define LCR_BITS_6              0x01    /* 6 bits/char */
> #define LCR_BITS_7              0x02    /* 7 bits/char */
> #define LCR_BITS_8              0x03    /* 8 bits/char */
> #define LCR_BITS_MASK           0x03    /* Mask for bits/char field */
> 
> 
> There's a section in the code which has several of these. The processing
> slows down when this expression matches repeatedly,

Ah, that makes some sense, as I did remove a lot of these that were not
being used in other patches to the file.

> # Check for potential 'bare' types
>                 my ($stat, $cond, $line_nr_next, $remain_next, $off_next);
>                 if ($realcnt && $line =~ /.\s*\S/) {
>                         ($stat, $cond, $line_nr_next, $remain_next, $off_next) =
>                                 ctx_statement_block($linenr, $realcnt, 0);
> 
> and ctx_statement_block will process $realcnt lines trying to find a
> complete block, and it has no concept of "define" so it just keep
> processing until it's concept of a block ending.. That happens on each
> "define" line in the file, which I think accounts for all the overhead.
> 
> I added the following temporary work around, which speeds things up
> considerably. Just forcing it to only process one line at most.

But defines do cross a line, and we should be able to check them
properly, isn't that what the original version of this was doing?

thanks,

greg k-h
