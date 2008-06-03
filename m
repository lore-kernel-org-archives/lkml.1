Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbYFCXwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbYFCXwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 19:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbYFCXwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 19:52:35 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:50810 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYFCXwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 19:52:33 -0400
Message-ID: <4845D937.2000205@keyaccess.nl>
Date: Wed, 04 Jun 2008 01:52:23 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [patch 15/15] PNP: convert resource options to single linked
 list
References: <20080530224853.976744229@ldl.fc.hp.com> <20080530224934.357694359@ldl.fc.hp.com> <4845A217.3030701@keyaccess.nl>
In-Reply-To: <4845A217.3030701@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03-06-08 21:57, Rene Herman wrote:

> The other quirks look good -- but I have the hardware and will test them 
> specifically.

The other quirks are good (In the sense that they work as before. The 
comments below doubting them have nothing to do with Bjorn reworking 
them). The options display is with the 0x100 | prio thing fixed locally 
already.


== 1 == quirk_awe32_resources, CTL0022:

* pre-quirk:

Dependent: 00 - Priority preferred
   port 0x620-0x620, align 0x0, size 0x4, 16-bit address decoding
Dependent: 01 - Priority acceptable
   port 0x620-0x680, align 0x1f, size 0x4, 16-bit address decoding

* post-quirk:

Dependent: 00 - Priority preferred
   port 0x620-0x620, align 0x0, size 0x4, 16-bit address decoding
   port 0xa20-0xa20, align 0x0, size 0x4, 16-bit address decoding
   port 0xe20-0xe20, align 0x0, size 0x4, 16-bit address decoding
Dependent: 01 - Priority acceptable
   port 0x620-0x680, align 0x1f, size 0x4, 16-bit address decoding
   port 0xa20-0xa80, align 0x1f, size 0x4, 16-bit address decoding
   port 0xe20-0xe80, align 0x1f, size 0x4, 16-bit address decoding


I actually expect this quirk to be totally bogus. This adds ports which 
isapnp_set_resources is then going to try to program into hardware which 
wouldn't be expecting them. The ALSA driver only references port0 (the 
0x620 one) and hardcodes the two other ports at +0x400 and +0x800 
itself. I expect the issue is simply that the offsetted ones alias and 
somebody once thought this could be a way to just reserve those or 
something.

It's been there since the dawning of time though. Will look at some 
other time. Things work fine.


== 2 == quirk_cmi8330_resources, @X@0001 (Invalid ID!)

* pre-quirk:

Dependent: 00 - Priority preferred
   port 0x220-0x220, align 0x0, size 0x10, 10-bit address decoding
   irq 5 High-Edge
   dma 1 8-bit byte-count compatible
   dma 5 16-bit word-count compatible
Dependent: 01 - Priority acceptable
   port 0x220-0x240, align 0x1f, size 0x10, 10-bit address decoding
   irq 5,7,2/9,10 High-Edge
   dma 0,1,3 8-bit byte-count compatible
   dma 5,7 16-bit word-count compatible
Dependent: 02 - Priority acceptable
   port 0x220-0x240, align 0x1f, size 0x10, 10-bit address decoding
   irq 5,7,2/9,10,11,12 High-Edge
   dma 0,1,3 8-bit byte-count compatible
   dma 5,7 16-bit word-count compatible

* post-quirk:

Dependent: 00 - Priority preferred
   port 0x220-0x220, align 0x0, size 0x10, 10-bit address decoding
   irq 5,7,10 High-Edge
   dma 1,3 8-bit byte-count compatible
   dma 5 16-bit word-count compatible
Dependent: 01 - Priority acceptable
   port 0x220-0x240, align 0x1f, size 0x10, 10-bit address decoding
   irq 5,7,10 High-Edge
   dma 1,3 8-bit byte-count compatible
   dma 5,7 16-bit word-count compatible
Dependent: 02 - Priority acceptable
   port 0x220-0x240, align 0x1f, size 0x10, 10-bit address decoding
   irq 5,7,10 High-Edge
   dma 1,3 8-bit byte-count compatible
   dma 5,7 16-bit word-count compatible


I'll need to verify if this wasn't just someone with a busted DMA 
channel 0 and too few free interrupts. Unlikely quirk...


== 3 == quirk_sb16audio_resources, CTL0042:

* pre-quirk:

Dependent: 00 - Priority preferred
   irq 5 High-Edge
   dma 1 8-bit byte-count compatible
   dma 5 16-bit word-count compatible
   port 0x220-0x220, align 0x0, size 0x10, 16-bit address decoding
   port 0x330-0x330, align 0x0, size 0x2, 16-bit address decoding
   port 0x388-0x388, align 0x0, size 0x4, 16-bit address decoding
Dependent: 01 - Priority acceptable
   irq 5,7,2/9,10 High-Edge
   dma 0,1,3 8-bit byte-count compatible
   dma 5,6,7 16-bit word-count compatible
   port 0x220-0x280, align 0x1f, size 0x10, 16-bit address decoding
   port 0x300-0x330, align 0x2f, size 0x2, 16-bit address decoding
   port 0x388-0x388, align 0x0, size 0x4, 16-bit address decoding
Dependent: 02 - Priority acceptable
   irq 5,7,2/9,10 High-Edge
   dma 0,1,3 8-bit byte-count compatible
   dma 5,6,7 16-bit word-count compatible
   port 0x220-0x280, align 0x1f, size 0x10, 16-bit address decoding
   port 0x300-0x330, align 0x2f, size 0x2, 16-bit address decoding
Dependent: 03 - Priority acceptable
   irq 5,7,2/9,10 High-Edge
   dma 0,1,3 8-bit byte-count compatible
   dma 5,6,7 16-bit word-count compatible
   port 0x220-0x280, align 0x1f, size 0x10, 16-bit address decoding
Dependent: 04 - Priority acceptable
   irq 5,7,2/9,10 High-Edge
   dma 0,1,3 8-bit byte-count compatible
   port 0x220-0x280, align 0x1f, size 0x10, 16-bit address decoding
   port 0x300-0x330, align 0x2f, size 0x2, 16-bit address decoding
   port 0x388-0x388, align 0x0, size 0x4, 16-bit address decoding
Dependent: 05 - Priority acceptable
   irq 5,7,2/9,10 High-Edge
   dma 0,1,3 8-bit byte-count compatible
   port 0x220-0x280, align 0x1f, size 0x10, 16-bit address decoding
   port 0x300-0x330, align 0x2f, size 0x2, 16-bit address decoding
Dependent: 06 - Priority acceptable
   irq 5,7,2/9,10 High-Edge
   dma 0,1,3 8-bit byte-count compatible
   port 0x220-0x280, align 0x1f, size 0x10, 16-bit address decoding
Dependent: 07 - Priority functional
   irq 5,7,2/9,10 High-Edge
   dma 0,1,3 8-bit byte-count compatible
   dma 5,6,7 16-bit word-count compatible
   port 0x220-0x280, align 0x1f, size 0x10, 16-bit address decoding
   port 0x300-0x330, align 0xf, size 0x2, 16-bit address decoding
   port 0x388-0x394, align 0x3, size 0x4, 16-bit address decoding

* post-quirk:

Dependent: 00 - Priority preferred
   irq 5 High-Edge
   dma 1 8-bit byte-count compatible
   dma 5 16-bit word-count compatible
   port 0x220-0x220, align 0x0, size 0x10, 16-bit address decoding
   port 0x330-0x330, align 0x0, size 0x2, 16-bit address decoding
   port 0x388-0x3f8, align 0x0, size 0x4, 16-bit address decoding
Dependent: 01 - Priority acceptable
   irq 5,7,2/9,10 High-Edge
   dma 0,1,3 8-bit byte-count compatible
   dma 5,6,7 16-bit word-count compatible
   port 0x220-0x280, align 0x1f, size 0x10, 16-bit address decoding
   port 0x300-0x330, align 0x2f, size 0x2, 16-bit address decoding
   port 0x388-0x3f8, align 0x0, size 0x4, 16-bit address decoding
Dependent: 02 - Priority acceptable
   irq 5,7,2/9,10 High-Edge
   dma 0,1,3 8-bit byte-count compatible
   dma 5,6,7 16-bit word-count compatible
   port 0x220-0x280, align 0x1f, size 0x10, 16-bit address decoding
   port 0x300-0x330, align 0x2f, size 0x2, 16-bit address decoding
Dependent: 03 - Priority acceptable
   irq 5,7,2/9,10 High-Edge
   dma 0,1,3 8-bit byte-count compatible
   dma 5,6,7 16-bit word-count compatible
   port 0x220-0x280, align 0x1f, size 0x10, 16-bit address decoding
Dependent: 04 - Priority acceptable
   irq 5,7,2/9,10 High-Edge
   dma 0,1,3 8-bit byte-count compatible
   port 0x220-0x280, align 0x1f, size 0x10, 16-bit address decoding
   port 0x300-0x330, align 0x2f, size 0x2, 16-bit address decoding
   port 0x388-0x3f8, align 0x0, size 0x4, 16-bit address decoding
Dependent: 05 - Priority acceptable
   irq 5,7,2/9,10 High-Edge
   dma 0,1,3 8-bit byte-count compatible
   port 0x220-0x280, align 0x1f, size 0x10, 16-bit address decoding
   port 0x300-0x330, align 0x2f, size 0x2, 16-bit address decoding
Dependent: 06 - Priority acceptable
   irq 5,7,2/9,10 High-Edge
   dma 0,1,3 8-bit byte-count compatible
   port 0x220-0x280, align 0x1f, size 0x10, 16-bit address decoding
Dependent: 07 - Priority functional
   irq 5,7,2/9,10 High-Edge
   dma 0,1,3 8-bit byte-count compatible
   dma 5,6,7 16-bit word-count compatible
   port 0x220-0x280, align 0x1f, size 0x10, 16-bit address decoding
   port 0x300-0x330, align 0xf, size 0x2, 16-bit address decoding
   port 0x388-0x394, align 0x3, size 0x4, 16-bit address decoding

I'll need to verify if the OPL chip in fact works when not on 0x388 (to 
0x394 as set 7 allows for) or if this was just someone believing it 
would. I haven't tested all supported IDs (I might have them all) but if 
there are none that do _not_ allow the OPL to be completely absent as 
this CTL0042 (an early Soundblaster AWE64) does, this quirk should just 
go anyway.


=== 4 === quirk_ad1815_mpu_resources, ADS7151

These results are with the dependent cloning already removed locally.

* pre-quirk:

irq 5,7,2/9,11,12 High-Edge
Dependent: 00 - Priority preferred
   port 0x330-0x330, align 0x0, size 0x2, 10-bit address decoding
Dependent: 01 - Priority acceptable
   port 0x300-0x300, align 0x0, size 0x2, 10-bit address decoding
Dependent: 02 - Priority functional
   port 0x100-0x3fe, align 0x1, size 0x2, 10-bit address decoding

* post-quirk:

irq 5,7,2/9,11,12 High-Edge
Dependent: 00 - Priority preferred
   port 0x330-0x330, align 0x0, size 0x2, 10-bit address decoding
Dependent: 01 - Priority acceptable
   port 0x300-0x300, align 0x0, size 0x2, 10-bit address decoding
Dependent: 02 - Priority functional
   port 0x100-0x3fe, align 0x1, size 0x2, 10-bit address decoding


See why that "(optional)" flag display is good? :-) I ofcourse tested 
things and the flag works great...


== 5 == quirk_add_irq_optional_dependent_sets, ADS7181

* pre-quirk:

Dependent: 00 - Priority preferred
   irq 2/9 High-Edge
   port 0x330-0x330, align 0xf, size 0x2, 16-bit address decoding
Dependent: 01 - Priority acceptable
   irq 2/9 High-Edge
   port 0x300-0x330, align 0xf, size 0x2, 16-bit address decoding
Dependent: 02 - Priority functional
   irq 2/9,10,11 High-Edge
   port 0x300-0x330, align 0xf, size 0x2, 16-bit address decoding

* post-quirk:

Dependent: 00 - Priority preferred
   irq 2/9 High-Edge
   port 0x330-0x330, align 0xf, size 0x2, 16-bit address decoding
Dependent: 01 - Priority acceptable
   irq 2/9 High-Edge
   port 0x300-0x330, align 0xf, size 0x2, 16-bit address decoding
Dependent: 02 - Priority functional
   irq 2/9,10,11 High-Edge
   port 0x300-0x330, align 0xf, size 0x2, 16-bit address decoding
Dependent: 03 - Priority functional
   irq 2/9 High-Edge
   port 0x330-0x330, align 0xf, size 0x2, 16-bit address decoding
Dependent: 04 - Priority functional
   irq 2/9 High-Edge
   port 0x300-0x330, align 0xf, size 0x2, 16-bit address decoding
Dependent: 05 - Priority functional
   irq 2/9,10,11 High-Edge
   port 0x300-0x330, align 0xf, size 0x2, 16-bit address decoding


Again needs the flag display to make sense but as intended and works fine.

The PCI one didn't change here...

Rene.
