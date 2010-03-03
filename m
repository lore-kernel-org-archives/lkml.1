Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab0CCVvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:51:13 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:36605 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756729Ab0CCVvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:51:09 -0500
Date: Wed, 3 Mar 2010 22:50:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
	userspace is frozen?
Message-ID: <20100303215056.GB2579@ucw.cz>
References: <20100301063508.GA1455@ucw.cz> <Pine.LNX.4.44L0.1003011021440.1645-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1003011021440.1645-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > The reason for freezing those tasks is to avoid writebacks at random
> > > times during a system sleep transition, when the underlying device may
> > > already be suspended, right?
> > 
> > It is also there to avoid inconsistency between in-filesystem data and
> > snapshot in hibernation image.
> 
> A good point, although in this case I think it won't matter.  Writing
> out a dirty page twice (once right after taking the snapshot and then
> again after resuming from hibernation) will leave the disk in a correct
> state.

No, I don't think so. Have you considered all the various journalling
systems?

Definitely not in presence of I/O errors. Commit block can only be
written after previous blocks are successfully writen to the journal.

So lets see:

<snapshot>

Write previous block, write commit block, write more blocks

<hibernation powerdown, restart>

Error writing previous block (block now contains garbage), leading to
kernel panic

<restart>

journalling assumptions broken: commit block is there, but previous
blocks are not intact. Data loss.

...and that was the first I could think about. Lets not do
 this. Barriers were invented for a reason.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
