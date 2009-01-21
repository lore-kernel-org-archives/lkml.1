Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbZAURLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbZAURLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 12:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZAURLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 12:11:35 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:17271 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbZAURLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 12:11:34 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Philipp Kohlbecher <xt28@gmx.de>
Subject: Re: [PATCH] Make PNP IDs all uppercase
Date: Wed, 21 Jan 2009 10:09:46 -0700
User-Agent: KMail/1.9.10
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
       Vojtech Pavlik <vojtech@ucw.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       Pau Oliva Fora <pof@eslack.org>, Hans Verkuil <hverkuil@xs4all.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Jaroslav Kysela <perex@perex.cz>, Adam Belay <abelay@mit.edu>,
       Len Brown <lenb@kernel.org>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       linux-acpi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
References: <49733678.40006@gmx.de> <200901201742.10155.bjorn.helgaas@hp.com> <4976D517.2070406@gmx.de>
In-Reply-To: <4976D517.2070406@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200901211009.48191.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 January 2009 12:56:07 am Philipp Kohlbecher wrote:
> Bjorn Helgaas wrote:
> > On Sunday 18 January 2009 07:02:32 am Philipp Kohlbecher wrote:
> >> If I understand correctly, ACPI _HIDs (including PNP IDs) should be all 
> >> uppercase, including the hex digits, cf. ACPI Specification 3.0b [1], 
> >> pp. 162-3
> > 
> > Section 6.1.4, "_HID (Hardware ID)" says:
> > 
> >     A valid PNP ID must be of the form “AAA####” where A is an uppercase
> >     letter and # is a hex digit.  A valid ACPI ID must be of the form
> >     “ACPI####” where # is a hex digit.
> > 
> > I don't see the part about requiring the hex digits to be uppercase.
> > Did I miss it, or is it somewhere else?
> 
> It doesn't say explicitly, hence my reservation. The ACPI specification 
> does, however, use uppercase hex digits in all examples of _HIDs.

The PNPBIOS spec doesn't seem to say explicitly either, although the
examples there also use uppercase.  So it'd probably be nicer if we
used uppercase everywhere in Linux.  Unfortunately, we have the legacy
of the kernel using lowercase in PNP IDs, and there are userspace things
like modprobe aliases that depend on that.

> I do. Thanks for noticing that. Now, how do I make sure this mix-up 
> doesn't go into the commit message? Re-submit or ask the committer to 
> correct it?

I think reposting the patch will be better.  But I would split this
up into a patch per file, so they can go through the usual maintainers,
and I think we should wait a bit (see below).

> > There are definitely some inconsistencies that it would be nice to
> > fix, if we can do it safely.  For example, for ISAPNP and PNPBIOS
> > devices, I think we always generate lowercase hex digits in the PNP
> > IDs.  For PNPACPI, we generate uppercase digits for numeric _HIDs,
> > but we use string _HIDs unchanged.
> > 
> > Did you trip over an actual problem that is fixed by this patch?  If
> > so, can you give any more details?
> 
> Yes. After a package update, hwclock stopped using the "--directisa" 
> switch and could not access the RTC anymore. My RTC is handled by 
> rtc-cmos, which is compiled as a module. However, udev did not load this 
> module, as the device's modalias "acpi:PNP0B00:" did not match any of 
> the module's aliasas, including "acpi*:PNP0b00:*". Thus, the system 
> clock was not set correctly at startup (my hardware clock is set to 
> local time). Changing the PNP IDs in drivers/rtc/rtc-cmos.c to use 
> uppercase hex digits solved that problem for me.

Nice work debugging that problem!  I would include that synopsis in
the changelog, because it helps people who trip over the same problem
and are looking for a solution, and it helps people who want to
understand why the change was made.

IMO, part of the problem here is that there is a single PNP ID
namespace, but it's shared between the PNP core and the ACPI core.
And PNP doesn't emit uevents, so in this case, we're using ACPI
uevents to load a PNP driver.  The ACPI uevents will be uppercase
(which matches the IDs in ACPI drivers), but the IDs in PNP drivers
are typically lowercase (which matches the strings in
/sys/devices/pnp*/*/id).

I started trying to untangle this last year, but I didn't get far
enough to be comfortable that I wouldn't break existing userspace
stuff.  Maybe it's time to resurrect that work.

The RTC problem is not really a regression; it sounds like this is
a long-standing problem.  Given that, I'd like to have a clearer
idea of how to clean up the namespace and uevent issues before we
go changing all the PNP drivers.

Bjorn

