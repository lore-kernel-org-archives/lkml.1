Return-Path: <linux-kernel-owner+w=401wt.eu-S932873AbXHFVjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873AbXHFVjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 17:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbXHFVjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 17:39:44 -0400
Received: from mithrandir.softwarenexus.net ([66.98.186.96]:4729 "EHLO
	mail.genesi-usa.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbXHFVjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 17:39:43 -0400
Message-ID: <46B79562.9020202@genesi-usa.com>
Date: Mon, 06 Aug 2007 22:40:50 +0100
From: Matt Sealey <matt@genesi-usa.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Alan Curry <pacman@TheWorld.com>
CC: Segher Boessenkool <segher@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: Pegasos keyboard detection
References: <200708020440.l724edCT290676@shell01.TheWorld.com>
In-Reply-To: <200708020440.l724edCT290676@shell01.TheWorld.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Okay before you add to the nvramrc you also need to add probe-all to build the
device tree first; I assumed this was common knowledge.

probe-all
" /pci/isa/8042" find-device
" 8042" encode-string device-type
install-console
banner

That should do it. Without probe-all/install-console/banner in the nvramrc they
will be run by the boot process (this is documented in the IEEE 1275 specs)

Yeah it will break for people on their first boot but let's put a few things
across;

1) Pegasos has been discontinued. The number of people with this bug are in
the low thousands - if they upgrade to 2.6.22 at all.

2) The fix was in the wrong place anyway, if it was going to be done anywhere
at all it needs to be in arch/powerpc/kernel/prom_init.c:fixup_device_tree_chrp()
like the ISA ranges breakage (which is on Briq) and IDE IRQ misnumbering fix.
Not the keyboard platform driver.

3) In any case this should be something that is fixed in the firmware, as any
stalwart, stubborn Linux developer will rant at you about. If you can't get a
firmware update or it's not fixed, this is the best place to do it.

As for Segher, bootwrapper not such a good place as that's still mussing up
the kernel with these fixes. Let the boot loader do it for the OS, and don't
mess up the OS with device-tree fixups. After all it may not just be Linux
that stumbles on it. Why have the same patch in every OS?

With nvramrc, the fix is done for EVERY operating system from firmware upwards.
The semi-official Genesi line of support and what I have been told by the board
designer is if you need to fix something in the device tree, that is what nvramrc
is for, and that is why Open Firmware runs Forth scripts.

I have a fixup script for Pegasos and one for Efika which I may publish at some
point in the very near future. We may ship a small patch for Marcin Kurek's
"BootCreator" (http://tbs-software.com/morgoth/projects.html) which includes
all the stuff. We may write our own binary bootloader.. I am waiting for the
result of the new firmware feature requests before we waste time on stuff
bplan is silently fixing.

-- 
Matt Sealey <matt@genesi-usa.com>
Genesi, Manager, Developer Relations

Alan Curry wrote:
> Matt Sealey writes the following:
>> Yeah please do a fixup for the boot wrapper.
>>
>> Or, if you have trouble, go into the firmware and type "nvedit", add
>> these lines;
>>
>> " /isa/8042" find-device
>> " 8042" encode-string device-type
>>
>> (then ctrl-c to exit and nvstore to run it on next reboot. Try it without
>> the patch first, on the firmware console, just to be sure I got it right,
>> because I can't test it here)
> 
> It works from the ok prompt but in the nvramrc it doesn't find the device.
> (pci/isa nodes not created yet?)
> 
> But the larger point:
> 
>> You don't need to patch Linux at all. In fact for silly things like this
>> I would recommend against it :)
> 
> If the workaround doesn't go into the kernel, everybody with affected
> hardware has to individually find out about the bug (probably by experiencing
> an annoying keyboardless boot) and fix it himself. Is that worth the
> reduction in kernel clutter?
> 
