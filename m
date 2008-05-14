Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbYENUmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbYENUmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 16:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbYENUmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 16:42:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:27517 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbYENUl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 16:41:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Y1YIpas+ft6IAa/YLeN9wRHzcAw7pS0YokfsrejRcQg+S2uORJyMAl/7Umnhq4wVnY1UKCSOzlXYl5pzsbD8VCZIUDb8mLew8VvPHCueP1co7up40UU81M3vie4qAvhZRHpIhRIgFBdwpYxBq9nEJEsKitPXScDNv1WPYbffcnk=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
Date: Wed, 14 May 2008 23:41:51 +0300
User-Agent: KMail/1.9.9
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, nigel@nigel.suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>
References: <Pine.LNX.4.44L0.0803121055510.4595-100000@iolanthe.rowland.org> <200803140231.39282.rjw@sisk.pl> <m1prtsug2e.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1prtsug2e.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805142341.52078.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 18 March 2008 18:56:09 Eric W. Biederman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Friday, 14 of March 2008, Eric W. Biederman wrote:
> >
> >> > Still, it would be sufficient if we disconnected the drivers from the
> > hardware
> >> > and thus prevented applications from accessing that hardware.
> >> 
> >> My gut feeling is that except for a handful of drivers we could even
> >> get away with simply implementing hot unplug and hot replug.  Disks
> >> are the big exception here.
> >> 
> >> Which suggests to me that it is at least possible that the methods we
> >> want for a kexec jump hibernation may be different from an in-kernel
> >> hibernation and quite possibly are easier to implement.
> >
> > I'm not sure about the "easier" part, quite frankly.  Also, with our current
> > ordering of code the in-kernel hibernation will need the same callbacks
> > as the kexec-based thing.  However, with the in-kernel approach we can
> > attempt (in the future) to be more ACPI compliant, so to speak, but with the
> > kexec-based approach that won't be possible.
> >
> > Whether it's a good idea to follow ACPI, as far as hibernation is concerned, is
> > a separate question, but IMO we won't be able to answer it without _lots_ of
> > testing on vaious BIOS/firmware configurations.  Our experience so far
> > indicates that at least some BIOSes expect us to follow ACPI and misbehave
> > otherwise, so for those systems there should be an "ACPI way" available.
> > [Others just don't work well if we try to follow ACPI and those may be handled
> > using the kexec-based approach, but that doesn't mean that we can just ignore
> > the ACPI compliance issue, at least for now.]
> 
> If we do use the ACPI S4 state I completely agree we should be at
> least spec compliant in how we use it.
> 
> I took a quick skim through my copy of the ACPI spec so I could get a
> feel for this issue.  Hibernation maps to the ACPI S4 state.  The only
> thing we appear to gain from S4 is the ability to tell the BIOS (so it
> can tell a bootloader) that this was a hibernation power off instead
> of simply a software power off.
> 
> It looks like entering the ACPI S4 state has a few advantages with
> respect to how the system wakes up.  In general using the ACPI S5
> state (soft off) appears simpler, and potentially more reliable.
> 
> The sequence we appear to want is:
> - Disconnecting drivers from devices.
> - Saving the image.
> - Placing the system in a low power or off state.
> 
> - Coming out of the low power state.
> - Restoring the image.
> - Reconnecting drivers to devices.
>   (We must assume the device state could have changed here
>    no matter what we do)
> 
> It is mostly a matter of where we place the code.
> 
> Right now I don't see a limitation either with a kexec based approach
> or without one.  Especially since the common case would be using
> the same kernel with the same drivers both before and after the
> hibernation event.
> 
> The low power states for S4 seem to be just so that we can
> decide which devices have enough life that they can wake up
> the system.  If we handle all of that as a second pass after
> we have the system in a state where we have saved it we should
> be in good shape.
> 
> My inclination is to just use S5 (soft off).
> 
> One of the cool things about hibernation to disk was that we were
> supposed to get the BIOS totally out of that path so we could get
> something that was rock solid and reliable.  I don't see why we should
> use ACPI S4 when the BIOS doesn't seem to give us anything useful, and
> causes us headaches we should even consider using S4.
> 
> Does using the S4 state have advantages that I currently do not
> see?
First of all S4 ACPI code turns some leds on some systems,
cosmetic thing, but still nice.

Secondary, what about wakeup devices?
Hardware can disable some devices in S5 while leave them running in S4
on my system for example network card will do WOL in S4,
but to make it WOL in S5 I have to turn a specific option in BIOS.

While my system doesn't have this, it isn't uncommon for system to leave USB ports
running so one can turn the PC with keyboard/mouse even in S4.
in S5 those ports  will probably  be disabled.
My system on have this for S3 only.

On laptops we can expect even more ACPI functionality, so some more differences between
S4 and S5 can happen.

Last thing that I want to say is that, when linux puts PC in S? state, on top of executing 
_PTS, _GTS acpi functions, it writes the destination S state to a fixed register, thus the hardware
can (and does) behave differently.

Best regards,
	Maxim Levitsky

> 
> Len? Rafael? Anyone?
> 
> Eric
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/linux-pm
> 


