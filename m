Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab0CAVW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 16:22:58 -0500
Received: from www.tglx.de ([62.245.132.106]:60613 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab0CAVW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 16:22:57 -0500
Date: Mon, 1 Mar 2010 22:21:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: bugzilla-daemon@bugzilla.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       =?ISO-8859-15?Q?Asbj=F8rn_Sannes?= <kernelbugzilla@sannes.org>,
       Venkatesch Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [Bug 15289] Regression 2.6.32 -> 2.6.33, Kernel needs a helping
 key to boot :)
In-Reply-To: <201003012103.00609.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1003012114470.4245@localhost.localdomain>
References: <bug-15289-10028@http.bugzilla.kernel.org/> <201003010617.o216HBix024914@demeter.kernel.org> <201003012103.00609.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1971964662-1267478501=:4245"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1971964662-1267478501=:4245
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 1 Mar 2010, Rafael J. Wysocki wrote:
> [Swithing to e-mail, please keep bugzilla-daemon in the CC list.]
> 
> On Monday 01 March 2010, bugzilla-daemon@bugzilla.kernel.org wrote:
> > http://bugzilla.kernel.org/show_bug.cgi?id=15289
> > 
> > --- Comment #30 from Asbjørn Sannes <kernelbugzilla@sannes.org>  2010-03-01 06:17:06 ---
> > hm, so from what I have gathered the previously bisected commit only exposes
> > another bug (hidden by enabling hpet). So I started bisecting again, this time
> > with hpet=disabled all the way and found:
> > 
> > commit aa276e1cafb3ce9d01d1e837bcd67e92616013ac
> > Author: Thomas Gleixner <tglx@linutronix.de>
> > Date:   Mon Jun 9 19:15:00 2008 +0200
> > 
> > x86, clockevents: add C1E aware idle function
> > 
> > Reverting this from a non-working 2.6.27 makes it work also. Things have
> > changed considerably since then so I was not able to revert it from the newest
> > kernel.
> > 
> > Maybe that disabling of SBX00 hpet msi, only should be done when you do
> > actually have floppy support? Makes more people boot atleast :P
> 
> Thomas, it looks like something's missing in our C1E handling.  Can you have
> a look at this bug report, please?

Groan. We have been through that exercise of blaming the above commit
and the C1E handling for a couple of times now. It never turned out to
be the real culprit.

Looking at the various steps Asbjorn took to analyse that problem it
simply boils down to the oldest problem with timers on ATI chipsets:

       the irq0 timer interrupt routing is hosed

I have no clue yet, why this is not detected by the test logic we have
in place for that, but it might be something which gets borked later
in the boot process.

Enabling MSI for HPET just papers over the problem as it uses a
different interrupt vector and mechanism.

Disabling HPET does not help simply because PIT is using IRQ0 as well
as the MSI disabled HPET.

I need some sleep to come up with a reasonable method to debug that,
but maybe someone else has an brilliant idea before I have to twist my
brain around it.

Thanks,

	tglx
--8323328-1971964662-1267478501=:4245--
