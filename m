Return-Path: <linux-kernel-owner+w=401wt.eu-S1760177AbZF2T0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177AbZF2T0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 15:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759456AbZF2TZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 15:25:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33582 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759555AbZF2TZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 15:25:55 -0400
Date: Mon, 29 Jun 2009 15:25:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of
 I/O devices (rev. 6)
In-Reply-To: <200906292025.15142.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906291504050.17436-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009, Rafael J. Wysocki wrote:

> IMO one can think of pm_request_resume() as a top half of pm_runtime_resume().

Normal top halves don't trigger before the circumstances are
appropriate.  For example, if you enable remote wakeup on a USB device,
it won't send a wakeup signal before it has been powered down.  A
driver calling pm_request_resume while the device is still resumed is
like a USB device sending a wakeup request while it is still powered
up.  So IMO the analogy with top halves isn't a good one.

> Thus, it should either queue up a request to run pm_runtime_resume() or leave
> the status as though pm_runtime_resume() ran.  Anything else would be
> internally inconsistent.  So, if pm_runtime_resume() cancels pending suspend
> requests, pm_request_resume() should do the same or the other way around.
> 
> Now, arguably, ignoring pending suspend requests is somewhat easier from
> the core's point of view, but it may not be so for drivers.

The argument I gave in the previous email demonstrates that it doesn't
make any difference to drivers.  Either way, they have to use two I/O
pathways, they have to do a pm_runtime_get before pm_request_resume,
and they have to do a pm_request_put after the I/O is done.

Of course, this is all somewhat theoretical.  I still don't know of any 
actual drivers that do the equivalent of pm_request_resume.

> My point is that the core should always treat pending suspend requests in the
> same way.  If they are canceled by pm_runtime_resume(), then
> pm_request_resume() should also cancel them and it shouldn't be possible
> to schedule a suspend request when the resume counter is greater than 0.
> In turn, if they are ignored by pm_runtime_resume(), then pm_request_resume()
> should also ignore them and there's no point to prevent pm_request_suspend()
> from scheduling a suspend request if the resume counter is greater than 0.
> 
> Any other type of behavior has a potential to confuse driver writers.

Another possible approach you could take when the call to
cancel_delayed_work fails (which should be rare) is to turn on RPM_WAKE
in addition to RPM_IDLE and leave the suspend request queued.  When
__pm_runtime_suspend sees both flags are set, it should abort and set
the status directly back to RPM_ACTIVE.  At that time the idle
notifications can start up again.

Is this any better?  I can't see how drivers would care, though.

Alan Stern

P.S.: What do you think should happen if there's a delayed suspend
request pending, then pm_request_resume is called (and it leaves the
request queued), and then someone calls pm_runtime_suspend?  You've got
two pending requests and a synchronous call all active at the same
time!

