Return-Path: <linux-kernel-owner+w=401wt.eu-S1760207AbYABXdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207AbYABXdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 18:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYABXdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 18:33:13 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54484 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028AbYABXdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 18:33:12 -0500
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org>
References: <20080102162534.GA4041@elte.hu>
	 <1199292381.3258.32.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org>
	 <20080102194030.GC11638@parisc-linux.org>
	 <1199304735.3258.53.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 02 Jan 2008 17:33:05 -0600
Message-Id: <1199316785.3258.85.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-02 at 12:45 -0800, Linus Torvalds wrote:
> 
> On Wed, 2 Jan 2008, James Bottomley wrote:
> > 
> > OK ... I'll revert it.  However, I still think it's the wrong course of
> > action, because as far as my analysis goes, this code is functionally
> > equivalent to what went before with the exception that we now rely on
> > the request->cmd_type information in the post processing (previously we
> > just relied on the cmnd->done pointer).
> 
> To say that another way:
> 
>  "the code is functionally equivalent, EXCEPT IT ISN'T, and it's 
>   known to be broken".
> 
> wouldn't you say my version is more honest and correct?

No.  Just because a bug appears when a particular piece of code is in
and disappears when it is reverted doesn't automatically equate to the
code in question being buggy.  We seem to get a lot of these second
order effect type things; sometimes its just a problem caused by a
particular routine compiling to a longer byte sequence and pushing
something else out.

Do give us credit for thinking "functional equivalency problem" when
this bug report first came in ... I've had myself and several other
people over the code.  If there's an inequivalency somewhere I'm damned
if I can spot it.  The most promising other failure mode we tried was
request type changes over the lifetime of the command, but we can't make
that one fly either.

Look at the taxonomy of the bug.  This is the form of the error:

buffer I/O error on device sr0, logical block 20304
attempt to access beyond end of device
sr0: rw=0, want=81224, limit=40944

The last limit is the most suggestive, that comes straight from
bdev->bd_inode->i_size>>9 and is supposed to be the size of the block
device in 512 byte blocks. For a 4.7GB DVD, it's a little small.
Nothing in the sr code sets this directly (although it does come from
get_blkdev() for the first opener).  pktcdvd does set it, though ... and
probably wrongly if the drive in question isn't UDF formatted.

I have also tried on many occasions to reproduce this without success
(there's a simple recipe in the bug report, but it just doesn't work for
me).  My setup is with an aic94xxx->expander->SATAPI DVD, whereas the
original reporter is ata_piix -> PATA DVD, so it could be stack
differences---but again, if it is, the bug itself can't be a simple one
in the generic code.  The fact that there are no other reporters of
problems like this also indicate to me that it isn't a widespread
problem (again, pointing to something more specific in the setup of the
reporter).

The unreproduceability coupled with the lack of other error reports
leads me to be about 90% confident the problem isn't in the code you
want reverted.  However, I grant that we cannot seem to find the root
cause, and reverting the code will cause our bug metrics to go down by
one (at least until something else causes it to reappear), so it is the
corporate thing to do, I suppose.  I'll send in a reversion with the
sr_mod removal bug fix.

James


