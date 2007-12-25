Return-Path: <linux-kernel-owner+w=401wt.eu-S1753009AbXLYNHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbXLYNHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 08:07:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbXLYNHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 08:07:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34509 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbXLYNHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 08:07:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4 suspend-to-RAM
Date: Tue, 25 Dec 2007 14:26:12 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Robert Hancock <hancockr@shaw.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <fa.Tr7qmPdet0rF2FSRX/94s2UEMSE@ifi.uio.no> <4770356E.1000407@shaw.ca> <200712250003.27570.carlos@strangeworlds.co.uk>
In-Reply-To: <200712250003.27570.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712251426.14024.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 25 of December 2007, Carlos Corbacho wrote:
> On Monday 24 December 2007 22:40:46 Robert Hancock wrote:
> > The ACPI spec has the following to say about the _PTS method:
> >
> > "The platform must not make any assumptions about the state of the
> > machine when _PTS is called. For example, operation region accesses that
> > require devices to be configured and enabled may not succeed, as these
> > devices may be in a non-decoding state due to plug and play or power
> > management operations."
> 
> That is from the 3.0 spec though. And it looks like the definition changed 
> from pre-3.0 to 3.0 and above.
> 
> This is what the 1.0B spec says (and this is also repeated verbatim in 2.0, 
> 2.0a, 2.0b, and 2.0c):
> 
> "The _PTS control method is executed by the operating system at the beginning 
> of the sleep process for S1, S2, S3, S4, and for orderly S5 shutdown. The 
> sleeping state value (1, 2, 3, 4, or 5) is passed to the _PTS control method. 
> Before the OS notifies native device drivers and prepares the system software 
> for a system sleeping state, it executes this ACPI control method. Thus, this 
> control method can be executed a relatively long time before actually 
> entering the desired sleeping state. In addition, the OS can abort the 
> sleeping operation without notification to the ACPI driver, in which case 
> another _PTS would occur some time before the next attempt by the OS to enter 
> a sleeping state. The _PTS control method cannot modify the current 
> configuration or power state of any device in the system. For example, _PTS 
> would simply store the sleep type in the embedded controller in sequencing 
> the system into a sleep state when the SLP_EN bit is set."
> 
> According to the earlier versions of the ACPI spec, Linux is doing the wrong 
> thing - we should call _PTS() before we start powerding down devices, or 
> notifying device drivers to start suspending.

Well, citing from the ACPI 2.0 specification, section 9.1.6 Transitioning from
the Working to the Sleeping State (which is what we're discussing here):

3. OSPM places all device drivers into their respective Dx state. If the device
   is enabled for wake, it enters the Dx state associated with the wake
   capability. If the device is not enabled to wake the system, it enters the
   D3 state.
4. OSPM executes the _PTS control method, passing an argument that indicates
   the desired sleeping state (1, 2, 3, or 4 representing S1, S2, S3, and S4).

My opinion is that we should follow this part of the specification and so we do.

> So, my limited understanding of what we currently do for ACPI suspend-to-RAM 
> is:
> 
> 1) Freeze processes/ devices
> 2) Put all devices into low power mode
> 3) Execute _PTS()
> 4) Suspend system
> 
> So the problem is - our current suspend order is fine for ACPI 3.0 and above, 
> but for pre-3.0 systems, this violates the older specs, where 2) and 3) 
> should be reversed.
> 
> > I would guess some BIOS writers failed to heed this..
> 
> No, it looks like the BIOS is obeying the older specs, and Linux is at fault 
> here for breaking the suspend logic of pre ACPI 3.0 systems.

You're wrong, sorry.

Greetings,
Rafael
