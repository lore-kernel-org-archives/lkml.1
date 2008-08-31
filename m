Return-Path: <linux-kernel-owner+w=401wt.eu-S1758004AbYHaCVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbYHaCVc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 22:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756235AbYHaCVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 22:21:23 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2908 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756202AbYHaCVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 22:21:22 -0400
Date: Sat, 30 Aug 2008 22:21:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Frans Pop <elendil@planet.nl>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [regression] usb: sometimes dead keyboard after boot
In-Reply-To: <200808301640.21043.elendil@planet.nl>
Message-ID: <Pine.LNX.4.44L0.0808302202250.514-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Aug 2008, Frans Pop wrote:

> The patch seems to do exactly what I was looking for! Details further 
> down, but first some other comments.
> 
> 
> My first boot with your patch was with brltty still enabled. The log 
> showed the right result, but I wanted to get a cleaner log without all 
> the USB suspend/resume noise caused by brltty. So I disabled brltty's 
> init script and rebooted.
> 
> This gave a totally unexpected result: ehci now got loaded and initialized 
> _before_ uhci which of course avoids the problem altogether (see attached 
> log: dmesg_ehci-first). So apparently brltty's init script was 
> responsible not only for the suspend/resume noise, but also influenced 
> the load order of the two USB drivers.
> And apparently when things are left alone ehci _will_ be loaded before 
> uhci, but that does not match what you described in earlier mails as it 
> means the PCI bus order isn't followed. Confusing...

It _is_ confusing.  There's so much going on at boot time, with tons of
processes all trying to run at once...  Small changes can have
unexpectedly large effects.

What I said before was that the UHCI controllers are discovered and
registered before the EHCI controller.  That's different from the order
in which the drivers are loaded, however; driver loading is managed
by the hotplug infrastructure in userspace, which is outside the
kernel's control.  If your drivers had been built into the kernel
instead of as separate modules, then they would be probed in order of 
discovery -- which would mean ehci-hcd would _always_ come after 
uhci-hcd, not what you want.

(Actually even this might not be true any more.  There are patches in 
development which make certain parts of the kernel initialization, 
including driver probing, run in parallel threads rather than 
serially.)

> Anyway, this meant that to test your patch I had to try to get uhci to 
> load first again. This turned out to be simple: just adding uhci_hcd 
> in /etc/modules did the trick. The result is in dmesg_uhci-first.
> 
> That log shows what was desired, at least 3-1 and 4-1 get disconnected 
> cleanly and I get no error messages to the console. Yay!
> 
> I added two extra printk's around the usb_wait_for_khubd_idle call to show 
> the exact effect of the wait (look for "khubd_idle" in two messages). 
> These seem to show what was wanted: both keyboard and mouse are detected 
> during the wait.

So it worked as intended.

> But it also shows a few events on bus 3 and 4 that happen after I get 
> khubd_idle that seem to indicate the probe on that bus is not completely 
> finished and that could maybe still cause "problems". But maybe I'm just 
> reading it wrong and those events are part of the lead up to the 
> disconnects for the hand-off.

Both statements are correct.  The initialization of the devices on 
buses 3 and 4 _was_ complete.  But the drivers were loaded later, so 
driver probing and/or normal driver operation were in progress when 
ehci-hcd interrupted things.  Initialization != probing.

Remember what I said earlier, that EHCI initialization would interfere 
with _any_ ongoing operations on the companion controllers?  Now you're 
seeing that effect in action.

> Anyway, I'm quite happy with the result, so:
> Tested-by: Frans Pop <elendil@planet.nl>

I still regard this more as a band-aid than anything else.  In fact, it 
should (in theory) be _safer_ to interrupt things during device 
initialization than later, after the driver has started up.  So I'm not 
at all certain the patch should be merged.

Tomorrow I'll try asking for comments from other people on the mailing
list...

Alan Stern

