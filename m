Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYKHL52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYKHL52 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 06:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYKHL5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 06:57:19 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:21567 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbYKHL5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 06:57:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from:sender;
        b=RKWEtq+1/JY8JF9hwCbVUwEBjS2QwAu69YsLuv2PcKsfjJXnsP4w+r8O7/6qa0WFQR
         jgzcLlJ2ssX6Q5q6pMJ6ObHQhP3fa5Cr43XgzGjx/gkBdKdAV8K8o/sbBEi/ADaj/vdH
         BGK/2ttohfiHxWqyMLdMNGal4Hlrxukj1+j4c=
Message-ID: <49157E97.60503@tuffmail.co.uk>
Date: Sat, 08 Nov 2008 11:57:11 +0000
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       ath5k-devel@venema.h4ckr.net, alsa-devel@alsa-project.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: Bugs on aspire one A150
References: <491506DB.1070000@gmail.com>
In-Reply-To: <491506DB.1070000@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Levitsky wrote:
> I have just bought an Aspire one A150, XP version,
> as it was the only available here, and installed ubuntu on it.
> 
> Bugs I discovered so far:
> 
> 
> ** 1 - embedded controler works in polling mode, due to this:
> 
> [    0.708571] ACPI: EC: non-query interrupt received, switching to interrupt mode
> [    1.224043] ACPI: EC: missing confirmations, switch off interrupt mode.
> 
> 
> Maybe this is the reason for the fact that gnome power manager freezes when I unplug
> the AC, and freezes often when I try to see battery status.
> 
> 
> (Note: same is seen on my acer aspire 5720)

That sounds like a known issue.  It has been resolved by "ACPI: EC: revert msleep patch".  Happily Len submitted it for mainline this week.  You will also find it if you try the acpi-test git tree.  We're all hoping 2.6.28 will be much improved in terms of reliable operation of different ECs :).

> ** 2 - wireless: not to mention the fact that ath5k wasn't installed by default in ubuntu...
> wireless more or less works, but kernel log is full of backtraces.

Well, that doesn't tell us much.  Did they still happen after upgrading to 2.6.28-rc3?  Can we see them?

> Was able to connect to my WPA2 access point.
> Sometimes wireless fails completely, especially after suspend to ram.
> Advanced features like monitor/injection work, but when I changed the card's
> mac address it stopped working.
> I also noticed that if I then start airodump, then wireless works with new mac.
> 
> 
> 
> ** 3 - internal mic doesn't work.
> tried model=acer, model=auto.
> Overall it seems that alsa misprograms O/B realteck
> codec.
> I talk about this later.
> Have same issue on my acer 5720
> 
> 
> 
> ** 4 - wireless led doesn't work.
> ath5k devs, can you fix this?
> 
> 
> ** 5 - coretemp doesn't show cpu temperature,
> I have seen somewhere that atom support same thermal diode as core2
> and only patch to detect it is needed.
> Please include such path in 2.6.28 if exists.
> 
> 
> ** 6 - both card readers are missing from lspci, is this normal?

A similar bug has been reported as a regression:

<http://bugzilla.kernel.org/show_bug.cgi?id=11828>

so one assumes that it worked on the machines with linux pre-installed.  Hopefully without requiring any hacks.

It seems that for now a workaround may be to pass the option debug_quirks=1 to the sdhci module...

<http://marc.info/?l=linux-kernel&m=122509648027303&w=2>

...or that it may help if you insert an SD card before booting.

Apparently the reporter also investigated pcie hotplug.  Probably the BIOS doesn't provide the normal support.  You can try "modprobe pciehp pciehp_force=1", maybe it helps the kernel discover the devices.  It worked for something else on my EeePC.  But then it will reportedly disappear the ethernet controller.

However, at the moment pciehp can cause delays of 10s of seconds during resume.
 
> ** 7 - opengl is broken, I tried running neverball in fullscreen, but it shows wrong/corrupted
> textures (compiz is running, and working well thought)
>  
> Now I installed 2.6.28-rc3 (actually latest -git)
> 
> 
> Sadly nothing improved.
> I only found few regressions:
> 
> 
> 
> * Wireless now drops connection from my WPA2 access point after few minutes.
> I changed temporarily its wireless protection to WEP and open mode, and both work
> fine, maybe this is related to periodic key exchange WPA does?
> 
> * System doesn't reboot/shutdown, just hangs.

Could be this:

<http://bugzilla.kernel.org/show_bug.cgi?id=11942>

As a fix, 8fd145917fb62368a9b80db59562c20576238f5a was reverted from the acpi tree.  This has also been submitted to mainline.

Thanks for your work!  If you continue with this, I suggest CC'ing <kernel-testers@vger.kernel.org>.  That will help Rafael the regression hunter pick it up.

Alan
