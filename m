Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbYILMVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbYILMVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 08:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbYILMVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 08:21:43 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59973 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbYILMVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 08:21:42 -0400
Date: Fri, 12 Sep 2008 14:23:11 +0200
From: Pavel Machek <pavel@suse.cz>
To: Anders Aagaard <aagaande@gmail.com>
Cc: suspend-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Suspend-devel] Resume performance
Message-ID: <20080912122310.GA1669@elf.ucw.cz>
References: <48C10908.60101@gmail.com> <200809051308.14079.rjw@sisk.pl> <48C13827.1010409@gmail.com> <200809052043.38677.rjw@sisk.pl> <48C3AE68.5010902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C3AE68.5010902@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-09-07 12:35:20, Anders Aagaard wrote:
> Rafael J. Wysocki wrote:
> > On Friday, 5 of September 2008, Anders Aagaard wrote:
> >> Rafael J. Wysocki wrote:
> >>> On Friday, 5 of September 2008, Anders Aagaard wrote:
> >>>> Hi
> >>> Hi,
> >>>
> >>> This is a kernel problem, so let's CC the LKML.
> >>>
> >>>> I have a intel P35 board with a quad core cpu in it, it's currently 
> >>>> running as a server for a small network, and I'd like to be able to shut 
> >>>> it down when idle, and use wake on lan to wake it up when it's needed. 
> >>>> Now I got that part working quite well, but for some reason I have a 
> >>>> long delay in resume.
> >>>>
> >>>> I seem to remember being able to resume this computer in 2-3 seconds 
> >>>> when I was testing it, now it needs 35 seconds to resume.  It seems 
> >>>> regardless of resume options used, and it always resumes to a working 
> >>>> state without problems.
> >>> What kernel are you using at the moment and which one was used for the
> >>> testing?
> >> I'm using gentoo's 2.6.25-r7, I've also tried vanilla sources.
> > 
> > Would it be possible to test 2.6.27-rc5-gi7 from kernel.org?
> 
> Tested, makes no difference.
> 
> > 
> >>>> I've tried quite a lot of things, booting with noapic/nosmp, booting a 
> >>>> kernel without usb/network drivers, disabling ahci (using ata_piix 
> >>>> driver instead of ahci), and there's always that one long delay.  And 
> >>>> I'm not quite sure how the kernel printk timing information works, so 
> >>>> I'm not sure whats causing that delay.
> >>>>
> >>>> Output from dmesg when booting with nosmp (to get accurate timing data):
> >>>> scripts/show_delta -b "Force enabled HPET at resume"
> >>>> [349.821150 < 7.039261 >] ata3.00: configured for UDMA/133
> >>>> [349.821160 < 7.039271 >] sd 2:0:0:0: [sdc] 976773168 512-byte hardware 
> >>>> sectors (500108 MB)
> >>>> [349.821165 < 7.039276 >] sd 2:0:0:0: [sdc] Write Protect is off
> >>>> [349.821166 < 7.039277 >] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> >>>> [349.821173 < 7.039284 >] sd 2:0:0:0: [sdc] Write cache: enabled, read 
> >>>> cache: enabled, doesn't support DPO or FUA
> >>>> [349.972801 < 7.190912 >] ata1: SATA link up 3.0 Gbps (SStatus 123 
> >>>> SControl 300)
> >>>> [349.979060 < 7.197171 >] ata1.00: configured for UDMA/133
> >>>> [349.979070 < 7.197181 >] sd 0:0:0:0: [sda] 976771055 512-byte hardware 
> >>>> sectors (500107 MB)
> >>>> [349.979075 < 7.197186 >] sd 0:0:0:0: [sda] Write Protect is off
> >>>> [349.979076 < 7.197187 >] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> >>>> [349.979083 < 7.197194 >] sd 0:0:0:0: [sda] Write cache: enabled, read 
> >>>> cache: enabled, doesn't support DPO or FUA
> >>> It looks like this happens here.  Can you try to unload the network driver
> >>> before suspend, please?
> >> I tried to build a kernel without it, and it still takes the exact same 
> >> amount to boot, I've also tried unloading usb drivers and it takes the 
> >> exact same amount of time.
> > 
> > Can you try to boot with init=/bin/bash and suspend to RAM?  (Please have a
> > look at section 2 of Documentation/power/basic-pm-debugging.txt in the newer
> > kernel sources).
> 
> I checked without X before, but forgot to unload the nvidia module, that 
> apparently makes a big difference, I did some numbers with 
> scripts/show_delta -b "Back to C".
> 
> Nvidia and X : 32 seconds
> No X (same result as booting with init=/bin/bash) : 8.3 seconds
> Git kernel : 8.2 seconds
> Light kernel (no sound, network card and usb drivers) : 8.17 seconds
> ATI card instead of nvidia : 8.22 seconds
> 
> I think we found the problem, I already replaced nvidia hardware in one 
> computer to resolve another issue.  Really appreciate your help on this 
> issue, this resume time works pretty well for me, it was a bit 
> ridiculous when I could boot faster than resume.
> 
> Is 8 seconds fairly expected?  My other computer (same ati card) boots 
> in about 2 seconds, but there's a lot less hardware in it (6 hd's and a 
> ton of usb devices in one computer, 1 hd and 1 usb device in the other). 
>   I checked cold booting with and without usb devices, my light kernel 
> boots to /bin/bash in 2.5 seconds, normal kernel about 7-8.  But I dont 
> see anything about usb on resume.

8 seconds sounds long but reasonable...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
