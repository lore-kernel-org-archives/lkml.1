Return-Path: <linux-kernel-owner+w=401wt.eu-S1765059AbZLQUrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765059AbZLQUrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 15:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764899AbZLQUrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 15:47:10 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:36185 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764894AbZLQUrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 15:47:08 -0500
Message-ID: <4B2A98BB.5080406@knaff.lu>
Date: Thu, 17 Dec 2009 21:46:51 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: markh@compro.net, fdutils@fdutils.linux.lu, linux-kernel@vger.kernel.org
Subject: Re: DMA cache consistency bug introduced in 2.6.28 (Was: Re: [Fdutils]
 Cannot format floppies under kernel 2.6.*?)
References: <4AFB3962.2020106@ntlworld.com> <4B26884C.8000306@knaff.lu> <4B2697C4.2040204@compro.net> <4B26A82E.5040902@knaff.lu> <4B26B031.4060301@compro.net> <4B26BAE3.2090408@knaff.lu> <4B275975.8040509@cfl.rr.com> <4B275B18.80704@knaff.lu> <4B275D37.4090807@cfl.rr.com> <4B2761E9.2030301@knaff.lu> <4B276513.6030509@cfl.rr.com> <4B276753.80807@knaff.lu> <4B27983F.5090600@compro.net> <4B27EF18.7050101@knaff.lu> <4B28FDEB.3030800@compro.net> <4B290029.90602@knaff.lu> <4B2901DB.8040403@compro.net> <4B29052B.9070406@knaff.lu> <4B292D84.5040306@compro.net> <4B29624F.2080109@knaff.lu> <4B2A3805.8040707@compro.net> <4B2A3E3E.8060405@knaff.lu> <4B2A4975.8020809@compro.net> <4B2A49F4.6070402@compro.net> <4B2A4B86.8060307@knaff.lu> <4B2A4C78.10107@compro.net> <4B2A4CF7.6040000@knaff.lu> <4B2A4EC9.2030902@compro.net> <4B2A4FA5.5000701@knaff.lu> <4B2A5192.6090602@compro.net> <4B2A530D.3080606@knaff! .lu> <4B2A6394.3080705@knaff.lu> <alpine.LFD.2.00.0912170916420.15740@localhost.locald!
 omain>
In-Reply-To: <alpine.LFD.2.00.0912170916420.15740@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 17 Dec 2009, Alain Knaff wrote:
>> 1. initial contents:  33 44 55 66
>> 2. one DMA transfer is performed
>> 3. program changes buffer to: 77 88 99 aa
>> 4. new DMA transfer is performed => instead it transmits 33 88 99 aa
>>    (i.e. first byte is from previous contents)
>>
>> This used to work in 2.6.27.41, but broke in 2.6.28 . It doesn't happen on
>> all hardware though.
> 
> Do you have a list of hardware it works on? Especially chipsets.

For the moment, I have a very small sample of hardware:
1. One machine which works (my own): Athlon XP 1800+ processor
2. One which doesn't work (Mark's)

I might get access to a wider sample of boxen in a week or so, in order
to do some stats.

What's the easiest way to find out the chipset?

Here's already the output of lspci from my machine (works):

00:00.0 Host bridge: VIA Technologies, Inc. VT8377 [KT400/KT600 AGP]
Host Bridge
00:01.0 PCI bridge: VIA Technologies, Inc. VT8235 PCI Bridge
00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 80)
00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 80)
00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 80)
00:10.3 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 82)
00:11.0 ISA bridge: VIA Technologies, Inc. VT8235 ISA Bridge
00:11.1 IDE interface: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
00:11.5 Multimedia audio controller: VIA Technologies, Inc.
VT8233/A/8235/8237 AC97 Audio Controller (rev 50)
00:12.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II]
(rev 74)
01:00.0 VGA compatible controller: nVidia Corporation NV17 [GeForce4 MX
440] (rev a3)


[...]
> I'm not entirely surprised. Actual CPU bugs are pretty rare in the x86 
> world. But chipset bugs? Another thing entirely. There are buffers and 
> caches there, and those are sometimes software-visible. The most obvious 
> case of that is just the IOMMU's themselves, but from your description I 
> don't think you actually change the DMA _mappings_ do you? Just the 
> actual buffer (that was then mapped earlier)?

No, I don't change any DMA mappings. And the buffer is still the same
physical buffer, at the same physical address.

(It happens during formatting the floppy drive: here the first byte
happens to be the trackid of the first physical sector of the track, and
it always ends up being the track of the *previously* formatted track).

> So I don't think it's the IOMMU code itself necessarily, although an IOMMU 
> may well be involved (eg I could easily see a few cachelines worth of 
> actual DMA data caching going on in the whole IOMMU too)
> 
> And to some degree the floppy driver might be _more_ likely to see some 
> kinds of bugs, because it uses that crazy legacy DMA engine. So it's not 

Indeed, most other drivers use "bus master" DMA, that doesn't use the
legacy DMA controller at all, but use DMA controllers hosted on the
device itself...

> going to go through the regular PCI DMA hardware paths, it's going to go 
> through its own special paths that nobody else uses any more (and thus has 
> probably not had as much testing).
> 
>> In the diff between 2.6.27.41 and 2.6.28, I noticed a lot of changes in
>> arch/x86/kernel/amd_iommu.c and related files, could any of these have
>> triggered this behavior?
> 
> Could it have triggered? Sure. Chipset caches are often flushed by certain 
> trivial operations (often the caches are small, and operations like "any 
> PIO access" will make sure they are flushed). Different IOMMU flush 
> patterns could easily account for it.
> 
> But I think we'd like to see a list of hardware where this can be 
> triggered,

We'll get a list of 2 machines relatively quickly (unless other people
would like to chime in: the test is easy, just fdformat a floppy disk),
and more in a week or so.

> and quite frankly, a 'git bisect' would be absolutely wonderful 

How exactly would I use this (command line sample)?

> especially if the list of hardware is not showing any really obvious 
> patterns (and I assume they aren't all _that_ obvious, or you'd have 
> mentioned them).
> 
> 			Linus

Thanks,

Alain
