Return-Path: <linux-kernel-owner+w=401wt.eu-S1031122AbXDJQsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031122AbXDJQsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 12:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031123AbXDJQsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 12:48:41 -0400
Received: from waste.org ([66.93.16.53]:50696 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031122AbXDJQsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 12:48:39 -0400
Date: Tue, 10 Apr 2007 11:35:11 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Robin Holt <holt@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070410163511.GB10459@waste.org>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com> <4616CBF0.7090606@garzik.org> <20070409172339.48d661d6.akpm@linux-foundation.org> <20070410015912.GE1994@redhat.com> <20070409193056.6b52c354.akpm@linux-foundation.org> <461B3754.9040107@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461B3754.9040107@garzik.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 03:05:56AM -0400, Jeff Garzik wrote:
> Andrew Morton wrote:
> >: root         3  0.0  0.0      0     0 ?        S    18:51   0:00 
> >[watchdog/0]
> >
> >That's the softlockup detector.  Confusingly named to look like a, err,
> >watchdog.  Could probably use keventd.
> 
> I would think this would run into the keventd "problem", where $N 
> processes can lock out another?
> 
> IMO a lot of these could potentially be simply started as brand new 
> threads, when an exception arises.
> 
> 
> >: root         5  0.0  0.0      0     0 ?        S    18:51   0:00 
> >[khelper]
> >
> >That's there to parent the kthread_create()d threads.  Could presumably use
> >khelper.
> >
> >: root       152  0.0  0.0      0     0 ?        S    18:51   0:00 [ata/0]
> >
> >Does it need to be per-cpu?
> 
> No, it does not.
> 
> It is used for PIO data transfer, so it merely has to respond quickly, 
> which rules out keventd.  You also don't want PIO data xfer for port A 
> blocked, sitting around waiting for PIO data xfer to complete on port C.
> 
> So, we merely need fast-reacting threads that keventd will not block. 
> We do not need per-CPU threads.
> 
> Again, I think a model where threads are created on demand, and reaped 
> after inactivity, would fit here.  As I feel it would fit with many 
> other non-libata drivers.
> 
> 
> >: root       153  0.0  0.0      0     0 ?        S    18:51   0:00 
> >[ata_aux]
> >
> >That's a single-threaded workqueue handler.  Perhaps could use keventd.
> 
> That is used by libata exception handler, for hotpug and such.  My main 
> worry with keventd is that we might get stuck behind an unrelated 
> process for an undefined length of time.
> 
> IMO the best model would be to create ata_aux thread on demand, and kill 
> it if it hasn't been used recently.
> 
> 
> 
> >: root       299  0.0  0.0      0     0 ?        S    18:51   0:00 
> >[scsi_eh_0]
> >: root       300  0.0  0.0      0     0 ?        S    18:51   0:00 
> >[scsi_eh_1]
> >: root       305  0.0  0.0      0     0 ?        S    18:51   0:00 
> >[scsi_eh_2]
> >: root       306  0.0  0.0      0     0 ?        S    18:51   0:00 
> >[scsi_eh_3]
> >
> >This machine has one CPU, one sata disk and one DVD drive.  The above is
> >hard to explain.
> 
> Nod.  I've never thought we needed this many threads.  At least it 
> doesn't scale out of control for $BigNum-CPU boxen.
> 
> As the name implies, this is SCSI exception handling thread.  Although 
> some synchronization is required, this could probably work with an 
> on-demand thread creation model too.
> 
> 
> >: root       319  0.0  0.0      0     0 ?        S    18:51   0:00 
> >[pccardd]
> >
> >hm.
> >
> >: root       331  0.0  0.0      0     0 ?        S    18:51   0:00 
> >[kpsmoused]
> >
> >hm.
> 
> This kernel thread is used as a "bottom half" handler for the PS2 mouse 
> interrupt.  This one is a bit more justifiable.
> 
> 
> >: root       337  0.0  0.0      0     0 ?        S    18:51   0:00 [kedac]
> >
> >hm.  I didn't know that the Vaio had EDAC.
> >
> >: root      1173  0.0  0.0      0     0 ?        S    18:51   0:00 
> >[khpsbpkt]
> >
> >I can't even pronounce that.
> >
> >: root      1354  0.0  0.0      0     0 ?        S    18:51   0:00 
> >[knodemgrd_0]
> >
> >OK, I do have 1394 hardware, but it hasn't been used.
> >
> >: root      1636  0.0  0.0      0     0 ?        S    18:52   0:00 
> >[kondemand/0]
> >
> >I blame davej.
> >
> >> > otoh, a lot of these inefficeincies are probably down in scruffy 
> >> drivers
> >> > rather than in core or top-level code.
> >>
> >>You say scruffy, but most of the proliferation of kthreads comes
> >>from code written in the last few years.  Compare the explosion of 
> >>kthreads
> >>we see coming from 2.4 to 2.6. It's disturbing, and I don't see it
> >>slowing down at all.
> >>
> >>On the 2-way box I grabbed the above ps output from, I end up with 69 
> >>kthreads.
> >>It doesn't surprise me at all that bigger iron is starting to see issues.
> >>
> >
> >Sure.
> >
> >I don't think it's completely silly to object to all this.  Sure, a kernel
> >thread is worth 4k in the best case, but I bet they have associated unused
> >resources and as we've seen, they can cause overhead.
> 
> Agreed.

There are some upsides to persistent kernel threads that we might want
to keep in mind:

- they can be reniced, made RT, etc. as needed
- they can be bound to CPUs
- they collect long-term CPU usage information

Most of the above doesn't matter for the average kernel thread that's
handling the occassional hardware reset, but for others it could.

-- 
Mathematics is the supreme nostalgia of our time.
