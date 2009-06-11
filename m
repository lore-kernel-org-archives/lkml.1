Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbZFKORD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbZFKORD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZFKOQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:16:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43695 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751708AbZFKOQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:16:52 -0400
Date: Thu, 11 Jun 2009 10:16:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re:
 [RFC][PATCH 0/2] PM: Rearrange core suspend code)
In-Reply-To: <200906111557.49490.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0906111010360.2939-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009, Oliver Neukum wrote:

> Am Donnerstag, 11. Juni 2009 15:48:33 schrieb Rafael J. Wysocki:
> > > > But after pm_request_resume() returns there's no means to make sure
> > > > nothing alters it back to RPM_SUSPENDED. The workqueue doesn't help
> > > > you because you've scheduled nothing by that time. The suspension will
> > > > work because C is still in RPM_SUSPENDED.
> > >
> > > This is an example where usage counters come in handy.
> >
> > Do you mean we can count suspend/resume requests for a device?
> 
> No, we count reasons a device cannot be suspended. Drivers are allowed to
> add their own reasons. The core uses that mechanism to indicate that an
> ongoing resumption lower down is also a reason.
> The count going to zero is equivalent to a request to suspend.

Right.

Here's a related thought.  Change the resume routines as follows:

void pm_runtime_resume(struct device *dev)
{
// Do the actual resume ...
}
EXPORT_SYMBOL_GPL(pm_runtime_resume);

static void pm_runtime_resume_work(struct work_struct *work)
{
	pm_runtime_resume(resume_work_to_device(work));
}

Then there's no need for a separate pm_resume_sync(); drivers can
simply call pm_runtime_resume() directly.  The same trick works for 
suspending.

Of course, this means you have to give up the notion that all suspends 
and resumes are funnelled through the workqueue.  IMO that notion isn't 
worth keeping in any case.

Alan Stern

