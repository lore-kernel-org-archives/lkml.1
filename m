Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbZF2Wuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbZF2Wuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 18:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbZF2Wum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 18:50:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46800 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbZF2Wul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 18:50:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of I/O devices (rev. 6)
Date: Tue, 30 Jun 2009 00:50:55 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0906291752570.18279-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906291752570.18279-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906300050.56304.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 June 2009, Alan Stern wrote:
> On Mon, 29 Jun 2009, Rafael J. Wysocki wrote:
> 
> > > Another possible approach you could take when the call to
> > > cancel_delayed_work fails (which should be rare) is to turn on RPM_WAKE
> > > in addition to RPM_IDLE and leave the suspend request queued.  When
> > > __pm_runtime_suspend sees both flags are set, it should abort and set
> > > the status directly back to RPM_ACTIVE.  At that time the idle
> > > notifications can start up again.
> > > 
> > > Is this any better?  I can't see how drivers would care, though.
> > 
> > There still is the problem that the suspend request is occupying the
> > work_struct which cannot be used for any other purpose.
> 
> What other purpose?  We don't send idle notifications in RPM_IDLE

OK

> and resume requests don't need to be stored since (as described above) they
> just set the RPM_WAKE flag.  Hence nothing else needs to use the
> work_struct.

Good.  I'd go for it, then.  OK?

> >  I don't think this
> > is avoidable, though.  This way or another it is possible to have two requests
> > pending at a time.
> > 
> > Perhaps the simplest thing to do would be to simply ignore pending suspend
> > requests in both pm_request_resume() and pm_runtime_resume() and to allow
> > them to be scheduled at any time.  That shouldn't hurt anything as long as
> > pm_runtime_suspend() is smart enough, but it has to be anyway, because it
> > can be run synchronously at any time.
> > 
> > The only question is what pm_runtime_suspend() should do when it sees a pending
> > suspend request and quite frankly I think it can just ignore it as well,
> > leaving the RPM_IDLE bit set.  In which case the name RPM_IDLE will not really
> > be adequate, so perhaps it can be renamed to RPM_REQUEST or something like
> > this.
> > 
> > Then, we'll need a separate work structure for suspend requests, but I have no
> > problem with that.
> 
> You seem to be thinking about these requests in a very different way
> from me.  They don't form a queue or anything like that.  Instead they
> mean "Change the device's power state to this value as soon as
> possible" -- and they are needed only because sometimes (in atomic or
> interrupt contexts) the change can't be made right away.
> 
> That's why it doesn't make any sense to have both a suspend and a 
> resume request pending at the same time.  It would mean the driver is 
> telling us "Change the device's power state to both low-power and 
> full-power as soon as possible"!
> 
> We should settle on a general policy for how to handle it when a 
> driver makes the mistake of telling us to do contradictory things.  
> There are three natural policies:
> 
> 	The first request takes precedence over the second;
> 
> 	The second request takes precedence over the first;
> 
> 	Resumes take precedence over suspends.
> 
> Any one of those would be acceptable.

IMO resumes should take precedence over suspends, because resume usually means
"there's I/O to process" and we usually we want the I/O to be processed as soon
as possible (deferred wake-up will usually mean deferred I/O and that would
hurt user experience).

Best,
Rafael
