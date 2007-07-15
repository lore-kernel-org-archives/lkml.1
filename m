Return-Path: <linux-kernel-owner+w=401wt.eu-S1762917AbXGOQ3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762917AbXGOQ3c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759243AbXGOQ3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:29:24 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3623 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757397AbXGOQ3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:29:23 -0400
Date: Sun, 15 Jul 2007 12:29:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Al Boldi <a1426z@gawab.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>, <david@lang.hm>
Subject: Re: Hibernation considerations
In-Reply-To: <200707151810.33554.a1426z@gawab.com>
Message-ID: <Pine.LNX.4.44L0.0707151220570.24011-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jul 2007, Al Boldi wrote:

> >     If possible, during a restore devices should be brought back to the
> > same state in which they were before the corresponding hibernation.  Of
> > course in some situations it might be impossible to do that (eg. the user
> > connected the hibernated system to a different IP subnet and then
> > restored), but as a general rule, we should do our best to restore the
> > state of devices, which is directly related to point (5) above.
> 
> This part could easily be handled by the normal kernel before and after 
> resume.

I agree with you except for the word "easily".  And there are some 
things the kernel simply punts on (I'm thinking of the current VGA 
font).

> > (7) On ACPI systems special platform-related actions have to be carried
> > out at the right points, so that the platform works correctly after the
> > restore
> >
> >     The ACPI specification requires us to invoke some global ACPI methods
> >     during the hibernation and during the restore.  Moreover, the ordering
> > of code related to these ACPI methods may not be arbitrary (eg. some of
> > them have to be executed after devices are put into low power states
> > etc.).
> 
> This should be the responsibility of the kexec'd hibernating kernel.  Note 
> though in (6), the normal kernel takes care of preparing devices, then the 
> hibernating kernel dumps the image and either calls S4 or S3.  On resume 
> from S3 it can immediately switch over to the normal kernel, and from S4 the 
> known bootup would occur.

Is it really that simple?  Somehow I doubt it.  In order for some 
devices to remain available for the kexec'd kernel to use, they cannot 
be suspended at the ACPI level.  So the kexec'd kernel will have to 
handle the ACPI requirements for those devices.  Likewise, it would 
have to handle the ACPI interactions which need to be done after all 
devices are prepared for the transition to S3 or S4.

> > (8) Hibernation and restore should not be too slow
> >
> >     In my opinion, if more than one minute is needed to hibernate the
> > system with the help of certain hibernation framework, then this framework
> > is not very useful in practice.  It might be useful to perform some
> > special tasks (eg. moving a server to another place without taking it
> > down), but it is not very useful, for example, to notebook users.
> 
> The latest hibernating kexec patches boot a kexec'd modular kernel with 
> initramfs into crashkernel=16M@16M in less than one second.  Switch-back is 
> almost instant.  Add to this the time required to either store or restore 
> the image, and it may be obvious that this approach isn't slower, but maybe 
> even faster than the current swsusp.

Does that include the time required for probing PCI buses?  On my
desktop system, PCI probing incurs a five-second timeout delay because
of a bug in the BIOS's USB firmware.  Don't be so sure that kexec will
always be lightning fast; it is always better to avoid unnecessary
boots.

Alan Stern

