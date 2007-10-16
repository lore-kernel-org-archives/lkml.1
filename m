Return-Path: <linux-kernel-owner+w=401wt.eu-S934994AbXJPTbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934994AbXJPTbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 15:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761578AbXJPTbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 15:31:31 -0400
Received: from rtr.ca ([76.10.145.34]:1075 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760687AbXJPTbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 15:31:31 -0400
Message-ID: <47151191.40406@rtr.ca>
Date: Tue, 16 Oct 2007 15:31:29 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: pcihpd-discuss@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIe Hotplug:  NFG unless I boot with card already inserted.
References: <4714C0A6.1030204@rtr.ca>	<4714D700.7060008@rtr.ca>	<20071016084634.8a0d695a.kristen.c.accardi@intel.com>	<47150565.5090102@rtr.ca> <20071016114328.a96e8bcb.kristen.c.accardi@intel.com> <47150982.6050102@rtr.ca> <471509FE.7080505@rtr.ca>
In-Reply-To: <471509FE.7080505@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Mark Lord wrote:
>> Kristen Carlson Accardi wrote:
>>> On Tue, 16 Oct 2007 14:39:33 -0400
>>> Mark Lord <lkml@rtr.ca> wrote:
>>>
>>>> I also checked my modprobe.d/ options, and I am using pciehp_force=1.
>>>> Without that flag, none of this ever works.
>>>
>>> OK - I suspected something like this.  Most Dell computers don't support
>>> ExpressCard hotplug using Native PCIe -- in fact, I've not seen a single
>>> one, they explicitly disable it because they have not validated it or
>>> they have and something didn't work right.  I'll take a look at what 
>>> you've
>>> got, but be aware that you are forcing pciehp to load and operate on 
>>> a system
>>> where they've certainly either not tested it, or tested it and something
>>> bad happened.
>>
>> Perhaps.  But this one works perfectly, except for two driver bugs:
>>
>> 1. Driver does not notice already-inserted cards after modprobe.
>> 2. Driver fails to function after suspend/resume until reloaded.
>>
>> Both of those are fixable in the kernel.
> 
> Ahh.. point 2 in particular suffers from "suspend/resume" not implemented.
> Or rather, implemented as a pair of "do nothing" functions.

This patch below seems to fix point 1 on my system,
causing pciehp to become aware of already-inserted cards on module load.

It's not perfect, but I believe it does show the kind of functionality
that's missing from the driver.

The resume() function will need something similar, to poll the slots
on resume and call pciehp_enable_slot() or pciehp_disable_slot()
as appropriate.

I suspect this is broken even on machines that do have ACPI BIOS
support.

Cheers

Not for kernel inclusion (yet), but..

Signed-off-by:  Mark Lord <mlord@pobox.com>

--- old/drivers/pci/hotplug/pciehp_core.c	2007-10-12 12:43:44.000000000 -0400
+++ linux/drivers/pci/hotplug/pciehp_core.c	2007-10-16 15:22:46.000000000 -0400
@@ -475,6 +475,9 @@
 		rc = t_slot->hpc_ops->power_off_slot(t_slot); /* Power off slot if not occupied*/
 		if (rc)
 			goto err_out_free_ctrl_slot;
+	} else {
+		extern int pciehp_enable_slot(struct slot *p_slot);
+		pciehp_enable_slot(t_slot);
 	}
 
 	return 0;
--- old/drivers/pci/hotplug/pciehp_ctrl.c	2007-10-12 12:43:44.000000000 -0400
+++ linux/drivers/pci/hotplug/pciehp_ctrl.c	2007-10-16 15:22:44.000000000 -0400
@@ -37,7 +37,7 @@
 #include "pciehp.h"
 
 static void interrupt_event_handler(struct work_struct *work);
-static int pciehp_enable_slot(struct slot *p_slot);
+       int pciehp_enable_slot(struct slot *p_slot);
 static int pciehp_disable_slot(struct slot *p_slot);
 
 static int queue_interrupt_event(struct slot *p_slot, u32 event_type)
