Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204AbXLZEO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbXLZEO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 23:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbXLZEOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 23:14:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59565 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751522AbXLZEOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 23:14:44 -0500
Date: Tue, 25 Dec 2007 20:11:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: Suspend code ordering (again) (was: Re: x86: Increase PCIBIOS_MIN_IO
 to 0x1500 to fix nForce 4 suspend-to-RAM)
In-Reply-To: <200712251713.13223.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.9999.0712252006330.21557@woody.linux-foundation.org>
References: <200712231419.40207.carlos@strangeworlds.co.uk> <200712241444.24031.rjw@sisk.pl> <alpine.LFD.0.9999.0712241008150.21557@woody.linux-foundation.org> <200712251713.13223.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 Dec 2007, Rafael J. Wysocki wrote:
>
> the ACPI specification between versions 1.0x and 2.0.  Namely, while ACPI
> 2.0 and later wants us to put devices into low power states before calling
> _PTS, ACPI 1.0x wants us to do that after calling _PTS.  Since we're following
> the 2.0 and later specifications right now, we're not doing the right thing for
> the (strictly) ACPI 1.0x-compliant systems.
> 
> We ought to be able to fix things on the high level, by calling _PTS earlier on
> systems that claim to be ACPI 1.0x-compliant.  That will require us to modify
> the generic susped code quite a bit and will need to be tested for some time.

That's insane. Are you really saying that ACPI wants totally different 
orderings for different versions of the spec? And does Windows really do 
that?

Please don't make lots of modifications to the generic suspend code. The 
only thing that is worth doing is to just have a firmware callback before 
the "device_suspend()" thing (and then on a ACPI-1.0 system, call _PTS 
*there*), and on an ACPI-2.0 system, call _PTS *after* device_suspend().

Still, the fact is, some (most, I think) drivers *should* put themselves 
into D3 only in "late_suspend()", so if ACPI-2.0 really expects _PTS to be 
called after that, we're just screwed. That's when the system is really 
down, interrupts disabled etc, we don't want to call anything but the 
final ACPI "turn us off" stuff there!

			Linus
