Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab0CCWYC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 17:24:02 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56001 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752963Ab0CCWX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 17:23:57 -0500
Date: Wed, 3 Mar 2010 17:23:56 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
 userspace is frozen?
In-Reply-To: <20100303215056.GB2579@ucw.cz>
Message-ID: <Pine.LNX.4.44L0.1003031720530.1380-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010, Pavel Machek wrote:

> Hi!
> 
> > > > The reason for freezing those tasks is to avoid writebacks at random
> > > > times during a system sleep transition, when the underlying device may
> > > > already be suspended, right?
> > > 
> > > It is also there to avoid inconsistency between in-filesystem data and
> > > snapshot in hibernation image.
> > 
> > A good point, although in this case I think it won't matter.  Writing
> > out a dirty page twice (once right after taking the snapshot and then
> > again after resuming from hibernation) will leave the disk in a correct
> > state.
> 
> No, I don't think so. Have you considered all the various journalling
> systems?
> 
> Definitely not in presence of I/O errors. Commit block can only be
> written after previous blocks are successfully writen to the journal.
> 
> So lets see:
> 
> <snapshot>
> 
> Write previous block, write commit block, write more blocks
> 
> <hibernation powerdown, restart>
> 
> Error writing previous block (block now contains garbage), leading to
> kernel panic
> 
> <restart>
> 
> journalling assumptions broken: commit block is there, but previous
> blocks are not intact. Data loss.
> 
> ...and that was the first I could think about. Lets not do
>  this. Barriers were invented for a reason.

Very well.  Then we still need a solution to the original problem:  
Devices sometimes need to be unregistered during resume, but
del_gendisk() blocks on the writeback thread, which is frozen until
after the resume finishes.  How do you suggest this be fixed?

Alan Stern

