Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbZFQS2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbZFQS2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 14:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbZFQS2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 14:28:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:48752 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbZFQS2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 14:28:42 -0400
Date: Wed, 17 Jun 2009 18:27:59 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, gorcunov@openvz.org, vegard.nossum@gmail.com,
       gorcunov@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, yinghai@kernel.org, vegard.nossum@gmail.com,
       tglx@linutronix.de, gorcunov@gmail.com, mingo@elte.hu
In-Reply-To: <20090617181322.GG10822@lenovo>
References: <20090617181322.GG10822@lenovo>
Subject: [tip:x86/urgent] x86, ioapic: Don't call disconnect_bsp_APIC if no APIC present
Message-ID: <tip-3f4c3955ea320bde870ac2ce587466295aba5710@git.kernel.org>
Git-Commit-ID: 3f4c3955ea320bde870ac2ce587466295aba5710
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 18:28:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f4c3955ea320bde870ac2ce587466295aba5710
Gitweb:     http://git.kernel.org/tip/3f4c3955ea320bde870ac2ce587466295aba5710
Author:     Cyrill Gorcunov <gorcunov@gmail.com>
AuthorDate: Wed, 17 Jun 2009 22:13:22 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Jun 2009 20:24:39 +0200

x86, ioapic: Don't call disconnect_bsp_APIC if no APIC present

Vegard Nossum reported:

[  503.576724] ACPI: Preparing to enter system sleep state S5
[  503.710857] Disabling non-boot CPUs ...
[  503.716853] Power down.
[  503.717770] ------------[ cut here ]------------
[  503.717770] WARNING: at arch/x86/kernel/apic/apic.c:249 native_apic_write_du)
[  503.717770] Hardware name: OptiPlex GX100
[  503.717770] Modules linked in:
[  503.717770] Pid: 2136, comm: halt Not tainted 2.6.30 #443
[  503.717770] Call Trace:
[  503.717770]  [<c154d327>] ? printk+0x18/0x1a
[  503.717770]  [<c1017358>] ? native_apic_write_dummy+0x38/0x50
[  503.717770]  [<c10360fc>] warn_slowpath_common+0x6c/0xc0
[  503.717770]  [<c1017358>] ? native_apic_write_dummy+0x38/0x50
[  503.717770]  [<c1036165>] warn_slowpath_null+0x15/0x20
[  503.717770]  [<c1017358>] native_apic_write_dummy+0x38/0x50
[  503.717770]  [<c1017173>] disconnect_bsp_APIC+0x63/0x100
[  503.717770]  [<c1019e48>] disable_IO_APIC+0xb8/0xc0
[  503.717770]  [<c1214231>] ? acpi_power_off+0x0/0x29
[  503.717770]  [<c1015e55>] native_machine_shutdown+0x65/0x80
[  503.717770]  [<c1015c36>] native_machine_power_off+0x26/0x30
[  503.717770]  [<c1015c49>] machine_power_off+0x9/0x10
[  503.717770]  [<c1046596>] kernel_power_off+0x36/0x40
[  503.717770]  [<c104680d>] sys_reboot+0xfd/0x1f0
[  503.717770]  [<c109daa0>] ? perf_swcounter_event+0xb0/0x130
[  503.717770]  [<c109db7d>] ? perf_counter_task_sched_out+0x5d/0x120
[  503.717770]  [<c102dfc6>] ? finish_task_switch+0x56/0xd0
[  503.717770]  [<c154da1e>] ? schedule+0x49e/0xb40
[  503.717770]  [<c10444b0>] ? sys_kill+0x70/0x160
[  503.717770]  [<c119d9db>] ? selinux_file_ioctl+0x3b/0x50
[  503.717770]  [<c10dd443>] ? sys_ioctl+0x63/0x70
[  503.717770]  [<c1003024>] sysenter_do_call+0x12/0x22
[  503.717770] ---[ end trace 8157b5d0ed378f15 ]---

|
| That's including this commit:
|
| commit 103428e57be323c3c5545db8ad12667099bc6005
|Author: Cyrill Gorcunov <gorcunov@openvz.org>
|Date:   Sun Jun 7 16:48:40 2009 +0400
|
|    x86, apic: Fix dummy apic read operation together with broken MP handling
|

If we have apic disabled we don't even switch to APIC mode and do not
calling for connect_bsp_APIC. Though on SMP compiled kernel the
native_machine_shutdown does try to write the apic register anyway.

Fix it with explicit check if we really should touch apic registers.

Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20090617181322.GG10822@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/io_apic.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 29d0752..b7a7920 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2004,7 +2004,9 @@ void disable_IO_APIC(void)
 	/*
 	 * Use virtual wire A mode when interrupt remapping is enabled.
 	 */
-	disconnect_bsp_APIC(!intr_remapping_enabled && ioapic_i8259.pin != -1);
+	if (cpu_has_apic)
+		disconnect_bsp_APIC(!intr_remapping_enabled &&
+				ioapic_i8259.pin != -1);
 }
 
 #ifdef CONFIG_X86_32
