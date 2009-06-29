Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109AbZF2QjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbZF2QjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZF2QjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:39:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45153 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbZF2QjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:39:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of I/O devices (rev. 6)
Date: Mon, 29 Jun 2009 18:39:15 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0906291203070.17436-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906291203070.17436-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906291839.16631.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 June 2009, Alan Stern wrote:
> On Mon, 29 Jun 2009, Rafael J. Wysocki wrote:
> 
> > > It doesn't need to know.  All it needs to do is guarantee that the
> > > device will be in a resumed state some time not long after the function
> > > returns.  Thus calling rpm_request_resume while the status is RPM_IDLE
> > > is like calling it while the status is RPM_ACTIVE.  In neither case
> > > does it have to do anything, because the device will already be resumed
> > > when it returns.
> > 
> > Not exactly, because RPM_IDLE prevents idle notifications from being run,
> > as it means a suspend has already been requested, which is not really the
> > case after pm_request_resume().
> 
> Yes it is.  A delayed suspend and an immediate resume have _both_ been
> requested.  We are within our rights to say that the resume request 
> gets fulfilled immediately (by doing nothing) and the suspend request 
> will be fulfilled later.

Theoretically, we are, but practically we want to be able to use
pm_runtime_put() (the asynchronous version) after a pm_runtime_resume()
that found the device operational, but that would result in queuing a request
using the same work structure that is used by the pending suspend request.
Don't you see a problem here?

> > > > No, it doesn't matter if the request runs, but it does matter if the work
> > > > structure used for queuing it up may be used for another purpose. :-)
> > > 
> > > What else would it be used for?  If rpm_request_resume returns without 
> > > doing anything and leaves the status set to RPM_IDLE, then the work 
> > > structure won't be reused until the status changes.
> > 
> > Which is not right, because we may want to run ->runtime_idle() before
> > the status is changed.
> 
> If the status is RPM_IDLE then there's already a suspend request
> queued.  So what reason is there for sending idle notifications?  The 
> whole point of idle notifications is to let the driver know that it 
> might want to initiate a suspend -- but one has already been initiated.
> 
> > That's why I think pm_request_resume() should queue up a resume request if
> > a suspend request is pending.
> 
> Surely you don't mean we should suspend the device and then resume it
> immediately afterward?

No, I don't.

> What would be the point?  Just leave the device active throughout.

Absolutely.

> As long as the behavior is documented, I think it will be okay for
> pm_request_resume not to cancel a pending suspend request.

I could agree with that, but what about pm_runtime_resume() happening after
a suspend request has been scheduled?  Should it also ignore the pending
suspend request?

In which case it would be consistent to allow to schedule suspends even though
the resume counter is greater than 0.

Best,
Rafael
