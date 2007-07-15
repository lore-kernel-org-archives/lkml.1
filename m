Return-Path: <linux-kernel-owner+w=401wt.eu-S1762722AbXGORlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762722AbXGORlg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 13:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760050AbXGORl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 13:41:28 -0400
Received: from [212.12.190.206] ([212.12.190.206]:32863 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752076AbXGORl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 13:41:27 -0400
From: Al Boldi <a1426z@gawab.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Hibernation considerations
Date: Sun, 15 Jul 2007 20:40:33 +0300
User-Agent: KMail/1.5
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>, <david@lang.hm>
References: <Pine.LNX.4.44L0.0707151220570.24011-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707151220570.24011-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707152040.33836.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Sun, 15 Jul 2007, Al Boldi wrote:
> > >     If possible, during a restore devices should be brought back to
> > > the same state in which they were before the corresponding
> > > hibernation.  Of course in some situations it might be impossible to
> > > do that (eg. the user connected the hibernated system to a different
> > > IP subnet and then restored), but as a general rule, we should do our
> > > best to restore the state of devices, which is directly related to
> > > point (5) above.
> >
> > This part could easily be handled by the normal kernel before and after
> > resume.
>
> I agree with you except for the word "easily".  And there are some
> things the kernel simply punts on (I'm thinking of the current VGA
> font).

Why; can you explain?

> > > (7) On ACPI systems special platform-related actions have to be
> > > carried out at the right points, so that the platform works correctly
> > > after the restore
> > >
> > >     The ACPI specification requires us to invoke some global ACPI
> > > methods during the hibernation and during the restore.  Moreover, the
> > > ordering of code related to these ACPI methods may not be arbitrary
> > > (eg. some of them have to be executed after devices are put into low
> > > power states etc.).
> >
> > This should be the responsibility of the kexec'd hibernating kernel. 
> > Note though in (6), the normal kernel takes care of preparing devices,
> > then the hibernating kernel dumps the image and either calls S4 or S3. 
> > On resume from S3 it can immediately switch over to the normal kernel,
> > and from S4 the known bootup would occur.
>
> Is it really that simple?  Somehow I doubt it.  In order for some
> devices to remain available for the kexec'd kernel to use, they cannot
> be suspended at the ACPI level.  So the kexec'd kernel will have to
> handle the ACPI requirements for those devices.  Likewise, it would
> have to handle the ACPI interactions which need to be done after all
> devices are prepared for the transition to S3 or S4.

Ok, after applying the latest kexec patches, I was able to use the kexec'd 
kernel to suspend to ram and resume to the normal kernel, while working 
under a full-blown X session.  It went without a hitch.  All that is needed 
now are the dump/restore hibernation-image routines.

> > > (8) Hibernation and restore should not be too slow
> > >
> > >     In my opinion, if more than one minute is needed to hibernate the
> > > system with the help of certain hibernation framework, then this
> > > framework is not very useful in practice.  It might be useful to
> > > perform some special tasks (eg. moving a server to another place
> > > without taking it down), but it is not very useful, for example, to
> > > notebook users.
> >
> > The latest hibernating kexec patches boot a kexec'd modular kernel with
> > initramfs into crashkernel=16M@16M in less than one second.  Switch-back
> > is almost instant.  Add to this the time required to either store or
> > restore the image, and it may be obvious that this approach isn't
> > slower, but maybe even faster than the current swsusp.
>
> Does that include the time required for probing PCI buses?  On my
> desktop system, PCI probing incurs a five-second timeout delay because
> of a bug in the BIOS's USB firmware.

Using a modular kernel you would only insmod those modules that you need to 
dump the image, which is mainly the diskdriver.  If you wanted to dump it 
onto USB flash, then you would insmod that driver, and if that driver is 
slow due to a bug, then a fix should be in order.

> Don't be so sure that kexec will
> always be lightning fast; it is always better to avoid unnecessary
> boots.

Agreed, but what we want to achieve right know is a proof of concept.  Later, 
I could imagine a specially stub'd device driver to be kexec'd instead of 
the full kernel.


Thanks!

--
Al

