Return-Path: <linux-kernel-owner+w=401wt.eu-S1030470AbXCGIbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030470AbXCGIbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 03:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965190AbXCGIbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 03:31:40 -0500
Received: from www.osadl.org ([213.239.205.134]:56623 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965185AbXCGIbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 03:31:39 -0500
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Dan Hecht <dhecht@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <45EE1EA3.90803@vmware.com>
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>
	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>
	 <20070306084647.GA16280@elte.hu>  <45ED2C82.3080008@vmware.com>
	 <1173178774.24738.311.camel@localhost.localdomain>
	 <45EDD82F.90204@vmware.com>
	 <1173225182.24738.507.camel@localhost.localdomain>
	 <45EE0628.1080108@goop.org>  <45EE08E8.2020008@vmware.com>
	 <1173228544.24738.514.camel@localhost.localdomain>
	 <45EE0D10.7070807@vmware.com>
	 <1173230305.24738.529.camel@localhost.localdomain>
	 <45EE1EA3.90803@vmware.com>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 09:37:46 +0100
Message-Id: <1173256666.24738.576.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 18:08 -0800, Dan Hecht wrote:
> > IMO the paravirt interfaces should use nanoseconds anyway for both
> > readout and next event programming. That way the conversion is done in
> > the hypervisor once and the clocksources and clockevents are simple and
> > unified (except for the underlying hypervisor calls).
> > 
> 
> I disagree.  The clocksource/clockevents layer are always going to have 
> to convert nanoseconds to/from hardware units, so why not use it?  And, 
> some guests (say, a future version of linux that does trace-based 
> process accounting) may want higher resolution than nanoseconds for 
> certain uses. 

That's a pure academic exercise. When we are at the point where
nanoseconds are to coarse - sometimes after we both retired - the
internal resolution will be femtoseconds or whatever fits.

Again: paravirt should use a common infrastructure for this. Virtual
clocksource and virtual clockevent devices, which operate on ktime_t and
not on some artificial clock chip emulation frequency. The backend
implementation will be still per hypervisor, but we have _ONE_ device
emulation model, which is exposed to the kernel instead of five.

On a Linux based host, you probably end up with a hrtimer on the host
side to schedule the next event on the guest. So why do we need to
convert ktime_t to some virtual frequency in the guest so we can convert
it back into ktime_t on the host ?

Abstractions for the abstractions sake are braindead. There is no real
reason to implement 128 bit math into that path just to make the virtual
clockevent device look like real hardware.

The abstraction of clockevents helps you to get rid of hardwired
hardware assumptions, but you insist on creating them artificially for
reasons which are beyond my grasp.

> In any case, this is beside the point; I'd prefer to 
> stick to using the clockevents interface in the way it was intended 
> rather than reaching into ->next_event.

Sigh. The gain is, that you still have a good reason, why you can't move
to the clockevents interface.

Jeremy spent a couple of hours to get NO_HZ running for Xen yesterday
instead of writing up lengthy excuses, why it is soooo hard and takes
sooo much time and the current interface is sooo insufficient.

	tglx


