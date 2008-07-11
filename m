Return-Path: <linux-kernel-owner+w=401wt.eu-S1757145AbYGKTHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145AbYGKTHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbYGKTHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:07:25 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:15930 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbYGKTHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:07:25 -0400
X-BigFish: VPS-15(zz1432R98dR7efV1805Mzz10d3izzz32i6bh87il43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3UVRO-02-JJW-01
Date: Fri, 11 Jul 2008 13:10:45 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: David Brigada <brigad@rpi.edu>
CC: jim.cromie@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       linux-geode@lists.infradead.org
Subject: Re: PCI-ISA Bridge not operating
Message-ID: <20080711191045.GB29570@cosmic.amd.com>
References: <487774F9.6000001@rpi.edu> <20080711164845.GB28720@cosmic.amd.com> <4877908C.4060706@rpi.edu> <4877AD63.3000405@rpi.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4877AD63.3000405@rpi.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 11 Jul 2008 19:07:10.0770 (UTC) FILETIME=[521CC120:01C8E389]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/08 14:58 -0400, David Brigada wrote:
> David Brigada wrote:
> > Jordan Crouse wrote:
> >> On 11/07/08 10:58 -0400, David Brigada wrote:
> >>> Hi,
> >>>
> >>> I'm working with the MSM800XEV board from Digital-Logic.  This board 
> >>> uses a Geode LX800 for a CPU and has the CS5536 companion board also 
> >>> installed.  The board works with an IT8888G IC that provides a PCI/ISA 
> >>> bridge to a PC/104 bus that is externally provided.
> >>>
> >>> If I boot with FreeDOS, I can twiddle I/O ports, and the proper ISA 
> >>> signaling comes over the PC/104 bus.  In Linux, the /IOW or /IOR line 
> >>> goes low as expected, but the address doesn't come over the bus.  The 
> >>> DOS that I'm running doesn't seem to have any specific drivers for the 
> >>> chip, I'm guessing that the hardware should "just work" --- the IT8888G 
> >>> is designed to grab I/O requests in the ISA range off the PCI bus after 
> >>> a short delay if nothing else grabs them first.
> >>>
> >>> I have a feeling that it has something to do with the CS5536 companion 
> >>> chip, as it seems as though there is a driver for a PCI/ISA bridge on 
> >>> that chip, though I can't get much detail from AMD's datasheet on that 
> >>> functionality.  I do know that on the MSM800XEV, any such functionality 
> >>> is wired to the IT8888G, not the CS5536.
> >>>
> >>> There are two kernel config options related to the PCI IDs of the parts 
> >>> of the device that handle the ISA bus, CONFIG_SCx200_ACB and 
> >>> CONFIG_CS5535_GPIO.  I've tried disabling both, but it doesn't seem to help.
> >>>
> >>> In lspci, the CS5536 PCI/ISA bridge is shown, but not the IT8888G.
> >>>
> >>> Any ideas?
> >> ISA should indeed "just work".  The only thing I'm wondering is if
> >> the kernel is interfering (it shouldn't).  I assume that since it works
> >> in FreeDOS that there is no possibility that something on the PCI bus
> >> is grabbing the cycles instead.
> > 
> > That's what I'm thinking --- that the CS5536 PCI/ISA bridge is claiming 
> > the cycles.
> > 
> >> How are you trying to access the device in Linux?  Through a kernel module
> >> or a user application running as root?
> > 
> > I've tried both.  I have a kernel module that I wrote for the hardware. 
> >   When I couldn't get that working, I tried looping some code that keeps 
> > touching the same I/O port that I'm using.
> > 
> >> Jordan
> >>
> > 
> > Dave
> 
> Looking through the documentation for the CS5536, in the "CS56536 
> Companion Device Data Book," section 5.2.8, it says the following:
> 
>  > If the SDOFF (Subtractive Decode Off) bit in the GLPCI_MSR_CTRL (MSR
>  > 51000010h[10]) is cleared (reset value), any PCI transaction, other
>  > than Configuration Read/Write, Interrupt Acknowledge, and Special
>  > Cycle transactions, not claimed by any device (i.3., not asserting
>  > DEVSEL#) within the default active decode cycles (three cycles
>  > immediately after FRAME# being asserted) will be accepted by GLPCI_SB
>  > at the fourth clock edge.
> 
> This is the same behavior that the IT8888G chip uses --- it waits three 
> cycles for another device to claim it and then passes the transaction 
> along.  I'm guessing that the CS5536 might be grabbing it (maybe it's 
> electrically closer, or the logic is more optimized) before the IT8888G 
> can handle it.
> 
> Does this seem feasible as to what could be happening?

Sure, but then why does FreeDOS work?  It shouldn't be any different
when the bits hit the line.

Jordan
-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

