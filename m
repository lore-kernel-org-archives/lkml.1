Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbZETHxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbZETHxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZETHx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:53:28 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:62084 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbZETHx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:53:27 -0400
Date: Wed, 20 May 2009 08:53:27 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Wolfgang =?iso-8859-1?Q?M=FCes?= <wolfgang.mues@auerswald.de>,
       David Brownell <david-b@pacbell.net>
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc_spi: use EILSEQ for possible transmission errors
Message-ID: <20090520075327.GA11473@console-pimps.org>
References: <200905141324.27908.wolfgang.mues@auerswald.de> <20090519112948.GB28564@console-pimps.org> <200905192149.07778.david-b@pacbell.net> <20090519112948.GB28564@console-pimps.org> <200905191347.46026.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200905192149.07778.david-b@pacbell.net> <200905191347.46026.wolfgang.mues@auerswald.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 09:49:07PM -0700, David Brownell wrote:
> On Tuesday 19 May 2009, Matt Fleming wrote:
> > Hmm, always returning -EILSEQ is devious. What happens if we sent an
> > illegal command? The value of "value" is passed up to the callers via
> > cmd->error and so may eventually get printed in the pr_debug() call in
> > mmc_request_done(), line 86.
> 
> True, but a pr_debug from mmc_spi could help that.  A patch doing
> that would need to be less aggressive about ripping out the current
> fault-parsing logic, but it could continue reporting -EILSEQ to
> cope with the possible response mangling.
> 

Yes, a less aggressive patch would be fine.

> > Whereas before the error would display EINVAL for an illegal command
> > now it'll display EILSEQ, which makes no sense. Seeing EILSEQ in my
> > log when really the error is EINVAL is gonna really confuse me.
> > 
> > IMHO always assuming that command errors are caused by transmission
> > problems is not the right solution.
> 
> Do you have a better solution to propose though?  If Wolfgang
> is actually observing transmission errors there, I'm not sure
> a better one is to be had.
> 

You're right. It's not cool for me to criticise and not give any
suggestions. I've been trying to come up with some middle-ground
solution since yesterday.

I think if the patch was less aggressive at returning EILSEQ, it'd be
fine. For instance, returning EILSEQ if the response you get doesn't
make any sense given the command you sent or if the response is just
garbage.

It might even make sense to retry commands (say twice, and only if
it's safe to do so) and if the response codes differ in bizarre ways
then the status bits have probably been garbled on the bus and EILSEQ
is the correct error code to use. I'm less sure about this bit though,
it depends on exactly what we're trying to fix.

Wolfgang, is there a particular scenario where you're seeing the
status bits trashed by noise on the line? Or is this just a cautionary
patch?

On Tue, May 19, 2009 at 01:47:45PM +0200, Wolfgang Mües wrote:
> 
> > IMHO always assuming that command errors are caused by transmission
> > problems is not the right solution.
> 
> It's not your or my fault, it's the fault of the spi SD/MMC card protocol 
> designer. You may send him to me, already prepared: naked and in chains ;-)

This is the funniest reply I've ever read.
