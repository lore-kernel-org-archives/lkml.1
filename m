Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYGaHio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYGaHio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 03:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbYGaHig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 03:38:36 -0400
Received: from mail.lippert-at.com ([62.80.22.186]:49803 "EHLO
	domex.lippertembedded.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751529AbYGaHif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 03:38:35 -0400
X-Greylist: delayed 916 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jul 2008 03:38:35 EDT
Message-ID: <48916864.901@LiPPERTEmbedded.de>
Date: Thu, 31 Jul 2008 09:23:16 +0200
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andres Salomon <dilinger@debian.org>
CC: linux-geode@bombadil.infradead.org, linux-kernel@vger.kernel.org
Subject: MFGPT driver inhibits boot on some boards
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jul 2008 07:23:41.0650 (UTC) FILETIME=[5BC72B20:01C8F2DE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

I've got the problem that Linux kernels with MFGPT clocksource support
won't boot on any of our Geode-LX/CS5536 based boards (4 different
models), and I'd be grateful for your opinion/help. Sorry for the long
mail, but things are a bit complex.

The symptom is that the MFGPT driver registers itself, but is not
producing any timer ticks. Due to its rating, MFGPT soon is selected as
clocksource, and the kernel simply starves on the next occasion. Users
see a hang on boot, no errors nor warnings, but lots of innocent
messages after MFGPT init to get them off track.


Reason: mfgpt is using both wrong IRQ and baseaddress. I'll get to the
IRQ issue first.


The driver defaults to IRQ7. Our boards use this for the parallel port.
This alone would be ok, but the parallel port is on a LPC SIO, so IRQ7
is routed to the LPC bus in MSR 51400025, so MFGPT IRQs are not received.

Possible solution 1: make geode_mfgpt_set_irq() clear the needed bit in
MSR 51400025. This would break lp0, but at least Linux would boot and
users could cat /proc/interrupts and see what's going on.

Possible solution 2: make geode_mfgpt_set_irq() check the bit and fail
if the IRQ is routed to LPC. (I think I'd prefer this over 1.)

But that's not clean, even an IRQ not routed to LPC might be the wrong
one. The BIOS we're using (Insyde BIOS, uses VSA and 5 MFGPTs, but
leaves 3 timers available) exports a PCI header for MFGPT, which of
course gets an IRQ assigned (LNKB-->IRQ11), and this is the right IRQ to
use. Some autodetection instead of hardcoding IRQ7 would be perfect. But
looking for the PCI header won't work, because AMD removed them from the
spec, most BIOSes don't support them (any more) and some day our BIOS
will hide them, too.

I guess MSR 51400022 aka MSR_PIC_ZSEL_LOW is the key here.
geode_mfgpt_set_irq() overwrites this unconditionally, which I think is
bad. If the BIOS has already set an IRQ here, the driver should keep it
and assume it to be ok.

Possible solution 3: keep the IRQ already chosen in MSR_PIC_ZSEL_LOW
unless it's 0, only in that case use IRQ7

But how about CMP1 and CMP2? geode_mfgpt_set_irq() currently sets IRQs
for both, but I think it's better to only read/set the IRQ for the
requested CMP, because they might differ.

In fact, they do differ, because pairs of MFGPTs always share an IRQ
(stupid idea, that): E.g. VSA sets CMP1 of MFGPT7 to IRQ2, so its twin
MFGPT3, which itself is available, has its CMP1 also set to IRQ2. But
the clocksource driver only requests CMP2, so MFGPT3 could still be used.

Possible solution 4: only touch the CMP actually requested. But also
fail if this CMP is set to IRQ2, because this means VSA is using its twin.

IMHO hardcoding IRQ7 is bad. Yes, you can override it, but this isn't
some non-critical device driver like audio where only this one device
won't work. And MFGPT can't be compiled as module, so initramfs can't do
anything about it.
I think, if there is any chance to do it, Linux should be able to boot
without any parameters given - even if with reduced functionality.


Now about the baseaddress issue:


The problem is that Linux upon PCI scan detects a resource conflict
(which in fact is none, but Linux cannot know that) and moves the
resources (MFGPT IO space among them) to some other place.

But init_lbars() in geode_32.c has saved all base addresses in an array
_before_ the move, and geode_get_dev_base() and geode_mfgpt_write() keep
using these addresses _after_ the move.

Possible solutions 5-7:
* drop the array and always read the baseaddr from the MSR - but this
  would impact performance quite a lot, I guess
* run init_lbars() only after the PCI scan - but they might be needed
  before that, and what if someone changes the base again, say with
  setpci?
* update the array every time the base is changed - but I have no idea
  how to do that ...

Anyway, the baseaddr issue is not that serious for me, I will probably
be able to fix the bogus resource conflict that triggers the baseaddr
move, and this issue will disappear. But still - mfgpt will still crash
again if someone moves the resource for any reason ...


Well, that's what I've figured out so far. (Thanks if you're still
reading on!)  :-)   I might be able to implement some fixes for the IRQ
issue, but I'd like your opinion first. What do you think?

Best regards,
Jens Rottmann

