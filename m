Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbYKIQG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbYKIQG3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 11:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbYKIQGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 11:06:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:32593 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbYKIQGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 11:06:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=NYR6ZiY1RXxArYs5ByLkDgGZHyYkgfXtLjHs0GjaJSc0G123lxL1rxWlNkACePaOkK
         CcwyX7DjgdFGk/+XjTgNyzaqYCo/sUvE3fGhuyKaxLbpZPCxSgTAdnUhCO/5cKPVk4t4
         yk2CkFzREiF5WxvwwH4Xo0Uglo2CbZWEmEM1c=
Message-ID: <49170B16.4010909@tuffmail.co.uk>
Date: Sun, 09 Nov 2008 16:08:54 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: Add option to passively listen for PCIE hotplug events
References: <bujwT-2Ew-5@gated-at.bofh.it> <buml1-6du-3@gated-at.bofh.it> <d51a1b7b-32db-41dd-a36d-911ed62f5cb4@l33g2000pri.googlegroups.com> <20081104124706.GB19401@srcf.ucam.org> <20081104133214.GA20427@srcf.ucam.org> <49105BA6.9090403@tuffmail.co.uk> <20081104143332.GA21689@srcf.ucam.org> <491063B3.4080808@tuffmail.co.uk> <20081104151128.GA22544@srcf.ucam.org> <49106DD7.9010307@tuffmail.co.uk> <20081104155722.GA23314@srcf.ucam.org> <491076BD.1030704@tuffmail.co.uk>
In-Reply-To: <491076BD.1030704@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Matthew Garrett wrote:
>> On Tue, Nov 04, 2008 at 03:44:23PM +0000, Alan Jenkins wrote:
>>
>>  
>>> I instrumented all the delays I could find. hpc_check_lnk_status() was
>>> the only one that came up.  1000ms delay per call, and I get 6 such 
>>> delays.
>>>     
>>
>> Ok, which is getting called from pciehp_enable_slot(). I'm not quite 
>> clear on why this is being called 6 times - any chance you can put a 
>> dump_stack() in there? Some are probably directly from the resume 
>> code. This confuses me a little, since there's a check for whether 
>> there's a card in the slot first. If that fails, pciehp_enable_slot() 
>> isn't called. If it succeeds, pciehp_enable_slot checks whether the 
>> slot is already powered up. If it is, it bails before doing the link 
>> setup.

Bump.  In case you're still slightly confused, I've found out why.  It 
skips the slot power check because POWER_CTRL(ctrl) == 0.  (See "Power 
Controller" in the debug output below).

Interestingly, I can see that hpc_get_power_status() is still being 
called from elsewhere.  So I'm not sure why we avoid calling it here.

Should I try out the obvious dumb fix (removing the POWER_CTRL test)?

Ta
Alan


# modprobe pciehp pciehp_passive=1 pciehp_debug=1

dmesg output from last of 3 pcie slots:

[  328.873347] pciehp 0000:00:1c.1:pcie02: hpc_check_lnk_status: lnk_status = 1011
[  328.873347] pciehp 0000:00:1c.1:pcie02: Device 0000:03:00.0 already exists at 0000:03:00, cannot hot-add
[  328.873347] pciehp 0000:00:1c.1:pcie02: Cannot add device at 0000:03:00
[  328.873347] pciehp 0000:00:1c.1:pcie02: hpc_get_power_status: SLOTCTRL 58 value read 38
[  328.873347] pciehp 0000:00:1c.1:pcie02: hpc_get_attention_status: SLOTCTRL 58, value read 38
[  328.873347] pciehp 0000:00:1c.1:pcie02: service driver pciehp loaded
[  328.873347] pciehp 0000:00:1c.2:pcie02: Hotplug Controller:
[  328.873347] pciehp 0000:00:1c.2:pcie02:   Seg/Bus/Dev/Func/IRQ : 0000:00:1c.2 IRQ 45
[  328.873347] pciehp 0000:00:1c.2:pcie02:   Vendor ID            : 0x8086
[  328.873347] pciehp 0000:00:1c.2:pcie02:   Device ID            : 0x2664
[  328.873347] pciehp 0000:00:1c.2:pcie02:   Subsystem ID         : 0x0000
[  328.873347] pciehp 0000:00:1c.2:pcie02:   Subsystem Vendor ID  : 0x0000
[  328.873347] pciehp 0000:00:1c.2:pcie02:   PCIe Cap offset      : 0x40
[  328.873347] pciehp 0000:00:1c.2:pcie02:   PCI resource [8]     : 0x3f00000@0xf8000000
[  328.873347] pciehp 0000:00:1c.2:pcie02:   PCI resource [9]     : 0x7000000@0xf0000000
[  328.873347] pciehp 0000:00:1c.2:pcie02: Slot Capabilities      : 0x00180560
[  328.873347] pciehp 0000:00:1c.2:pcie02:   Physical Slot Number : 3
[  328.873347] pciehp 0000:00:1c.2:pcie02:   Attention Button     :  no
[  328.873347] pciehp 0000:00:1c.2:pcie02:   Power Controller     :  no
[  328.873347] pciehp 0000:00:1c.2:pcie02:   MRL Sensor           :  no
[  328.873347] pciehp 0000:00:1c.2:pcie02:   Attention Indicator  :  no
[  328.873347] pciehp 0000:00:1c.2:pcie02:   Power Indicator      :  no
[  328.873347] pciehp 0000:00:1c.2:pcie02:   Hot-Plug Surprise    : yes
[  328.873347] pciehp 0000:00:1c.2:pcie02:   EMI Present          :  no
[  328.873347] pciehp 0000:00:1c.2:pcie02:   Command Completed    : yes
[  328.873347] pciehp 0000:00:1c.2:pcie02: Slot Status            : 0x0040
[  328.873347] pciehp 0000:00:1c.2:pcie02: Slot Control           : 0x0000
[  328.873347] pciehp 0000:00:1c.2:pcie02: HPC vendor_id 8086 device_id 2664 ss_vid 0 ss_did 0
[  328.873347] pciehp 0000:00:1c.2:pcie02: Registering domain:bus:dev=0000:01:00 hp_slot=0 sun=3 slot_device_offset=0
[  328.873347] pciehp 0000:00:1c.2:pcie02: get_power_status: physical_slot = 3
[  328.873347] pciehp 0000:00:1c.2:pcie02: hpc_get_power_status: SLOTCTRL 58 value read 38
[  328.873347] pciehp 0000:00:1c.2:pcie02: get_attention_status: physical_slot = 3
[  328.873347] pciehp 0000:00:1c.2:pcie02: hpc_get_attention_status: SLOTCTRL 58, value read 38
[  328.873347] pciehp 0000:00:1c.2:pcie02: get_latch_status: physical_slot = 3
[  328.873347] pciehp 0000:00:1c.2:pcie02: get_adapter_status: physical_slot = 3
[  328.873347] pciehp 0000:00:1c.2:pcie02: board_added: slot device, slot offset, hp slot = 0, 0, 0
[  329.876677] pciehp 0000:00:1c.2:pcie02: hpc_check_lnk_status: DEBUG TIME 1000ms
[  329.876677] Pid: 5101, comm: modprobe Not tainted 2.6.28-rc3eeepc #128
[  329.876677] Call Trace:
[  329.876677]  [<e02d3b11>] hpc_check_lnk_status+0x107/0x1ba [pciehp]
[  329.876677]  [<e02d1eaa>] pciehp_enable_slot+0x19d/0x2c9 [pciehp]
[  329.876677]  [<e02d19b8>] pciehp_probe+0x3b2/0x3ee [pciehp]
[  329.876677]  [<c01c276d>] pcie_port_probe_service+0x29/0x63
[  329.876677]  [<c020759b>] driver_probe_device+0xa1/0x117
[  329.876677]  [<c020765a>] __driver_attach+0x49/0x67
[  329.876677]  [<c0206df8>] bus_for_each_dev+0x35/0x56
[  329.876677]  [<c020744a>] driver_attach+0x11/0x13
[  329.876677]  [<c0207611>] __driver_attach+0x0/0x67
[  329.876677]  [<c020713f>] bus_add_driver+0x91/0x192
[  329.876677]  [<c02077b1>] driver_register+0x6d/0xc2
[  329.876677]  [<c0191561>] sysfs_addrm_finish+0x13/0x16f
[  329.876677]  [<e027d000>] pcied_init+0x0/0x5c [pciehp]
[  329.876677]  [<e027d00b>] pcied_init+0xb/0x5c [pciehp]
[  329.876677]  [<c0101134>] _stext+0x4c/0x136
[  329.876677]  [<c01576c3>] __vunmap+0x7c/0x8a
[  329.876677]  [<c0135324>] load_module+0xfe3/0x10e8
[  329.876677]  [<e0046c77>] acpi_get_hp_params_from_firmware+0x0/0x49d [pci_hotplug]
[  329.876677]  [<c01354b0>] sys_init_module+0x87/0x177
[  329.876677]  [<c010376d>] sysenter_do_call+0x12/0x21
[  329.876677] pciehp 0000:00:1c.2:pcie02: hpc_check_lnk_status: lnk_status = 1011
[  329.876677] pciehp 0000:00:1c.2:pcie02: Device 0000:01:00.0 already exists at 0000:01:00, cannot hot-add
[  329.876677] pciehp 0000:00:1c.2:pcie02: Cannot add device at 0000:01:00
[  329.876677] pciehp 0000:00:1c.2:pcie02: hpc_get_power_status: SLOTCTRL 58 value read 38
[  329.876677] pciehp 0000:00:1c.2:pcie02: hpc_get_attention_status: SLOTCTRL 58, value read 38
[  329.876677] pciehp 0000:00:1c.2:pcie02: service driver pciehp loaded


