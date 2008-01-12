Return-Path: <linux-kernel-owner+w=401wt.eu-S1762278AbYALJQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762278AbYALJQl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 04:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759732AbYALJQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 04:16:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:50780 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758884AbYALJQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 04:16:24 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: Lenovo ThinkPads need acpi_osi="Linux"
Date: Sat, 12 Jan 2008 04:16:08 -0500
User-Agent: KMail/1.9.5
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080112022348.GC27524@khazad-dum.debian.net>
In-Reply-To: <20080112022348.GC27524@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801120416.08631.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 January 2008 21:23, Henrique de Moraes Holschuh wrote:
> While helping a user find out what happened to his mute key, I found out
> that the Lenovo BIOSes need the OSI string Linux defined to behave properly
> in Linux.
> 
> Lenovo has been attempting to make things a bit easier for Linux on their
> ThinkPads, by disabling the more obnoxious behaviours of the firmware (used
> by their Windows drivers) when in Linux.  It looks like they used the OSI
> string for that.
> 
> It is probably worthwhile to give a head's up: regressions involving
> thinkpads and 2.6.23+ should probably have a 'please test with
> acpi_osi="Linux"' step added if there is any chance ACPI AML code, BIOS or
> SMBIOS code, or EC behaviour could be involved.
> 
> The most concrete example I have right now of changed behaviour is the Mute
> key on the T61, which just plain disappears if acpi_osi="!Linux" (2.6.23
> default).
> 
> I have also seen some hacked DSDTs around (mostly for older T4x models)
> which used the Linux OSI string to fix or work around AML weirdness.  Those
> would break in 2.6.23 (and 2.6.24?) as well.
> 
> Now, what should we do about it?  Add a quirk to always define the Linux OSI
> string on ThinkPads (based on DMI information)?  All IBM ones (which won't
> have BIOS revisions anymore, anyway) deal well with it, and Lenovo ones
> seem to benefit from it.
> 
> We could also ask Lenovo to change the BIOS to stop paying attention to that
> OSI string, but they will likely want/need a trigger for the AML code to
> know it should change behaviour anyway, and the OSI string *does* look like
> the proper thing to use IMHO.  I don't know if we could get them to arrive
> to a behaviour that is acceptable both to us, and also to their Windows
> drivers...
> 

I discussed this with Lenovo a few months ago
and made it clear that Linux will unlikely
default to answer yes to OSI(Linux) in the future --
for all the reasons I stated when I disabled it.

However, they told me they wanted to use OSI(Linux)
to enable the backlight (via video re-post) on S3 resume,
and the problem at hand was a distro kernel which still
had OSI(Linux), so that is what they did.

I was unaware that they're using it for anything else,
and the fact that they are lends further support to
the case that as an OS interface string "Linux"
is too vague to be meaningful.

They seemed open to looking for another string, say
"Needs S3 video re-post".  However, we didn't
agree on such a string, and so it isn't in Linux
or the Lenovo BIOS.

I think until we have native Linux graphics driver for (fast)
backlight restore, we need to add a DMI to enable OSI(Linux)
for the offending Lenovo models.   We'll need to have
some coordination with the graphics guys so that they
can turn this off from user-space when they don't need it.

The reason it shoudl be turned off is that backlight enabling
backlight from a native graphics driver is much faster than running
through the video BIOS POST.  So if we keep the OSI(Linux)
video BIOS POST workaround in place permanently, it would
put Linux at a permanent performance disadvantage to Windows.

cheers,
-Len
