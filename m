Return-Path: <linux-kernel-owner+w=401wt.eu-S1753079AbZAFKMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbZAFKMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 05:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbZAFKMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 05:12:12 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55116 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZAFKML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 05:12:11 -0500
Date: Tue, 6 Jan 2009 11:14:15 +0100
From: Pavel Machek <pavel@suse.cz>
To: Daniel Troeder <daniel@admin-box.com>, deller@gmx.de,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: LED (leds_hp_disk) causes BUG: scheduling while atomic
Message-ID: <20090106101415.GA13972@elf.ucw.cz>
References: <1231156352.9735.6.camel@maya.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231156352.9735.6.camel@maya.local>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I'm not sure if I should send this email to LKML, because it doesn't
> seem to important, and the traffic there seems high. If you are not the
> correct maintainer, or if I should send it there anyway, please tell me.
> 
> Update: I sent this letter first to Helge Deller <deller@gmx.de>, he
> told me to mail to you.

Yep, that's right, I'm responsible. LKML is indeed right thing to Cc:.

> I have a HP Compaq nc2400 notebook, and having recently installed 2.6.28
> (gentoo patchset, self configured), I have observed the following:
> 
> When {I manually, udev automatically} load the leds_hp_disk module, my
> disk-led flashes regularly _without_ disk activity. When I look at my
> dmesg I see the following:

Yes, that's a (mis-feature).

> [  724.376881] BUG: scheduling while atomic: swapper/0/0x10000100
> [  724.376886] Modules linked in: leds_hp_disk i915 drm snd_pcm_oss

And that's a bug. I know what causes it, but i don't have right fix
yet.

If you are interested, take latest -mm (mmotm from userweb) and apply
this manually:

--- linux-mm/drivers/hwmon/hp_accel.c   2009-01-06 10:54:40.000000000
+0100
+++ linux/drivers/hwmon/hp_accel.c      2008-12-10 09:36:21.000000000
+0100
@@ -174,11 +174,35 @@
 }
 
 static struct led_classdev hpled_led = {
-       .name                   = "hp:red:hddprotection",
-       .default_trigger        = "heartbeat",
+       .name                   = "hp:red:hddprotect",
+       .default_trigger        = "none",
        .brightness_set         = hpled_set,
 };


...led will stop blinking, and messages will be gone. (But note that
if you turn on heartbeat or similar trigger, you'll still get the
"scheduling in interrupt" nastyness...)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
