Return-Path: <linux-kernel-owner+w=401wt.eu-S1751358AbXBVCOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbXBVCOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 21:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbXBVCON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 21:14:13 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:40611 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358AbXBVCOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 21:14:12 -0500
X-Sasl-enc: Q8eiGDajkDqXJrKwF4jAZPpnMShmPjAio8z3bq8k7Il6 1172110532
Date: Thu, 22 Feb 2007 00:13:56 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Alex Romosan <romosan@sycorax.lbl.gov>,
       Yaroslav Halchenko <kernel@onerussian.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       James Simmons <jsimmons@infradead.org>
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
Message-ID: <20070222021356.GC8845@khazad-dum.debian.net>
References: <20070219044616.GC25659@washoe.onerussian.com> <20070219000412.acad13de.akpm@linux-foundation.org> <1171876788.6046.3.camel@localhost.localdomain> <877iub9mu2.fsf@sycorax.lbl.gov> <1172097718.5790.29.camel@localhost.localdomain> <20070221231706.GA3336@khazad-dum.debian.net> <1172103159.5790.45.camel@localhost.localdomain> <20070222005122.GA7928@khazad-dum.debian.net> <1172106616.5790.90.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172106616.5790.90.camel@localhost.localdomain>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007, Richard Purdie wrote:
> The following sequence is reproducible:
> 
> echo 7 > brightness (repeat until actual_brightness reads 7)
> echo 0 > brightness (brightness reads 0, actual_brightness reads 4)
> echo 0 > brightness (brightness reads 0, actual_brightness reads 0)

As I said, it works fine on 2.6.20 on the hardware I have.  I will see if I
can test on 2.6.21, but it is something non-trivial for me to do right now.

> I suspect this is interference from software on the machine as it does
> show an onscreen display when I change the values in sysfs and the

Yes, I am using something like that here too, and it doesn't break anything.

> values on the OSD don't match what's really going on.  The
> actual_brightness does match the screen.

So something is screwing with what gets written to the EC, and it does it
AFTER ibm-acpi started processing the brightness change request.

actual_brightness asks the *EC* what the current brightness value is, so it
will never be wrong on a new-enough ThinkPad.

> I guess this just means we need to get userspace to agree on one method
> of access for this kind of thing. It makes me wondering where the
> hardware brightness keys fit into things though...

For ThinkPads:

The Golden Rule: never talk to the EC or write to firmware-command-space in
the CMOS NVRAM in userspace.  If you do, bad things could happen and it is
your fault.

Here's how brightness control works in ThinkPads:

0. Brightness and backlight on/off state are decoupled.  Turning the
backlight on or off is done through DPMS or something else video-card
specific.  Newer models shut the backlight off by EC firmware (or maybe even
on hardware) when the lid is closed, too.

1. The thinkpad does everything brightness-related in firmware (EC+BIOS).
If you keep your hands off, it works correctly on every O.S.

2. The brightness up key exports hotkey events (all models) and a brightness
up ACPI event (*60 and newer thinkpads, with 2.x BIOS).  It is a bad idea to
use those events to change the backlight brightness, because the firmware
will be doing just that too.

3. It doesn't export anything for brightness down.  You find it happened
snooping the CMOS nvram.

4. Ibm-acpi doesn't care about the ACPI events much, it just asks the EC
what the brightness level is when it needs to do something, then it issues
both CMOS commands and EC writes to make damn sure the level is changed.
The CMOS commands are step-style, so to go from 4 to 7, you issue 3x
brightness up.

> > Well, if you have the ACPI video module loaded, unload it.  Does it work
> > now?
> 
> No change if unloaded.

I am out of ideas. But blacklist that module on your ThinkPad, it just gets
in the way, even if you are not using ibm-acpi.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
