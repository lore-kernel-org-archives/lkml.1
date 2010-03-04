Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab0CDAUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 19:20:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44887 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153Ab0CDAUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 19:20:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while userspace is frozen?
Date: Thu, 4 Mar 2010 01:23:13 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-git-rjw; KDE/4.3.5; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.1003031720530.1380-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1003031720530.1380-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003040123.13617.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 March 2010, Alan Stern wrote:
> On Wed, 3 Mar 2010, Pavel Machek wrote:
> 
> > Hi!
> > 
> > > > > The reason for freezing those tasks is to avoid writebacks at random
> > > > > times during a system sleep transition, when the underlying device may
> > > > > already be suspended, right?
> > > > 
> > > > It is also there to avoid inconsistency between in-filesystem data and
> > > > snapshot in hibernation image.
> > > 
> > > A good point, although in this case I think it won't matter.  Writing
> > > out a dirty page twice (once right after taking the snapshot and then
> > > again after resuming from hibernation) will leave the disk in a correct
> > > state.
> > 
> > No, I don't think so. Have you considered all the various journalling
> > systems?
> > 
> > Definitely not in presence of I/O errors. Commit block can only be
> > written after previous blocks are successfully writen to the journal.
> > 
> > So lets see:
> > 
> > <snapshot>
> > 
> > Write previous block, write commit block, write more blocks
> > 
> > <hibernation powerdown, restart>
> > 
> > Error writing previous block (block now contains garbage), leading to
> > kernel panic
> > 
> > <restart>
> > 
> > journalling assumptions broken: commit block is there, but previous
> > blocks are not intact. Data loss.
> > 
> > ...and that was the first I could think about. Lets not do
> >  this. Barriers were invented for a reason.
> 
> Very well.  Then we still need a solution to the original problem:  
> Devices sometimes need to be unregistered during resume, but
> del_gendisk() blocks on the writeback thread, which is frozen until
> after the resume finishes.  How do you suggest this be fixed?

I thought about thawing the writeback thread earlier in such cases.

Would that makes sense / is it doable at all?

Rafael
