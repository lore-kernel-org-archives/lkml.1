Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbXIEUOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbXIEUOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 16:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbXIEUOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 16:14:06 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48510 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756964AbXIEUOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 16:14:04 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 5 Sep 2007 22:12:17 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Sleep problems with kernels >= 2.6.21 on powerpc
To: Andrew Morton <akpm@linux-foundation.org>
cc: rael@edge.ping.de, michal.k.k.piotrowski@gmail.com, rbrito@gmail.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       debian-powerpc@lists.debian.org, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, krh@redhat.com
In-Reply-To: <20070905124411.bc15f48c.akpm@linux-foundation.org>
Message-ID: <tkrat.29a16d2ec8698ff2@s5r6.in-berlin.de>
References: <6540c930708251937o2a9a23efv72a0f2b8947067bd@mail.gmail.com>
 <6bffcb0e0708261621q25316becqce7b3ae2176f45a8@mail.gmail.com>
 <20070827065246.GA21220@ime.usp.br> <46D279E8.10001@edge.ping.de>
 <46D72BC6.3020809@edge.ping.de>
 <20070905100754.57ab4e3e.akpm@linux-foundation.org>
 <46DEEBBE.4070201@s5r6.in-berlin.de>
 <20070905124411.bc15f48c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On  5 Sep, Andrew Morton wrote:
>> On Wed, 05 Sep 2007 19:47:42 +0200 Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> >>> Trying to free already-free IRQ 40
>> >>> pci_set_power_state(): 0002:20:0e.0: state=3, current state=5
>> >>> firewire_ohci: pci_set_power_state failed with -22<3>pci_device_suspend(): pci_suspend+0x0/0x9c [firewire_ohci]() returns -22
...
>> The old ohci1394.c used to ignore pci_set_power_state's return value.
>> In the pre 2.6.19-rc1 commit ea6104c22468239083857fa07425c312b1ecb424, I
>> added a fail-on-error.  This was toned down to a printk-on-err by pre
>> 2.6.19-rc4 commit 346f5c7ee7fa4ebee0e4c96415a7e59716bfa1d0.
> 
> OK.
> 
>> This was because of Benjamin Herrenschmidt's regression report:
>> http://lkml.org/lkml/2006/10/24/13
> 
> It's not clear _why_ pci_set_power_state() is failing.

The only -22 error path in pci_set_power_state is this:

	/* Validate current state:
	 * Can enter D0 from any state, but if we can only go deeper 
	 * to sleep if we're already in a low power state
	 */
	if (state != PCI_D0 && dev->current_state > state) {
		printk(KERN_ERR "%s(): %s: state=%d, current state=%d\n",
			__FUNCTION__, pci_name(dev), state, dev->current_state);
		return -EINVAL;
	} [...else...]

(There seems to be one "if" too many in the comment.)


dev->current_state was PCI_UNKNOWN, and this is not properly handled by
pci_set_power_state.  Some checks later, there is

	switch (dev->current_state) {
	case PCI_D0:
	case PCI_D1:
	case PCI_D2:
		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
		pmcsr |= state;
		break;
	case PCI_UNKNOWN: /* Boot-up */
		if ((pmcsr & PCI_PM_CTRL_STATE_MASK) == PCI_D3hot
		 && !(pmcsr & PCI_PM_CTRL_NO_SOFT_RESET))
			need_restore = 1;
		/* Fall-through: force to D0 */
	default:
		pmcsr = 0;
		break;
	}

But the PCI_UNKNOWN branch will never be reached because of the if ()
clause quoted above.

Also, this FireWire controller here surely had left the boot-up phase
already long ago when the reporter tried to suspend the machine.
-- 
Stefan Richter
-=====-=-=== =--= --=-=
http://arcgraph.de/sr/


