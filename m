Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbYEZIio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbYEZIio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 04:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbYEZIie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 04:38:34 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40089 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbYEZIib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 04:38:31 -0400
Message-ID: <483A7663.4000700@jp.fujitsu.com>
Date: Mon, 26 May 2008 17:35:47 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       drzeus-list@drzeus.cx
Subject: Re: [patch, -git] pcie hotplug bootup crash fix
References: <20080524165828.GA29993@elte.hu> <20080524104024.a33116a3.akpm@linux-foundation.org>
In-Reply-To: <20080524104024.a33116a3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 24 May 2008 18:58:28 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
>> -tip tree testing found that the the PCI hotplug ISR routine crashes 
>> with a NULL pointer dereference under certain circumstances.
>>
>> The situation under which it occurs is hw and timing related: it appears 
>> to happen on a system that has PCI hotplug hardware but with no active 
>> hotplug cards, and another interrupt in the same (shared) IRQ line 
>> arrives too early, before the hotplug-slot entry has been set up - as 
>> triggered by CONFIG_DEBUG_SHIRQ=y:
>>
>> pciehp: HPC vendor_id 8086 device_id 27d0 ss_vid 0 ss_did 0
>> pciehp: pciehp_find_slot: slot (device=0x0) not found
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000070
>> IP: [<ffffffff80494a8b>] pciehp_handle_presence_change+0x7e/0x113
>> PGD 0
>> Oops: 0000 [1]
>> CPU 0
>> Modules linked in:
>> Pid: 1, comm: swapper Tainted: G        W 2.6.26-rc3-sched-devel.git-00001-g2b99b26-dirty #170
>> RIP: 0010:[<ffffffff80494a8b>]  [<ffffffff80494a8b>] pciehp_handle_presence_change+0x7e/0x113
>> RSP: 0000:ffff81003f83fbb0  EFLAGS: 00010046
>> RAX: 0000000000000039 RBX: 0000000000000000 RCX: 0000000000000000
>> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000046
>> RBP: ffff81003f83fbd0 R08: 0000000000000001 R09: ffffffff80245103
>> R10: 0000000000000020 R11: 0000000000000000 R12: ffff81003ea53a30
>> R13: 0000000000000000 R14: 0000000000000011 R15: ffffffff80495926
>> FS:  0000000000000000(0000) GS:ffffffff80be7400(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>> CR2: 0000000000000070 CR3: 0000000000201000 CR4: 00000000000006a0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process swapper (pid: 1, threadinfo ffff81003f83e000, task ffff81003f840000)
>> Stack:  0000000000000008 ffff81003f83fbf6 ffff81003ea53a30 0000000000000008
>>  ffff81003f83fc10 ffffffff80495ab4 0000000000000011 0000000000000002
>>  0000000000000202 0000000000000202 00000000fffffff4 ffff81003ea53a30
>> Call Trace:
>>  [<ffffffff80495ab4>] pcie_isr+0x18e/0x1bc
>>  [<ffffffff80260831>] request_irq+0x106/0x12f
>>  [<ffffffff80495fb6>] pcie_init+0x15e/0x6cc
>>  [<ffffffff804933a3>] pciehp_probe+0x64/0x541
>>  [<ffffffff8048f4e7>] pcie_port_probe_service+0x4c/0x76
>>  [<ffffffff8054af70>] driver_probe_device+0xd4/0x1f0
>>  [<ffffffff8054b108>] __driver_attach+0x7c/0x7e
>>  [<ffffffff8054b08c>] ? __driver_attach+0x0/0x7e
>>  [<ffffffff8054a4b6>] bus_for_each_dev+0x53/0x7d
>>  [<ffffffff8054ad3c>] driver_attach+0x1c/0x1e
>>  [<ffffffff8054a9c2>] bus_add_driver+0xdd/0x25b
>>  [<ffffffff80c09d3d>] ? pcied_init+0x0/0x8b
>>  [<ffffffff8054b288>] driver_register+0x5f/0x13e
>>  [<ffffffff80c09d3d>] ? pcied_init+0x0/0x8b
>>  [<ffffffff8048f441>] pcie_port_service_register+0x47/0x49
>>  [<ffffffff80c09d52>] pcied_init+0x15/0x8b
>>  [<ffffffff80bf3938>] kernel_init+0x75/0x243
>>  [<ffffffff808639d2>] ? _spin_unlock_irq+0x2b/0x3a
>>  [<ffffffff80228d1f>] ? finish_task_switch+0x57/0x9a
>>  [<ffffffff8020c258>] child_rip+0xa/0x12
>>  [<ffffffff8020bcec>] ? restore_args+0x0/0x30
>>  [<ffffffff80bf38c3>] ? kernel_init+0x0/0x243
>>  [<ffffffff8020c24e>] ? child_rip+0x0/0x12
>>
>> Code: 83 80 00 00 00 48 39 f0 75 e1 0f b6 c9 48 c7 c2 00 0e 8d 80 48 c7 c6 8a 60 a6 80 48 c7 c7 10 db a8 80 31 c0 e8 3f 8d d9 ff 31 db <48> 8b 43 70 48 8d 75 ef 48 89 df ff 50 30 80 7d ef 00 74 37 48
>> RIP  [<ffffffff80494a8b>] pciehp_handle_presence_change+0x7e/0x113
>>  RSP <ffff81003f83fbb0>
>> CR2: 0000000000000070
>> Kernel panic - not syncing: Fatal exception
> 
> This looks to me like CONFIG_DEBUG_SHIRQ doing its job.
> 
>> the config with which it occurs is:
>>
>>   http://redhat.com/~mingo/misc/config-Sat_May_24_18_17_56_CEST_2008.bad
>>
>> the fix is to check for NULL slots.
>>
>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> ---
>>  drivers/pci/hotplug/pciehp_ctrl.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> Index: linux/drivers/pci/hotplug/pciehp_ctrl.c
>> ===================================================================
>> --- linux.orig/drivers/pci/hotplug/pciehp_ctrl.c
>> +++ linux/drivers/pci/hotplug/pciehp_ctrl.c
>> @@ -118,6 +118,9 @@ u8 pciehp_handle_presence_change(u8 hp_s
>>  
>>  	p_slot = pciehp_find_slot(ctrl, hp_slot + ctrl->slot_device_offset);
>>  
>> +	if (!p_slot || !p_slot->hpc_ops)
>> +		return 0;
>> +
>>  	/* Switch is open, assume a presence change
>>  	 * Save the presence state
>>  	 */

There are some other code that needs the same fix.

In addition, I noticed that we need to clear some bits in Slot Status
register, which indicates hotplug events happen, before installing
interrupt service routine to prevent pciehp driver from detecting
events that happened before pciehp loading.

> 
> It is fishy that pcie_init() calls pciehp_request_irq() before calling
> pcie_init_hardware_part2().  That looks like the classic "lets die
> horridly if a shared IRQ comes in at the wrong time" sequence.

Yes. I think the pciehp driver must be ready to handle the events before
installing interrupt service routine. So we need more structural fixes.
But since it would need relatively large change, I think Ingo's approach
is needed as a short term fix.

I updated Ingo's patch. If it's ok, I'll send it to Jess Barnes with some
other patches for the other pciehp regression problems.

I could reproduce the problem as follows, and I've tested the patch on
that reproduction environment.

 - Build the kernel with CONFIG_DEBUG_SHIRQ=y
 - Cause hotplug events (MRL switch open/close, adapter insersion/deletion)
   before loading pciehp
 - load pciehp driver

Thanks,
Kenji Kaneshige


Fix the following NULL dereference problem reported from Pierre Ossman
and Ingo Molnar.

pciehp: HPC vendor_id 8086 device_id 27d0 ss_vid 0 ss_did 0
pciehp: pciehp_find_slot: slot (device=0x0) not found
BUG: unable to handle kernel NULL pointer dereference at 0000000000000070
IP: [<ffffffff80494a8b>] pciehp_handle_presence_change+0x7e/0x113
PGD 0
Oops: 0000 [1]
CPU 0
Modules linked in:
Pid: 1, comm: swapper Tainted: G        W 2.6.26-rc3-sched-devel.git-00001-g2b99b26-dirty #170
RIP: 0010:[<ffffffff80494a8b>]  [<ffffffff80494a8b>] pciehp_handle_presence_change+0x7e/0x113
RSP: 0000:ffff81003f83fbb0  EFLAGS: 00010046
RAX: 0000000000000039 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000046
RBP: ffff81003f83fbd0 R08: 0000000000000001 R09: ffffffff80245103
R10: 0000000000000020 R11: 0000000000000000 R12: ffff81003ea53a30
R13: 0000000000000000 R14: 0000000000000011 R15: ffffffff80495926
FS:  0000000000000000(0000) GS:ffffffff80be7400(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000070 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81003f83e000, task ffff81003f840000)
Stack:  0000000000000008 ffff81003f83fbf6 ffff81003ea53a30 0000000000000008
 ffff81003f83fc10 ffffffff80495ab4 0000000000000011 0000000000000002
 0000000000000202 0000000000000202 00000000fffffff4 ffff81003ea53a30
Call Trace:
 [<ffffffff80495ab4>] pcie_isr+0x18e/0x1bc
 [<ffffffff80260831>] request_irq+0x106/0x12f
 [<ffffffff80495fb6>] pcie_init+0x15e/0x6cc
 [<ffffffff804933a3>] pciehp_probe+0x64/0x541
 [<ffffffff8048f4e7>] pcie_port_probe_service+0x4c/0x76
 [<ffffffff8054af70>] driver_probe_device+0xd4/0x1f0
 [<ffffffff8054b108>] __driver_attach+0x7c/0x7e
 [<ffffffff8054b08c>] ? __driver_attach+0x0/0x7e
 [<ffffffff8054a4b6>] bus_for_each_dev+0x53/0x7d
 [<ffffffff8054ad3c>] driver_attach+0x1c/0x1e
 [<ffffffff8054a9c2>] bus_add_driver+0xdd/0x25b
 [<ffffffff80c09d3d>] ? pcied_init+0x0/0x8b
 [<ffffffff8054b288>] driver_register+0x5f/0x13e
 [<ffffffff80c09d3d>] ? pcied_init+0x0/0x8b
 [<ffffffff8048f441>] pcie_port_service_register+0x47/0x49
 [<ffffffff80c09d52>] pcied_init+0x15/0x8b
 [<ffffffff80bf3938>] kernel_init+0x75/0x243
 [<ffffffff808639d2>] ? _spin_unlock_irq+0x2b/0x3a
 [<ffffffff80228d1f>] ? finish_task_switch+0x57/0x9a
 [<ffffffff8020c258>] child_rip+0xa/0x12
 [<ffffffff8020bcec>] ? restore_args+0x0/0x30
 [<ffffffff80bf38c3>] ? kernel_init+0x0/0x243
 [<ffffffff8020c24e>] ? child_rip+0x0/0x12

Code: 83 80 00 00 00 48 39 f0 75 e1 0f b6 c9 48 c7 c2 00 0e 8d 80 48 c7 c6 8a 60 a6 80 48 c7 c7 10 db a8 80 31 c0 e8 3f 8d d9 ff 31 db <48> 8b 43 70 48 8d 75 ef 48 89 df ff 50 30 80 7d ef 00 74 37 48
RIP  [<ffffffff80494a8b>] pciehp_handle_presence_change+0x7e/0x113
 RSP <ffff81003f83fbb0>
CR2: 0000000000000070
Kernel panic - not syncing: Fatal exception

The situation under which it occurs is hw and timing related: it appears 
to happen on a system that has PCI hotplug hardware but with no active 
hotplug cards, and another interrupt in the same (shared) IRQ line 
arrives too early, before the hotplug-slot entry has been set up - as 
triggered by CONFIG_DEBUG_SHIRQ=y:

This patch contains the following two fixes.

(1) Clear all events bits in Slot Status register to prevent the pciehp
    driver from detecting the spurious events that would have been occur
    before pciehp loading.

(2) Add check whether slot initialization had been already done.

This is short term fix. We need more structural fixes to install
interrupt handler after slot initialization is done.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
---
 drivers/pci/hotplug/pciehp.h      |    8 +++----
 drivers/pci/hotplug/pciehp_ctrl.c |   22 ++++---------------
 drivers/pci/hotplug/pciehp_hpc.c  |   42 +++++++++++++++++++++++++-------------
 3 files changed, 37 insertions(+), 35 deletions(-)

Index: linux-2.6.26-rc3/drivers/pci/hotplug/pciehp_hpc.c
===================================================================
--- linux-2.6.26-rc3.orig/drivers/pci/hotplug/pciehp_hpc.c
+++ linux-2.6.26-rc3/drivers/pci/hotplug/pciehp_hpc.c
@@ -722,6 +722,7 @@ static irqreturn_t pcie_isr(int irq, voi
 {
 	struct controller *ctrl = (struct controller *)dev_id;
 	u16 detected, intr_loc;
+	struct slot *p_slot;
 
 	/*
 	 * In order to guarantee that all interrupt events are
@@ -756,21 +757,38 @@ static irqreturn_t pcie_isr(int irq, voi
 		wake_up_interruptible(&ctrl->queue);
 	}
 
+	if (!(intr_loc & ~CMD_COMPLETED))
+		return IRQ_HANDLED;
+
+	/*
+	 * Return without handling events if this handler routine is
+	 * called before controller initialization is done. This may
+	 * happen if hotplug event or another interrupt that shares
+	 * the IRQ with pciehp arrives before slot initialization is
+	 * done after interrupt handler is registered.
+	 *
+	 * FIXME - Need more structural fixes. We need to be ready to
+	 * handle the event before installing interrupt handler.
+	 */
+	p_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
+	if (!p_slot || !p_slot->hpc_ops)
+		return IRQ_HANDLED;
+
 	/* Check MRL Sensor Changed */
 	if (intr_loc & MRL_SENS_CHANGED)
-		pciehp_handle_switch_change(0, ctrl);
+		pciehp_handle_switch_change(p_slot);
 
 	/* Check Attention Button Pressed */
 	if (intr_loc & ATTN_BUTTN_PRESSED)
-		pciehp_handle_attention_button(0, ctrl);
+		pciehp_handle_attention_button(p_slot);
 
 	/* Check Presence Detect Changed */
 	if (intr_loc & PRSN_DETECT_CHANGED)
-		pciehp_handle_presence_change(0, ctrl);
+		pciehp_handle_presence_change(p_slot);
 
 	/* Check Power Fault Detected */
 	if (intr_loc & PWR_FAULT_DETECTED)
-		pciehp_handle_power_fault(0, ctrl);
+		pciehp_handle_power_fault(p_slot);
 
 	return IRQ_HANDLED;
 }
@@ -1028,6 +1046,12 @@ static int pciehp_acpi_get_hp_hw_control
 static int pcie_init_hardware_part1(struct controller *ctrl,
 				    struct pcie_device *dev)
 {
+	/* Clear all remaining event bits in Slot Status register */
+	if (pciehp_writew(ctrl, SLOTSTATUS, 0x1f)) {
+		err("%s: Cannot write to SLOTSTATUS register\n", __func__);
+		return -1;
+	}
+
 	/* Mask Hot-plug Interrupt Enable */
 	if (pcie_write_cmd(ctrl, 0, HP_INTR_ENABLE | CMD_CMPL_INTR_ENABLE)) {
 		err("%s: Cannot mask hotplug interrupt enable\n", __func__);
@@ -1040,16 +1064,6 @@ int pcie_init_hardware_part2(struct cont
 {
 	u16 cmd, mask;
 
-	/*
-	 * We need to clear all events before enabling hotplug interrupt
-	 * notification mechanism in order for hotplug controler to
-	 * generate interrupts.
-	 */
-	if (pciehp_writew(ctrl, SLOTSTATUS, 0x1f)) {
-		err("%s: Cannot write to SLOTSTATUS register\n", __FUNCTION__);
-		return -1;
-	}
-
 	cmd = PRSN_DETECT_ENABLE;
 	if (ATTN_BUTTN(ctrl))
 		cmd |= ATTN_BUTTN_ENABLE;
Index: linux-2.6.26-rc3/drivers/pci/hotplug/pciehp.h
===================================================================
--- linux-2.6.26-rc3.orig/drivers/pci/hotplug/pciehp.h
+++ linux-2.6.26-rc3/drivers/pci/hotplug/pciehp.h
@@ -146,10 +146,10 @@ struct controller {
 
 extern int pciehp_sysfs_enable_slot(struct slot *slot);
 extern int pciehp_sysfs_disable_slot(struct slot *slot);
-extern u8 pciehp_handle_attention_button(u8 hp_slot, struct controller *ctrl);
-extern u8 pciehp_handle_switch_change(u8 hp_slot, struct controller *ctrl);
-extern u8 pciehp_handle_presence_change(u8 hp_slot, struct controller *ctrl);
-extern u8 pciehp_handle_power_fault(u8 hp_slot, struct controller *ctrl);
+extern u8 pciehp_handle_attention_button(struct slot *p_slot);
+  extern u8 pciehp_handle_switch_change(struct slot *p_slot);
+extern u8 pciehp_handle_presence_change(struct slot *p_slot);
+extern u8 pciehp_handle_power_fault(struct slot *p_slot);
 extern int pciehp_configure_device(struct slot *p_slot);
 extern int pciehp_unconfigure_device(struct slot *p_slot);
 extern void pciehp_queue_pushbutton_work(struct work_struct *work);
Index: linux-2.6.26-rc3/drivers/pci/hotplug/pciehp_ctrl.c
===================================================================
--- linux-2.6.26-rc3.orig/drivers/pci/hotplug/pciehp_ctrl.c
+++ linux-2.6.26-rc3/drivers/pci/hotplug/pciehp_ctrl.c
@@ -55,16 +55,13 @@ static int queue_interrupt_event(struct 
 	return 0;
 }
 
-u8 pciehp_handle_attention_button(u8 hp_slot, struct controller *ctrl)
+u8 pciehp_handle_attention_button(struct slot *p_slot)
 {
-	struct slot *p_slot;
 	u32 event_type;
 
 	/* Attention Button Change */
 	dbg("pciehp:  Attention button interrupt received.\n");
 
-	p_slot = pciehp_find_slot(ctrl, hp_slot + ctrl->slot_device_offset);
-
 	/*
 	 *  Button pressed - See if need to TAKE ACTION!!!
 	 */
@@ -76,18 +73,15 @@ u8 pciehp_handle_attention_button(u8 hp_
 	return 0;
 }
 
-u8 pciehp_handle_switch_change(u8 hp_slot, struct controller *ctrl)
+u8 pciehp_handle_switch_change(struct slot *p_slot)
 {
-	struct slot *p_slot;
 	u8 getstatus;
 	u32 event_type;
 
 	/* Switch Change */
 	dbg("pciehp:  Switch interrupt received.\n");
 
-	p_slot = pciehp_find_slot(ctrl, hp_slot + ctrl->slot_device_offset);
 	p_slot->hpc_ops->get_latch_status(p_slot, &getstatus);
-
 	if (getstatus) {
 		/*
 		 * Switch opened
@@ -107,17 +101,14 @@ u8 pciehp_handle_switch_change(u8 hp_slo
 	return 1;
 }
 
-u8 pciehp_handle_presence_change(u8 hp_slot, struct controller *ctrl)
+u8 pciehp_handle_presence_change(struct slot *p_slot)
 {
-	struct slot *p_slot;
 	u32 event_type;
 	u8 presence_save;
 
 	/* Presence Change */
 	dbg("pciehp:  Presence/Notify input change.\n");
 
-	p_slot = pciehp_find_slot(ctrl, hp_slot + ctrl->slot_device_offset);
-
 	/* Switch is open, assume a presence change
 	 * Save the presence state
 	 */
@@ -141,16 +132,13 @@ u8 pciehp_handle_presence_change(u8 hp_s
 	return 1;
 }
 
-u8 pciehp_handle_power_fault(u8 hp_slot, struct controller *ctrl)
+u8 pciehp_handle_power_fault(struct slot *p_slot)
 {
-	struct slot *p_slot;
 	u32 event_type;
 
 	/* power fault */
 	dbg("pciehp:  Power fault interrupt received.\n");
 
-	p_slot = pciehp_find_slot(ctrl, hp_slot + ctrl->slot_device_offset);
-
 	if ( !(p_slot->hpc_ops->query_power_fault(p_slot))) {
 		/*
 		 * power fault Cleared
@@ -163,7 +151,7 @@ u8 pciehp_handle_power_fault(u8 hp_slot,
 		 */
 		info("Power fault on Slot(%s)\n", p_slot->name);
 		event_type = INT_POWER_FAULT;
-		info("power fault bit %x set\n", hp_slot);
+		info("power fault bit %x set\n", 0);
 	}
 
 	queue_interrupt_event(p_slot, event_type);


