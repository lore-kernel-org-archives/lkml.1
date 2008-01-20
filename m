Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbYATOdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbYATOdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 09:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbYATOcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 09:32:48 -0500
Received: from brick.kernel.dk ([87.55.233.238]:14221 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636AbYATOco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 09:32:44 -0500
Date: Sun, 20 Jan 2008 15:32:40 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrea Righi <righiandr@users.sourceforge.net>
Cc: Naveen Gupta <ngupta@google.com>, Paul Menage <menage@google.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroup: limit block I/O bandwidth
Message-ID: <20080120143239.GS6258@kernel.dk>
References: <2846be6b0801181439o55dcff09ted2b8f817e7ba682@mail.gmail.com> <4791DC2C.9090405@users.sourceforge.net> <4793507B.6040706@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4793507B.6040706@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20 2008, Andrea Righi wrote:
> Andrea Righi wrote:
> > Naveen Gupta wrote:
> >>> Paul Menage wrote:
> >>>> On Jan 18,  2008 7:36 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com>  wrote:
> >>>>> On Fri, Jan 18, 2008 at 12:41:03PM +0100, Andrea Righi  wrote:
> >>>>>> Allow to limit the  block I/O bandwidth for  specific process containers
> >>>>>> (cgroups) imposing additional delays  on I/O requests for those processes
> >>>>>> that exceed the  limits defined in the control group filesystem.
> >>>>>>
> >>>>>>  Example:
> >>>>>>   # mkdir /dev/cgroup
> >>>>>>   # mount -t cgroup -oio-throttle io-throttle /dev/cgroup
> >>>>> Just a minor nit, can't we name it as io,  keeping in mind that other
> >>>>> controllers are known as cpu and  memory?
> >>>> Or maybe "blockio"?
> >>> Agree, blockio seems better. Not all I/O is performed on  block devices
> >>> and in this case we're  considering block devices only.
> >> Here we want to rate limit in block layer, I would think I/O scheduler
> >> is the place where we are in much better position to do this kind of
> >> limiting.
> >>
> >> Also we are changing the behavior of application by adding sleeps to
> >> it during request submission. Moreover, we will prevent requests from
> >> being merged since we won't allow them to be submitted in this case.
> >>
> >> Since bulk of submission for writes is done in background kernel
> >> threads and we throttle based on limits on current, we will end up
> >> throttling these threads and not the actual processes submitting i/o.
> > 
> > Yep, that's true! This works for read operations only... at the very
> > least, if I've understood well, we could throttle I/O reads in the
> > submit_bio() path and write operations in __set_page_dirty(). But this
> > would change the applications behavior, so probably the best approcah
> > could be to just get I/O statistics from TASK_IO_ACCOUNTING stuff and
> > implement task delays at the I/O scheduler layer...
> 
> OK, to better figure the concept I tried to put the I/O throttling
> mechanism inside the simplest scheduler: noop. But this raises a new
> problem: under certain conditions (typically with write requests) a
> delay imposed on a I/O request of a process could impact on all the
> other I/O requests of other processes, causing the whole system to hang
> until the first request is completed, so it seem that we've to deal with
> a classic priority inversion problem.
> 
> Obviously the problem doesn't occur if the limited cgroup performs read
> operations only.
> 
> I'm posting the modified patch below only for discussion purposes, you
> could test it if you want, but you've been warned that the whole system
> could hang for certain amounts of time.

Your approach is totally flawed, imho. For instance, you don't want a
process to be able to dirty memory at foo mb/sec but only actually
write them out at bar mb/sec.

The noop-iosched changes are also very buggy. The queue back pointer
breaks reference counting and the task pointer storage assumes the task
will also always be around. That's of course not the case.

IOW, you are doing this at the wrong level.

What problem are you trying to solve?

-- 
Jens Axboe

