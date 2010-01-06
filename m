Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162Ab0AFT1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab0AFT1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756150Ab0AFT1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:27:35 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:36104 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab0AFT1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:27:32 -0500
Date: Wed, 06 Jan 2010 14:26:44 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Arjan van de Ven <arjan@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Christian Hofstaedtler <ch@zeha.at>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bruce.w.allan@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Add DMI quirk for Intel DP55KG mainboard
In-reply-to: <20100106143640.GB13984@srcf.ucam.org>
Message-id: <alpine.LFD.2.00.1001061321260.4086@localhost.localdomain>
References: <20100104162114.GA30113@percival.namespace.at>
 <alpine.LFD.2.00.1001041209300.4012@localhost.localdomain>
 <4B4225B3.8070705@zytor.com> <20100104174558.158cd512@infradead.org>
 <20100106143640.GB13984@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > can we do it based on the dmi/acpi year?

> I think a saner model would be to use a similar method to Windows - 
> that is, change behaviour based on the OSI calls that the firmware 
> makes. If the firmware supports Vista, it's probably safe to use the 
> ACPI reboot method.

Andrey Borzenkov's Toshiba Portege 4000 failed to reset with ACPI,
which is why we reverted ACPI reset as default in 2008.
Toshiba shipped the Portege 4000 in 2002 running with Windows 2000,
suggesting that Windows 2000 does not use ACPI reset -- at least
not always.

When debugging the reset failure in:
http://bugzilla.kernel.org/show_bug.cgi?id=11942
Yakui Zhao found that Windows XP writes the ACPI reset register
no matter if the FADT says it is valid or not:
http://lkml.indiana.edu/hypermail/linux/kernel/0811.0/02272.html
At the end of the day, we decided that Linux should honor that bit,
but what we learned is that Windows XP apparently uses ACPI reset by 
default.

So it is likely that our DMI exception lists will be minimized
by using legacy reset for W2K generation and before; and
using ACPI reset for Windows XP generation and after.
As Robert Hancock corrected me, XP is _OSI(Windows 2001).

But...
using _OSI is not "a similar method to Windows".
The BIOS does not need to invoke _OSI to determine if
it should expose a properly functioning ACPI reset or not.
Windows XP simply demanded it, and the box failed WHQL
if it did not work.

Further, there is no _guarantee_ that a BIOS will invoke _OSI
at all, let alone a _rule_ for what _OSI() strings the BIOS
will choose to query to trigger its Windows specific
compatibility hooks -- even if common practice is for
a desktop BIOS to evaluate _OSI strings in sequence
up throught he most recent version of Windows it
knows about...

So I'm more comfortable with DMI, and any year after
Windows 2000 is gone is probably reasonable, say 2003.

I have no doubt that no matter what we do, we will
end up with some exceptions on a blacklist, the goal
is simply to minimize those lists.

cheers,
Len Brown, Intel Open Source Technology Center

ps.
For CONFIG_ACPI_BLACKLIST_YEAR we chose not to strive
for consensus on a hard-coded year, but made it a config option.
I'm not a fan of more config options, but that one allowed
us to avoid thrashing about what year ACPI should kick in
and defer that to the distros.  I think it has probably
served its purpose now, as Fedora for the last few years
has shipped with this option disabled -- enabling ACPI
on all systems that present an ACPI BIOS.



