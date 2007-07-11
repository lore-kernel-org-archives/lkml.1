Return-Path: <linux-kernel-owner+w=401wt.eu-S1759746AbXGKIzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759746AbXGKIzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 04:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbXGKIzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 04:55:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706AbXGKIza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 04:55:30 -0400
Message-ID: <46949AFD.5030101@redhat.com>
Date: Wed, 11 Jul 2007 10:55:25 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Hanno Zulla <abos@hanno.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Nova-T, cx88-dvb & "cx88_wakeup: 2 buffers handled (should be
 1)"
References: <4693C318.8040105@hanno.de>
In-Reply-To: <4693C318.8040105@hanno.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Using a Nova-T dvb card, I get the following in /var/log/messages...
> 
> 22:09:54 kernel: cx88_wakeup: 2 buffers handled (should be 1)

> ...every few seconds while watching TV with xine or other dvb-apps. The
> event results in a visible interruption of the video stream.

I've added the printk some years ago.  I stopped maintaining v4l/dvb
bits two years ago, so it's a bit a shot into the dark because I have no
idea what has changed recently in the driver.

The message is in no way critical, the driver should cope just fine with
the situation, and as usually some more buffers are queued for dma it
also doesn't imply dvb stream data got lost.  It seems in your case some
data actually got lost though, otherwise the effect wouldn't be visible.

Background:  The card raises an interrupt for each filled buffer, so in
theory each time the irq handler runs it should handle a single buffer.
 If it is more than one it means the irq handler wasn't called in time
or wasn't called at all for some reason.

Could be someone in the kernel blocked interrupts for a insane long
time, so the hardware managed to fill the one more buffer before the irq
handler was actually called.  Could be IRQ handling in the cx88 driver
is screwed.  Could be a scheduling issue (Is this a core2 duo?  If so
check the longish discussion on about that here in lkml, subject "long
freezes on thinkpad t60").

> The problem appears to be shared irq resources [3]. However, my
> mainboard doesn't allow to choose specific irqs for pci slots and
> anyway, shared irqs shouldn't break this dvb card, in the first place.

Could also be the irq handler for the other device sharing the same irq
being very slow.  Any pattern here that it is linked to some specific
device sharing the irq?

cheers,
  Gerd
