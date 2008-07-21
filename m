Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbYGUN6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbYGUN6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 09:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbYGUN6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 09:58:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58301 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbYGUN6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 09:58:15 -0400
Date: Mon, 21 Jul 2008 15:57:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, ak@linux.intel.com,
       Alex Chiang <achiang@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] acpi: fix crash in core ACPI code, triggered by
	CONFIG_ACPI_PCI_SLOT=y
Message-ID: <20080721135745.GA22748@elte.hu>
References: <200807161639.24289.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807161639.24289.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-tip testing found the following boot crash on 32-bit x86 (Core2Duo 
laptop) yesterday:

[    5.606664] scsi4 : ata_piix
[    5.606664] scsi5 : ata_piix
[    5.606664] ACPI Error (psargs-0358): [\_SB_.PCI0.LPC_.EC__.BSTA] Namespace lookup failure, AE_NOT_FOUND
[    5.606664] ACPI Error (psparse-0530): ACPI Error (nsnames-0186): Invalid NS Node (f7c0e960) while traversing path [20080609]
[    5.606664] BUG: unable to handle kernel NULL pointer dereference at 0000000f
[    5.606664] IP: [<80339e2f>] acpi_ns_build_external_path+0x1f/0x80
[    5.609997] *pdpt = 0000000000a03001 *pde = 0000000000000000
[    5.609997] Oops: 0002 [#1] SMP
[    5.609997]
[    5.609997] Pid: 1, comm: swapper Not tainted (2.6.26-tip-03965-gbbfb62e-dirty #3153)
[    5.609997] EIP: 0060:[<80339e2f>] EFLAGS: 00010286 CPU: 0
[    5.609997] EIP is at acpi_ns_build_external_path+0x1f/0x80
[    5.609997] EAX: f7c18c18 EBX: ffffffff ECX: 00000010 EDX: 00000000
[    5.609997] ESI: f7c18c18 EDI: 00000010 EBP: f7c4dc28 ESP: f7c4dc18
[    5.609997]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    5.609997] Process swapper (pid: 1, ti=f7c4c000 task=f7c50000 task.ti=f7c4c000)
[    5.609997] Stack: 00000000 00000000 f7c18c18 f7c4dc48 f7c4dc40 80339ed0 00000000 f7c18c18
[    5.609997]        8084c1b6 8084c1b6 f7c4dc58 8033a60a 00000000 00000010 00000000 f7c18c18
[    5.609997]        f7c4dc70 8033a68f f7c18c18 00000000 f6de7600 00000005 f7c4dc98 8033c34d
[    5.609997] Call Trace:
[    5.609997]  [<80339ed0>] ? acpi_ns_handle_to_pathname+0x40/0x72
[    5.609997]  [<8033a60a>] ? acpi_ns_print_node_pathname+0x2c/0x61
[    5.609997]  [<8033a68f>] ? acpi_ns_report_method_error+0x50/0x6d
[    5.609997]  [<8033c34d>] ? acpi_ps_parse_aml+0x149/0x2f9
[    5.609997]  [<8033d6dd>] ? acpi_ps_execute_method+0x132/0x201
[    5.609997]  [<80339d19>] ? acpi_ns_evaluate+0x1ad/0x258
[    5.609997]  [<803406c4>] ? acpi_ut_evaluate_object+0x55/0x18f
[    5.609997]  [<803408b7>] ? acpi_ut_execute_STA+0x22/0x7a
[    5.609997]  [<8033a907>] ? acpi_get_object_info+0x131/0x1be
[    5.609997]  [<80344bb2>] ? do_acpi_find_child+0x22/0x4b
[    5.609997]  [<8033b855>] ? acpi_ns_walk_namespace+0xa5/0x124
[    5.609997]  [<803394f3>] ? acpi_walk_namespace+0x54/0x74
[    5.609997]  [<80344b90>] ? do_acpi_find_child+0x0/0x4b
[    5.609997]  [<80344b85>] ? acpi_get_child+0x38/0x43
[    5.609997]  [<80344b90>] ? do_acpi_find_child+0x0/0x4b
[    5.609997]  [<804d0148>] ? ata_acpi_associate+0xb5/0x1b5
[    5.609997]  [<804c6ecb>] ? ata_scsi_add_hosts+0x8e/0xdc
[    5.609997]  [<804c40c8>] ? ata_host_register+0x9f/0x1d6
[    5.609997]  [<804cbc7f>] ? ata_pci_sff_activate_host+0x179/0x19f
[    5.609997]  [<804cdd45>] ? ata_sff_interrupt+0x0/0x1c7
[    5.609997]  [<8069b033>] ? piix_init_one+0x569/0x5b0
[    5.609997]  [<801bd400>] ? sysfs_ilookup_test+0x0/0x11
[    5.609997]  [<801987d7>] ? ilookup5_nowait+0x29/0x30
[    5.609997]  [<802efc7e>] ? pci_match_device+0x99/0xa3
[    5.609997]  [<802efd3c>] ? pci_device_probe+0x39/0x59
[    5.609997]  [<803bc4af>] ? driver_probe_device+0xa0/0x11b
[    5.609997]  [<803bc564>] ? __driver_attach+0x3a/0x59
[    5.609997]  [<803bbde3>] ? bus_for_each_dev+0x36/0x58
[    5.609997]  [<803bc354>] ? driver_attach+0x14/0x16
[    5.609997]  [<803bc52a>] ? __driver_attach+0x0/0x59
[    5.609997]  [<803bc161>] ? bus_add_driver+0x93/0x196
[    5.609997]  [<803bc773>] ? driver_register+0x71/0xcd
[    5.609997]  [<802eff05>] ? __pci_register_driver+0x3f/0x6e
[    5.609997]  [<809af7ff>] ? piix_init+0x14/0x24
[    5.609997]  [<80984568>] ? kernel_init+0x128/0x269
[    5.609997]  [<809af7eb>] ? piix_init+0x0/0x24
[    5.609997]  [<802e2758>] ? trace_hardirqs_on_thunk+0xc/0x10
[    5.609997]  [<80116aef>] ? restore_nocheck_notrace+0x0/0xe
[    5.609997]  [<80984440>] ? kernel_init+0x0/0x269
[    5.609997]  [<80984440>] ? kernel_init+0x0/0x269
[    5.609997]  [<80117d87>] ? kernel_thread_helper+0x7/0x10
[    5.609997]  =======================
[    5.609997] Code: 75 02 b3 01 8d 43 01 8b 5d fc c9 c3 55 89 e5 57 89 cf 56 53 89 d3 4b 83 ec 04 83 fb 03 89 55 f0 77 09 c6 01 5c c6 41 01 00 eb 59 <c6> 04 19 00 8b 55 f0 8d 34 11 89 c2 eb 19 8b 42 08 83 eb 05 89
[    5.609997] EIP: [<80339e2f>] acpi_ns_build_external_path+0x1f/0x80 SS:ESP 0068:f7c4dc18
[    5.613331] Kernel panic - not syncing: Fatal exception
[    5.613331] Rebooting in 1 seconds..[    4.646664] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)

I have bisected it down to:

 # bad:  [5b664cbe] Merge branch 'upstream-linus' of git://git.kernel.
 # good: [bce7f795] Linux 2.6.26
 # good: [e18425ab] Merge branch 'tracing/for-linus' of git://git.kern
 # good: [cadc7236] Merge branch 'bkl-removal' into next
 # good: [4515889a] Merge branch 'merge' of git://git.kernel.org/pub/s
 # good: [42fdd14e] Merge git://git.kernel.org/pub/scm/linux/kernel/gi
 # good: [8a0ca91f] Merge branch 'for-linus' of git://git.kernel.org/p
 # bad:  [0af4b8cb] ACPI: Introduce new device wakeup flag 'prepared'
 # good: [fe997407] PCI: construct one fakephp slot per PCI slot
 # bad:  [531f254a] PCIE: aer: use dev_printk when possible
 # bad:  [15650a20] x86/PCI: fixup early quirk probing
 # good: [0e6859d9] ACPI PM: Remove obsolete Toshiba workaround
 # bad:  [8344b566] PCI: ACPI PCI slot detection driver
 # good: [f46753c9] PCI: introduce pci_slot

 | 8344b568f5bdc7ee1bba909de3294c6348c36056 is first bad commit
 | commit 8344b568f5bdc7ee1bba909de3294c6348c36056
 | Author: Alex Chiang <achiang@hp.com>
 | Date:   Tue Jun 10 15:30:42 2008 -0600
 |
 |     PCI: ACPI PCI slot detection driver
 |
 |     Detect all physical PCI slots as described by ACPI, and create entries in
 |     /sys/bus/pci/slots/.

I.e. the new CONFIG_ACPI_PCI_SLOT=y option was causing this crash.

But the bug is not mainly in this new PCI code - that code was just 
hitting the ACPI code in a new way which made ACPI break.

The crash signature shows that we are crashing on this instruction:

   movb $0x0, (%ecx, %ebx, 1)

ECX and EBX are 0x10 and -1. It's this line in
drivers/acpi/namespace/nsnames.c's acpi_ns_build_external_path():

        name_buffer[index] = 0;

I.e. name_buffer is 0x10 and index is -1.

index -1 corresponds to size 0, and name_buffer 0x10 is slab's
ZERO_SIZE_PTR special-case for zero-sized allocations.

I.e. when we called acpi_ns_handle_to_pathname(), we got required_size
of 0 due to an error condition, but this is passed to the ACPI allocator
unconditionally:

        required_size = acpi_ns_get_pathname_length(node);

        /* Validate/Allocate/Clear caller buffer */

        status = acpi_ut_initialize_buffer(buffer, required_size);
        if (ACPI_FAILURE(status)) {
                return_ACPI_STATUS(status);
        }

Where acpi_ut_initialize_buffer(), through many (unnecessary) layers, 
ends up calling kzalloc(0). Which returns 0x10 and that then causes the 
crash later on.

So fix both callers of acpi_ns_get_pathname_length(), which can return 0 
in case of an invalid node.

Also add a WARN_ON() against zero sized allocations in 
acpi_ut_initialize_buffer() to make it easier to find similar instances 
of this bug.

I have tested this patch for the past 24 hours and the crash has not 
reappeared.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/acpi/namespace/nsnames.c |    8 ++++++++
 drivers/acpi/utilities/utalloc.c |    4 ++++
 2 files changed, 12 insertions(+)

Index: tip/drivers/acpi/namespace/nsnames.c
===================================================================
--- tip.orig/drivers/acpi/namespace/nsnames.c
+++ tip/drivers/acpi/namespace/nsnames.c
@@ -137,6 +137,10 @@ char *acpi_ns_get_external_pathname(stru
 	/* Calculate required buffer size based on depth below root */
 
 	size = acpi_ns_get_pathname_length(node);
+	if (!size) {
+		ACPI_ERROR((AE_INFO, "Invalid node failure"));
+		return_PTR(NULL);
+	}
 
 	/* Allocate a buffer to be returned to caller */
 
@@ -229,6 +233,10 @@ acpi_ns_handle_to_pathname(acpi_handle t
 	/* Determine size required for the caller buffer */
 
 	required_size = acpi_ns_get_pathname_length(node);
+	if (!required_size) {
+		ACPI_ERROR((AE_INFO, "Invalid node failure"));
+		return_ACPI_STATUS(AE_ERROR);
+	}
 
 	/* Validate/Allocate/Clear caller buffer */
 
Index: tip/drivers/acpi/utilities/utalloc.c
===================================================================
--- tip.orig/drivers/acpi/utilities/utalloc.c
+++ tip/drivers/acpi/utilities/utalloc.c
@@ -242,6 +242,10 @@ acpi_ut_initialize_buffer(struct acpi_bu
 {
 	acpi_status status = AE_OK;
 
+	if (!required_length) {
+		WARN_ON(1);
+		return AE_ERROR;
+	}
 	switch (buffer->length) {
 	case ACPI_NO_BUFFER:
 
