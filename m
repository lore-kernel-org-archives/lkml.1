Return-Path: <linux-kernel-owner+w=401wt.eu-S1760910AbYARBRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910AbYARBRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760765AbYARBQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:16:57 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:25814 "EHLO
	outbound6-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760847AbYARBQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:16:55 -0500
X-Greylist: delayed 2146 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jan 2008 20:16:55 EST
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Thu, 17 Jan 2008 17:40:53 -0700
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "Arnd Hannemann" <hannemann@i4.informatik.rwth-aachen.de>
cc: "Andres Salomon" <dilinger@queued.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc8 hangs at mfgpt-timer
Message-ID: <20080118004053.GN8244@cosmic.amd.com>
References: <20080116165606.3ebc06a4@ephemeral>
 <478F25D6.3060503@i4.informatik.rwth-aachen.de>
 <20080117134032.4cc1a1cf@ephemeral>
 <478FB255.5040001@i4.informatik.rwth-aachen.de>
 <20080117211917.GF8244@cosmic.amd.com>
 <478FCDB6.4010708@i4.informatik.rwth-aachen.de>
 <20080117223644.GK8244@cosmic.amd.com>
 <478FDC12.6020505@i4.informatik.rwth-aachen.de>
 <20080117225744.GL8244@cosmic.amd.com>
 <478FE733.2030806@i4.informatik.rwth-aachen.de>
MIME-Version: 1.0
In-Reply-To: <478FE733.2030806@i4.informatik.rwth-aachen.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 18 Jan 2008 00:40:21.0534 (UTC)
 FILETIME=[B4D543E0:01C8596A]
X-WSS-ID: 6B912A1607S8378495-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/01/08 00:39 +0100, Arnd Hannemann wrote:
> Jordan Crouse schrieb:
> > On 17/01/08 23:52 +0100, Arnd Hannemann wrote:
> > 
> > <snip>
> > 
> >>> Hmmm - not sure whats happening here.  I wonder if we're stuck in an
> >>> interrupt storm of some sort as soon as you register the interrupt handler.
> >>> But I would think that whatever was causing the interrupt storm would be
> >>> running well before we hit setup_irq(), and you would be recording "nobody
> >>> cared" interrupts left and right.
> >> Interesting thing is that it hangs not in setup_irq() but later, right
> >> after printing the newline of the printk.
> > 
> > THat makes me think interrupt storm even more.
> > 
> >>> The thing that scares me is that the TinyBIOS seems to know that we want
> >>> to use the MFGPT timers, and I wonder if they did anything behind the scenes
> >>> to "help us out" even though we didn't ask for it.
> >>>
> >>> I don't know how easy it would be for you - but can you try reading 
> >>> MSRs 0x51400020 - 0x51400023?   If you need a command line app to do it,
> >>> you can use rdmsr from here:
> >>>
> >>> http://wiki.laptop.org/go/Flashing_LinuxBIOS_on_A-Test_Boards
> >> MSR register 0x51400020 => b7:ef:5f:f4:bf:d1:95:68
> >> MSR register 0x51400021 => b7:fd:1f:f4:bf:cf:5a:d8
> >> MSR register 0x51400022 => b7:f3:bf:f4:bf:f5:fb:a8
> >> MSR register 0x51400023 => b7:fb:9f:f4:bf:fd:d9:f8
> > 
> > Hmmm - those look wrong.  Is /dev/cpu/0/msr there?  The applet on the
> > wiki has a bug that doesn't check for it.
> I'm sorry, I should have checked: I didn't execute rdmsr as root.
> The correct ones:
> 
> MSR register 0x51400020 => 00:00:00:00:00:00:0f:00
> MSR register 0x51400021 => 00:00:00:00:04:00:00:00
> MSR register 0x51400022 => 00:00:00:00:00:00:00:00
> MSR register 0x51400023 => 00:00:00:00:00:0c:ba:90

Okay - those are sane.  Those are the IRQ routing MSRs - each nibble is an
IRQ for something in the southbridge - since 7 doesn't appear, a rogue
interrupt isn't likely.  Also, [0:31] in 0x51400022 are the MFGPT interrupts
specifically, and they are 0.  The timer tick code would set the first nibble
to 7 (in a sane system).

So, everything _seems_ okay from the hardware side.  The next step would be
to comment out the setup_irq() function and write a C app or something to
verify that all the MFGPT registers are set up like we expect them to be.
However, I think that maybe we can accomplish the same thing with the
forthcoming watchdog timer, since it will prove the MFGPT is behaving
well (though it doesn't use the interrupt wrapper, but one step at a time).

Jordan
-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.


