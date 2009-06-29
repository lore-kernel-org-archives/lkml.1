Return-Path: <linux-kernel-owner+w=401wt.eu-S1760360AbZF2QK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360AbZF2QK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757243AbZF2QKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:10:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38527 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754772AbZF2QKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:10:47 -0400
Date: Mon, 29 Jun 2009 12:10:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of
 I/O devices (rev. 6)
In-Reply-To: <200906291755.38232.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906291203070.17436-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009, Rafael J. Wysocki wrote:

> > It doesn't need to know.  All it needs to do is guarantee that the
> > device will be in a resumed state some time not long after the function
> > returns.  Thus calling rpm_request_resume while the status is RPM_IDLE
> > is like calling it while the status is RPM_ACTIVE.  In neither case
> > does it have to do anything, because the device will already be resumed
> > when it returns.
> 
> Not exactly, because RPM_IDLE prevents idle notifications from being run,
> as it means a suspend has already been requested, which is not really the
> case after pm_request_resume().

Yes it is.  A delayed suspend and an immediate resume have _both_ been
requested.  We are within our rights to say that the resume request 
gets fulfilled immediately (by doing nothing) and the suspend request 
will be fulfilled later.

> > > No, it doesn't matter if the request runs, but it does matter if the work
> > > structure used for queuing it up may be used for another purpose. :-)
> > 
> > What else would it be used for?  If rpm_request_resume returns without 
> > doing anything and leaves the status set to RPM_IDLE, then the work 
> > structure won't be reused until the status changes.
> 
> Which is not right, because we may want to run ->runtime_idle() before
> the status is changed.

If the status is RPM_IDLE then there's already a suspend request
queued.  So what reason is there for sending idle notifications?  The 
whole point of idle notifications is to let the driver know that it 
might want to initiate a suspend -- but one has already been initiated.

> That's why I think pm_request_resume() should queue up a resume request if
> a suspend request is pending.

Surely you don't mean we should suspend the device and then resume it
immediately afterward?  What would be the point?  Just leave the device 
active throughout.

As long as the behavior is documented, I think it will be okay for
pm_request_resume not to cancel a pending suspend request.

Alan Stern

