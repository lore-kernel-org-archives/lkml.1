Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbYHYEdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbYHYEdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 00:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750746AbYHYEdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 00:33:03 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:22448 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750734AbYHYEdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 00:33:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oFwjUzA1EemMNl+ifTZt1F0yXEk7pN969q0OckZ0LRugmI7IRWEYWD2QgwvousDJB5bqcj4HQKNDE3m1F8OxLLxHHH6ROWj7NWsKqh12Hepb4ifaBiSXd1eeuqRbE7vlSIJ2MuJDf1XyiFnUaKUJklH8tIdRwUV03fpURaYdUyM=  ;
X-YMail-OSG: C8jufeUVM1npe3C85u1zRUwxEDC1dtg7sspGSEXYoiiAE.eOgx00DaB5oekIRz7Ysfj4c8HfP5jKt4C7eCXCwCk3ZAhqqDgj25bQJYu6Tgi9J_GlxQGBRni1VKaQQ8RR1Tc-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous snapshotting file system)
Date: Mon, 25 Aug 2008 14:32:54 +1000
User-Agent: KMail/1.9.5
Cc: gus3 <musicman529@yahoo.com>, Szabolcs Szakacsits <szaka@ntfs-3g.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
References: <20080821051508.GB5706@disturbed> <200808221229.11069.nickpiggin@yahoo.com.au> <20080825015922.GP5706@disturbed>
In-Reply-To: <20080825015922.GP5706@disturbed>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808251432.54487.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 August 2008 11:59, Dave Chinner wrote:
> On Fri, Aug 22, 2008 at 12:29:10PM +1000, Nick Piggin wrote:

> > So if you were to tell
> > Jens that "these blocks" need more priority, or not to contribute to
> > a process's usage quota, etc. then I'm sure improvements could be
> > made.
>
> It's exactly this sort of complexity that is the problem. When the
> behaviour of such things change, filesystems that are optimised for
> the previous behaviour are not updated - we're not even aware that
> the elevator has been changed in some subtle manner that breaks
> the optimisations that have been done.
>
> To keep on top of this, we keep adding new variations and types and
> expect the filesystems to make best use of them (without
> documentation) to optimise for certain situations. Example - the
> new(ish) BIO_META tag that only CFQ understands. I can change the
> way XFS issues bios to use this tag to make CFQ behave the same way
> it used to w.r.t. metadata I/O from XFS, but then the deadline and
> AS will probably regress because they don't understand that tag and
> still need the old optimisations that just got removed. Ditto for
> prioritised bio dispatch - CFQ supports it but none of the others
> do.

I don't know why AS or DL would regress though. What old optimizations
would you be referring to?


> IOWs, I am left with a choice - optimise for a specific elevator
> (CFQ) to the detriment of all others (noop, as, deadline), or make
> the filesystem work best with the simple elevator (noop) and
> consider the smarter schedulers deficient if they are slower than
> the noop elevator....

I don't think this is necessarily such a bad thing to do. It would
be very helpful of course if you could report the workloads where one
is slower than noop so that we can work out what is going wrong and
how we can improve performance with the others.


> > Or am I completely misunderstanding you? :)
>
> You're suggesting that I add complexity to solve the too much complexity
> problem.... ;)

Actually, if it's too much complexity that's the problem for you, then I
do think testing with noop or deadline is a valid thing to do.


> > Is this rhetorical? Because I don't see how *they* could be showing
> > regular performance regressions.
>
> I get private email fairly often asking questions as to why XFS is
> slower going from, say, 2.6.23 to 2.6.24 and then speeds back up in
> 2.6.25. I seen a number of cases where the answer to this was that
> elevator 'x' with XFS in 2.6.x because for some reason it is much,
> much slower than the others on that workload on that hardware.
>
> As seen earlier in this thread, this can be caused by a problem with
> the hardware, firmware, configuration, driver bugs, etc - there are
> so many combinations of variables that can cause performance issues
> that often the only 'macro' level change that you can make to avoid
> them is to switch schedulers. IOWs, while a specific scheduler has
> not changed, the code around it has changed sufficiently for a
> specific elevator to show a regression compared to the otherr
> elevators.....

Fair enough, and you're saying noop isn't so fragile to these other
things changing. I would expect deadline to be pretty good too, in
that regard.


> Basically, the complexity of the interactions between the
> filesystems, elevators and the storage devices is such that there
> are transient second order effects occurring that are not reported
> widely because they are easily worked around by switching elevators.

Well then I don't have a good answer, sorry :P
