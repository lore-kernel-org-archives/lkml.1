Return-Path: <linux-kernel-owner+w=401wt.eu-S1751926AbYGCME2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbYGCME2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbYGCMEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:04:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:59376 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbYGCMEL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:04:11 -0400
Subject: Re: Intel Microcode loader, tg3 driver, and the -rc8-mmotd New
	World Order firmware...
From: Kay Sievers <kay.sievers@vrfy.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>, Valdis.Kletnieks@vt.edu,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jonathan@jonmasters.org, Shaohua Li <shaohua.li@intel.com>,
       greg@kroah.com, arjan@infradead.org
In-Reply-To: <1215081776.10393.531.camel@pmac.infradead.org>
References: <4534.1215048758@turing-police.cc.vt.edu>
	 <Pine.LNX.4.61.0807030716030.10434@ginsburg.homenet>
	 <32146.1215066947@turing-police.cc.vt.edu>
	 <Pine.LNX.4.61.0807030743230.10608@ginsburg.homenet>
	 <1215077028.10393.497.camel@pmac.infradead.org>
	 <1215080554.9721.62.camel@linux.site>
	 <1215081776.10393.531.camel@pmac.infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Thu, 03 Jul 2008 13:32:07 +0200
Message-Id: <1215084727.9721.82.camel@linux.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX1+T09EtBGIPqBrUSMsodePeF2BYMzD0k7y6KMl
 Fo5COqitm2FXd9rSu6ImYUlGuPG3n8piRtnYCBReKKPfM985eI
 5addWd4a0FiVNYup1sRdZbRCiXaT8+3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-03 at 11:42 +0100, David Woodhouse wrote:
> On Thu, 2008-07-03 at 12:22 +0200, Kay Sievers wrote:
> > So, maybe a:
> >   # rewrite firmware file name to all-in-one Intel CPU microcode data file
> >   SUBSYSTEM=="firmware", ENV{FIRMWARE}=="intel-ucode/*", ENV{FIRMWARE}="intel-ucode/microcode.dat"
> > would be enough?
> 
> Nah, it needs the binary form. The actual 'microcode.dat' just looks
> like this...

Ah, I see.

> 0x00000001,     0x00000013,     0x02062001,     0x00000683,
> 0x2f0da1b0,     0x00000001,     0x00000001,     0x00000000,
> 0x00000000,     0x00000000,     0x00000000,     0x00000000,
> 0xbf5ad468,     0xc79f5237,     0xbd53889e,     0x896bfd13,
> 0x7adc0c8f,     0x44e9e0bc,     0x1a331fc9,     0x00b0f479,
> 
> That's all microcode_ctl actually does; read in the text file and output
> the (complete) binary. Hence:
>       /sbin/microcode_ctl -f "$DIR/microcode.dat" -d /sys$DEVPATH/data
> 
> At a later date, we could make userspace output only the part for the
> desired CPU, and rip out the kernel-side code which searches for it
> within the big blob. That was presumably the intention in the commit
> which changed things. But then again, the kernel-side code still needs
> to do a certain amount of sanity checking on what it receives -- so I'm
> not sure we gain a huge amount by trying to remove that functionality
> from the kernel (not that I've looked hard at the line count).

﻿I think, the in-kernel selection logic is nice, people can still
provide a custom .bin file which contains only the needed code for the
actual CPU, and it will not really do any "search", right?

> If we're _not_ going to make userspace provide only what's required, and
> we keep the selection code in the kernel, then I don't see the point in
> having separate firmware filenames for different cpus. We could just
> change the driver to call request_firmware("intel-microcode.bin") and do
> this one-off conversion:
> 	touch /lib/firmware/intel-microcode.bin
> 	microcode_ctl -d /lib/firmware/intel-microcode.bin

Sounds fine, yeah. With the in-kernel search, we should make the file
just a name without the CPU id. This would also make it easier to find
and include the fw into the kernel, right?

We could always export the CPU id somewhere else, so "advanced" tools
could look it up in sysfs and upload in a "custom" way. I don't think
anybody will really need that. :)

Thanks,
Kay

