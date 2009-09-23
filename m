Return-Path: <linux-kernel-owner+w=401wt.eu-S1752289AbZIWJmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbZIWJmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 05:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZIWJmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 05:42:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:38026 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbZIWJmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 05:42:13 -0400
Subject: Re: PCI HotPlug and Adding Resources after Linux Boots
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Morrison, Tom" <tmorrison@empirix.com>
Cc: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <80955630EE34634AB5030FB8CE9BDCEFD7459DF2@EXBEDCLST.empirix.com>
References: <80955630EE34634AB5030FB8CE9BDCEFD7459DF2@EXBEDCLST.empirix.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Sep 2009 19:42:07 +1000
Message-Id: <1253698927.7103.312.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 15:36 -0400, Morrison, Tom wrote:
> I am not exactly sure who to direct this question to (general Linux
> kernel or LinuxPPC),

PCI Hotplug is reasonably arch specific at the moment so I suppose
here's is as good as anywhere else to ask :-)

> so I am directing to both – in hopes that someone will recognize this
> problem – and perhaps
> 
> give me some suggestions on how to proceed…

There's a few things you can do, though I don't have time just right now
to give you a detailed answer. I'll try again later.

In the meantime, some of the answers could be around not using full
automatic resource assignment, but instead, pre-initializing the top
bridge with some resources that are going to be enough for the device.

You can also try to get the bridge to re-allocate. There's various funky
locking issues with doing that though as long as it's during boot time,
it's not too much of a problem.

There are other more or less hackish ways to do it, but I'll have to
give it more thought.

I'm quite stretched at the moment so if you don't hear back from me in
the upcoming few days, don't hesitate to ping me again.

Cheers,
Ben. 

> 
> I am running Linux (2.6.23x (and 2.6.27.x)) on a MPC8572 based system.
> 
>  
> 
> I have an 8616 switch that has a Port (6) connected to a FPGA that is 
> 
> NOT loaded at before Linux boots (note: this port is configured for
> HOTPLUG
> 
> events - which we do get after FPGA  is loaded). We are NOT using a 
> 
> static device tree map (because the devices in the system are very
> dynamic).
> 
> 
> We use instead the pci auto scan mechanism(s) to scan/assign
> resources 
> 
> (including into the BAR registers) at bootup to all of the devices
> that are 
> 
> attached to this MPC8572…
> 
>  
> 
> Here is the port that is attached to the device (note: there are NO 
> 
> resources assigned at this point this port):
> 
>  
> 
> -------------------------------------------------------------------------------------------------
> 
> 02:06.0 PCI bridge: PLX Technology, Inc.: Unknown device 8616 (rev bb)
> (prog-if 00 [Normal decode])
> 
>         Flags: bus master, fast devsel, latency 0
> 
>         Bus: primary=02, secondary=05, subordinate=05, sec-latency=0
> 
>         Capabilities: [40] Power Management version 3
> 
>         Capabilities: [48] Message Signalled Interrupts: 64bit+
> Queue=0/2 Enable+
> 
>         Capabilities: [68] #10 [0162]
> 
>         Capabilities: [a4] #0d [0000]
> 
>  
> 
> root@slave7 ~ # lspci -t
> 
> -+-[01]---00.0-[02-05]--+-01.0
> 
>  |                      +-04.0-[03]--
> 
>  |                      +-05.0-[04]--
> 
>  |                      \-06.0-[05]—
> 
>  
> 
> -------------------------------------------------------------------------------------------------
> 
>  
> 
> Later, after I detect there is an FPGA to load - I load it. At
> completion of the
> 
> loading of the FPGA - the 8616  detects the FPGA – and creates a
> HotPlug 
> 
> event that the PCI Express HotPlug Driver handles:
> 
> -------------------------------------------------------------------------------------------------
> 
>  
> 
> root@slave7 ~ # pciehp: pcie_isr: intr_loc 8
> 
> pciehp: pciehp:  Presence/Notify input change.
> 
> pciehp: Card present on Slot(0005_0070)
> 
> pciehp: Surprise Removal
> 
> pciehp: hpc_get_power_status: SLOTCTRL 80 value read 8
> 
> pciehp: hpc_get_attention_status: SLOTCTRL 80, value read 8
> 
> pciehp: board_added: slot device, slot offset, hp slot = 0, 0 ,0
> 
> pciehp: hpc_check_lnk_status: lnk_status = 2021
> 
> PCI: Found 0000:05:00.0 [1172/0004] 00ff00 00
> 
> PCI: Calling quirk c0012d3c for 0000:05:00.0
> 
> program_fw_provided_values: Could not get hotplug parameters
> 
> entering assign resources (size: 2000000)
> 
> PCI: Failed to allocate mem resource #0:2000000@0 for 0000:05:00.0
> 
> bus pci: add device 0000:05:00.0
> 
> entering uevent
> 
> pci: Trying to Match Device 0000:05:00.0 with Driver pcieport-driver
> 
> pci: Trying to Match Device 0000:05:00.0 with Driver serial
> 
> pci: Trying to Match Device 0000:05:00.0 with Driver pexntb
> 
> pciehp: hpc_get_power_status: SLOTCTRL 80 value read 8
> 
> pciehp: hpc_get_attention_status: SLOTCTRL 80, value read 8
> 
>  
> 
> 02:06.0 PCI bridge: PLX Technology, Inc.: Unknown device 8616 (rev bb)
> (prog-if 00 [Normal decode])
> 
>         Flags: bus master, fast devsel, latency 0
> 
>         Bus: primary=02, secondary=05, subordinate=05, sec-latency=0
> 
>         Capabilities: [40] Power Management version 3
> 
>         Capabilities: [48] Message Signalled Interrupts: 64bit+
> Queue=0/2 Enable+
> 
>         Capabilities: [68] #10 [0162]
> 
>         Capabilities: [a4] #0d [0000]
> 
>  
> 
> 05:00.0 Class ff00: Altera Corporation: Unknown device 0004 (rev 01)
> 
>         Subsystem: Altera Corporation: Unknown device 0004
> 
>         Flags: fast devsel
> 
>         Capabilities: [50] Message Signalled Interrupts: 64bit+
> Queue=0/5 Enable-
> 
>         Capabilities: [78] Power Management version 3
> 
>         Capabilities: [80] #10 [0001]
> 
>  
> 
> root@slave7 ~ # lspci -t
> 
> -+-[01]---00.0-[02-05]--+-01.0
> 
>  |                      +-04.0-[03]--
> 
>  |                      +-05.0-[04]--
> 
>  |                      \-06.0-[05]----00.0
> 
>  \-[00]---00.0
> 
>  
> 
> -------------------------------------------------------------------------------------------------
> 
>  
> 
> So, as you can see – the device has been read – and it requires 32M of
> resources, but
> 
> because its parent doesn’t have any resources allocated – it seemingly
> can’t allocate and
> 
> use any additional resources.
> 
>  
> 
> How do I ‘customize’ and/or add resources at this point for this
> device (using semi-standard mechanisms)?
> 
>  
> 
> Thanks in advance for any/all ideas…
> 
>  
> 
>  
> 
> I 
> 
>  
> 
> Tom Morrison
> Principal Software Engineer
> 
> EMPIRIX 
> 20 Crosby Drive - Bedford, MA  01730
> p: 781.266.3567 f: 781.266.3670 
> email: tmorrison@empirix.com 
> www.empirix.com
> 
> 
> 
> 
>  
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev

