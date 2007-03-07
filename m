Return-Path: <linux-kernel-owner+w=401wt.eu-S932704AbXCGBMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704AbXCGBMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 20:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932645AbXCGBMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 20:12:20 -0500
Received: from www.osadl.org ([213.239.205.134]:47809 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932704AbXCGBMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 20:12:19 -0500
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Dan Hecht <dhecht@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <45EE0D10.7070807@vmware.com>
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>
	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>
	 <20070306084647.GA16280@elte.hu>  <45ED2C82.3080008@vmware.com>
	 <1173178774.24738.311.camel@localhost.localdomain>
	 <45EDD82F.90204@vmware.com>
	 <1173225182.24738.507.camel@localhost.localdomain>
	 <45EE0628.1080108@goop.org>  <45EE08E8.2020008@vmware.com>
	 <1173228544.24738.514.camel@localhost.localdomain>
	 <45EE0D10.7070807@vmware.com>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 02:18:24 +0100
Message-Id: <1173230305.24738.529.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 16:53 -0800, Dan Hecht wrote:
> > Ooops. I completely forgot, that you get the absolute expiry time
> > already in ktime_t format (nanoseconds) when dev->set_next_event() is
> > called.
> > 
> > 	dev->next_event = expires;
> > 
> > is done right before the call. 
> > 
> > So it's already there for free.
> > 
> >
> 
> Okay.  I noticed that but didn't think it was okay to use since it 
> didn't seem like it was set up for the clock_event_device code's use, so 
> seemed like a conceptual interface violation to go digging around in 
> there.

Yes it is. 

I just wanted to point out that you can use it until I'm awake enough to
implement it proper.

> Also, wasn't one of the points of clockevents to prevent the device code 
> from doing conversions between nanoseconds and clicks themselves?  Don't 
> we really want the clockevents generic layer to do this conversion 
> between monotonic nanonseconds to absolute device clicks and then give 
> the device code that value, so the device layer doesn't perform any 
> conversions?

Right. But this applies only to deltas, as the conversion of absolute
time values gets ugly, i.e. 128bit math

IMO the paravirt interfaces should use nanoseconds anyway for both
readout and next event programming. That way the conversion is done in
the hypervisor once and the clocksources and clockevents are simple and
unified (except for the underlying hypervisor calls).

> On an unrelated note, can you explain what the difference between 
> CLOCK_EVT_MODE_UNUSED and CLOCK_EVT_MODE_SHUTDOWN modes are and what the 
> legal state transitions are? (or point me to a document describing 
> this).  At least on i386, all clock event devices treat them the same; 
> do we really need both?

UNUSED:
The device is registered, but not used by any clockevents client

SHUTDOWN:
The device is registered, claimed by a clockevents client, but
momentarily not active.

The clock events device can treat UNUSED and SHUTDOWN basically in the
same way.

	tglx


