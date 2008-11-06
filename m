Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbYKFPhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbYKFPhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbYKFPgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:36:54 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47238 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754862AbYKFPgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:36:52 -0500
Date: Thu, 6 Nov 2008 10:36:50 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Brian Kysela <bkysela@gmail.com>, <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, <linux-usb@vger.kernel.org>
Subject: Re: [BUG] usb-storage: Error in queuecommand: us->srb = ffff88006a338480
In-Reply-To: <20081105174905.27194494.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0811061030370.2568-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2008, Andrew Morton wrote:

> On Thu, 30 Oct 2008 17:35:57 -0400
> Brian Kysela <bkysela@gmail.com> wrote:
> 
> > On kernels ranging from 2.6.26 - 2.6.28-rc2
> 
> So 2.6.25 was OK?
> 
> > on an Intel P4 3.2GHz HT x86-64
> > cpu, I am seeing a bug that occurs about half the time when copying ~300MB
> > data from a usb flash drive (FAT) to hard drive (XFS). There are three
> > possible outcomes, so far, when I hit the bug:
> > 
> >     (1) The copy process hangs, cpu wait hits 100% and load avg climbs until
> >         reboot;
> >     (2) The copy process hangs and then recovers and then one of:
> >         (a) the cpu wait & load avg both decline to normal; or
> >         (b) cpu wait hovers at 100% and the load avg slowly climbs until reboot;
> >     (3) Kernel bug reported and machine locks up.
> > 
> > Result (1) is the most frequent. Result (3) happened only twice out of about 40
> > tests. I lose the full traces, but here are two relevant lines that I see on
> > screen before the machine locks up:
> > 
> > kernel BUG at /home/brian/linux-2.6/block/elevator.c:841!
> > invalid opcode: 0000 [#1] PREMPT SMP
> 
> It is unclear what kernel version produced that message, and that is
> important information.  In 2.6.28-rc2, block/elevator.c:841 is
> 
>     void elv_dequeue_request(struct request_queue *q, struct request *rq)
>     {
> -->>	BUG_ON(list_empty(&rq->queuelist));
> 	BUG_ON(ELV_ON_HASH(rq));
> 
> please confirm that I have the correct line there.
> 
> 
> I assume that you're hitting a bug in the USB storage code and this is
> triggering consistency-checking code in the block layer.
> 
> > When (1) or (2b) occurs I pull the usb drive to see what happens. In two cases
> > (3) occurred, but more often I get this in /var/log/syslog:
> 
> The other things you saw were most likely a consequence of the
> BUG_ON().

In theory, this sort of thing could have been caused by changes to the 
block-layer timeout handling in 2.6.28-rc.  But those changes are not 
present in 2.6.26 or 2.6.27.

Note that the syslog shows a lockdep violation occurring _before_ the 
error message from usb-storage.  This suggests the problem originates 
somewhere else.

The error message:

> [  152.701070] usb-storage: Error in queuecommand: us->srb = ffff88007dfd0680

means that the SCSI layer has told usb-storage to start a new command 
before the old one completed.  This could happen, for example, if the 
SCSI layer had gotten confused and tried to cancel a command that 
wasn't running -- then it would think usb-storage was idle when in fact 
it was still busy.  (This was the failure mechanism resulting from the 
timeout changes.)

Alan Stern

