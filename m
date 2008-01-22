Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbYAVUxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbYAVUxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYAVUxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:53:42 -0500
Received: from slowhand.arndnet.de ([88.198.19.76]:42252 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753026AbYAVUxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:53:41 -0500
Message-ID: <47965806.6080903@i4.informatik.rwth-aachen.de>
Date: Tue, 22 Jan 2008 21:54:30 +0100
From: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jordan Crouse <jordan.crouse@amd.com>
CC: Lars Heete <hel@admin.de>, Andres Salomon <dilinger@queued.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc8 hangs at mfgpt-timer
References: <20080116165606.3ebc06a4@ephemeral> <478FCDB6.4010708@i4.informatik.rwth-aachen.de> <4795B14C.7040502@i4.informatik.rwth-aachen.de> <200801221111.21240.hel@admin.de> <4795D120.7070806@i4.informatik.rwth-aachen.de> <20080122192757.GC5241@cosmic.amd.com>
In-Reply-To: <20080122192757.GC5241@cosmic.amd.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jordan Crouse schrieb:
>> Indeed.
>> Strange, it works at least with mfgpt_irq=8 (rtc) and mfgpt_irq=5 (audio):
> 
> I have most excellent news.  I was able to get tinyBIOS booting on my
> development platform.  I looked at the problem with the debugger and
> I think I might have found something.  It looks like the interrupt is
> firing immediately before the clock is enabled.  In the handler, we
> were returning immediately if the clock wasn't enabled (and not clearing
> the event), so we were caught in a classic interrupt storm.
> 
> The attached patch rearranges the code so that the handler is installed
> before we setup the interrupt (so we have somebody to listen to the
> immediate interrupt), and it makes sure that we clear the event in the IRQ
> handler regardless of the state of the timer tick.

This patch indeed solves the problem. The board boots fine. Great work!

  0:         48    XT-PIC-XT        timer
  2:          0    XT-PIC-XT        cascade
  4:        493    XT-PIC-XT        serial
  7:      25875    XT-PIC-XT        mfgpt-timer
  8:          3    XT-PIC-XT        rtc
 10:      56963    XT-PIC-XT        eth0
 15:          1    XT-PIC-XT        ehci_hcd:usb1, ohci_hcd:usb2
NMI:          0   Non-maskable interrupts
TRM:          0   Thermal event interrupts
SPU:          0   Spurious interrupts
ERR:          0

> 
> I'm not 100% sure why this happens on IRQ7 but not on 5 or 8, but it might
> have something to do with the interrupts already being enabled on the other
> vectors.  Anyway, please try this test patch and let me know what happens.

Congratulations for this long but successful remote debugging ;-)

Greetings,
Arnd

