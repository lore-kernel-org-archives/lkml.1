Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbZCFNew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbZCFNew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZCFNa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:30:58 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:51929
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754168AbZCFNau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:30:50 -0500
X-BigFish: VPS-1(z5edJzzzzzz32i65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KG36UY-01-JL5-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 17/18] dma-debug: Documentation update
Date: Fri, 6 Mar 2009 14:30:28 +0100
Message-ID: <1236346229-6618-18-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 06 Mar 2009 13:30:30.0526 (UTC) FILETIME=[B824A1E0:01C99E5F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add documentation about DMA-API debugging to DMA-API.txt

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 Documentation/DMA-API.txt |  106 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 106 insertions(+), 0 deletions(-)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index 2a3fcc5..d9aa43d 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -609,3 +609,109 @@ size is the size (and should be a page-sized multiple).
 The return value will be either a pointer to the processor virtual
 address of the memory, or an error (via PTR_ERR()) if any part of the
 region is occupied.
+
+Part III - Debug drivers use of the DMA-API
+-------------------------------------------
+
+The DMA-API as described above as some constraints. DMA addresses must be
+released with the corresponding function with the same size for example. With
+the advent of hardware IOMMUs it becomes more and more important that drivers
+do not violate those constraints. In the worst case such a violation can
+result in data corruption up to destroyed filesystems.
+
+To debug drivers and find bugs in the usage of the DMA-API checking code can
+be compiled into the kernel which will tell the developer about those
+violations. If your architecture supports it you can select the "Enable
+debugging of DMA-API usage" option in your kernel configuration. Enabling this
+option has a performance impact. Do not enable it in production kernels.
+
+If you boot the resulting kernel will contain code which does some bookkeeping
+about what DMA memory was allocated for which device. If this code detects an
+error it prints a warning message with some details into your kernel log. An
+example warning message may look like this:
+
+------------[ cut here ]------------
+WARNING: at /data2/repos/linux-2.6-iommu/lib/dma-debug.c:448
+	check_unmap+0x203/0x490()
+Hardware name:
+forcedeth 0000:00:08.0: DMA-API: device driver frees DMA memory with wrong
+	function [device address=0x00000000640444be] [size=66 bytes] [mapped as
+single] [unmapped as page]
+Modules linked in: nfsd exportfs bridge stp llc r8169
+Pid: 0, comm: swapper Tainted: G        W  2.6.28-dmatest-09289-g8bb99c0 #1
+Call Trace:
+ <IRQ>  [<ffffffff80240b22>] warn_slowpath+0xf2/0x130
+ [<ffffffff80647b70>] _spin_unlock+0x10/0x30
+ [<ffffffff80537e75>] usb_hcd_link_urb_to_ep+0x75/0xc0
+ [<ffffffff80647c22>] _spin_unlock_irqrestore+0x12/0x40
+ [<ffffffff8055347f>] ohci_urb_enqueue+0x19f/0x7c0
+ [<ffffffff80252f96>] queue_work+0x56/0x60
+ [<ffffffff80237e10>] enqueue_task_fair+0x20/0x50
+ [<ffffffff80539279>] usb_hcd_submit_urb+0x379/0xbc0
+ [<ffffffff803b78c3>] cpumask_next_and+0x23/0x40
+ [<ffffffff80235177>] find_busiest_group+0x207/0x8a0
+ [<ffffffff8064784f>] _spin_lock_irqsave+0x1f/0x50
+ [<ffffffff803c7ea3>] check_unmap+0x203/0x490
+ [<ffffffff803c8259>] debug_dma_unmap_page+0x49/0x50
+ [<ffffffff80485f26>] nv_tx_done_optimized+0xc6/0x2c0
+ [<ffffffff80486c13>] nv_nic_irq_optimized+0x73/0x2b0
+ [<ffffffff8026df84>] handle_IRQ_event+0x34/0x70
+ [<ffffffff8026ffe9>] handle_edge_irq+0xc9/0x150
+ [<ffffffff8020e3ab>] do_IRQ+0xcb/0x1c0
+ [<ffffffff8020c093>] ret_from_intr+0x0/0xa
+ <EOI> <4>---[ end trace f6435a98e2a38c0e ]---
+
+The driver developer can find the driver and the device including a stacktrace
+of the DMA-API call which caused this warning.
+
+Per default only the first error will result in a warning message. All other
+errors will only silently counted. This limitation exist to prevent the code
+from flooding your kernel log. To support debugging a device driver this can
+be disabled via debugfs. See the debugfs interface documentation below for
+details.
+
+The debugfs directory for the DMA-API debugging code is called dma-api/. In
+this directory the following files can currently be found:
+
+	dma-api/all_errors	This file contains a numeric value. If this
+				value is not equal to zero the debugging code
+				will print a warning for every error it finds
+				into the kernel log. Be carefull with this
+				option. It can easily flood your logs.
+
+	dma-api/disabled	This read-only file contains the character 'Y'
+				if the debugging code is disabled. This can
+				happen when it runs out of memory or if it was
+				disabled at boot time
+
+	dma-api/error_count	This file is read-only and shows the total
+				numbers of errors found.
+
+	dma-api/num_errors	The number in this file shows how many
+				warnings will be printed to the kernel log
+				before it stops. This number is initialized to
+				one at system boot and be set by writing into
+				this file
+
+	dma-api/min_free_entries
+				This read-only file can be read to get the
+				minimum number of free dma_debug_entries the
+				allocator has ever seen. If this value goes
+				down to zero the code will disable itself
+				because it is not longer reliable.
+
+	dma-api/num_free_entries
+				The current number of free dma_debug_entries
+				in the allocator.
+
+If you have this code compiled into your kernel it will be enabled by default.
+If you want to boot without the bookkeeping anyway you can provide
+'dma_debug=off' as a boot parameter. This will disable DMA-API debugging.
+Notice that you can not enable it again at runtime. You have to reboot to do
+so.
+
+When the code disables itself at runtime this is most likely because it ran
+out of dma_debug_entries. These entries are preallocated at boot. The number
+of preallocated entries is defined per architecture. If it is too low for you
+boot with 'dma_debug_entries=<your_desired_number>' to overwrite the
+architectural default.
-- 
1.5.6.4


