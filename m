Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbXKVBnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbXKVBnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 20:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbXKVBnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 20:43:05 -0500
Received: from mfbak.jpl.nasa.gov ([137.78.160.179]:58534 "EHLO
	mfbak.jpl.nasa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbXKVBnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 20:43:04 -0500
X-Greylist: delayed 2071 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Nov 2007 20:43:04 EST
Subject: Where is the interrupt going?
From: Al Niessner <Al.Niessner@jpl.nasa.gov>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 21 Nov 2007 17:08:30 -0800
Message-Id: <1195693710.5544.240.camel@morte.jpl.nasa.gov>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Source-IP: morte.jpl.nasa.gov [137.78.15.44]
X-Source-Sender: Al.Niessner@jpl.nasa.gov
X-AUTH: Authorized
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Quickly stated, I have a piece of hardware on the PCI bus that is
generating an interrupt (can watch it with a scope) but my handler is
not being called (no printk in /var/log/messages). So, where has the
interrupt gone?

Obligatory information:
1) I have done the google search and mailing list search finding lots of
ancillary information but not what I needed.
2) Yes, it is my fault, but I need some help from people more directly
involved in the kernel than myself to point out what I am doing wrong.
3) Thanks for any and all help in advance.

On with the detailed technical information. I developed a kernel module
for an PCI card back in 2.4, moved it to 2.6.3, then 2.6.11 or so and
now I am trying to move it to 2.6.22. When I began the to move to
2.6.22, I changed all of the deprecated calls for finding the card on
the PCI bus, modified the interrupt handler prototype, and changed my
readvv/writev to aio_read/aio_write following
http://lwn.net/Articles/202449/. So initialization looks like this:

p8620 = pci_get_device (APC8620_VENDOR_ID, APC8620_DEVICE_ID, p8620);
<... fail if p8620 is 0 ...>
apcsi[i].ret_val = register_chrdev (MAJOR_NUM,

DEVICE_NAME,

&apc8620_ops);
<... fail if ret_val < 0 ...>
apcsi[i].board_irq = p8620->irq;
status = request_irq (apcsi[i].board_irq,
                                      apc8620_handler,
                                      IRQF_DISABLED,
                                      DEVICE_NAME,
                                      (void*)&apcsi[i]);
<... fail if status != 0 ...>

I do check all of the return values to verify the call happened
successfully. There are some memory mapping calls that I have left out
since they are working while the interrupt is not.

Things seem to work for the most part because I can read/write data
through a memory map and verify the IndustryPack modules on the carrier
through their header. The memory map is still working sufficiently well
that I can program up one of the IndustryPack modules to generate an
interrupt every 2 seconds or so. Prior to my changes for 2.6.22 this
worked quite well. Since it is the interrupt portion of this game that
is giving me grief, lets stick with just that. apc8620_handler is:

static irqreturn_t apc8620_handler (int irq,
                                                               void
*did)
{
  printk (KERN_NOTICE "apc8620: did (0x%lx)\n", (unsigned long)did);
  <... other irrelevant steps ...>
  return IRQ_HANDLED;
}

I would then expect that every two seconds or so I would see a message
from apc8620_handler pop up. Instead I see nothing. Poking around I see
that the kernel module is loaded and attached to my devices and set for
IRQ 10:

lsmod:                          -> acromag8620          4207556  0 
cat /proc/devices       -> 46 apc8620
cat /proc/interrupts -> 10:          0   IO-APIC-edge      apc8620

With /proc/interrupts, LOC keeps growing at a rate faster than what my
hardware is generating and I have no idea what LOC means, but ERR and
MIS (I take it to mean error and missed respectively) are both 0 and
remain 0 indefinitely.

In /var/log/messages, I do not see any missing interrupt messages or any
other report indicating that there is some trouble.

Assuming no one sees the error I am making right off the bat and would
like me to probe the interrupt system a little bit more, please give me
a suggestion as to where to poke. There is lots of code there and I
would prefer to have guided poke over a random one.

Anyway, I read through linux/interrupts.h looking for some bit, flag, or
call that I have omitted but found nothing. I understand why the
interrupt handlers have changed, but the changes made should not be
causing this problem.

Again, any and all help in finding my lost interrupt is much
appreciated.

Lastly, I would be happy to give out the entire module to anyone who
requests it, but it is about 550 lines so I did not want to attach it to
this already long post.

-- 
Al Niessner
818.354.0859

All opinions stated above are mine and do not necessarily reflect those
of JPL or NASA.

--------
|  dS  | >= 0
--------


