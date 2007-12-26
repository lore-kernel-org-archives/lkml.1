Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbXLZOsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbXLZOsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 09:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbXLZOsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 09:48:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38805 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbXLZOsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 09:48:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Suspend code ordering (again) (was: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4 suspend-to-RAM)
Date: Wed, 26 Dec 2007 16:07:17 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <200712231419.40207.carlos@strangeworlds.co.uk> <200712251713.13223.rjw@sisk.pl> <alpine.LFD.0.9999.0712252006330.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712252006330.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712261607.18429.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 26 of December 2007, Linus Torvalds wrote:
> 
> On Tue, 25 Dec 2007, Rafael J. Wysocki wrote:
> >
> > the ACPI specification between versions 1.0x and 2.0.  Namely, while ACPI
> > 2.0 and later wants us to put devices into low power states before calling
> > _PTS, ACPI 1.0x wants us to do that after calling _PTS.  Since we're following
> > the 2.0 and later specifications right now, we're not doing the right thing for
> > the (strictly) ACPI 1.0x-compliant systems.
> > 
> > We ought to be able to fix things on the high level, by calling _PTS earlier on
> > systems that claim to be ACPI 1.0x-compliant.  That will require us to modify
> > the generic susped code quite a bit and will need to be tested for some time.
> 
> That's insane. Are you really saying that ACPI wants totally different 
> orderings for different versions of the spec?

Yes, I am.

> And does Windows really do that?

I don't know.

> Please don't make lots of modifications to the generic suspend code. The 
> only thing that is worth doing is to just have a firmware callback before 
> the "device_suspend()" thing (and then on a ACPI-1.0 system, call _PTS 
> *there*), and on an ACPI-2.0 system, call _PTS *after* device_suspend().

Yes, that's what I'm going to do, but I need to untangle some ACPI code for
this purpose.

> Still, the fact is, some (most, I think) drivers *should* put themselves 
> into D3 only in "late_suspend()", so if ACPI-2.0 really expects _PTS to be 
> called after that, we're just screwed.

Well, section 9.1.6 of ACPI 2.0 specifies the suspend ordering directly and
says exactly that _PTS is to be executed after putting devices into respective
D states.

> That's when the system is really down, interrupts disabled etc, we don't want
> to call anything but the final ACPI "turn us off" stuff there!

OTOH, we ought to be able to put devices into low power states at any time, for
example when they are not used, without any problems and having to put them
back into D0 just in order to execute _PTS doesn't seem very logical to me. ;-)

Greetings,
Rafael


