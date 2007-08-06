Return-Path: <linux-kernel-owner+w=401wt.eu-S933068AbXHFOgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbXHFOgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932414AbXHFOgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 10:36:36 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51469 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932413AbXHFOgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 10:36:35 -0400
X-Sasl-enc: NWYlrCgUnOohxy9gAhO9MzMGl3g9g9PQMwOU6H/ZxRsY 1186410994
Date: Mon, 6 Aug 2007 11:36:31 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Pavel Machek <pavel@ucw.cz>, ibm-acpi-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: suspend/hibernation regression between 2.6.19 and 2.6.20 w/
	Thinkpad T41
Message-ID: <20070806143631.GB31615@khazad-dum.debian.net>
References: <200708051902.18801.toralf.foerster@gmx.de> <20070805222937.GA23963@elf.ucw.cz> <200708061136.50491.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200708061136.50491.toralf.foerster@gmx.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Aug 2007, Toralf Förster wrote:
> Am Montag, 6. August 2007 00:29 schrieb Pavel Machek:
> > Yes, I seen similar reports. Does it happen in all shutdown mode and
> > 2.6.22? Does it happen   in platform mode in 2.6.19?
> 
> I can reproduce this behaviour by doing the following with kernel 2.6.20 :
> 
> 1. <Fn>+<F4>   - the systems sleeps within RAM
> 2. <Fn>             - the systems wakes up
> 3. <Fn>+<F12> - the systems hibernates to disk
> 4. <power>       - systems wakes up
> 5. <Fn>+<F4>   - the systems sleeps within RAM
> 
> Now pressing <Fn> doesn't wake up the system, I have to press the power button
> for that instead.

The resume path for suspend to disk is very different (for the firmware, at
least) than the resume path from sleep-to-RAM.  One of them goes through a
system shutdown and cold boot (S5) or whatever-boot (S4 - who knows if it is
the same as a cold boot in a given thinkpad model? It doesn't have to be!).

The firmware *knows* when you press Fn+F4/FN+F12, and recalls that. That's
why you can't get multiple hot key presses from pressing Fn+F4 or FN+F12
until you actually do an ACPI wake-up.

While you are just doing S3, all that state is preserved without fuss. But
S5 does not preserve anything, and S4 is anyone's guess.  Numerous thinkpad
BIOS fixes in the past were releated to such problems, so if you are not
using the latest BIOS for your model, your first duty is to upgrade it and
try again.

IMHO, probably some ACPI state is being lost by the BIOS because of the
sleep-to-disk.  I don't know how sleep-to-disk plays with the ACPI NV areas,
and ACPI data areas from the BIOS, so I can't help much there.

And, mind you, I am *not* sure one is supposed to be able to wake up
thinkpads using Fn.  It might be in fact a bug that we can do it.  One has
to at the very least verify whether it happens in Windows as well.

However, the following events *are* to wake a thinkpad up from S3:
	1. ACPI wake devices
	2. Dock or bay eject buttons/lever being actuated
	3. Brief press on power button

You can check if (2) is still working. If both Fn and (2) stop working, we
can be sure we have a bug in Linux.  (2) is useful because it is reported
inside the ACPI firmware mostly through the same codepaths.

> BTW I tried to test the latest git-sources -rc2 but the <Fn> keys do not work
> anymore with the thinkpad-acpi feature (neither as module nor if compiled into).

Don't enable the input layer by default in thinkpad-acpi Kconfig.  A patch
to change that to default to N has already been sent to Len Brown, but it
has not been merged yet.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
