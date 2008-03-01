Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbYCAIGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbYCAIGx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 03:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbYCAIGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:06:44 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:48368 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYCAIGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:06:43 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47C90E81.7050603@s5r6.in-berlin.de>
Date: Sat, 01 Mar 2008 09:06:25 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: linuxppc-dev@ozlabs.org, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] firewire: fw-ohci: PPC PMac platform code
References: <tkrat.ac97915a5b51e35b@s5r6.in-berlin.de>	<tkrat.7e8e04e66a38dcd6@s5r6.in-berlin.de> <1204340392.15052.455.camel@pasglop>
In-Reply-To: <1204340392.15052.455.camel@pasglop>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
>> +#ifdef CONFIG_PPC_PMAC
>> +	/* Necessary on some machines if fw-ohci was loaded/ unloaded before */
>> +	if (machine_is(powermac)) {
>> +		struct device_node *ofn = pci_device_to_OF_node(dev);
>> +
>> +		if (ofn) {
>> +			pmac_call_feature(PMAC_FTR_1394_CABLE_POWER, ofn, 0, 1);
>> +			pmac_call_feature(PMAC_FTR_1394_ENABLE, ofn, 0, 1);
>> +		}
>> +	}
>> +#endif /* CONFIG_PPC_PMAC */
> 
> I -think- that the hunk above can be removed if you just call
> pci_enable_device(). I have a hook in the arch pcibios_enable_device()
> that detects the internal firewire and does the calls. Can you verify it
> works ?

The first test I did was
# modprobe ohci1394    # this has the same four feature call blocks
# modprobe -r ohci1394
# modprobe firewire-ohci
<boom>

Tried the same now again (actually modprobe -r firewire-ohci (patched); 
modprobe firewire-ohci (unpatched)):

Machine check in kernel mode.
Caused by (from SRR1=49030): Transfer error ack signal
Oops: Machine check, sig: 7 [#1]
PowerMac
Modules linked in: firewire_ohci(+) firewire_core crc_itu_t af_packet 
apm_emu apm_emulation usbhid sungem sungem_phy yenta_socket 
rsrc_nonstatic ohci_hcd pcmcia_core usbcore ide_cd_mod cdrom evdev [last 
unloaded: crc_itu_t]
NIP: e18ee3dc LR: e18ee32c CTR: c0065178
REGS: d7c01c40 TRAP: 0200   Not tainted  (2.6.25-rc3)
MSR: 00049030 <EE,ME,IR,DR>  CR: 84004428  XER: 00000000
TASK = dedae6d0[5376] 'modprobe' THREAD: d7c00000
GPR00: e18e61c0 d7c01cf0 dedae6d0 defcf000 00000000 00000385 c06c09f8 
00001000
GPR08: ffffec0f 00000000 e18e6000 dfafd000 24004428 1001e354 00000000 
00000000
GPR16: 0000007a 0000007a 00000000 e18e9bf4 00000124 00000000 e18e6000 
c0050280
GPR24: 00000019 e18e9cc4 c0290630 dfb61420 df85b800 dfafdcf8 00000000 
dfafdcf8
NIP [e18ee3dc] ar_context_add_page+0xd0/0xf4 [firewire_ohci]
LR [e18ee32c] ar_context_add_page+0x20/0xf4 [firewire_ohci]
Call Trace:
[d7c01cf0] [e18ee32c] ar_context_add_page+0x20/0xf4 [firewire_ohci] 
(unreliable)
[d7c01d00] [e18ee440] ar_context_init+0x40/0x70 [firewire_ohci]
[d7c01d50] [e18f0004] pci_probe+0x118/0x70c [firewire_ohci]
[d7c01d70] [c010e0ac] pci_device_probe+0x80/0xa0
[d7c01d90] [c0146230] driver_probe_device+0xb8/0x1cc
[d7c01db0] [c0146528] __driver_attach+0xd4/0x104
[d7c01dd0] [c0144d78] bus_for_each_dev+0x58/0x94
[d7c01e00] [c0145f60] driver_attach+0x24/0x34
[d7c01e10] [c0145d48] bus_add_driver+0xb0/0x250
[d7c01e30] [c0146a18] driver_register+0x48/0x130
[d7c01e50] [c010dcb0] __pci_register_driver+0x48/0x94
[d7c01e70] [e101e028] fw_ohci_init+0x28/0x48 [firewire_ohci]
[d7c01e80] [c00516e8] sys_init_module+0xd4/0x1754
[d7c01f40] [c0013d98] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xff7325c
     LR = 0x10003b50
Instruction dump:
90690010 817f0000 907f0008 814b04b4 813f0010 7c0a4a14 7c0004ac 7ce0052c
817f0000 812b04b4 7c0004ac 7d204c2c <0c090000> 4c00012c 38000000 7c030378
---[ end trace a3cf91a5f7d45355 ]---


BTW, ohci1394 had traditionally only 3 of the blocks; I added the block 
by commit 48cfae44b4d6c7ca843d611a93ed2f94b59bcb38 in November 2006. 
This fixed http://bugzilla.kernel.org/show_bug.cgi?id=7431 .

[...]
>> @@ -2211,6 +2241,16 @@ static int pci_suspend(struct pci_dev *p
>>  	if (err)
>>  		fw_error("pci_set_power_state failed with %d\n", err);
>>  
>> +/* PowerMac suspend code comes last */
>> +#ifdef CONFIG_PPC_PMAC
>> +	if (machine_is(powermac)) {
>> +		struct device_node *ofn = pci_device_to_OF_node(pdev);
>> +
>> +		if (ofn)
>> +			pmac_call_feature(PMAC_FTR_1394_ENABLE, ofn, 0, 0);
>> +	}
>> +#endif /* CONFIG_PPC_PMAC */
> 
> I wonder why we don't do the cable power thingy here...

I don't know.

I tested with a bus powered device now.  Actually, suspend to RAM 
switches off cable power nevertheless, but resume does not switch it on 
anymore...

Of course the same is true with ohci1394.  Why did nobody ever complain? 
I suppose the last two users of FireWire + Linux + UniNorth rev01 don't 
use cable power or don't suspend and resume.
-- 
Stefan Richter
-=====-==--- --== ----=
http://arcgraph.de/sr/
