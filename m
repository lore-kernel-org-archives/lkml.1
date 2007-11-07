Return-Path: <linux-kernel-owner+w=401wt.eu-S1759045AbXKGRsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045AbXKGRsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843AbXKGRsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:48:46 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:33971 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783AbXKGRsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:48:46 -0500
X-Greylist: delayed 1670 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Nov 2007 12:48:45 EST
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: is minimum udelay() not respected in preemptible SMP kernel-2.6.23?
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
Date: Wed, 7 Nov 2007 19:21:52 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200711071921.52330.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have written a linux device driver for a frame grabber I use in my 
every day experimental work.

In my device driver I have to write to a MMIO register, wait for a while 
(using udelay(65)) for data being written to an internal register (i2c?)
and test a flag (in another MMIO register) if the operation has completed. 
(The hardware guarantees that the operation has completed in less than 
65 usec). If the flag is not reset I write a message via printk.
After switching to the kernel-2.6.23 (compiled as PREEMPTIBLE SMP i686)
(AMD dual core) I see this message in dmesg output sometime.

Testing with rdtscll() before and after udelay(65) shows the expected
delay of 65 usec (after dividing by CPU frequency) when all is OK, but
gives a big value (in the tenths msec range) when the error message 
shows itself in dmesg. 

Bracketing udelay(65) by:

local_irq_disable();
udelay(65);
local_irq_enable();

as well as by

preempt_disable();
udelay(65); 
preempt_enable();

leads to message disappearing.

I believe the hardware is working correctly, so if the flag is not reset 
I think udelay(65) returns prematurely (the flag clears some time latter)
And it does not matter if I use udelay(65) or udelay(100).

What could be the reason for such a behavior?
Is this a bug in udelay() due to preemption?
(udelay() being preempted and migrated to another processor)

All my previous kernels used were SMP (but not PREEMPTIBLE)

My kernel is compiled with:
CONFIG_PREEMPT=y
CONFIG_IRQBALANCE=y
CONFIG_HPET_TIMER=y

And I have this line in dmesg:
Time: acpi_pm clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1

The south bridge is: VIA VT8237 (Asus A8V Delux)

Thank you in advance for your help in understanding  where
the problem is coming from.

Best regards.

Marin Mitov
