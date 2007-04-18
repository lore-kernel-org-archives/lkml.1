Return-Path: <linux-kernel-owner+w=401wt.eu-S2992422AbXDRMrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992422AbXDRMrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 08:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422975AbXDRMrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 08:47:40 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:49735 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1422976AbXDRMrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 08:47:39 -0400
Message-ID: <462613A3.9060402@ru.mvista.com>
Date: Wed, 18 Apr 2007 16:48:35 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Mike Mattie <codermattie@gmail.com>
CC: Adrian Bunk <bunk@stusta.de>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.21-rc7 hpt366 driver broken
References: <20070415224846.52a465b6@reforged>	<20070416043822.0ea2490e@reforged>	<20070416143613.GD10338@stusta.de>	<20070416182112.4fcbb87f@reforged>	<20070416194303.58545412@reforged>	<20070416202515.2fe46f65@reforged> <20070417213048.033af0fc@reforged>
In-Reply-To: <20070417213048.033af0fc@reforged>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Mike Mattie wrote:

> I have added Sergei Shtylyov to the address list after seeing his recent posts on hpt366 issues, and the
> git changelog for the hpt366.c driver. I am very confident that I have pinpointed the defect in the driver.

   Indeed you have. Thank you.

>>>>>[ Cc's added, full bug report was in
>>>>>http://lkml.org/lkml/2007/4/16/18 ]

>>>>>On Mon, Apr 16, 2007 at 04:38:22AM -0700, Mike Mattie wrote:

>>>>>>On Sun, 15 Apr 2007 22:48:46 -0700
>>>>>>Mike Mattie <codermattie@gmail.com> wrote:

>>>>>>>Hello,

>>>>>>>I am testing the 2.6.21-rc7 kernel release. The IDE hpt366
>>>>>>>driver is crashing hanging the boot. I have basically the
>>>>>>>same config as 2.6.20.7 which works fine (except for
>>>>>>>netconsole mentioned in a previous mail).

>>>>>>>here is the hand-copied info:

>>>>>>>* "unable to handle paging request" , null deref
>>>>>>>* EIP @ init_chipset_hpt366

>>>>>>>I am running a git-bisect to see if I can resolve it to a
>>>>>>>commit.

>>>>>>This was identified as the first broken commit:

>>>>>>commit 7b73ee05d0acb926923d43d78b61add776ea4bb1
>>>>>>Author: Sergei Shtylyov <sshtylyov@ru.mvista.com>
>>>>>>Date:   Wed Feb 7 18:18:16 2007 +0100

>>>>>>    hpt366: init code rewrite

>>>>>>Reverting is conflicted so it will be a bit longer before I
>>>>>>pin-point any other build-breaks.

>>>>>Thanks for your report.

>>>>>Can you use a digital camera for taking a photograph of the
>>>>>crash?

>>>>I can later on tonight, by about 11PM west coast. I also saw
>>>>some hex offsets after the function pointed to by EIP, is there
>>>>a way to decode that to a line number ? I have debugging symbols
>>>>enabled.

>>>>I am also doing printk breadcrumbs to pin it down to a block
>>>>or a line.

>>>I have narrowed the crash with breadcrumbs down to these lines:

>>>	/*
>>>	 * Only try the DPLL if we don't have a table for the PCI
>>>clock that
>>>	 * we are running at for HPT370/A, always use it  for
>>>anything newer... *
>>>	 * NOTE: Using the internal DPLL results in slow reads on 33
>>>MHz PCI.
>>>	 * We also  don't like using  the DPLL because this causes
>>>glitches
>>>	 * on PRST-/SRST- when the state engine gets reset...
>>>	 */
>>>	if (info->chip_type >= HPT374 || info->settings[clock] ==
>>>NULL) { u16 f_low, delta = pci_clk < 50 ? 2 : 4;
>>>		int adjust;
>>>
>>>		printk(KERN_INFO "inside the if\n");
>>>
>>>		 /*
>>>		  * Select 66 MHz DPLL clock only if UltraATA/133
>>>mode is
>>>		  * supported/enabled, use 50 MHz DPLL clock
>>>otherwise... */
>>>		if (info->max_mode == 0x04) {
>>>			dpll_clk = 66;
>>>			clock = ATA_CLOCK_66MHZ;
>>>		} else if (dpll_clk) {	/* HPT36x chips don't
>>>have DPLL */ dpll_clk = 50;
>>>			clock = ATA_CLOCK_50MHZ;
>>>		}
>>>
>>>		if (info->settings[clock] == NULL) {

>>                ^^^^^^^^ crashes here

>>since info is deref'd all over the place I am assuming it is the array
>>that is blowing up.

>>I printk'd the value of clock which is "4". that array is either not
>>setup correctly , or it is out-of-bounds (speculation)

> here on line 493: the hpt302n ( The chipset I have ) is the only struct without
> a .settings field , I am extremely confident this is the exact location of the bug.
 
> static struct hpt_info hpt302n __devinitdata = {
> 	.chip_type	= HPT302N,
> 	.max_mode	= HPT302_ALLOW_ATA133_6 ? 4 : 3,
> 	.dpll_clk	= 77,
> };

   Argh, a missed line! :-< And what a pity that I've only maneged to test on plain HPT302 chip and this managed to slip past the review too. :-(

> I do not know enough about the HPT chips to correctly select which settings group
> this field should be initialized to. Please take a look, the fix now should be very
> easy.

   It should be hpt37x_settings, of course. I'll submit a patch in a couple jiffies...

MBR, Sergei
