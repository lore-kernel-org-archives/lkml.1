Return-Path: <linux-kernel-owner+w=401wt.eu-S1752285AbXEXS4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbXEXS4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 14:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbXEXS4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 14:56:24 -0400
Received: from terminus.zytor.com ([192.83.249.54]:51068 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbXEXS4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 14:56:23 -0400
Message-ID: <4655DF34.7000507@zytor.com>
Date: Thu, 24 May 2007 11:53:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.22-rc1-mm1: IDE compile error
References: <20070515201914.16944e04.akpm@linux-foundation.org>	<20070516185552.GA4086@stusta.de>	<200705240145.38055.bzolnier@gmail.com> <20070524115549.01c0e1ca@the-village.bc.nu>
In-Reply-To: <20070524115549.01c0e1ca@the-village.bc.nu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> hd.c:(.init.text+0x44a7d): undefined reference to `drive_info'
>>> hd.c:(.init.text+0x44a89): undefined reference to `drive_info'
>>> hd.c:(.init.text+0x44a95): undefined reference to `drive_info'
>>> hd.c:(.init.text+0x44aa1): undefined reference to `drive_info'
>>> hd.c:(.init.text+0x44aad): undefined reference to `drive_info'
>>> drivers/built-in.o:hd.c:(.init.text+0x44ab9): more undefined references to `drive_info' follow
>>> make[1]: *** [.tmp_vmlinux1] Error 1
>>>
>>> <--  snip  -->
>>>
>>> Considering the fact that we have two more recent drivers with the same 
>>> functionality, it might be an option to simply remove this driver...
>> Care to send a patch?
> 
> hd.c can drive MFM and RLL disks and drivers/ide cannot. Although it
> really wants burying further down the config tree the ability to read MFM
> and RLL disks when recovering ancient data is useful and people do
> actually use this driver now and then rescuing stuff like twenty year old
> datasets.
> 
> It thus needs fixing not removing.

Why is this driver parked in drivers/ide/legacy when the companion
driver, xd.c, is in drivers/block (where hd.c used to be at one point,
too)?  Especially so since it's not really for IDE, but for ST-506.

HOWEVER, the code that fails above hard-assumes that the ST-506 disks
that you have are your primary system drives, which is obviously a wrong
assumption -- ST-506 drives were obsolete quite a while before Linux
existed[1].

xd.c, on the other hand, seems to actually go out and query the hardware
directly.  I guess this is understandably, since this controller would
never have been primary.

If hd.c is pure legacy, which it obviously is, should we remove the code
to assume the BIOS settings are the MFM/RLL settings (i.e. the __i386__
clause), and instead do something more like the __arm__ clause which
means that "if you really want to use this you have to specify the
parameters manually"?

	-hpa


[1] The 386-16 that I had access to at Northwestern, which with 0.59
BogoMIPS was the slowest Linux system in existence until Linux was
ported to other architectures, might have been an ST-506 drive, but I'm
not sure.
