Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbYC0HNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbYC0HNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 03:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbYC0HMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 03:12:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:50401 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589AbYC0HMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 03:12:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,562,1199692800"; 
   d="scan'208";a="540795770"
Subject: [PATCH -mm 2/4] x86_64 boot: Add linked list of struct setup_data
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, Paul Jackson <pj@sgi.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Mar 2008 15:09:08 +0800
Message-Id: <1206601748.3067.22.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 27 Mar 2008 07:06:07.0594 (UTC) FILETIME=[07767CA0:01C88FD9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a field of 64-bit physical pointer to NULL terminated
single linked list of struct setup_data to real-mode kernel
header. This is used as a more extensible boot parameters passing
mechanism.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/boot/header.S      |    6 +++++-
 arch/x86/kernel/head64.c    |   20 ++++++++++++++++++++
 arch/x86/kernel/setup_64.c  |   22 ++++++++++++++++++++++
 include/asm-x86/bootparam.h |   14 ++++++++++++++
 4 files changed, 61 insertions(+), 1 deletion(-)

--- a/include/asm-x86/bootparam.h
+++ b/include/asm-x86/bootparam.h
@@ -9,6 +9,17 @@
 #include <asm/ist.h>
 #include <video/edid.h>
 
+/* setup data types */
+#define SETUP_NONE			0
+
+/* extensible setup data list node */
+struct setup_data {
+	u64 next;
+	u32 type;
+	u32 len;
+	u8 data[0];
+};
+
 struct setup_header {
 	__u8	setup_sects;
 	__u16	root_flags;
@@ -46,6 +57,9 @@ struct setup_header {
 	__u32	cmdline_size;
 	__u32	hardware_subarch;
 	__u64	hardware_subarch_data;
+	__u32	payload_offset;
+	__u32	payload_length;
+	__u64	setup_data;
 } __attribute__((packed));
 
 struct sys_desc_table {
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -120,7 +120,7 @@ _start:
 	# Part 2 of the header, from the old setup.S
 
 		.ascii	"HdrS"		# header signature
-		.word	0x0208		# header version number (>= 0x0105)
+		.word	0x0209		# header version number (>= 0x0105)
 					# or else old loadlin-1.5 will fail)
 		.globl realmode_swtch
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
@@ -227,6 +227,10 @@ hardware_subarch_data:	.quad 0
 payload_offset:		.long input_data
 payload_length:		.long input_data_end-input_data
 
+setup_data:		.quad 0			# 64-bit physical pointer to
+						# single linked list of
+						# struct setup_data
+
 # End of setup header #####################################################
 
 	.section ".inittext", "ax"
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -266,6 +266,26 @@ void __attribute__((weak)) __init memory
        machine_specific_memory_setup();
 }
 
+static void __init parse_setup_data(void)
+{
+	struct setup_data *data;
+	unsigned long pa_data;
+
+	if (boot_params.hdr.version < 0x0209)
+		return;
+	pa_data = boot_params.hdr.setup_data;
+	while (pa_data) {
+		data = early_ioremap(pa_data, PAGE_SIZE);
+		switch (data->type) {
+		default:
+			break;
+		}
+		free_early(pa_data, pa_data+sizeof(*data)+data->len);
+		pa_data = data->next;
+		early_iounmap(data, PAGE_SIZE);
+	}
+}
+
 /*
  * setup_arch - architecture-specific boot-time initializations
  *
@@ -318,6 +338,8 @@ void __init setup_arch(char **cmdline_p)
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
+	parse_setup_data();
+
 	parse_early_param();
 
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -11,6 +11,7 @@
 #include <linux/string.h>
 #include <linux/percpu.h>
 #include <linux/start_kernel.h>
+#include <linux/io.h>
 
 #include <asm/processor.h>
 #include <asm/proto.h>
@@ -105,6 +106,24 @@ static void __init reserve_ebda_region(v
 	reserve_early(lowmem, 0x100000, "BIOS reserved");
 }
 
+static void __init reserve_setup_data(void)
+{
+	struct setup_data *data;
+	unsigned long pa_data;
+	char buf[32];
+
+	if (boot_params.hdr.version < 0x0209)
+		return;
+	pa_data = boot_params.hdr.setup_data;
+	while (pa_data) {
+		data = early_ioremap(pa_data, sizeof(*data));
+		sprintf(buf, "setup data %x", data->type);
+		reserve_early(pa_data, pa_data+sizeof(*data)+data->len, buf);
+		pa_data = data->next;
+		early_iounmap(data, sizeof(*data));
+	}
+}
+
 void __init x86_64_start_kernel(char * real_mode_data)
 {
 	int i;
@@ -159,6 +178,7 @@ void __init x86_64_start_kernel(char * r
 	}
 
 	reserve_ebda_region();
+	reserve_setup_data();
 
 	/*
 	 * At this point everything still needed from the boot loader

