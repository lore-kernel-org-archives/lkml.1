Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbZF2VD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbZF2VD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 17:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZF2VDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 17:03:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46368 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbZF2VDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 17:03:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of I/O devices (rev. 6)
Date: Mon, 29 Jun 2009 23:04:01 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0906291504050.17436-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906291504050.17436-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906292304.02181.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 June 2009, Alan Stern wrote:
> On Mon, 29 Jun 2009, Rafael J. Wysocki wrote:
> 
> > IMO one can think of pm_request_resume() as a top half of pm_runtime_resume().
> 
> Normal top halves don't trigger before the circumstances are
> appropriate.  For example, if you enable remote wakeup on a USB device,
> it won't send a wakeup signal before it has been powered down.  A
> driver calling pm_request_resume while the device is still resumed is
> like a USB device sending a wakeup request while it is still powered
> up.  So IMO the analogy with top halves isn't a good one.
> 
> > Thus, it should either queue up a request to run pm_runtime_resume() or leave
> > the status as though pm_runtime_resume() ran.  Anything else would be
> > internally inconsistent.  So, if pm_runtime_resume() cancels pending suspend
> > requests, pm_request_resume() should do the same or the other way around.
> > 
> > Now, arguably, ignoring pending suspend requests is somewhat easier from
> > the core's point of view, but it may not be so for drivers.
> 
> The argument I gave in the previous email demonstrates that it doesn't
> make any difference to drivers.  Either way, they have to use two I/O
> pathways, they have to do a pm_runtime_get before pm_request_resume,
> and they have to do a pm_request_put after the I/O is done.
> 
> Of course, this is all somewhat theoretical.  I still don't know of any 
> actual drivers that do the equivalent of pm_request_resume.
> 
> > My point is that the core should always treat pending suspend requests in the
> > same way.  If they are canceled by pm_runtime_resume(), then
> > pm_request_resume() should also cancel them and it shouldn't be possible
> > to schedule a suspend request when the resume counter is greater than 0.
> > In turn, if they are ignored by pm_runtime_resume(), then pm_request_resume()
> > should also ignore them and there's no point to prevent pm_request_suspend()
> > from scheduling a suspend request if the resume counter is greater than 0.
> > 
> > Any other type of behavior has a potential to confuse driver writers.
> 
> Another possible approach you could take when the call to
> cancel_delayed_work fails (which should be rare) is to turn on RPM_WAKE
> in addition to RPM_IDLE and leave the suspend request queued.  When
> __pm_runtime_suspend sees both flags are set, it should abort and set
> the status directly back to RPM_ACTIVE.  At that time the idle
> notifications can start up again.
> 
> Is this any better?  I can't see how drivers would care, though.

There still is the problem that the suspend request is occupying the
work_struct which cannot be used for any other purpose.  I don't think this
is avoidable, though.  This way or another it is possible to have two requests
pending at a time.

Perhaps the simplest thing to do would be to simply ignore pending suspend
requests in both pm_request_resume() and pm_runtime_resume() and to allow
them to be scheduled at any time.  That shouldn't hurt anything as long as
pm_runtime_suspend() is smart enough, but it has to be anyway, because it
can be run synchronously at any time.

The only question is what pm_runtime_suspend() should do when it sees a pending
suspend request and quite frankly I think it can just ignore it as well,
leaving the RPM_IDLE bit set.  In which case the name RPM_IDLE will not really
be adequate, so perhaps it can be renamed to RPM_REQUEST or something like
this.

Then, we'll need a separate work structure for suspend requests, but I have no
problem with that.

> P.S.: What do you think should happen if there's a delayed suspend
> request pending, then pm_request_resume is called (and it leaves the
> request queued), and then someone calls pm_runtime_suspend?  You've got
> two pending requests and a synchronous call all active at the same
> time!

That's easy, pm_runtime_suspend() sees a pending resume, so it quits and the
other things work out as usual.

Best,
Rafael
