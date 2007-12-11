Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbXLKRc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbXLKRc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 12:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbXLKRcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 12:32:48 -0500
Received: from mga06.intel.com ([134.134.136.21]:22378 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751577AbXLKRcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 12:32:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,153,1196668800"; 
   d="scan'208";a="240575082"
Message-ID: <475EC9C1.9080708@linux.intel.com>
Date: Tue, 11 Dec 2007 12:32:49 -0500
From: Anas Nashif <nashif@linux.intel.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Intel Management Engine Interface
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have addressed the issues raised on lkml after the first submission 
of the driver several weeks back and enhanced the driver with better 
sysfs support and additional device IDs to support more hardware with
the ME firmware.

The "legacy" device is not really legacy as it is available in most 
recent desktops as a firmware options in the ME (AMT 1.0) and is 
still supported by Intel and many 3rd party applications; removing 
it will break many applications.

The Intel Management Engine Interface (aka HECI: Host Embedded 
Controller Interface ) enables communication between the host OS and 
the Management Engine firmware. MEI is bi-directional, and either the 
host or Intel AMT firmware can initiate transactions.

The core hardware architecture of Intel Active Management Technology 
(Intel AMT) is resident in firmware. The micro-controller within the 
chipset's graphics and memory controller (GMCH) hub houses the 
Management Engine (ME) firmware, which implements various services 
on behalf of management applications. 

Some of the ME subsystems that can be access via MEI driver:

- Intel(R) Quiet System Technology (QST) is implemented as a firmware 
subsystem  that  runs in the ME.  Programs that wish to expose the 
health monitoring and fan speed control capabilities of Intel(R) QST 
will need to use the MEI driver to communicate with the ME sub-system.
- ASF is the "Alert Standard Format" which is an DMTF manageability 
standard. It is implemented in the PC's hardware and firmware, and is 
managed from a remote console.

Most recent Intel desktop chipsets have one or more of the above ME 
services. The MEI driver will make it possible to support the above 
features on Linux and provides applications access to the ME and it's 
features. 

Signed-off-by: Anas Nashif <anas.nashif@intel.com>
Signed-off-by: Marek Dabek <marek.dabek@intel.com>
Signed-off-by: Marcin Obara <marcin.obara@intel.com>


---
diff --git a/MAINTAINERS b/MAINTAINERS
index 9a91d9e..7b471bc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1993,6 +1993,15 @@ M:	kernel@wantstofly.org
 L:	netdev@vger.kernel.org
 S:	Maintained
 
+INTEL MANAGEABILITY ENGINE INTERFACE (HECI)
+P:	Anas Nashif
+M: 	anas.nashif@intel.com
+P:	Marek Dabek
+M:	marek.dabek@intel.com
+W:	http://www.openamt.org
+L:	openamt-devel@lists.sourceforge.net
+S:	Supported
+
 INTEL PRO/100 ETHERNET SUPPORT
 P:	John Ronciak
 M:	john.ronciak@intel.com
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index b391776..469ad5b 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -1063,6 +1063,7 @@ config DEVPORT
 	default y
 
 source "drivers/s390/char/Kconfig"
+source "drivers/char/heci/Kconfig"
 
 endmenu
 
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index c78ff26..c5ca384 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -105,6 +105,7 @@ obj-$(CONFIG_IPMI_HANDLER)	+= ipmi/
 
 obj-$(CONFIG_HANGCHECK_TIMER)	+= hangcheck-timer.o
 obj-$(CONFIG_TCG_TPM)		+= tpm/
+obj-$(CONFIG_HECI)              += heci/
 
 obj-$(CONFIG_PS3_FLASH)		+= ps3flash.o
 
diff --git a/drivers/char/heci/Kconfig b/drivers/char/heci/Kconfig
new file mode 100644
index 0000000..46715de
--- /dev/null
+++ b/drivers/char/heci/Kconfig
@@ -0,0 +1,12 @@
+#
+# HECI device configuration
+#
+
+config HECI
+       tristate "Intel Manageability Engine Interface (HECI) Support"
+       depends on EXPERIMENTAL
+       help
+         The Intel Manageability Engine Interface driver allows
+         applications to access the  Active Management Technology 
+         firmware via host interface (as opposed to a network interface).
+
diff --git a/drivers/char/heci/Makefile b/drivers/char/heci/Makefile
new file mode 100644
index 0000000..47b2217
--- /dev/null
+++ b/drivers/char/heci/Makefile
@@ -0,0 +1,7 @@
+#
+## Makefile for the Intel MEI driver (heci)
+#
+
+obj-$(CONFIG_HECI) += heci.o
+
+heci-objs := heci_init.o heci_interface.o heci_main.o interrupt.o io_heci.o
diff --git a/drivers/char/heci/heci.h b/drivers/char/heci/heci.h
new file mode 100644
index 0000000..63834dc
--- /dev/null
+++ b/drivers/char/heci/heci.h
@@ -0,0 +1,189 @@
+/*
+ * Part of Intel(R) Manageability Engine Interface Linux driver
+ *
+ * Copyright (c) 2003 - 2007 Intel Corp.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ *
+ */
+
+#ifndef _HECI_H_
+#define _HECI_H_
+
+#include <linux/version.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+#include <linux/pci.h>
+#include <linux/timer.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/module.h>
+#include <linux/aio.h>
+#include <linux/types.h>
+#include "heci_data_structures.h"
+
+extern const struct guid heci_pthi_guid;
+extern const struct guid heci_wd_guid;
+extern const __u8 start_wd_params[];
+extern const __u8 stop_wd_params[];
+
+/**
+ * memory IO BAR definition
+ */
+#define     BAR_0                        0
+#define     BAR_1                        1
+#define     BAR_5                        5
+
+/**
+ * heci device ID
+ */
+#define    PCI_HECI_DEVICE_ID01   0x2974
+#define    PCI_HECI_DEVICE_ID02   0x2984
+#define    PCI_HECI_DEVICE_ID03   0x2994
+#define    PCI_HECI_DEVICE_ID04   0x29A4
+
+#define    PCI_HECI_DEVICE_ID05   0x29B4
+#define    PCI_HECI_DEVICE_ID06   0x29C4
+#define    PCI_HECI_DEVICE_ID07   0x29D4
+#define    PCI_HECI_DEVICE_ID08   0x29E4
+#define    PCI_HECI_DEVICE_ID09   0x29F4
+
+#define    PCI_HECI_DEVICE_ID10   0x28B4
+#define    PCI_HECI_DEVICE_ID11   0x28C4
+#define    PCI_HECI_DEVICE_ID12   0x28D4
+#define    PCI_HECI_DEVICE_ID13   0x28E4
+#define    PCI_HECI_DEVICE_ID14   0x28F4
+
+#define    PCI_HECI_DEVICE_ID15   0x2A44
+#define    PCI_HECI_DEVICE_ID16   0x2A54
+#define    PCI_HECI_DEVICE_ID17   0x2A64
+#define    PCI_HECI_DEVICE_ID18   0x2A74
+
+#define    PCI_HECI_DEVICE_ID19   0x2E04
+#define    PCI_HECI_DEVICE_ID20   0x2E14
+#define    PCI_HECI_DEVICE_ID21   0x2E24
+#define    PCI_HECI_DEVICE_ID22   0x2E34
+
+/**
+ * heci init function prototypes
+ */
+struct iamt_heci_device *init_heci_device(struct pci_dev *pdev);
+void heci_reset(struct iamt_heci_device *dev, int interrupts);
+int heci_hw_init(struct iamt_heci_device *dev);
+int heci_initialize_clients(void *data);
+struct heci_file_private *alloc_priv(struct file *file);
+int heci_disconnect_host_client(struct iamt_heci_device *dev,
+				struct heci_file_private *file_ext);
+void heci_initialize_list(struct io_heci_list *list,
+			  struct iamt_heci_device *dev);
+void heci_flush_list(struct io_heci_list *list,
+		     struct heci_file_private *file_ext);
+void heci_flush_queues(struct iamt_heci_device *dev,
+		       struct heci_file_private *file_ext);
+
+void heci_remove_client_from_file_list(struct iamt_heci_device *dev,
+				       __u8 host_client_id);
+
+/**
+ *  interrupt function prototype
+ */
+irqreturn_t heci_isr_interrupt(int irq, void *dev_id);
+void heci_wd_timer(unsigned long data);
+
+/**
+ *  input output function prototype
+ */
+int heci_ioctl_get_version(struct iamt_heci_device *device, int if_num,
+			   struct heci_message_data *u_msg,
+			   struct heci_message_data k_msg,
+			   struct heci_file_private *file_ext);
+
+int heci_ioctl_connect_client(struct iamt_heci_device *device, int if_num,
+			      struct heci_message_data *u_msg,
+			      struct heci_message_data k_msg,
+			      struct file *file);
+
+int heci_ioctl_wd(struct iamt_heci_device *device, int if_num,
+		  struct heci_message_data k_msg,
+		  struct heci_file_private *file_ext);
+
+int heci_ioctl_bypass_wd(struct iamt_heci_device *device, int if_num,
+		  struct heci_message_data k_msg,
+		  struct heci_file_private *file_ext);
+
+int legacy_ioctl_send_msg(struct iamt_heci_device *device, int if_num,
+			      struct heci_message_data k_msg,
+			      struct file *file);
+
+int legacy_ioctl_recv_msg(struct iamt_heci_device *device, int if_num,
+				 struct heci_message_data *u_msg,
+				 struct heci_message_data k_msg,
+				 struct file *file);
+
+int heci_start_read(struct iamt_heci_device *device, int if_num,
+		    struct heci_file_private *file_ext);
+
+int pthi_write(struct iamt_heci_device *device,
+	       struct heci_cb_private *priv_cb);
+
+int pthi_read(struct iamt_heci_device *device, int if_num, struct file *file,
+	      char *ubuf, size_t length, loff_t *offset);
+
+struct heci_cb_private *find_pthi_read_list_entry(
+			struct iamt_heci_device *device,
+			struct file *file, struct heci_file_private *file_ext);
+
+void run_next_legacy_cmd(struct iamt_heci_device *device);
+
+/**
+ * heci_fe_same_id - tell if file extensions have same id
+ * @fe1 -file extension
+ * @fe2 -file extension
+ *
+ * @return :
+ *  1 - if ids are the same,
+ *  0 - if differ.
+ */
+static inline int heci_fe_same_id(struct heci_file_private *fe1,
+				  struct heci_file_private *fe2)
+{
+	if ((fe1->host_client_id == fe2->host_client_id)
+	    && (fe1->me_client_id == fe2->me_client_id)) {
+		return 1;
+	} else {
+		return 0;
+	}
+}
+
+#endif /* _HECI_H_ */
diff --git a/drivers/char/heci/heci_data_structures.h b/drivers/char/heci/heci_data_structures.h
new file mode 100644
index 0000000..83d7cb1
--- /dev/null
+++ b/drivers/char/heci/heci_data_structures.h
@@ -0,0 +1,511 @@
+/*
+ * Part of Intel(R) Manageability Engine Interface Linux driver
+ *
+ * Copyright (c) 2003 - 2007 Intel Corp.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ *
+ */
+
+#ifndef _HECI_DATA_STRUCTURES_H_
+#define _HECI_DATA_STRUCTURES_H_
+
+#include <linux/version.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+#include <linux/pci.h>
+#include <linux/timer.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/module.h>
+#include <linux/aio.h>
+#include <linux/types.h>
+
+/**
+ * error code definition
+ */
+#define     ESLOTS_OVERFLOW              1
+#define     ECORRUPTED_MESSAGE_HEADER    1000
+#define     ECOMPLETE_MESSAGE            1001
+#define     FC_MESSAGE_RESERVED_LENGTH           5
+
+/**
+ * Number of queue lists used by this driver
+ */
+#define NUMBER_OF_LISTS        7
+
+#define LEGACY_MTU 4160
+
+
+/**
+ * HECI HW Section
+ */
+
+/* HECI addresses and defines */
+#define H_CB_WW    0
+#define H_CSR      4
+#define ME_CB_RW   8
+#define ME_CSR_HA  0xC
+
+
+/* register bits - H_CSR */
+
+#define H_CBD             0xFF000000
+#define H_CBWP            0x00FF0000
+#define H_CBRP            0x0000FF00
+#define H_RST             0x00000010
+#define H_RDY             0x00000008
+#define H_IG              0x00000004
+#define H_IS              0x00000002
+#define H_IE              0x00000001
+
+
+/* register bits - ME_CSR_HA */
+#define ME_CBD_HRA        0xFF000000
+#define ME_CBWP_HRA       0x00FF0000
+#define ME_CBRP_HRA       0x0000FF00
+#define ME_RST_HRA        0x00000010
+#define ME_RDY_HRA        0x00000008
+#define ME_IG_HRA         0x00000004
+#define ME_IS_HRA         0x00000002
+#define ME_IE_HRA         0x00000001
+
+/**
+ *  heci driver use additional char device for legacy mode
+ */
+#define  MINORS_COUNT	2
+
+#define  LEGACY_MINOR_NUMBER	0
+#define  HECI_MINOR_NUMBER	1
+#define  MAX_OPEN_HANDLE_COUNT	253
+
+/**
+ * debug kernel print macro define
+ */
+extern int heci_debug;
+
+#define DBG(format, arg...) do { \
+	if (heci_debug) \
+		printk(KERN_ERR "%s: " format , __func__ , ## arg); \
+} while (0)
+
+
+/**
+ * time to wait event
+ */
+#define HECI_INTEROP_TIMEOUT    (HZ * 7)
+
+/**
+ * watch dog definition
+ */
+#define HECI_WATCHDOG_DATA_SIZE         16
+#define HECI_START_WD_DATA_SIZE         20
+#define HECI_WD_PARAMS_SIZE             4
+
+
+#define HECI_WD_HOST_CLIENT_ID          1
+#define HECI_LEGACY_HOST_CLIENT_ID      2
+
+struct guid {
+	__u32 data1;
+	__u16 data2;
+	__u16 data3;
+	__u8 data4[8];
+} __attribute__((packed));
+
+/* File state */
+enum file_state {
+	HECI_FILE_INITIALIZING = 0,
+	HECI_FILE_CONNECTING,
+	HECI_FILE_CONNECTED,
+	HECI_FILE_DISCONNECTING,
+	HECI_FILE_DISCONNECTED
+};
+
+/* HECI states */
+enum heci_states{
+	HECI_INITIALIZING = 0,
+	HECI_ENABLED,
+	HECI_RESETING,
+	HECI_DISABLED,
+	HECI_RECOVERING_FROM_RESET,
+	HECI_POWER_DOWN,
+	HECI_POWER_UP
+};
+
+enum legacy_states {
+	HECI_LEGACY_IDLE,
+	HECI_LEGACY_WRITING,
+	HECI_LEGACY_FLOW_CONTROL,
+	HECI_LEGACY_READING,
+	HECI_LEGACY_READ_COMPLETE
+};
+
+enum heci_file_transaction_states {
+	HECI_IDLE,
+	HECI_WRITING,
+	HECI_WRITE_COMPLETE,
+	HECI_FLOW_CONTROL,
+	HECI_READING,
+	HECI_READ_COMPLETE
+};
+
+/* HECI CB */
+enum heci_cb_major_types {
+	HECI_READ = 0,
+	HECI_WRITE,
+	HECI_IOCTL,
+	HECI_OPEN,
+	HECI_CLOSE
+};
+
+/* HECI user data struct */
+struct heci_message_data {
+	__u32 size;
+	char *data;
+} __attribute__((packed));
+
+#define SECOND_TO_MILLI                 1000
+#define SECOND_TO_MICRO                 SECOND_TO_MILLI * 1000
+#define SECOND_TO_100NANO               SECOND_TO_MICRO * 10
+
+#define CONNECT_TIMEOUT                 3	/* at least 2 seconds */
+
+#define LEGACY_STALL_TIMER              12	/* seconds */
+#define LEGACY_READ_TIMER               15	/* seconds */
+
+struct heci_cb_private {
+	struct list_head cb_list;
+	enum heci_cb_major_types major_file_operations;
+	void *file_private;
+	struct heci_message_data request_buffer;
+	struct heci_message_data response_buffer;
+	unsigned long information;
+	unsigned long read_time;
+	struct file *file_object;
+};
+
+/* Private file struct */
+struct heci_file_private {
+	struct list_head link;
+	struct file *file;
+	enum file_state state;
+	wait_queue_head_t tx_wait;
+	wait_queue_head_t rx_wait;
+	wait_queue_head_t wait;
+	spinlock_t file_lock; /* file lock */
+	spinlock_t read_io_lock; /* read lock */
+	spinlock_t write_io_lock; /* write lock */
+	int read_pending;
+	int status;
+	/* ID of client connected */
+	__u8 host_client_id;
+	__u8 me_client_id;
+	__u8 flow_ctrl_creds;
+	__u8 timer_count;
+	enum heci_file_transaction_states reading_state;
+	enum heci_file_transaction_states writing_state;
+	struct heci_cb_private *read_cb;
+};
+
+struct io_heci_list {
+	struct heci_cb_private heci_cb;
+	int status;
+	struct iamt_heci_device *device_extension;
+};
+
+struct heci_driver_version {
+	__u8 major;
+	__u8 minor;
+	__u8 hotfix;
+	__u16 build;
+} __attribute__((packed));
+
+
+struct heci_client {
+	__u32 max_msg_length;
+	__u8 protocol_version;
+} __attribute__((packed));
+
+/*
+ *  HECI BUS Interface Section
+ */
+struct heci_msg_hdr {
+	__u32 me_addr:8;
+	__u32 host_addr:8;
+	__u32 length:9;
+	__u32 reserved:6;
+	__u32 msg_complete:1;
+} __attribute__((packed));
+
+
+struct hbm_cmd {
+	__u8 cmd:7;
+	__u8 is_response:1;
+} __attribute__((packed));
+
+
+struct heci_bus_message {
+	struct hbm_cmd cmd;
+	__u8 command_specific_data[];
+} __attribute__((packed));
+
+struct hbm_version {
+	__u8 minor_version;
+	__u8 major_version;
+} __attribute__((packed));
+
+struct hbm_host_version_request {
+	struct hbm_cmd cmd;
+	__u8 reserved;
+	struct hbm_version host_version;
+} __attribute__((packed));
+
+struct hbm_host_version_response {
+	struct hbm_cmd cmd;
+	int host_version_supported;
+	struct hbm_version me_max_version;
+} __attribute__((packed));
+
+struct hbm_host_stop_request {
+	struct hbm_cmd cmd;
+	__u8 reason;
+	__u8 reserved[2];
+} __attribute__((packed));
+
+struct hbm_host_stop_response {
+	struct hbm_cmd cmd;
+	__u8 reserved[3];
+} __attribute__((packed));
+
+struct hbm_me_stop_request {
+	struct hbm_cmd cmd;
+	__u8 reason;
+	__u8 reserved[2];
+} __attribute__((packed));
+
+struct hbm_host_enum_request {
+	struct hbm_cmd cmd;
+	__u8 reserved[3];
+} __attribute__((packed));
+
+struct hbm_host_enum_response {
+	struct hbm_cmd cmd;
+	__u8 reserved[3];
+	__u8 valid_addresses[32];
+} __attribute__((packed));
+
+struct heci_client_properties {
+	struct guid protocol_name;
+	__u8 protocol_version;
+	__u8 max_number_of_connections;
+	__u8 fixed_address;
+	__u8 single_recv_buf;
+	__u32 max_msg_length;
+} __attribute__((packed));
+
+struct hbm_props_request {
+	struct hbm_cmd cmd;
+	__u8 address;
+	__u8 reserved[2];
+} __attribute__((packed));
+
+
+struct hbm_props_response {
+	struct hbm_cmd cmd;
+	__u8 address;
+	__u8 status;
+	__u8 reserved[1];
+	struct heci_client_properties client_properties;
+} __attribute__((packed));
+
+struct hbm_client_connect_request {
+	struct hbm_cmd cmd;
+	__u8 me_addr;
+	__u8 host_addr;
+	__u8 reserved;
+} __attribute__((packed));
+
+struct hbm_client_connect_response {
+	struct hbm_cmd cmd;
+	__u8 me_addr;
+	__u8 host_addr;
+	__u8 status;
+} __attribute__((packed));
+
+struct hbm_client_disconnect_request {
+	struct hbm_cmd cmd;
+	__u8 me_addr;
+	__u8 host_addr;
+	__u8 reserved[1];
+} __attribute__((packed));
+
+struct hbm_flow_control {
+	struct hbm_cmd cmd;
+	__u8 me_addr;
+	__u8 host_addr;
+	__u8 reserved[FC_MESSAGE_RESERVED_LENGTH];
+} __attribute__((packed));
+
+struct heci_me_client {
+	struct heci_client_properties props;
+	__u8 client_id;
+	__u8 flow_ctrl_creds;
+} __attribute__((packed));
+
+/* private device struct */
+struct iamt_heci_device {
+	struct pci_dev *pdev;	/* pointer to pci device struct */
+	/*
+	 * lists of queues
+	 */
+	 /* array of pointers to  aio lists */
+	struct io_heci_list *io_list_array[NUMBER_OF_LISTS];
+	struct io_heci_list read_list;	/* driver read queue */
+	struct io_heci_list write_list;	/* driver write queue */
+	struct io_heci_list write_waiting_list;	/* write waiting queue */
+	struct io_heci_list ctrl_wr_list;	/* managed write IOCTL list */
+	struct io_heci_list ctrl_rd_list;	/* managed read IOCTL list */
+	struct io_heci_list pthi_cmd_list;	/* PTHI list for cmd waiting */
+
+	/* driver managed PTHI list for  read completed pthi cmd data */
+	struct io_heci_list pthi_read_complete_list;
+	/*
+	 * list of files
+	 */
+	struct list_head file_list;
+	/*
+	 * memory of device
+	 */
+	unsigned int mem_base;
+	unsigned int mem_length;
+	char *mem_addr;
+	/*
+	 * lock for the device
+	 */
+	spinlock_t device_lock; /* device lock*/
+	spinlock_t extra_lock;  /* extra lock */
+	/*
+	 * intterupts
+	 */
+	int irq;
+	struct work_struct work;
+	int recvd_msg;
+
+	struct timer_list timer;
+	struct timer_list wd_timer;
+	/*
+	 * hw states of host and fw(ME)
+	 */
+	__u32 host_hw_state;
+	__u32 me_hw_state;
+	/*
+	 * waiting queue for receive message from FW
+	 */
+	wait_queue_head_t wait_recvd_msg;
+	wait_queue_head_t wait_stop_wd;
+	/*
+	 * heci device  states
+	 */
+	enum heci_states heci_state;
+	int stop;
+
+	__u32 extra_write_index;
+	__u32 rd_msg_buf[128];	/* used for control messages */
+	__u32 wr_msg_buf[128];	/* used for control messages */
+	__u32 ext_msg_buf[8];	/* for control responses    */
+	__u32 rd_msg_hdr;
+
+	struct hbm_version version;
+
+	int host_buffer_is_empty;
+	struct heci_file_private wd_file_ext;
+	struct heci_me_client *me_clients; /* Note: memory has to be allocated*/
+	__u8 heci_me_clients[32];	/* list of existing clients */
+	__u8 num_heci_me_clients;
+	__u8 heci_host_clients[32];	/* list of existing clients */
+	__u8 current_host_client_id;
+
+	int wd_pending;
+	int wd_stoped;
+	__u16 wd_timeout;	/* seconds ((wd_data[1] << 8) + wd_data[0]) */
+	unsigned char wd_data[HECI_START_WD_DATA_SIZE];
+
+
+	__u16 wd_due_counter;
+	int asf_mode;
+	int wd_bypass;	/* if 1, don't refresh watchdog ME client */
+
+	/* maybe this is not required */
+	struct file *legacy_file_object;
+	struct heci_file_private legacy_file_ext;
+	int legacy_ioctl;
+	int legacy_canceled;
+	__u32 legacy_timer;
+	__u32 legacy_stall_timer;
+	unsigned char legacy_msg_buf[LEGACY_MTU];
+	__u32 legacy_msg_buf_size;
+	__u32 legacy_msg_buf_index;
+	int legacy_flow_control_pending;
+	enum legacy_states legacy_state;
+
+	struct heci_cb_private *legacy_current_cb;
+	__u8 write_hang;
+	int need_reset;
+	long open_handle_count;
+
+};
+
+/**
+ * read_heci_register - Read a byte from the heci device
+ * @device: the device structure
+ * @offset: offset from which to read the data
+ *
+ * Return:
+ * the byte read.
+ */
+__u32 read_heci_register(struct iamt_heci_device *device,
+			    unsigned long offset);
+
+/**
+ * write_heci_register - Write  4 bytes to the heci device
+ * @device: the device structure
+ * @offset: offset from which to write the data
+ *
+ * @value: the byte to write
+ */
+void write_heci_register(struct iamt_heci_device *device, unsigned long offset,
+			 __u32 value);
+
+#endif /* _HECI_DATA_STRUCTURES_H_ */
diff --git a/drivers/char/heci/heci_init.c b/drivers/char/heci/heci_init.c
new file mode 100644
index 0000000..3195895
--- /dev/null
+++ b/drivers/char/heci/heci_init.c
@@ -0,0 +1,1080 @@
+/*
+ * Part of Intel(R) Manageability Engine Interface Linux driver
+ *
+ * Copyright (c) 2007 Intel Corp.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/reboot.h>
+#include <linux/poll.h>
+#include <linux/init.h>
+#include <linux/kdev_t.h>
+#include <linux/moduleparam.h>
+#include <linux/wait.h>
+#include <linux/delay.h>
+#include <linux/uaccess.h>
+
+#include "heci_data_structures.h"
+#include "heci_interface.h"
+#include "heci.h"
+
+
+const __u8 watch_dog_data[] = {
+	1, 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
+};
+const __u8 start_wd_params[] = { 0x02, 0x12, 0x13, 0x10 };
+const __u8 stop_wd_params[] = { 0x02, 0x02, 0x14, 0x10 };
+const struct guid heci_asf_guid = {
+	0x75B30CD6, 0xA29E, 0x4AF7,
+	{0xA7, 0x12, 0xE6, 0x17, 0x43, 0x93, 0xC8, 0xA6}
+};
+const struct guid heci_wd_guid = {
+	0x05B79A6F, 0x4628, 0x4D7F,
+	{0x89, 0x9D, 0xA9, 0x15, 0x14, 0xCB, 0x32, 0xAB}
+};
+const struct guid heci_pthi_guid = {
+	0x12f80028, 0xb4b7, 0x4b2d,
+	{0xac, 0xa8, 0x46, 0xe0, 0xff, 0x65, 0x81, 0x4c}
+};
+
+
+/**
+ *  heci init function prototypes
+ */
+static int host_start_message(struct iamt_heci_device *dev);
+static int host_enum_clients_message(struct iamt_heci_device *dev);
+static int allocate_me_clients_storage(struct iamt_heci_device *dev);
+static void host_init_wd(struct iamt_heci_device *dev);
+static void host_init_legacy(struct iamt_heci_device *dev);
+static int heci_wait_event_int_timeout(struct iamt_heci_device *dev,
+				       long timeout);
+
+
+/**
+ * heci_initialize_list - Sets up a  queue  list.
+ *
+ * @list - An instance of our list structure
+ * @dev -Device object for our driver
+ *
+ * @return :
+ * none;
+ */
+void heci_initialize_list(struct io_heci_list *list,
+			  struct iamt_heci_device *dev)
+{
+	/* initialize our queue list */
+	INIT_LIST_HEAD(&list->heci_cb.cb_list);
+	list->status = 0;
+	list->device_extension = dev;
+}
+
+/**
+ * heci_flush_queues - flush our queues list belong to file_ext.
+ *
+ * @dev -Device object for our driver
+ *
+ * @return :
+ * none;
+ */
+void heci_flush_queues(struct iamt_heci_device *dev,
+		       struct heci_file_private *file_ext)
+{
+	int i;
+
+	if (!dev || !file_ext)
+		return;
+
+	/* flush our queue list belong to file_ext */
+	for (i = 0; i < NUMBER_OF_LISTS; i++) {
+		DBG("remove list etnry belong to file_ext\n");
+		heci_flush_list(dev->io_list_array[i], file_ext);
+	}
+}
+
+
+/**
+ * heci_flush_list - remove list etnry belong to file_ext.
+ *
+ * @list - An instance of our list structure
+ * @file_ext -extension of the file object
+
+ * @return :
+ * none;
+ */
+void heci_flush_list(struct io_heci_list *list,
+		struct heci_file_private *file_ext)
+{
+	struct heci_file_private *file_ext_tmp = NULL;
+	struct heci_cb_private *priv_cb_pos = NULL;
+	struct heci_cb_private *priv_cb_next = NULL;
+
+	if (!list || !file_ext)
+		return;
+
+	if (list->status == 0
+	    && !list_empty(&list->heci_cb.cb_list)) {
+		list_for_each_entry_safe(priv_cb_pos,
+				priv_cb_next, &list->heci_cb.cb_list, cb_list) {
+			if (priv_cb_pos)
+				file_ext_tmp = (struct heci_file_private *)
+					priv_cb_pos->file_private;
+
+			if (file_ext_tmp) {
+				if (heci_fe_same_id(file_ext, file_ext_tmp))
+					list_del(&priv_cb_pos->cb_list);
+
+			}
+
+		}
+	}
+}
+
+/**
+ * init_heci_device - allocates and initializes the heci device structure
+ * @pdev: The pci device structure
+ *
+ * @return :
+ * The heci_device_device pointer on success, NULL on failure.
+ */
+struct iamt_heci_device *init_heci_device(struct pci_dev *pdev)
+{
+	int i;
+	struct iamt_heci_device *device;
+
+	device = kmalloc(sizeof(struct iamt_heci_device), GFP_KERNEL);
+	if (!device)
+		return NULL;
+
+	/* setup our list array */
+	device->io_list_array[0] = &device->read_list;
+	device->io_list_array[1] = &device->write_list;
+	device->io_list_array[2] = &device->write_waiting_list;
+	device->io_list_array[3] = &device->ctrl_wr_list;
+	device->io_list_array[4] = &device->ctrl_rd_list;
+	device->io_list_array[5] = &device->pthi_cmd_list;
+	device->io_list_array[6] = &device->pthi_read_complete_list;
+	INIT_LIST_HEAD(&device->file_list);
+	INIT_LIST_HEAD(&device->wd_file_ext.link);
+	INIT_LIST_HEAD(&device->legacy_file_ext.link);
+	spin_lock_init(&device->device_lock);
+	init_waitqueue_head(&device->wait_recvd_msg);
+	init_waitqueue_head(&device->wait_stop_wd);
+	device->open_handle_count = 0;
+	device->num_heci_me_clients = 0;
+	device->mem_base = 0;
+	device->mem_length = 0;
+	device->extra_write_index = 0;
+	device->rd_msg_hdr = 0;
+	device->mem_addr = NULL;
+	device->asf_mode = 0;
+	device->need_reset = 0;
+	device->recvd_msg = 0;
+	device->heci_state = HECI_INITIALIZING;
+
+	device->num_heci_me_clients = 0;
+	device->legacy_current_cb = NULL;
+	device->legacy_file_object = NULL;
+	device->legacy_canceled = 0;
+	device->legacy_flow_control_pending = 0;
+	device->legacy_state = HECI_LEGACY_IDLE;
+	device->legacy_msg_buf_index = 0;
+	device->wd_pending = 0;
+	device->wd_stoped = 0;
+	device->wd_bypass = 0;
+
+	device->me_clients = NULL;
+	/* init work for schedule work */
+	INIT_WORK(&device->work, NULL);
+	for (i = 0; i < NUMBER_OF_LISTS; i++)
+		heci_initialize_list(device->io_list_array[i], device);
+	device->pdev = pdev;
+	return device;
+}
+
+
+
+
+static int heci_wait_event_int_timeout(struct iamt_heci_device *dev,
+		long timeout)
+{
+	int err = 0;
+
+	err = wait_event_interruptible_timeout(dev->wait_recvd_msg,
+			(dev->recvd_msg), timeout);
+	return err;
+}
+
+/**
+ * heci_hw_init  - init host and fw to start work.
+ *
+ * @dev -Device object for our driver
+ *
+ *@return:
+ * 0 on success.
+ * negative on failure
+ */
+int heci_hw_init(struct iamt_heci_device *dev)
+{
+	int err = 0;
+
+	dev->host_hw_state = read_heci_register(dev, H_CSR);
+	dev->me_hw_state = read_heci_register(dev, ME_CSR_HA);
+	DBG("host_hw_state = 0x%08x, mestate = 0x%08x.\n",
+	    dev->host_hw_state, dev->me_hw_state);
+
+	if ((dev->host_hw_state & H_IS) == H_IS) {
+		/* acknowledge interrupt and stop interupts */
+		write_heci_register(dev, H_CSR, dev->host_hw_state);
+	}
+	dev->recvd_msg = 0;
+	DBG("reset in start the heci device.\n");
+
+	heci_reset(dev, 1);
+
+	DBG("host_hw_state = 0x%08x, me_hw_state = 0x%08x.\n",
+	    dev->host_hw_state, dev->me_hw_state);
+
+	/* wait for ME to turn on ME_RDY */
+	if (!dev->recvd_msg)
+		err = heci_wait_event_int_timeout(dev, HECI_INTEROP_TIMEOUT);
+
+	if (!err && !dev->recvd_msg) {
+		dev->heci_state = HECI_DISABLED;
+		DBG("wait_event_interruptible_timeout failed"
+		    "on wait for ME to turn on ME_RDY.\n");
+		return -ENODEV;
+	} else {
+		if (!(((dev->host_hw_state & H_RDY) == H_RDY)
+		      && ((dev->me_hw_state & ME_RDY_HRA) == ME_RDY_HRA))) {
+			dev->heci_state = HECI_DISABLED;
+			DBG("host_hw_state = 0x%08x, me_hw_state = 0x%08x.\n",
+			    dev->host_hw_state,
+			    dev->me_hw_state);
+
+			if (!(dev->host_hw_state & H_RDY) != H_RDY)
+				DBG("host turn off H_RDY.\n");
+
+			if (!(dev->me_hw_state & ME_RDY_HRA) != ME_RDY_HRA)
+				DBG("ME turn off ME_RDY.\n");
+
+			printk(KERN_ERR
+			       "%s: link layer initialization failed.\n",
+			       THIS_MODULE->name);
+			return -ENODEV;
+		}
+	}
+	dev->recvd_msg = 0;
+	DBG("host_hw_state = 0x%08x, me_hw_state = 0x%08x.\n",
+	    dev->host_hw_state, dev->me_hw_state);
+	DBG("ME turn on ME_RDY and host turn on H_RDY.\n");
+	printk(KERN_INFO "%s: link layer has been established.\n",
+	       THIS_MODULE->name);
+	return 0;
+}
+
+/**
+ * heci_reset  - reset host and fw.
+ *
+ * @dev -Device object for our driver
+ * @interrupts - if interrupt should be enable after reset.
+ *
+ * @return:
+ * none;
+ */
+void heci_reset(struct iamt_heci_device *dev, int interrupts)
+{
+	struct heci_file_private *file_pos = NULL;
+	struct heci_file_private *file_next = NULL;
+	struct heci_cb_private *priv_cb_pos = NULL;
+	struct heci_cb_private *priv_cb_next = NULL;
+	int unexpected = 0;
+
+	if (dev->heci_state == HECI_RECOVERING_FROM_RESET) {
+		dev->need_reset = 1;
+		return;
+	}
+
+	if (dev->heci_state != HECI_INITIALIZING &&
+	    dev->heci_state != HECI_DISABLED &&
+	    dev->heci_state != HECI_POWER_DOWN &&
+	    dev->heci_state != HECI_POWER_UP)
+		unexpected = 1;
+
+	dev->host_hw_state = read_heci_register(dev, H_CSR);
+
+	DBG("before reset host_hw_state = 0x%08x.\n",
+	    dev->host_hw_state);
+
+	dev->host_hw_state |= (H_RST | H_IG);
+
+	if (interrupts)
+		dev->host_hw_state |= (H_IE);
+	else
+		dev->host_hw_state &= ~(H_IE);
+
+	write_heci_register(dev, H_CSR, dev->host_hw_state);
+
+	dev->host_hw_state = read_heci_register(dev, H_CSR);
+	BUG_ON((dev->host_hw_state & H_RST) != H_RST);
+	BUG_ON((dev->host_hw_state & H_RDY) != 0);
+
+	dev->host_hw_state &= ~H_RST;
+	dev->host_hw_state |= H_IG;
+
+	write_heci_register(dev, H_CSR, dev->host_hw_state);
+
+	DBG("currently saved host_hw_state = 0x%08x.\n",
+	    dev->host_hw_state);
+
+	dev->need_reset = 0;
+
+	if (dev->heci_state != HECI_INITIALIZING) {
+		if ((dev->heci_state != HECI_DISABLED) &&
+		    (dev->heci_state != HECI_POWER_DOWN))
+			dev->heci_state = HECI_RESETING;
+
+		list_for_each_entry_safe(file_pos,
+				file_next, &dev->file_list, link) {
+			file_pos->state = HECI_FILE_DISCONNECTED;
+			file_pos->flow_ctrl_creds = 0;
+			file_pos->read_cb = NULL;
+			file_pos->timer_count = 0;
+		}
+		/* remove entry if already in list */
+		DBG("list del legacy and wd file list.\n");
+		heci_remove_client_from_file_list(dev,
+				dev->wd_file_ext.host_client_id);
+
+		heci_remove_client_from_file_list(dev,
+				dev->legacy_file_ext.host_client_id);
+		/* reset legacy parameters. */
+		dev->legacy_current_cb = NULL;
+		dev->legacy_msg_buf_size = 0;
+		dev->legacy_msg_buf_index = 0;
+		dev->legacy_canceled = 0;
+		dev->legacy_file_ext.file = NULL;
+		dev->legacy_ioctl = 0;
+		dev->legacy_state = HECI_LEGACY_IDLE;
+		dev->legacy_timer = 0;
+		dev->wd_due_counter = 0;
+		dev->extra_write_index = 0;
+		dev->wd_pending = 0;
+	}
+
+	dev->num_heci_me_clients = 0;
+	dev->rd_msg_hdr = 0;
+	dev->stop = 0;
+	dev->wd_pending = 0;
+
+	/* update the state of the registers after reset */
+	dev->host_hw_state =  read_heci_register(dev, H_CSR);
+	dev->me_hw_state =  read_heci_register(dev, ME_CSR_HA);
+
+	DBG("after reset host_hw_state = 0x%08x, me_hw_state = 0x%08x.\n",
+	    dev->host_hw_state, dev->me_hw_state);
+
+	if (unexpected)
+		printk(KERN_ERR "%s: unexpected heci reset.\n",
+		       THIS_MODULE->name);
+
+	/* Wake up all readings so they can be interrupted */
+	list_for_each_entry_safe(file_pos, file_next, &dev->file_list, link) {
+		if (&file_pos->rx_wait &&
+		    waitqueue_active(&file_pos->rx_wait)) {
+			printk(KERN_INFO "%s: Waking up client!\n",
+			       THIS_MODULE->name);
+			wake_up_interruptible(&file_pos->rx_wait);
+		}
+	}
+	/* remove all waiting requests */
+	if (dev->write_list.status == 0 &&
+		!list_empty(&dev->write_list.heci_cb.cb_list)) {
+		list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+				&dev->write_list.heci_cb.cb_list, cb_list) {
+			if (priv_cb_pos) {
+				list_del(&priv_cb_pos->cb_list);
+				kfree(priv_cb_pos->request_buffer.data);
+				priv_cb_pos->request_buffer.data = NULL;
+				kfree(priv_cb_pos->response_buffer.data);
+				priv_cb_pos->response_buffer.data = NULL;
+				kfree(priv_cb_pos);
+				priv_cb_pos = NULL;
+			}
+		}
+	}
+}
+
+/**
+ * heci_initialize_clients  -  routine.
+ *
+ * @dev -Device object for our driver
+ *
+ * @return:
+ * none;
+ */
+int heci_initialize_clients(void *data)
+{
+	int status;
+	struct iamt_heci_device *dev = (struct iamt_heci_device *) data;
+
+	msleep(100); /* FW needs time to be ready to talk with us */
+	DBG("link is established start sending messages.\n");
+	/* link is established start sending messages. */
+	status = host_start_message(dev);
+	if (status) {
+		DBG("start sending messages failed.\n");
+		return -ENODEV;
+	}
+	/* enumerate clients */
+
+	status = host_enum_clients_message(dev);
+	if (status) {
+		DBG("enum clients failed.\n");
+		return -ENODEV;
+	}
+	/* allocate storage for ME clients representation */
+	status = allocate_me_clients_storage(dev);
+	if (status) {
+		DBG("allocate clients failed.\n");
+		return -ENODEV;
+	}
+	/*heci initialization wd */
+	host_init_wd(dev);
+	/*heci initialization legacy client */
+	host_init_legacy(dev);
+	if (dev->need_reset) {
+		dev->need_reset = 0;
+		dev->heci_state = HECI_DISABLED;
+		return -ENODEV;
+	}
+
+	memset(dev->heci_host_clients, 0, sizeof(dev->heci_host_clients));
+	dev->open_handle_count = 0;
+	dev->heci_host_clients[0] |= 7;
+	dev->current_host_client_id = 3;
+	dev->heci_state = HECI_ENABLED;
+	DBG("initialization heci clients successful.\n");
+	return 0;
+}
+
+/**
+ * host_start_message - heci host send start message.
+ *
+ * @dev - Device object for our driver
+ *
+ * @return :
+ *  0 on success,
+ *  negative on failure.
+ */
+static int host_start_message(struct iamt_heci_device *dev)
+{
+	long timeout = 60;	/* 60 second */
+
+	struct heci_msg_hdr *heci_hdr;
+	struct hbm_host_version_request *host_start_req;
+	struct hbm_host_stop_request *host_stop_req;
+	int err = 0;
+
+	/* host start message */
+	heci_hdr = (struct heci_msg_hdr *) &dev->wr_msg_buf[0];
+	heci_hdr->host_addr = 0;
+	heci_hdr->me_addr = 0;
+	heci_hdr->length = sizeof(struct hbm_host_version_request);
+	heci_hdr->msg_complete = 1;
+	heci_hdr->reserved = 0;
+
+	host_start_req =
+	    (struct hbm_host_version_request *) &dev->wr_msg_buf[1];
+	memset(host_start_req, 0, sizeof(host_start_req));
+	host_start_req->cmd.cmd = HOST_START_REQ_CMD;
+	host_start_req->reserved = 0;
+	host_start_req->host_version.major_version = HBM_MAJOR_VERSION;
+	host_start_req->host_version.minor_version = HBM_MINOR_VERSION;
+	dev->recvd_msg = 0;
+	if (!heci_write_message(dev, heci_hdr,
+				       (unsigned char *) (host_start_req),
+				       heci_hdr->length)) {
+		dev->heci_state = HECI_DISABLED;
+		DBG("send version to fw fail.\n");
+		return -ENODEV;
+	}
+	DBG("call wait_event_interruptible_timeout for response message.\n");
+	/* wait for response */
+	err = heci_wait_event_int_timeout(dev, timeout * HZ);
+	if (!err && !dev->recvd_msg) {
+		dev->heci_state = HECI_DISABLED;
+		DBG("wait_timeout failed on host start response message.\n");
+		return -ENODEV;
+	}
+	dev->recvd_msg = 0;
+	DBG("wait_timeout successful on host start response message.\n");
+	if ((dev->version.major_version != HBM_MAJOR_VERSION) ||
+	    (dev->version.minor_version != HBM_MINOR_VERSION)) {
+		/* send stop message */
+		heci_hdr->host_addr = 0;
+		heci_hdr->me_addr = 0;
+		heci_hdr->length = sizeof(struct hbm_host_stop_request);
+		heci_hdr->msg_complete = 1;
+		heci_hdr->reserved = 0;
+
+		host_stop_req =
+		    (struct hbm_host_stop_request *) &dev->wr_msg_buf[1];
+
+		memset(host_stop_req, 0, sizeof(host_stop_req));
+		host_stop_req->cmd.cmd = HOST_STOP_REQ_CMD;
+		host_stop_req->reason = DRIVER_STOP_REQUEST;
+		memset(host_stop_req->reserved, 0,
+		       sizeof(host_stop_req->reserved));
+		heci_write_message(dev, heci_hdr,
+				   (unsigned char *) (host_stop_req),
+				   heci_hdr->length);
+		DBG("version  mismatch.\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+/**
+ * host_enum_clients_message - host send enumeration client request message.
+ *
+ * @dev - Device object for our driver
+ *
+ * @return :
+ *  0 on success,
+ *  negative on failure.
+ */
+static int host_enum_clients_message(struct iamt_heci_device *dev)
+{
+	long timeout = 5;	/*5 second */
+	struct heci_msg_hdr *heci_hdr;
+	struct hbm_host_enum_request *host_enum_req;
+	int err = 0;
+	__u8 i, j;
+
+	heci_hdr = (struct heci_msg_hdr *) &dev->wr_msg_buf[0];
+	/* enumerate clients */
+	heci_hdr->host_addr = 0;
+	heci_hdr->me_addr = 0;
+	heci_hdr->length = sizeof(struct hbm_host_enum_request);
+	heci_hdr->msg_complete = 1;
+	heci_hdr->reserved = 0;
+
+	host_enum_req = (struct hbm_host_enum_request *) &dev->wr_msg_buf[1];
+	memset(host_enum_req, 0, sizeof(host_enum_req));
+	host_enum_req->cmd.cmd = HOST_ENUM_REQ_CMD;
+	memset(host_enum_req->reserved, 0, sizeof(host_enum_req->reserved));
+	if (!heci_write_message(dev, heci_hdr,
+			       (unsigned char *) (host_enum_req),
+			       heci_hdr->length)) {
+		dev->heci_state = HECI_DISABLED;
+		DBG("send enumeration request fail.\n");
+		return -ENODEV;
+	}
+	/* wait for response */
+	dev->recvd_msg = 0;
+	err = heci_wait_event_int_timeout(dev, timeout * HZ);
+	if (!err && !dev->recvd_msg) {
+		dev->heci_state = HECI_DISABLED;
+		DBG("wait_event_interruptible_timeout failed "
+				"on enumeration cients response message.\n");
+		return -ENODEV;
+	}
+	dev->recvd_msg = 0;
+	/* count how many ME clients we have */
+	for (i = 0; i < sizeof(dev->heci_me_clients); i++) {
+		for (j = 0; j < 8; j++) {
+			if ((dev->heci_me_clients[i] & (1 << j)) != 0)
+				dev->num_heci_me_clients++;
+
+		}
+	}
+	return 0;
+}
+
+/**
+ * allocate_me_clients_storage - allocate storage for me clients
+ *
+ * @dev - Device object for our driver
+ *
+ * @return :
+ *  0 on success,
+ *  negative on failure.
+ */
+static int allocate_me_clients_storage(struct iamt_heci_device *dev)
+{
+	long timeout = 10;	/*10 second */
+	struct heci_msg_hdr *heci_hdr;
+	struct hbm_props_request *host_cli_req;
+	__u8 num, i, j;
+	int err;
+
+	heci_hdr = (struct heci_msg_hdr *) &dev->wr_msg_buf[0];
+	/* allocate storage for ME clients representation */
+
+	if (dev->num_heci_me_clients <= 0)
+		return 0;
+
+	kfree(dev->me_clients);
+	dev->me_clients = kcalloc(dev->num_heci_me_clients,
+			sizeof(struct heci_me_client), GFP_KERNEL);
+	if (!dev->me_clients) {
+		dev->heci_state = HECI_DISABLED;
+		DBG("allocate me clents  memory failed.\n");
+		return -ENOMEM;
+	}
+
+	num = 0;
+
+	for (i = 0; i < sizeof(dev->heci_me_clients); i++) {
+		for (j = 0; j < 8; j++) {
+			if ((dev->heci_me_clients[i] & (1 << j)) != 0) {
+				struct heci_me_client *client;
+				client = &dev->me_clients[num];
+
+				client->client_id = (i * 8) + j;
+				client->flow_ctrl_creds = 0;
+				heci_hdr->host_addr = 0;
+				heci_hdr->me_addr = 0;
+				heci_hdr->length =
+					sizeof(struct hbm_props_request);
+				heci_hdr->msg_complete = 1;
+				heci_hdr->reserved = 0;
+
+				host_cli_req =
+					(struct hbm_props_request *)
+					&dev->wr_msg_buf[1];
+
+				memset(host_cli_req, 0,
+					sizeof(struct hbm_props_request));
+				host_cli_req->cmd.cmd =
+					HOST_CLIENT_PROPERTEIS_REQ_CMD;
+				host_cli_req->address = client->client_id;
+
+				memset(host_cli_req->reserved, 0,
+						sizeof(host_cli_req->reserved));
+				if (!heci_write_message(dev,
+					heci_hdr,
+					(unsigned char *) (host_cli_req),
+					heci_hdr->length)) {
+					DBG("send props request fail.\n");
+					dev->heci_state = HECI_DISABLED;
+					kfree(dev->me_clients);
+					return -ENODEV;
+				}
+				/* wait for response */
+				dev->recvd_msg = 0;
+				err = heci_wait_event_int_timeout(dev,
+						timeout * HZ);
+				if (!err && !dev->recvd_msg) {
+					DBG("wait failed on props resp msg\n");
+					dev->heci_state = HECI_DISABLED;
+					kfree(dev->me_clients);
+					return -ENODEV;
+				}
+				dev->recvd_msg = 0;
+				num++;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * host_init_wd - heci initialization wd.
+ *
+ * @dev - Device object for our driver
+ *
+ * @return :
+ * none;
+ */
+static void host_init_wd(struct iamt_heci_device *dev)
+{
+	long timeout = 15;	/*15 second */
+	__u8 i;
+	int err = 0;
+
+	/* look for WD client and connect to it */
+	spin_lock_init(&dev->wd_file_ext.file_lock);
+	init_waitqueue_head(&dev->wd_file_ext.wait);
+	dev->wd_file_ext.file = NULL;
+	dev->wd_file_ext.state = HECI_FILE_DISCONNECTED;
+	dev->wd_timeout = 0;
+	dev->asf_mode = 0;
+	/* find ME ASF client - otherwise assume AMT mode */
+	DBG("find ME ASF client - otherwise assume AMT mode.\n");
+	for (i = 0; i < dev->num_heci_me_clients; i++) {
+		if (memcmp(&heci_asf_guid,
+				&dev->me_clients[i].props.protocol_name,
+				sizeof(struct guid)) == 0) {
+			dev->asf_mode = 1;
+			DBG("found ME ASF client.\n");
+		}
+	}
+	if (dev->asf_mode) {
+		memcpy(dev->wd_data, stop_wd_params, HECI_WD_PARAMS_SIZE);
+	} else {
+		/* AMT mode */
+		DBG("assume AMT mode.\n");
+		dev->wd_timeout = AMT_WD_VALUE;
+		DBG("dev->wd_timeout=%d.\n", dev->wd_timeout);
+		memcpy(dev->wd_data, start_wd_params, HECI_WD_PARAMS_SIZE);
+		memcpy(dev->wd_data + HECI_WD_PARAMS_SIZE,
+		       &dev->wd_timeout, sizeof(__u16));
+	}
+
+	/* find ME WD client */
+	for (i = 0; i < dev->num_heci_me_clients; i++) {
+		if (memcmp(&heci_wd_guid,
+			   &dev->me_clients[i].props.protocol_name,
+			   sizeof(struct guid)) == 0) {
+			spin_lock_bh(&dev->device_lock);
+			dev->wd_file_ext.me_client_id =
+				dev->me_clients[i].client_id;
+			dev->wd_file_ext.state =
+				HECI_FILE_CONNECTING;
+			dev->wd_file_ext.host_client_id =
+				HECI_WD_HOST_CLIENT_ID;
+
+			dev->wd_file_ext.flow_ctrl_creds = 0;
+			dev->wd_file_ext.timer_count = 0;
+			list_add_tail(&dev->wd_file_ext.link, &dev->file_list);
+			spin_unlock_bh(&dev->device_lock);
+			break;
+		}
+	}
+	DBG("check wd_file_ext\n");
+	if (HECI_FILE_CONNECTING == dev->wd_file_ext.state) {
+		if (heci_connect(dev, &dev->wd_file_ext)) {
+			err = wait_event_timeout(dev->wait_recvd_msg,
+			    (HECI_FILE_CONNECTED == dev->wd_file_ext.state ||
+			     HECI_FILE_DISCONNECTED == dev->wd_file_ext.state),
+			    timeout * HZ);
+			if (HECI_FILE_CONNECTED == dev->wd_file_ext.state) {
+				DBG("dev->wd_timeout=%d.\n", dev->wd_timeout);
+				if (dev->wd_timeout != 0)
+					dev->wd_due_counter = 1;
+				else
+					dev->wd_due_counter = 0;
+
+				DBG("successfully to connect to WD client.\n");
+			} else {
+				heci_remove_client_from_file_list(dev,
+					dev->wd_file_ext.host_client_id);
+				if (HECI_FILE_CONNECTED !=
+						dev->wd_file_ext.state)
+					DBG("wrong status for WD client.\n");
+
+				if (!err)
+					DBG("failed connect err=%08x\n", err);
+
+				DBG("failed to connect to WD client.\n");
+				dev->wd_file_ext.state = HECI_FILE_DISCONNECTED;
+			}
+		} else {
+			DBG("failed to call heci_connect for wd_file_ext.\n");
+			heci_remove_client_from_file_list(dev,
+					dev->wd_file_ext.host_client_id);
+			dev->wd_file_ext.state = HECI_FILE_DISCONNECTED;
+		}
+	} else
+		DBG("failed to find WD client.\n");
+
+
+	dev->wd_timer.function = &heci_wd_timer;
+	dev->wd_timer.data = (unsigned long) dev;
+}
+
+
+/**
+ * host_init_legacy - heci initialization legacy client.
+ *
+ * @dev - Device object for our driver
+ *
+ * @return :
+ * none;
+ */
+static void host_init_legacy(struct iamt_heci_device *dev)
+{
+	long timeout = 15;	/*15 second */
+	__u8 i;
+	int err;
+
+	spin_lock_init(&dev->legacy_file_ext.file_lock);
+	init_waitqueue_head(&dev->legacy_file_ext.wait);
+	spin_lock_init(&dev->legacy_file_ext.read_io_lock);
+	spin_lock_init(&dev->legacy_file_ext.
+		       write_io_lock);
+	init_waitqueue_head(&dev->legacy_file_ext.rx_wait);
+	init_waitqueue_head(&dev->legacy_file_ext.tx_wait);
+	dev->legacy_file_ext.reading_state = HECI_IDLE;
+	dev->legacy_file_ext.writing_state = HECI_IDLE;
+	dev->legacy_file_ext.read_pending = 0;
+	dev->legacy_file_ext.flow_ctrl_creds = 0;
+	dev->legacy_file_ext.read_cb = NULL;
+	/* look for legacy client and connect to it */
+	dev->legacy_file_ext.file = NULL;
+	dev->legacy_file_ext.state = HECI_FILE_DISCONNECTED;
+
+	/* find ME PTHI client */
+	for (i = 0; i < dev->num_heci_me_clients; i++) {
+		if (memcmp(&heci_pthi_guid,
+			   &dev->me_clients[i].props.protocol_name,
+			   sizeof(struct guid)) == 0) {
+			spin_lock_bh(&dev->device_lock);
+			dev->legacy_file_ext.me_client_id =
+				dev->me_clients[i].client_id;
+			dev->legacy_file_ext.state =
+				HECI_FILE_CONNECTING;
+			dev->legacy_file_ext.host_client_id =
+				HECI_LEGACY_HOST_CLIENT_ID;
+			dev->legacy_file_ext.flow_ctrl_creds = 0;
+			dev->legacy_file_ext.timer_count = 0;
+			list_add_tail(&dev->legacy_file_ext.link,
+					&dev->file_list);
+			spin_unlock_bh(&dev->device_lock);
+			break;
+		}
+	}
+	if (dev->asf_mode) {
+		dev->legacy_file_ext.state =
+			HECI_FILE_DISCONNECTED;
+		heci_remove_client_from_file_list(dev,
+				dev->legacy_file_ext.host_client_id);
+		return;
+	}
+	if (dev->legacy_file_ext.state == HECI_FILE_CONNECTING) {
+		BUG_ON(dev->me_clients[i].props.max_msg_length != LEGACY_MTU);
+
+
+		if (dev->me_clients[i].props.max_msg_length < LEGACY_MTU) {
+			dev->legacy_file_ext.state = HECI_FILE_DISCONNECTED;
+			DBG("legacy client buffer too small.\n");
+		} else {
+			if (heci_connect(dev, &dev->legacy_file_ext)) {
+				err = wait_event_timeout(dev->wait_recvd_msg,
+					(dev->legacy_file_ext.state ==
+						HECI_FILE_CONNECTED ||
+					dev->legacy_file_ext.state ==
+						HECI_FILE_DISCONNECTED),
+					timeout * HZ);
+				if ((dev->legacy_file_ext.state !=
+						HECI_FILE_CONNECTED)) {
+					heci_remove_client_from_file_list(dev,
+					  dev->legacy_file_ext.host_client_id);
+					DBG("failed connect to legacy.\n");
+					dev->legacy_file_ext.state =
+						HECI_FILE_DISCONNECTED;
+				} else {
+					DBG("OK to connect legacy client.\n");
+					dev->legacy_state = HECI_LEGACY_IDLE;
+				}
+			} else {
+				DBG("failed to heci_connect for legacy.\n");
+				heci_remove_client_from_file_list(dev,
+				     dev->legacy_file_ext.host_client_id);
+				dev->legacy_file_ext. state =
+					HECI_FILE_DISCONNECTED;
+			}
+		}
+	} else {
+		if (!dev->asf_mode)
+			DBG("failed to find legacy client.\n");
+
+	}
+}
+
+/**
+ * alloc_priv - allocates a private file structure and set it up.
+ * @file: the file structure
+ *
+ * @return :
+ * The allocated file or NULL on failure
+ */
+struct heci_file_private *alloc_priv(struct file *file)
+{
+	struct heci_file_private *priv;
+
+	priv = kmalloc(sizeof(struct heci_file_private), GFP_KERNEL);
+	if (!priv)
+		return NULL;
+
+
+	spin_lock_init(&priv->file_lock);
+	spin_lock_init(&priv->read_io_lock);
+	spin_lock_init(&priv->write_io_lock);
+	init_waitqueue_head(&priv->wait);
+	init_waitqueue_head(&priv->rx_wait);
+	DBG("priv->rx_wait =%p\n", &priv->rx_wait);
+	init_waitqueue_head(&priv->tx_wait);
+	INIT_LIST_HEAD(&priv->link);
+	priv->reading_state = HECI_IDLE;
+	priv->writing_state = HECI_IDLE;
+	priv->file = file;
+	priv->flow_ctrl_creds = 0;
+	priv->timer_count = 0;
+	priv->me_client_id = 0;
+	priv->read_cb = NULL;
+	priv->status = 0;
+	priv->read_pending = 0;
+	return priv;
+}
+
+
+
+/**
+ * heci_disconnect_host_client  - send disconnect message  to fw from host client.
+ *
+ * @dev -Device object for our driver
+ * @file_ext -extension of the file object
+ *
+ * @return :
+ *  0 on success,
+ *  negative on failure.
+ */
+int heci_disconnect_host_client(struct iamt_heci_device *dev,
+		struct heci_file_private *file_ext)
+{
+	int rets = 0, err = 0;
+	long timeout = 15;	/*15 second */
+	struct heci_cb_private *priv_cb = NULL;
+	struct heci_file_private *file_temp = NULL;
+	struct heci_cb_private *priv_cb_pos = NULL;
+	struct heci_cb_private *priv_cb_next = NULL;
+
+	if ((!dev) || (!file_ext))
+		return -ENODEV;
+
+	priv_cb = kmalloc(sizeof(struct heci_cb_private), GFP_KERNEL);
+	if (!priv_cb)
+		return -ENOMEM;
+
+	if (file_ext->state == HECI_FILE_DISCONNECTING) {
+		INIT_LIST_HEAD(&priv_cb->cb_list);
+		priv_cb->file_private = file_ext;
+		priv_cb->major_file_operations = HECI_CLOSE;
+		spin_lock_bh(&dev->device_lock);
+		if (dev->host_buffer_is_empty) {
+			dev->host_buffer_is_empty = 0;
+			if (heci_disconnect(dev, file_ext)) {
+				list_add_tail(&priv_cb->cb_list,
+					&dev->ctrl_rd_list.heci_cb.cb_list);
+			} else {
+				spin_unlock_bh(&dev->device_lock);
+				rets = -ENODEV;
+				DBG("failed to call heci_disconnect.\n");
+				goto free;
+			}
+		} else {
+			priv_cb->file_private = file_ext;
+			DBG("add disconnect cb to control write list\n");
+			list_add_tail(&priv_cb->cb_list,
+					&dev->ctrl_wr_list.heci_cb.cb_list);
+		}
+		spin_unlock_bh(&dev->device_lock);
+
+		err = wait_event_timeout(dev->wait_recvd_msg,
+			 (HECI_FILE_DISCONNECTED == file_ext->state),
+			 timeout * HZ);
+		if (HECI_FILE_DISCONNECTED == file_ext->state) {
+			rets = 0;
+			DBG("successfully to disconnect from fw client.\n");
+		} else {
+			rets = -ENODEV;
+			if (HECI_FILE_DISCONNECTED != file_ext->state)
+				DBG("wrong status client disconnect.\n");
+
+			if (!err)
+				DBG("wait failed disconnect err=%08x\n", err);
+
+			DBG("failed to diconnect to fw client.\n");
+		}
+
+	}
+
+	if (priv_cb) {
+		spin_lock_bh(&dev->device_lock);
+		if (dev->ctrl_rd_list.status == 0 &&
+		    !list_empty(&dev->ctrl_rd_list.heci_cb.cb_list)) {
+			list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+				&dev->ctrl_rd_list.heci_cb.cb_list, cb_list) {
+				file_temp = (struct heci_file_private *)
+						priv_cb_pos->file_private;
+				if (file_temp) {
+					if (heci_fe_same_id(file_ext,
+							    file_temp))
+						list_del(&priv_cb_pos->cb_list);
+
+				}
+			}
+		}
+		spin_unlock_bh(&dev->device_lock);
+free:
+		kfree(priv_cb);
+		priv_cb = NULL;
+	}
+	return rets;
+}
+
+
+/**
+ * heci_remove_client_from_file_list  -
+ *	remove file extension from device file list
+ *
+ * @dev -Device object for our driver
+ * @host_client_id   -host client id to be removed
+ *
+ * @return :
+ * none;
+ */
+void heci_remove_client_from_file_list(struct iamt_heci_device *dev,
+				       __u8 host_client_id)
+{
+	struct heci_file_private *file_pos = NULL;
+	struct heci_file_private *file_next = NULL;
+	list_for_each_entry_safe(file_pos, file_next, &dev->file_list, link) {
+		if (host_client_id == file_pos->host_client_id) {
+			DBG("remove host client = %d, ME client = %d\n",
+					file_pos->host_client_id,
+					file_pos->me_client_id);
+			list_del(&file_pos->link);
+			break;
+		}
+	}
+}
diff --git a/drivers/char/heci/heci_interface.c b/drivers/char/heci/heci_interface.c
new file mode 100644
index 0000000..ba78692
--- /dev/null
+++ b/drivers/char/heci/heci_interface.c
@@ -0,0 +1,503 @@
+/*
+ * Part of Intel(R) Manageability Engine Interface Linux driver
+ *
+ * Copyright (c) 2003 - 2007 Intel Corp.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ *
+ */
+
+
+#include "heci.h"
+#include "heci_interface.h"
+
+
+
+static const __u8 interface_start_wd_params[] = { 0x02, 0x12, 0x13, 0x10};
+static const __u8 interface_stop_wd_params[] =  { 0x02, 0x02, 0x14, 0x10};
+
+/**
+ * read_heci_register - Read a byte from the heci device
+ * @device: the device structure
+ * @offset: offset from which to read the data
+ *
+ * Return:
+ * the byte read.
+ */
+__u32 read_heci_register(struct iamt_heci_device *device,
+			    unsigned long offset)
+{
+	return readl(device->mem_addr + offset);
+}
+
+/**
+ * write_heci_register - Write  4 bytes to the heci device
+ * @device: the device structure
+ * @offset: offset from which to write the data
+ *
+ * @value: the byte to write
+ */
+void write_heci_register(struct iamt_heci_device *device, unsigned long offset,
+			 __u32 value)
+{
+	writel(value, device->mem_addr + offset);
+}
+
+/**
+ * host_buffer_is_empty  - check if host buffer is empty.
+ *
+ * @dev -Device object for our driver
+ *
+ * @return :
+ * 1 if empty
+ * 0 - otherwise.
+ */
+int host_buffer_is_empty(struct iamt_heci_device *dev)
+{
+	char read_ptr, write_ptr;
+	unsigned char buffer_depth, filled_slots, empty_slots;
+
+	dev->host_hw_state = read_heci_register(dev, H_CSR);
+	read_ptr = (char) ((dev->host_hw_state & H_CBRP) >> 8);
+	write_ptr = (char) ((dev->host_hw_state & H_CBWP) >> 16);
+	buffer_depth = (unsigned char) ((dev->host_hw_state & H_CBD) >> 24);
+	filled_slots = (unsigned char) (write_ptr - read_ptr);
+	empty_slots = buffer_depth - filled_slots;
+
+	if (filled_slots > 0)
+		return 0;
+
+	return 1;
+}
+
+/**
+ * count_empty_write_slots  - count write empty slots.
+ *
+ * @dev - Device object for our driver
+ *
+ *
+ * @return :
+ *  -1(ESLOTS_OVERFLOW) if overflow
+ *  otherwise filed slots count
+ */
+__s32 count_empty_write_slots(struct iamt_heci_device *dev)
+{
+	char read_ptr, write_ptr;
+	unsigned char buffer_depth, filled_slots, empty_slots;
+
+	read_ptr = (char) ((dev->host_hw_state & H_CBRP) >> 8);
+	write_ptr = (char) ((dev->host_hw_state & H_CBWP) >> 16);
+	buffer_depth = (unsigned char) ((dev->host_hw_state & H_CBD) >> 24);
+	filled_slots = (unsigned char) (write_ptr - read_ptr);
+	empty_slots = buffer_depth - filled_slots;
+
+	if (filled_slots > buffer_depth) {
+		/* overflow */
+		return -ESLOTS_OVERFLOW;
+	}
+
+	return (__s32) empty_slots;
+}
+
+/**
+ * heci_write_message  - write a message to heci device.
+ *
+ * @heci_hdr          - header of  message
+ * @write_buffer         - message buffer will be write
+ * @write_length         - message size will be write
+ *
+ * @return :
+ * 1 if success
+ * 0 - otherwise.
+ */
+int heci_write_message(struct iamt_heci_device *dev,
+			     struct heci_msg_hdr *header,
+			     unsigned char *write_buffer,
+			     unsigned long write_length)
+{
+	__u32 temp_msg = 0;
+	unsigned long bytes_written = 0;
+	char read_ptr, write_ptr;
+	unsigned char buffer_depth, filled_slots, empty_slots;
+	unsigned long dw_to_write;
+
+	dw_to_write = ((write_length + 3) / 4);
+	DBG("host_hw_state = 0x%08x.\n", dev->host_hw_state);
+	DBG("heci_write_message header=%08x.\n", *((__u32 *) header));
+
+	read_ptr = (char) ((dev->host_hw_state & H_CBRP) >> 8);
+	write_ptr = (char) ((dev->host_hw_state & H_CBWP) >> 16);
+	buffer_depth = (unsigned char) ((dev->host_hw_state & H_CBD) >> 24);
+	filled_slots = (unsigned char) (write_ptr - read_ptr);
+	empty_slots = buffer_depth - filled_slots;
+	DBG("filled = %hu, empty = %hu.\n", filled_slots, empty_slots);
+
+	if (dw_to_write > empty_slots)
+		return 0;
+
+	write_heci_register(dev, H_CB_WW, *((__u32 *) header));
+
+	while (write_length >= 4) {
+		write_heci_register(dev, H_CB_WW,
+				*(__u32 *) (write_buffer + bytes_written));
+		bytes_written += 4;
+		write_length -= 4;
+	}
+
+	if (write_length > 0) {
+		memcpy(&temp_msg, &write_buffer[bytes_written], write_length);
+		write_heci_register(dev, H_CB_WW, temp_msg);
+	}
+
+	dev->host_hw_state |= H_IG;
+	write_heci_register(dev, H_CSR, dev->host_hw_state);
+	dev->me_hw_state = read_heci_register(dev, ME_CSR_HA);
+	if ((dev->me_hw_state & ME_RDY_HRA) != ME_RDY_HRA)
+		return 0;
+
+	dev->write_hang = 0;
+	return 1;
+}
+
+/**
+ * count_full_read_slots  - reset host and fw.
+ *
+ * @dev -Device object for our driver
+ *
+ *
+ * @return :
+ * -1(ESLOTS_OVERFLOW) if overflow
+ * otherwise filed slots count
+ */
+__s32 count_full_read_slots(struct iamt_heci_device *dev)
+{
+	char read_ptr, write_ptr;
+	unsigned char buffer_depth, filled_slots, empty_slots;
+
+	dev->me_hw_state = read_heci_register(dev, ME_CSR_HA);
+	read_ptr = (char) ((dev->me_hw_state & ME_CBRP_HRA) >> 8);
+	write_ptr = (char) ((dev->me_hw_state & ME_CBWP_HRA) >> 16);
+	buffer_depth = (unsigned char)((dev->me_hw_state & ME_CBD_HRA) >> 24);
+	filled_slots = (unsigned char) (write_ptr - read_ptr);
+	empty_slots = buffer_depth - filled_slots;
+
+	if (filled_slots > buffer_depth) {
+		/* overflow */
+		return -ESLOTS_OVERFLOW;
+	}
+
+	DBG("filled_slots =%08x  \n", filled_slots);
+	return (__s32) filled_slots;
+}
+
+/**
+ * heci_read_slots  - read a message from heci device.
+ *
+ * @dev  - device object for our driver
+ * @buffer         - message buffer will be write
+ * @buffer_length  - message size will be read
+ *
+ * @return :
+ * none;
+ */
+void heci_read_slots(struct iamt_heci_device *dev,
+		     unsigned char *buffer, unsigned long buffer_length)
+{
+	__u32 i = 0;
+	unsigned char temp_buf[sizeof(__u32)];
+
+	while (buffer_length >= sizeof(__u32)) {
+		((__u32 *) buffer)[i] = read_heci_register(dev, ME_CB_RW);
+		DBG("buffer[%d]= %d\n", i, ((__u32 *) buffer)[i]);
+		i++;
+		buffer_length -= sizeof(__u32);
+	}
+
+	if (buffer_length > 0) {
+		*((__u32 *) &temp_buf) = read_heci_register(dev, ME_CB_RW);
+		memcpy(&buffer[i * 4], temp_buf, buffer_length);
+	}
+
+	dev->host_hw_state |= H_IG;
+	write_heci_register(dev, H_CSR, dev->host_hw_state);
+}
+
+/**
+ * flow_ctrl_creds  - check flow_control credentials.
+ *
+ * @dev -Device object for our driver
+ * @file_ext -extension of the file object
+ *
+ * @return :
+ * 1 if flow_ctrl_creds >0
+ * 0 - otherwise.
+ */
+int flow_ctrl_creds(struct iamt_heci_device *dev,
+				   struct heci_file_private *file_ext)
+{
+	__u8 i;
+
+	if (!dev->num_heci_me_clients)
+		return 0;
+
+	if (file_ext == NULL)
+		return 0;
+
+	if (file_ext->flow_ctrl_creds > 0)
+		return 1;
+
+	for (i = 0; i < dev->num_heci_me_clients; i++) {
+		if (dev->me_clients[i].client_id == file_ext->me_client_id) {
+			if (dev->me_clients[i].flow_ctrl_creds > 0) {
+				BUG_ON(dev->me_clients[i].props.single_recv_buf
+					 == 0);
+				return 1;
+			}
+			return 0;
+		}
+	}
+	BUG_ON(1);
+	return 0;
+}
+
+/**
+ * flow_ctrl_reduce  - reduce flow_control .
+ *
+ * @dev -Device object for our driver
+ * @file_ext -extension of the file object
+ *
+ * @return :
+ * none;
+ */
+void flow_ctrl_reduce(struct iamt_heci_device *dev,
+			 struct heci_file_private *file_ext)
+{
+	__u8 i;
+
+	if (!dev->num_heci_me_clients)
+		return;
+
+	for (i = 0; i < dev->num_heci_me_clients; i++) {
+		if (dev->me_clients[i].client_id == file_ext->me_client_id) {
+			if (dev->me_clients[i].props.single_recv_buf != 0) {
+				BUG_ON(dev->me_clients[i].flow_ctrl_creds <= 0);
+				dev->me_clients[i].flow_ctrl_creds--;
+			} else {
+				BUG_ON(file_ext->flow_ctrl_creds <= 0);
+				file_ext->flow_ctrl_creds--;
+			}
+			return;
+		}
+	}
+	BUG_ON(1);
+}
+
+/**
+ * heci_send_flow_control  - send flow control to fw.
+ *
+ * @dev -Device object for our driver
+ * @file_ext -extension of the file object
+ *
+ * @return :
+ * 1 if success
+ * 0 - otherwise.
+ */
+int heci_send_flow_control(struct iamt_heci_device *dev,
+				 struct heci_file_private *file_ext)
+{
+	struct heci_msg_hdr *heci_hdr;
+	struct hbm_flow_control *heci_flow_control;
+
+	heci_hdr = (struct heci_msg_hdr *) &dev->wr_msg_buf[0];
+	heci_hdr->host_addr = 0;
+	heci_hdr->me_addr = 0;
+	heci_hdr->length = sizeof(struct hbm_flow_control);
+	heci_hdr->msg_complete = 1;
+	heci_hdr->reserved = 0;
+
+	heci_flow_control = (struct hbm_flow_control *) &dev->wr_msg_buf[1];
+	memset(heci_flow_control, 0, sizeof(heci_flow_control));
+	heci_flow_control->host_addr = file_ext->host_client_id;
+	heci_flow_control->me_addr = file_ext->me_client_id;
+	heci_flow_control->cmd.cmd = FLOW_CONTROL_CMD;
+	memset(heci_flow_control->reserved, 0,
+			sizeof(heci_flow_control->reserved));
+	DBG("sending flow control host client = %d, me client = %d\n",
+	    file_ext->host_client_id, file_ext->me_client_id);
+	if (!heci_write_message(dev, heci_hdr,
+				(unsigned char *) heci_flow_control,
+				sizeof(struct hbm_flow_control)))
+		return 0;
+
+	return 1;
+
+}
+
+/**
+ * other_client_is_connecting  - check if other
+ * client with the same client id is connected.
+ *
+ * @dev -Device object for our driver
+ * @file_ext -extension of the file object
+ *
+ * @return :
+ * 1 if other client is connected.
+ * 0 - otherwise.
+ */
+int other_client_is_connecting(struct iamt_heci_device *dev,
+		struct heci_file_private *file_ext)
+{
+
+	struct heci_file_private *file_pos = NULL;
+	struct heci_file_private *file_next = NULL;
+	list_for_each_entry_safe(file_pos, file_next, &dev->file_list, link) {
+		if ((file_pos->state == HECI_FILE_CONNECTING)
+			&& (file_pos != file_ext)
+			&& file_ext->me_client_id == file_pos->me_client_id)
+			return 1;
+
+	}
+	return 0;
+}
+
+/**
+ * heci_send_wd  - send watch dog message to fw.
+ *
+ * @dev -Device object for our driver
+ *
+ * @return :
+ * 1 if success
+ * 0 - otherwise.
+ */
+int heci_send_wd(struct iamt_heci_device *dev)
+{
+	struct heci_msg_hdr *heci_hdr;
+
+	heci_hdr = (struct heci_msg_hdr *) &dev->wr_msg_buf[0];
+	heci_hdr->host_addr = dev->wd_file_ext.host_client_id;
+	heci_hdr->me_addr = dev->wd_file_ext.me_client_id;
+	heci_hdr->msg_complete = 1;
+	heci_hdr->reserved = 0;
+
+	if (!memcmp(dev->wd_data, interface_start_wd_params,
+			HECI_WD_PARAMS_SIZE)) {
+		heci_hdr->length = HECI_START_WD_DATA_SIZE;
+	} else {
+		BUG_ON(memcmp(dev->wd_data, interface_stop_wd_params,
+			HECI_WD_PARAMS_SIZE));
+		heci_hdr->length = HECI_WD_PARAMS_SIZE;
+	}
+
+	if (!heci_write_message(dev, heci_hdr, dev->wd_data, heci_hdr->length))
+		return 0;
+
+	return 1;
+}
+
+/**
+ * heci_disconnect  - send disconnect message  to fw.
+ *
+ * @dev -Device object for our driver
+ * @file_ext -extension of the file object
+ *
+ * @return :
+ * 1 if success
+ * 0 - otherwise.
+ */
+int heci_disconnect(struct iamt_heci_device *dev,
+			  struct heci_file_private *file_ext)
+{
+	struct heci_msg_hdr *heci_hdr;
+	struct hbm_client_disconnect_request *heci_cli_disconnect;
+
+	heci_hdr = (struct heci_msg_hdr *) &dev->wr_msg_buf[0];
+	heci_hdr->host_addr = 0;
+	heci_hdr->me_addr = 0;
+	heci_hdr->length = sizeof(struct hbm_client_disconnect_request);
+	heci_hdr->msg_complete = 1;
+	heci_hdr->reserved = 0;
+
+	heci_cli_disconnect =
+	    (struct hbm_client_disconnect_request *) &dev->wr_msg_buf[1];
+	memset(heci_cli_disconnect, 0, sizeof(heci_cli_disconnect));
+	heci_cli_disconnect->host_addr = file_ext->host_client_id;
+	heci_cli_disconnect->me_addr = file_ext->me_client_id;
+	heci_cli_disconnect->cmd.cmd = CLIENT_DISCONNECT_REQ_CMD;
+	heci_cli_disconnect->reserved[0] = 0;
+
+	if (!heci_write_message(dev, heci_hdr,
+				(unsigned char *) heci_cli_disconnect,
+				sizeof(struct hbm_client_disconnect_request)))
+		return 0;
+
+	return 1;
+}
+
+/**
+ * heci_connect  - send connect message  to fw.
+ *
+ * @dev -Device object for our driver
+ * @file_ext -extension of the file object
+ *
+ * @return :
+ * 1 if success
+ * 0 - otherwise.
+ */
+int heci_connect(struct iamt_heci_device *dev,
+		       struct heci_file_private *file_ext)
+{
+	struct heci_msg_hdr *heci_hdr;
+	struct hbm_client_connect_request *heci_cli_connect;
+
+	heci_hdr = (struct heci_msg_hdr *) &dev->wr_msg_buf[0];
+	heci_hdr->host_addr = 0;
+	heci_hdr->me_addr = 0;
+	heci_hdr->length = sizeof(struct hbm_client_connect_request);
+	heci_hdr->msg_complete = 1;
+	heci_hdr->reserved = 0;
+
+	heci_cli_connect =
+	    (struct hbm_client_connect_request *) &dev->wr_msg_buf[1];
+	heci_cli_connect->host_addr = file_ext->host_client_id;
+	heci_cli_connect->me_addr = file_ext->me_client_id;
+	heci_cli_connect->cmd.cmd = CLIENT_CONNECT_REQ_CMD;
+	heci_cli_connect->reserved = 0;
+
+	if (!heci_write_message(dev, heci_hdr,
+				(unsigned char *) heci_cli_connect,
+				sizeof(struct hbm_client_connect_request)))
+		return 0;
+
+	return 1;
+}
diff --git a/drivers/char/heci/heci_interface.h b/drivers/char/heci/heci_interface.h
new file mode 100644
index 0000000..1ae5d5b
--- /dev/null
+++ b/drivers/char/heci/heci_interface.h
@@ -0,0 +1,176 @@
+/*
+ * Part of Intel(R) Manageability Engine Interface Linux driver
+ *
+ * Copyright (c) 2003 - 2007 Intel Corp.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ *
+ */
+
+
+#ifndef _HECI_INTERFACE_H_
+#define _HECI_INTERFACE_H_
+
+#include <linux/version.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+#include <linux/pci.h>
+#include <linux/timer.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/module.h>
+#include <linux/aio.h>
+#include <linux/types.h>
+#include "heci_data_structures.h"
+
+
+#define HBM_MINOR_VERSION                   0
+#define HBM_MAJOR_VERSION                   1
+#define HBM_TIMEOUT                         1	/* 1 second */
+
+
+#define HOST_START_REQ_CMD                  0x01
+#define HOST_START_RES_CMD                  0x81
+
+#define HOST_STOP_REQ_CMD                   0x02
+#define HOST_STOP_RES_CMD                   0x82
+
+#define ME_STOP_REQ_CMD                     0x03
+
+#define HOST_ENUM_REQ_CMD                   0x04
+#define HOST_ENUM_RES_CMD                   0x84
+
+#define HOST_CLIENT_PROPERTEIS_REQ_CMD      0x05
+#define HOST_CLIENT_PROPERTEIS_RES_CMD      0x85
+
+#define CLIENT_CONNECT_REQ_CMD              0x06
+#define CLIENT_CONNECT_RES_CMD              0x86
+
+#define CLIENT_DISCONNECT_REQ_CMD           0x07
+#define CLIENT_DISCONNECT_RES_CMD           0x87
+
+#define FLOW_CONTROL_CMD                    0x08
+
+
+#define AMT_WD_VALUE 120	/* seconds */
+
+#define HECI_WATCHDOG_DATA_SIZE         16
+#define HECI_START_WD_DATA_SIZE         20
+#define HECI_WD_PARAMS_SIZE             4
+
+/* IOCTL commands */
+#define HECI_IOCTL_LETTER 'H'
+
+
+#define IOCTL_HECI_GET_VERSION \
+    _IOWR(HECI_IOCTL_LETTER , 0x800, struct heci_message_data)
+#define IOCTL_HECI_CONNECT_CLIENT \
+    _IOWR(HECI_IOCTL_LETTER , 0x801, struct heci_message_data)
+#define IOCTL_HECI_WD \
+    _IOWR(HECI_IOCTL_LETTER , 0x802, struct heci_message_data)
+#define IOCTL_HECI_BYPASS_WD \
+    _IOWR(HECI_IOCTL_LETTER , 0x810, struct heci_message_data)
+
+#define IAMT_IOC_MAGIC 'i'
+#define IAMT_KCS_SEND_MESSAGE_COMMAND \
+	_IOR(IAMT_IOC_MAGIC, 1, struct heci_message_data)
+#define IAMT_KCS_RECEIVE_MESSAGE_COMMAND \
+	_IOW(IAMT_IOC_MAGIC, 2, struct heci_message_data)
+
+
+enum heci_stop_reason_types{
+	DRIVER_STOP_REQUEST = 0x00,
+	DEVICE_D1_ENTRY = 0x01,
+	DEVICE_D2_ENTRY = 0x02,
+	DEVICE_D3_ENTRY = 0x03,
+	SYSTEM_S1_ENTRY = 0x04,
+	SYSTEM_S2_ENTRY = 0x05,
+	SYSTEM_S3_ENTRY = 0x06,
+	SYSTEM_S4_ENTRY = 0x07,
+	SYSTEM_S5_ENTRY = 0x08
+};
+
+enum me_stop_reason_types{
+	FW_UPDATE = 0x00
+};
+
+enum client_connect_status_types{
+	CCS_SUCCESS = 0x00,
+	CCS_NOT_FOUND = 0x01,
+	CCS_ALREADY_STARTED = 0x02,
+	CCS_OUT_OF_RESOURCES = 0x03,
+	CCS_MESSAGE_SMALL = 0x04
+};
+
+enum client_disconnect_status_types{
+	CDS_SUCCESS = 0x00
+};
+
+
+/**
+ * heci interface function prototypes
+ */
+void heci_read_slots(struct iamt_heci_device *dev,
+		     unsigned char *buffer, unsigned long buffer_length);
+
+int heci_write_message(struct iamt_heci_device *dev,
+			     struct heci_msg_hdr *header,
+			     unsigned char *write_buffer,
+			     unsigned long write_length);
+
+int host_buffer_is_empty(struct iamt_heci_device *dev);
+
+__s32 count_full_read_slots(struct iamt_heci_device *dev);
+
+__s32 count_empty_write_slots(struct iamt_heci_device *dev);
+
+int flow_ctrl_creds(struct iamt_heci_device *dev,
+				   struct heci_file_private *file_ext);
+
+int heci_send_wd(struct iamt_heci_device *dev);
+
+void flow_ctrl_reduce(struct iamt_heci_device *dev,
+			 struct heci_file_private *file_ext);
+
+int heci_send_flow_control(struct iamt_heci_device *dev,
+				 struct heci_file_private *file_ext);
+
+int heci_disconnect(struct iamt_heci_device *dev,
+			  struct heci_file_private *file_ext);
+int other_client_is_connecting(struct iamt_heci_device *dev,
+				     struct heci_file_private *file_ext);
+int heci_connect(struct iamt_heci_device *dev,
+		       struct heci_file_private *file_ext);
+
+#endif /* _HECI_INTERFACE_H_ */
diff --git a/drivers/char/heci/heci_main.c b/drivers/char/heci/heci_main.c
new file mode 100644
index 0000000..3fef71e
--- /dev/null
+++ b/drivers/char/heci/heci_main.c
@@ -0,0 +1,1623 @@
+/*
+ * Part of Intel(R) Manageability Engine Interface Linux driver
+ *
+ * Copyright (c) 2003 - 2007 Intel Corp.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ *
+ */
+
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/fcntl.h>
+#include <linux/aio.h>
+#include <linux/pci.h>
+#include <linux/reboot.h>
+#include <linux/poll.h>
+#include <linux/init.h>
+#include <linux/kdev_t.h>
+#include <linux/ioctl.h>
+#include <linux/cdev.h>
+#include <linux/device.h>
+#include <linux/unistd.h>
+#include <linux/uaccess.h>
+
+#include "heci.h"
+#include "heci_interface.h"
+#include "heci_version.h"
+
+
+#define HECI_READ_TIMEOUT	45
+
+#define  MAX_OPEN_HANDLE_COUNT			253
+/**
+ *  heci driver strings
+ */
+char heci_driver_name[] = "heci";
+char heci_driver_string[] = "Intel(R) AMT Management Interface";
+char heci_driver_version[] = DRIVER_VERSION;
+char heci_copyright[] = "Copyright (c) 2003 - 2007 Intel Corporation.";
+
+
+#ifdef HECI_DEBUG
+int heci_debug = 1;
+#else
+int heci_debug;  /* initialized to 0 automatically.*/
+#endif
+MODULE_PARM_DESC(heci_debug,  "Debug enabled or not");
+module_param(heci_debug, int, 0644);
+
+
+#define LEGACY_DEV_NAME	"iamthif"
+#define HECI_DEV_NAME	"heci"
+
+/* heci char device for registration */
+static struct cdev heci_cdev = {
+	.kobj = {.name = HECI_DEV_NAME, },
+	.owner = THIS_MODULE,
+};
+
+/* iamt legacy char device for registration */
+static struct cdev iamt_legacy_cdev = {
+	.kobj = {.name = LEGACY_DEV_NAME, },
+	.owner = THIS_MODULE,
+};
+
+/* major number for device */
+static int heci_major;
+/* The device pointer */
+static struct pci_dev *heci_device;
+
+struct class *heci_class;
+struct class_device *iamt_legacy_class_dev;
+struct class_device *heci_class_dev;
+
+
+/* heci_pci_tbl - PCI Device ID Table */
+static struct pci_device_id heci_pci_tbl[] = {
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID01)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID02)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID03)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID04)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID05)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID06)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID07)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID08)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID09)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID10)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID11)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID12)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID13)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID14)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID15)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID16)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID17)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID18)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID19)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID20)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID21)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_HECI_DEVICE_ID22)},
+	/* required last entry */
+	{0, }
+};
+
+MODULE_DEVICE_TABLE(pci, heci_pci_tbl);
+
+/**
+ * Local Function Prototypes
+ */
+static int __init heci_init_module(void);
+static void __exit heci_exit_module(void);
+static int __devinit heci_probe(struct pci_dev *pdev,
+				const struct pci_device_id *ent);
+static void __devexit heci_remove(struct pci_dev *pdev);
+static int heci_open(struct inode *inode, struct file *file);
+static int heci_release(struct inode *inode, struct file *file);
+static unsigned int heci_legacy_poll(struct file *file, poll_table *wait);
+static ssize_t heci_read(struct file *file, char __user *ubuf,
+			 size_t length, loff_t *offset);
+static int heci_ioctl(struct inode *inode, struct file *file,
+		      unsigned int cmd, unsigned long data);
+static ssize_t heci_write(struct file *file, const char __user *ubuf,
+			  size_t length, loff_t *offset);
+static unsigned int heci_poll(struct file *file, poll_table *wait);
+#ifdef CONFIG_PM
+static int heci_suspend(struct pci_dev *pdev, pm_message_t state);
+static int heci_resume(struct pci_dev *pdev);
+static __u16 g_sus_wd_timeout;
+#endif
+/**
+ *  PCI driver structure
+ */
+static struct pci_driver heci_driver = {
+	.name = heci_driver_name,
+	.id_table = heci_pci_tbl,
+	.probe = heci_probe,
+	.remove = heci_remove,
+	.shutdown = heci_remove,
+#ifdef CONFIG_PM
+	.suspend = heci_suspend,
+	.resume = heci_resume
+#endif
+};
+
+/**
+ * file operations structure will be use heci char device.
+ */
+static struct file_operations heci_fops = {
+	.owner = THIS_MODULE,
+	.read = heci_read,
+	.ioctl = heci_ioctl,
+	.open = heci_open,
+	.release = heci_release,
+	.write = heci_write,
+	.poll = heci_poll,
+};
+
+/**
+ * file operations structure will be use iamt legacy char device.
+ */
+static struct file_operations iamt_legacy_fops = {
+	.owner = THIS_MODULE,
+	.ioctl = heci_ioctl,
+	.open = heci_open,
+	.release = heci_release,
+	.poll = heci_legacy_poll,
+};
+
+
+/**
+ * Set up the cdev structure for heci device.
+ * @dev   - char device struct
+ * @hminor - minor number for registration char device
+ * @fops  - file operations structure
+ * @return :
+ * 0 on success,
+ * negative on failure
+ */
+static int heci_registration_cdev(struct cdev *dev, int hminor,
+				  struct file_operations *fops)
+{
+	int ret = 0, devno = MKDEV(heci_major, hminor);
+
+	cdev_init(dev, fops);
+	dev->owner = THIS_MODULE;
+	dev->ops = fops;
+	ret = cdev_add(dev, devno, 1);
+	/* Fail gracefully if need be */
+	if (ret) {
+		kobject_put(&dev->kobj);
+		printk(KERN_ERR "%s: Error %d registering heci device %d\n",
+		       THIS_MODULE->name, ret, hminor);
+	}
+	return ret;
+}
+
+/* Display the version of heci driver. */
+static ssize_t version_show(struct class *dev, char *buf)
+{
+	return sprintf(buf, "%s %s.\n",
+		       heci_driver_string, heci_driver_version);
+}
+
+static CLASS_ATTR(version, S_IRUGO, version_show, NULL);
+
+/**
+ * heci_sysfs_create - creates a struct class to contain heci info
+ * @owner  - pointer to the module that is to "own" heci sysfs class
+ * @name   - pointer to a string for the name of this class
+ *
+ * @return :
+ * valid pointer to a struct class on success
+ * false pointer on failure
+ */
+static struct class *heci_sysfs_create(struct module *owner, char *name)
+{
+	struct class *class;
+	int err = 0;
+
+	class = class_create(owner, name);
+	if (IS_ERR(class)) {
+		err = PTR_ERR(class);
+		goto error;
+	}
+
+	err = class_create_file(class, &class_attr_version);
+	if (err)
+		goto destroy_class;
+
+	return class;
+
+destroy_class:
+	class_destroy(class);
+error:
+	return ERR_PTR(err);
+}
+
+/**
+ * heci_sysfs_destroy - destroys a struct class of heci info
+ * @cs      - pointer to the struct class that is to be destroyed
+ *
+ * @return :
+ * none;
+ */
+static void heci_sysfs_destroy(struct class *class)
+{
+	if ((class == NULL) || (IS_ERR(class)))
+		return;
+
+	class_remove_file(class, &class_attr_version);
+	class_destroy(class);
+}
+
+/**
+ * heci_sysfs_device_create - adds two devices to sysfs for chararcter devices
+ * @cs      - pointer to the struct class that the device to be registered on
+ *
+ * @return :
+ * 0 on success,
+ * negative on failure
+ */
+static int heci_sysfs_device_create(struct class *cs)
+{
+	int err = 0;
+
+	if ((cs == NULL) || (IS_ERR(cs))) {
+		err = -EINVAL;
+		goto err_out;
+	}
+
+	iamt_legacy_class_dev = class_device_create(cs, NULL,
+						    iamt_legacy_cdev.dev,
+						    NULL,
+						    LEGACY_DEV_NAME);
+	if (IS_ERR(iamt_legacy_class_dev)) {
+		err = PTR_ERR(iamt_legacy_class_dev);
+		goto err_out;
+	}
+
+	heci_class_dev = class_device_create(cs, NULL,
+					     heci_cdev.dev,
+					     NULL,
+					     HECI_DEV_NAME);
+	if (IS_ERR(heci_class_dev)) {
+		class_device_unregister(iamt_legacy_class_dev);
+		err = PTR_ERR(heci_class_dev);
+	}
+
+err_out:
+	return err;
+}
+
+/**
+ * heci_sysfs_device_remove - unregisters the two device entries on sysfs
+ *
+ * @return :
+ * none;
+ */
+static void heci_sysfs_device_remove(void)
+{
+	if (iamt_legacy_class_dev)
+		class_device_unregister(iamt_legacy_class_dev);
+	if (heci_class_dev)
+		class_device_unregister(heci_class_dev);
+}
+
+/**
+ * heci_init_module - Driver Registration Routine
+ *
+ * heci_init_module is the first routine called when the driver is
+ * loaded. All it does is register with the PCI subsystem.
+ *
+ * @return :
+ * 0 on success,
+ * negative on failure
+ */
+static int __init heci_init_module(void)
+{
+	int ret = 0;
+	dev_t dev;
+
+	printk(KERN_INFO "%s: %s - version %s\n",
+	       THIS_MODULE->name, heci_driver_string, heci_driver_version);
+	printk(KERN_INFO "%s: %s\n", THIS_MODULE->name, heci_copyright);
+
+	/* init pci module */
+	ret = pci_register_driver(&heci_driver);
+	if (ret < 0)
+		goto end;
+
+	/* registration char devices */
+	ret = alloc_chrdev_region(&dev, 0, MINORS_COUNT, "heci");
+
+	heci_major = MAJOR(dev);
+
+	/* rgisteration in sysfs interface */
+	heci_class = heci_sysfs_create(THIS_MODULE, "heci");
+	if (IS_ERR(heci_class)) {
+		printk(KERN_ERR "HECI: Error creating heci class.\n");
+		ret = PTR_ERR(heci_class);
+		goto unregister;
+	}
+
+	/* Now registration two cdevs. */
+	ret = heci_registration_cdev(&iamt_legacy_cdev, LEGACY_MINOR_NUMBER,
+				     &iamt_legacy_fops);
+	if (ret)
+		goto destroy_sysfs;
+
+	ret = heci_registration_cdev(&heci_cdev, HECI_MINOR_NUMBER,
+				     &heci_fops);
+	if (ret) {
+		cdev_del(&iamt_legacy_cdev);
+		goto destroy_sysfs;
+	}
+
+	if (heci_sysfs_device_create(heci_class)) {
+		cdev_del(&iamt_legacy_cdev);
+		cdev_del(&heci_cdev);
+		ret = -EAGAIN;
+		goto destroy_sysfs;
+	}
+
+	return ret;
+
+destroy_sysfs:
+	heci_sysfs_destroy(heci_class);
+
+unregister:
+	pci_unregister_driver(&heci_driver);
+	unregister_chrdev_region(MKDEV(heci_major, 0), MINORS_COUNT);
+end:
+	return ret;
+}
+
+module_init(heci_init_module);
+
+
+/**
+ * heci_exit_module - Driver Exit Cleanup Routine
+ *
+ * heci_exit_module is called just before the driver is removed
+ * from memory.
+ *
+ * @return :
+ * none;
+ */
+
+static void __exit heci_exit_module(void)
+{
+	pci_unregister_driver(&heci_driver);
+	/* Now  unregister two cdevs. */
+	cdev_del(&iamt_legacy_cdev);
+	cdev_del(&heci_cdev);
+
+	heci_sysfs_device_remove();
+	heci_sysfs_destroy(heci_class);
+	unregister_chrdev_region(MKDEV(heci_major, 0), MINORS_COUNT);
+}
+
+module_exit(heci_exit_module);
+
+
+/**
+ * heci_probe - Device Initialization Routine
+ *
+ * @pdev: PCI device information struct
+ * @ent: entry in kcs_pci_tbl
+ *
+ * @return :
+ * 0 on success,
+ * negative on failure
+ */
+static int __devinit heci_probe(struct pci_dev *pdev,
+				const struct pci_device_id *ent)
+{
+	struct iamt_heci_device *dev = NULL;
+	int i, err = 0;
+
+	if (heci_device) {
+		err = -EEXIST;
+		goto end;
+	}
+	/* enable pci dev */
+	err = pci_enable_device(pdev);
+	if (err) {
+		printk(KERN_ERR "%s: Failed to enable pci device.\n",
+		       THIS_MODULE->name);
+		goto end;
+	}
+	/* set PCI host mastering  */
+	pci_set_master(pdev);
+	/* pci request regions for heci driver */
+	err = pci_request_regions(pdev, heci_driver_name);
+	if (err) {
+		printk(KERN_ERR "%s: Failed to get pci regions.\n",
+		       THIS_MODULE->name);
+		goto disable_device;
+	}
+	/* allocates and initializes the heci dev structure */
+	dev = init_heci_device(pdev);
+	if (!dev) {
+		err = -ENOMEM;
+		goto release_regions;
+	}
+	/* mapping  IO device memory */
+	for (i = BAR_0; i <= BAR_5; i++) {
+		if (pci_resource_len(pdev, i) == 0)
+			continue;
+		if (pci_resource_flags(pdev, i) & IORESOURCE_IO) {
+			printk(KERN_ERR "%s: heci has an IO ports.\n",
+			       THIS_MODULE->name);
+			goto free_device;
+		} else if (pci_resource_flags(pdev, i) & IORESOURCE_MEM) {
+			if (dev->mem_base) {
+				printk(KERN_ERR "%s: Too many mem addresses.\n",
+				       THIS_MODULE->name);
+				goto free_device;
+			}
+			dev->mem_base = pci_resource_start(pdev, i);
+			dev->mem_length = pci_resource_len(pdev, i);
+		}
+	}
+	if (!dev->mem_base) {
+		printk(KERN_ERR "%s: No address to use.\n", THIS_MODULE->name);
+		err = -ENODEV;
+		goto free_device;
+	}
+	dev->mem_addr = ioremap_nocache(dev->mem_base,
+			dev->mem_length);
+	if (!dev->mem_addr) {
+		printk(KERN_ERR "%s: Remap IO device memory failure.\n",
+		       THIS_MODULE->name);
+		err = -ENOMEM;
+		goto free_device;
+	}
+	/* request and enable interrupt   */
+	dev->irq = pdev->irq;
+	err = request_irq(dev->irq, heci_isr_interrupt, IRQF_SHARED,
+			heci_driver_name, dev);
+	if (err) {
+		printk(KERN_ERR "%s: Request_irq failure. irq = %d \n",
+		       THIS_MODULE->name, dev->irq);
+		goto unmap_memory;
+	}
+
+	if (heci_hw_init(dev)) {
+		printk(KERN_ERR "%s: Init hw failure.\n", THIS_MODULE->name);
+		err = -ENODEV;
+		goto release_irq;
+	}
+	init_timer(&dev->wd_timer);
+	heci_initialize_clients(dev);
+	if (dev->heci_state != HECI_ENABLED) {
+		err = -ENODEV;
+		goto release_hw;
+	}
+	spin_lock_bh(&dev->device_lock);
+	heci_device = pdev;
+	pci_set_drvdata(pdev, dev);
+	spin_unlock_bh(&dev->device_lock);
+	if (dev->wd_timeout)
+		mod_timer(&dev->wd_timer, jiffies);
+
+
+#ifdef CONFIG_PM
+	g_sus_wd_timeout = 0;
+#endif
+	printk(KERN_INFO "%s: heci driver initialization successful.\n",
+	       THIS_MODULE->name);
+	return 0;
+
+release_hw:
+	/* disable interrupts */
+	dev->host_hw_state = read_heci_register(dev, H_CSR);
+	dev->host_hw_state &= ~H_IE;
+	/* acknowledge interrupt and stop interupts */
+	write_heci_register(dev, H_CSR, dev->host_hw_state);
+
+	del_timer_sync(&dev->wd_timer);
+
+
+	flush_scheduled_work();
+
+release_irq:
+	free_irq(pdev->irq, dev);
+unmap_memory:
+	if (dev->mem_addr)
+		iounmap(dev->mem_addr);
+free_device:
+	kfree(dev);
+release_regions:
+	pci_release_regions(pdev);
+disable_device:
+	pci_disable_device(pdev);
+end:
+	printk(KERN_ERR "%s: heci driver initialization failed.\n",
+	       THIS_MODULE->name);
+	return err;
+}
+
+/**
+ * heci_remove - Device Removal Routine
+ * @pdev: PCI device information struct
+ *
+ * heci_remove is called by the PCI subsystem to alert the driver
+ * that it should release a PCI device.
+ *
+ * @return :
+ * none;
+ */
+static void __devexit heci_remove(struct pci_dev *pdev)
+{
+	struct iamt_heci_device *dev = pci_get_drvdata(pdev);
+	int err = 0;
+
+	if (heci_device != pdev)
+		return;
+
+	del_timer_sync(&dev->wd_timer);
+	if (dev->wd_file_ext.state == HECI_FILE_CONNECTED
+	    && dev->wd_timeout) {
+		spin_lock_bh(&dev->device_lock);
+		dev->wd_timeout = 0;
+		dev->wd_due_counter = 0;
+		memcpy(dev->wd_data, stop_wd_params, HECI_WD_PARAMS_SIZE);
+		dev->stop = 1;
+		if (dev->host_buffer_is_empty &&
+		    flow_ctrl_creds(dev, &dev->wd_file_ext)) {
+			dev->host_buffer_is_empty = 0;
+
+			if (!heci_send_wd(dev))
+				DBG("Send stop WD  failed\n");
+			else
+				flow_ctrl_reduce(dev, &dev->wd_file_ext);
+
+			dev->wd_pending = 0;
+		} else {
+			dev->wd_pending = 1;
+		}
+		spin_unlock_bh(&dev->device_lock);
+		dev->wd_stoped = 0;
+
+		err = wait_event_interruptible_timeout(dev->wait_stop_wd,
+				(dev->wd_stoped), 10 * HZ);
+		if (!dev->wd_stoped)
+			DBG("stop wd failed to complete.\n");
+		else
+			DBG("stop wd complete.\n");
+
+	}
+
+	heci_device = NULL;
+	if (dev->legacy_file_ext.status == HECI_FILE_CONNECTED) {
+		dev->legacy_file_ext.status = HECI_FILE_DISCONNECTING;
+		heci_disconnect_host_client(dev,
+					    &dev->legacy_file_ext);
+	}
+	if (dev->wd_file_ext.status == HECI_FILE_CONNECTED) {
+		dev->wd_file_ext.status = HECI_FILE_DISCONNECTING;
+		heci_disconnect_host_client(dev,
+					    &dev->wd_file_ext);
+	}
+	/* remove entry if already in list */
+	DBG("list del legacy and wd file list.\n");
+	heci_remove_client_from_file_list(dev, dev->wd_file_ext.
+					  host_client_id);
+	heci_remove_client_from_file_list(dev,
+			dev->legacy_file_ext.host_client_id);
+	flush_scheduled_work();
+	/* disable interrupts */
+	dev->host_hw_state &= ~H_IE;
+	/* acknowledge interrupt and stop interupts */
+	write_heci_register(dev, H_CSR, dev->host_hw_state);
+	free_irq(pdev->irq, dev);
+	pci_set_drvdata(pdev, NULL);
+
+	if (dev->mem_addr)
+		iounmap(dev->mem_addr);
+
+	kfree(dev);
+
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+/**
+ * heci_clear_list - remove all callbacks associated with file
+ * 		from heci_cb_list
+ * @file: file informtion struct
+ * @heci_cb_list: callbacks list
+ * heci_clear_list is called to clear resources associated with file
+ * when application calls close function or Ctrl-C was pressed
+ *
+ * @return :1 if callback removed from the list, 0 otherwise
+ */
+static int heci_clear_list(struct iamt_heci_device *dev,
+		struct file *file, struct list_head *heci_cb_list)
+{
+	struct heci_cb_private *priv_cb_pos = NULL;
+	struct heci_cb_private*priv_cb_next = NULL;
+	struct file *file_temp = NULL;
+	int rets = 0;
+
+	/* list all list member */
+	list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+				 heci_cb_list, cb_list) {
+		file_temp = (struct file *)priv_cb_pos->file_object;
+		/* check if list member associated with a file */
+		if (file_temp == file) {
+			/* remove member from the list */
+			list_del(&priv_cb_pos->cb_list);
+			/* check if cb equal to current legacy cb */
+			if (dev->legacy_current_cb == priv_cb_pos) {
+				dev->legacy_current_cb = NULL;
+				/* send flow control to legacy client */
+				heci_send_flow_control(dev,
+						       &dev->legacy_file_ext);
+			}
+			/* free all allocated buffers */
+			kfree(priv_cb_pos->request_buffer.data);
+			priv_cb_pos->request_buffer.data = NULL;
+			kfree(priv_cb_pos->response_buffer.data);
+			priv_cb_pos->response_buffer.data = NULL;
+			kfree(priv_cb_pos);
+			rets = 1;
+		}
+	}
+	return rets;
+}
+
+/**
+ * heci_clear_lists - remove all callbacks associated with file
+ * @device: dev informtion struct
+ * @file: file informtion struct
+ * heci_clear_lists is called to clear resources associated with file
+ * when application calls close function or Ctrl-C was pressed
+ *
+ * @return :1 if callback removed from the list, 0 otherwise
+ */
+static int heci_clear_lists(struct iamt_heci_device *dev, struct file *file)
+{
+	int rets = 0;
+
+	/* remove callbacks associated with a file */
+	heci_clear_list(dev, file, &dev->pthi_cmd_list.heci_cb.cb_list);
+	if (heci_clear_list(dev, file,
+			    &dev->pthi_read_complete_list.heci_cb.cb_list))
+		rets = 1;
+
+	heci_clear_list(dev, file, &dev->ctrl_rd_list.heci_cb.cb_list);
+
+	if (heci_clear_list(dev, file, &dev->ctrl_wr_list.heci_cb.cb_list))
+		rets = 1;
+
+	if (heci_clear_list(dev, file,
+			    &dev->write_waiting_list.heci_cb.cb_list))
+		rets = 1;
+
+	if (heci_clear_list(dev, file, &dev->write_list.heci_cb.cb_list))
+		rets = 1;
+
+	/* check if legacy_current_cb not NULL */
+	if (dev->legacy_current_cb && (!rets)) {
+		/* check file and legacy current cb association */
+		if (dev->legacy_current_cb->file_object == file) {
+			/* remove cb */
+			kfree(dev->legacy_current_cb->request_buffer.data);
+			dev->legacy_current_cb->request_buffer.data = NULL;
+			kfree(dev->legacy_current_cb->response_buffer.data);
+			dev->legacy_current_cb->response_buffer.data = NULL;
+			kfree(dev->legacy_current_cb);
+			dev->legacy_current_cb = NULL;
+			rets = 1;
+		}
+	}
+	return rets;
+}
+
+/**
+ * heci_open - the open function
+ */
+static int heci_open(struct inode *inode, struct file *file)
+{
+	struct heci_file_private *file_ext = NULL;
+	int if_num = MINOR(inode->i_rdev);
+	struct iamt_heci_device *dev = NULL;
+
+	if (!heci_device)
+		return -ENODEV;
+
+	dev = pci_get_drvdata(heci_device);
+	if (((if_num != LEGACY_MINOR_NUMBER)
+	     && (if_num != HECI_MINOR_NUMBER)) || (!dev))
+		return -ENODEV;
+
+	if (if_num != LEGACY_MINOR_NUMBER) {
+		file_ext = alloc_priv(file);
+		if (!file_ext)
+			return -ENOMEM;
+	} else {
+		file->private_data = (void *) &dev->legacy_file_ext;
+		return 0;
+	}
+	spin_lock_bh(&dev->device_lock);
+	if (dev->heci_state != HECI_ENABLED) {
+		spin_unlock_bh(&dev->device_lock);
+		kfree(file_ext);
+		file_ext = NULL;
+		return -ENODEV;
+	}
+	if (dev->open_handle_count >= MAX_OPEN_HANDLE_COUNT) {
+		spin_unlock_bh(&dev->device_lock);
+		kfree(file_ext);
+		file_ext = NULL;
+		return -ENFILE;
+	};
+	dev->open_handle_count++;
+	list_add_tail(&file_ext->link, &dev->file_list);
+	while ((dev->heci_host_clients[dev->current_host_client_id / 8]
+		& (1 << (dev->current_host_client_id % 8))) != 0) {
+
+		dev->current_host_client_id++; /* allow overflow */
+		DBG("current_host_client_id = %d\n",
+		    dev->current_host_client_id);
+		DBG("dev->open_handle_count = %lu\n",
+		    dev->open_handle_count);
+	}
+	DBG("current_host_client_id = %d\n", dev->current_host_client_id);
+	file_ext->host_client_id = dev->current_host_client_id;
+	dev->heci_host_clients[file_ext->host_client_id / 8] |=
+		(1 << (file_ext->host_client_id % 8));
+	spin_unlock_bh(&dev->device_lock);
+	spin_lock(&file_ext->file_lock);
+	file_ext->state = HECI_FILE_INITIALIZING;
+
+	file->private_data = file_ext;
+	spin_unlock(&file_ext->file_lock);
+
+	return 0;
+}
+
+/**
+ * heci_release - the release function
+ */
+static int heci_release(struct inode *inode, struct file *file)
+{
+	int rets = 0;
+	int if_num = MINOR(inode->i_rdev);
+	struct heci_file_private *file_ext = file->private_data;
+	struct heci_cb_private *priv_cb = NULL;
+	struct iamt_heci_device *dev = NULL;
+
+	if (!heci_device)
+		return -ENODEV;
+
+	dev = pci_get_drvdata(heci_device);
+	if (((if_num != LEGACY_MINOR_NUMBER)
+	     && (if_num != HECI_MINOR_NUMBER)) || (!dev) || (!file_ext))
+		return -ENODEV;
+
+	if (file_ext != &dev->legacy_file_ext) {
+		spin_lock(&file_ext->file_lock);
+		if (file_ext->state == HECI_FILE_CONNECTED) {
+			file_ext->state = HECI_FILE_DISCONNECTING;
+			spin_unlock(&file_ext->file_lock);
+			DBG("disconnecting client host client = %d, "
+			    "ME client = %d\n",
+			    file_ext->host_client_id,
+			    file_ext->me_client_id);
+			rets = heci_disconnect_host_client(dev, file_ext);
+			spin_lock(&file_ext->file_lock);
+		}
+		spin_lock_bh(&dev->device_lock);
+		heci_flush_queues(dev, file_ext);
+		DBG("remove client host client = %d, ME client = %d\n",
+		    file_ext->host_client_id,
+		    file_ext->me_client_id);
+
+		dev->heci_host_clients[file_ext->host_client_id / 8] &=
+			~(1 << (file_ext->host_client_id % 8));
+		dev->open_handle_count--;
+		heci_remove_client_from_file_list(dev,
+				file_ext->host_client_id);
+		spin_unlock_bh(&dev->device_lock);
+
+		/* free read cb */
+		if (file_ext->read_cb != NULL) {
+			spin_unlock(&file_ext->file_lock);
+			priv_cb = file_ext->read_cb;
+			kfree(priv_cb->response_buffer.data);
+			priv_cb->response_buffer.data = NULL;
+			kfree(priv_cb);
+			priv_cb = NULL;
+
+			file_ext->read_cb = NULL;
+			spin_lock(&file_ext->file_lock);
+		}
+		spin_unlock(&file_ext->file_lock);
+		kfree(file_ext);
+		file->private_data = NULL;
+	} else {
+		spin_lock_bh(&dev->device_lock);
+		if (if_num != LEGACY_MINOR_NUMBER)
+			dev->open_handle_count--;
+
+		if (dev->legacy_file_object == file
+		    && dev->legacy_state != HECI_LEGACY_IDLE) {
+			DBG("pthi canceled legacy state %d\n",
+			    dev->legacy_state);
+			dev->legacy_canceled = 1;
+			if (dev->legacy_state == HECI_LEGACY_READ_COMPLETE) {
+				DBG("run next pthi legacy cb\n");
+				run_next_legacy_cmd(dev);
+			}
+		}
+
+		if (heci_clear_lists(dev, file))
+		    dev->legacy_state = HECI_LEGACY_IDLE;
+
+		spin_unlock_bh(&dev->device_lock);
+	}
+	return rets;
+}
+
+static struct heci_cb_private *find_read_list_entry(
+		struct iamt_heci_device *dev,
+		struct heci_file_private *file_ext)
+{
+	struct heci_cb_private *priv_cb_pos = NULL;
+	struct heci_cb_private *priv_cb_next = NULL;
+	struct heci_file_private *file_ext_list_temp = NULL;
+
+	if (dev->read_list.status == 0
+	    && !list_empty(&dev->read_list.heci_cb.cb_list)) {
+		DBG("remove read_list CB \n");
+		list_for_each_entry_safe(priv_cb_pos,
+				priv_cb_next,
+				&dev->read_list.heci_cb.cb_list, cb_list) {
+
+			file_ext_list_temp = (struct heci_file_private *)
+				priv_cb_pos->file_private;
+
+			if (file_ext_list_temp &&
+			    heci_fe_same_id(file_ext, file_ext_list_temp))
+				return priv_cb_pos;
+
+		}
+	}
+	return NULL;
+}
+
+/**
+ * heci_read - the read client message function.
+ */
+static ssize_t heci_read(struct file *file, char __user *ubuf,
+			 size_t length, loff_t *offset)
+{
+	int i;
+	int rets = 0, err = 0;
+	int if_num = MINOR((file->f_dentry->d_inode->i_rdev));
+	struct heci_file_private *file_ext = file->private_data;
+	struct heci_cb_private *priv_cb_pos = NULL;
+	struct heci_cb_private *priv_cb = NULL;
+	struct iamt_heci_device *dev = NULL;
+
+	if (!heci_device)
+		return -ENODEV;
+
+	dev = pci_get_drvdata(heci_device);
+	if ((if_num != HECI_MINOR_NUMBER) || (!dev) || (!file_ext))
+		return -ENODEV;
+
+	spin_lock_bh(&dev->device_lock);
+	if (dev->heci_state != HECI_ENABLED) {
+		spin_unlock_bh(&dev->device_lock);
+		return -ENODEV;
+	}
+	spin_unlock_bh(&dev->device_lock);
+	if (!file_ext)
+		return -ENODEV;
+
+	/* Do not allow to read watchdog client */
+	for (i = 0; i < dev->num_heci_me_clients; i++) {
+		if (memcmp(&heci_wd_guid,
+			   &dev->me_clients[i].props.protocol_name,
+			   sizeof(struct guid)) == 0) {
+			if (file_ext->me_client_id ==
+			    dev->me_clients[i].client_id)
+				return -EBADF;
+		}
+	}
+	if (file_ext == &dev->legacy_file_ext) {
+		rets = pthi_read(dev, if_num, file, ubuf, length, offset);
+		goto out;
+	}
+
+	if (file_ext->read_cb && file_ext->read_cb->information > *offset) {
+		priv_cb = file_ext->read_cb;
+		goto copy_buffer;
+	} else if (file_ext->read_cb && file_ext->read_cb->information > 0 &&
+		   file_ext->read_cb->information <= *offset) {
+		priv_cb = file_ext->read_cb;
+		rets = 0;
+		goto free;
+	} else if ((!file_ext->read_cb || file_ext->read_cb->information == 0)
+		    && *offset > 0) {
+		/*Offset needs to be cleaned for contingous reads*/
+		*offset = 0;
+		rets = 0;
+		goto out;
+	}
+
+	spin_lock(&file_ext->read_io_lock);
+	err = heci_start_read(dev, if_num, file_ext);
+	if (err != 0 && err != -EBUSY) {
+		DBG("heci start read failure with status = %d\n", err);
+		spin_unlock(&file_ext->read_io_lock);
+		rets = err;
+		goto out;
+	}
+	if (HECI_READ_COMPLETE != file_ext->reading_state
+			&& !waitqueue_active(&file_ext->rx_wait)) {
+		if (file->f_flags & O_NONBLOCK) {
+			rets = -EAGAIN;
+			spin_unlock(&file_ext->read_io_lock);
+			goto out;
+		}
+		spin_unlock(&file_ext->read_io_lock);
+
+		if (wait_event_interruptible(file_ext->rx_wait,
+			(HECI_READ_COMPLETE == file_ext->reading_state
+			 || HECI_FILE_INITIALIZING == file_ext->state
+			 || HECI_FILE_DISCONNECTED == file_ext->state
+			 || HECI_FILE_DISCONNECTING == file_ext->state))) {
+			if (signal_pending(current)) {
+				rets = -EINTR;
+				goto out;
+			}
+			return -ERESTARTSYS;
+		}
+
+		if (HECI_FILE_INITIALIZING == file_ext->state ||
+		    HECI_FILE_DISCONNECTED == file_ext->state ||
+		    HECI_FILE_DISCONNECTING == file_ext->state) {
+			rets = -EBUSY;
+			goto out;
+		}
+		spin_lock(&file_ext->read_io_lock);
+	}
+
+	priv_cb = file_ext->read_cb;
+
+	if (!priv_cb) {
+		spin_unlock(&file_ext->read_io_lock);
+		return -ENODEV;
+	}
+	if (file_ext->reading_state != HECI_READ_COMPLETE) {
+		spin_unlock(&file_ext->read_io_lock);
+		return 0;
+	}
+	spin_unlock(&file_ext->read_io_lock);
+	/* now copy the data to user space */
+copy_buffer:
+	DBG("priv_cb->response_buffer size - %d\n",
+	    priv_cb->response_buffer.size);
+	DBG("priv_cb->information - %lu\n",
+	    priv_cb->information);
+	if (length == 0 || ubuf == NULL ||
+	    *offset > priv_cb->information) {
+		rets = -EMSGSIZE;
+		goto free;
+	}
+
+	/* length is being turncated to PAGE_SIZE, however, */
+	/* information size may be longer */
+	length = (length < (priv_cb->information - *offset) ?
+			length : (priv_cb->information - *offset));
+
+	if (copy_to_user(ubuf,
+			 priv_cb->response_buffer.data + *offset,
+			 length)) {
+		rets = -EFAULT;
+		goto free;
+	} else {
+		rets = length;
+		*offset += length;
+		if ((unsigned long)*offset < priv_cb->information)
+			goto out;
+	}
+free:
+	spin_lock_bh(&dev->device_lock);
+	priv_cb_pos = find_read_list_entry(dev, file_ext);
+	/* Remove entry from read list */
+	if (priv_cb_pos != NULL)
+		list_del(&priv_cb_pos->cb_list);
+	spin_unlock_bh(&dev->device_lock);
+	kfree(priv_cb->response_buffer.data);
+	priv_cb->response_buffer.data = NULL;
+	kfree(priv_cb);
+	priv_cb = NULL;
+	spin_lock(&file_ext->read_io_lock);
+	file_ext->reading_state = HECI_IDLE;
+	file_ext->read_cb = NULL;
+	file_ext->read_pending = 0;
+	spin_unlock(&file_ext->read_io_lock);
+out:	DBG("end heci read rets= %d\n", rets);
+	return rets;
+}
+
+/**
+ * heci_write - the write function.
+ */
+static ssize_t heci_write(struct file *file, const char __user *ubuf,
+			  size_t length, loff_t *offset)
+{
+	int rets = 0;
+	__u8 i;
+	int if_num = MINOR((file->f_dentry->d_inode->i_rdev));
+	struct heci_file_private *file_ext = file->private_data;
+	struct heci_cb_private *priv_write_cb = NULL;
+	struct heci_msg_hdr heci_hdr;
+	struct iamt_heci_device *dev = NULL;
+	unsigned long currtime = get_seconds();
+
+	if (!heci_device)
+		return -ENODEV;
+
+	dev = pci_get_drvdata(heci_device);
+
+	if ((if_num != HECI_MINOR_NUMBER) || (!dev) || (!file_ext))
+		return -ENODEV;
+
+	spin_lock_bh(&dev->device_lock);
+
+	if (dev->heci_state != HECI_ENABLED) {
+		spin_unlock_bh(&dev->device_lock);
+		return -ENODEV;
+	}
+	if (file_ext == &dev->legacy_file_ext) {
+		priv_write_cb = find_pthi_read_list_entry(dev, file, file_ext);
+		if ((priv_write_cb) &&
+		     (((currtime - priv_write_cb->read_time) >
+			    LEGACY_READ_TIMER) ||
+		      (file_ext->reading_state == HECI_READ_COMPLETE))) {
+			(*offset) = 0;
+			list_del(&priv_write_cb->cb_list);
+			kfree(priv_write_cb->request_buffer.data);
+			kfree(priv_write_cb->response_buffer.data);
+			kfree(priv_write_cb);
+		}
+	}
+
+	/* free entry used in read */
+	if (file_ext->reading_state == HECI_READ_COMPLETE) {
+		*offset = 0;
+		priv_write_cb = find_read_list_entry(dev, file_ext);
+		if (priv_write_cb != NULL) {
+			list_del(&priv_write_cb->cb_list);
+			kfree(priv_write_cb->response_buffer.data);
+			priv_write_cb->response_buffer.data = NULL;
+			kfree(priv_write_cb);
+			priv_write_cb = NULL;
+			spin_lock(&file_ext->read_io_lock);
+			file_ext->reading_state = HECI_IDLE;
+			file_ext->read_cb = NULL;
+			file_ext->read_pending = 0;
+			spin_unlock(&file_ext->read_io_lock);
+		}
+	} else if (file_ext->reading_state == HECI_IDLE &&
+			file_ext->read_pending == 0)
+		(*offset) = 0;
+
+	spin_unlock_bh(&dev->device_lock);
+
+	priv_write_cb = kmalloc(sizeof(struct heci_cb_private), GFP_KERNEL);
+	if (!priv_write_cb)
+		return -ENOMEM;
+
+	spin_lock(&file_ext->file_lock);
+	priv_write_cb->request_buffer.data = NULL;
+	priv_write_cb->response_buffer.data = NULL;
+	priv_write_cb->file_object = file;
+	priv_write_cb->file_private = file_ext;
+	spin_unlock(&file_ext->file_lock);
+	priv_write_cb->request_buffer.data = kmalloc(length, GFP_KERNEL);
+	if (!priv_write_cb->request_buffer.data) {
+		kfree(priv_write_cb);
+		return -ENOMEM;
+	}
+	DBG("length =%d\n", (int) length);
+
+	if (copy_from_user(priv_write_cb->request_buffer.data,
+		ubuf, length)) {
+		rets = -EFAULT;
+		goto fail;
+	}
+	INIT_LIST_HEAD(&priv_write_cb->cb_list);
+	if (file_ext == &dev->legacy_file_ext) {
+		priv_write_cb->response_buffer.data =
+		    kmalloc(LEGACY_MTU, GFP_KERNEL);
+		if (!priv_write_cb->response_buffer.data) {
+			rets = -ENOMEM;
+			goto fail;
+		}
+		spin_lock_bh(&dev->device_lock);
+		if (dev->heci_state != HECI_ENABLED) {
+			spin_unlock_bh(&dev->device_lock);
+			rets = -ENODEV;
+			goto fail;
+		}
+		for (i = 0; i < dev->num_heci_me_clients; i++) {
+			if (dev->me_clients[i].client_id ==
+				dev->legacy_file_ext.me_client_id)
+				break;
+		}
+
+		BUG_ON(dev->me_clients[i].client_id != file_ext->me_client_id);
+		if ((i == dev->num_heci_me_clients) ||
+		    (dev->me_clients[i].client_id !=
+		      dev->legacy_file_ext.me_client_id)) {
+
+			spin_unlock_bh(&dev->device_lock);
+			rets = -ENODEV;
+			goto fail;
+		} else if ((length > dev->me_clients[i].props.max_msg_length)
+			    || (length <= 0)) {
+			spin_unlock_bh(&dev->device_lock);
+			rets = -EMSGSIZE;
+			goto fail;
+		}
+
+
+		priv_write_cb->response_buffer.size = LEGACY_MTU;
+		priv_write_cb->major_file_operations = HECI_IOCTL;
+		priv_write_cb->information = 0;
+		priv_write_cb->request_buffer.size = length;
+		if (dev->legacy_file_ext.state != HECI_FILE_CONNECTED) {
+			spin_unlock_bh(&dev->device_lock);
+			rets = -ENODEV;
+			goto fail;
+		}
+
+		if (!list_empty(&dev->pthi_cmd_list.heci_cb.cb_list)
+				|| dev->legacy_state != HECI_LEGACY_IDLE) {
+			DBG("pthi_state = %d\n", (int) dev->legacy_state);
+			DBG("add PTHI cb to pthi cmd waiting list\n");
+			list_add_tail(&priv_write_cb->cb_list,
+					&dev->pthi_cmd_list.heci_cb.cb_list);
+			rets = length;
+		} else {
+			DBG("call pthi write");
+			rets = pthi_write(dev, priv_write_cb);
+
+			if (rets != 0) {
+				DBG("pthi write failed with status = %d\n",
+				    rets);
+				spin_unlock_bh(&dev->device_lock);
+				goto fail;
+			}
+			rets = length;
+		}
+		spin_unlock_bh(&dev->device_lock);
+		return rets;
+	}
+
+	priv_write_cb->major_file_operations = HECI_WRITE;
+	/* make sure information is zero before we start */
+
+	priv_write_cb->information = 0;
+	priv_write_cb->request_buffer.size = length;
+
+	spin_lock(&file_ext->write_io_lock);
+	DBG("host client = %d, ME client = %d\n",
+	    file_ext->host_client_id, file_ext->me_client_id);
+	if (file_ext->state != HECI_FILE_CONNECTED) {
+		rets = -ENODEV;
+		DBG("host client = %d,  is not connected to ME client = %d",
+		    file_ext->host_client_id,
+		    file_ext->me_client_id);
+
+		goto unlock;
+	}
+	for (i = 0; i < dev->num_heci_me_clients; i++) {
+		if (dev->me_clients[i].client_id ==
+		    file_ext->me_client_id)
+			break;
+	}
+	BUG_ON(dev->me_clients[i].client_id != file_ext->me_client_id);
+	if (i == dev->num_heci_me_clients) {
+		rets = -ENODEV;
+		goto unlock;
+	}
+	if (length > dev->me_clients[i].props.max_msg_length || length <= 0) {
+		rets = -EINVAL;
+		goto unlock;
+	}
+	priv_write_cb->file_private = file_ext;
+
+	spin_lock_bh(&dev->device_lock);
+	if (flow_ctrl_creds(dev, file_ext) &&
+		dev->host_buffer_is_empty) {
+		spin_unlock_bh(&dev->device_lock);
+		dev->host_buffer_is_empty = 0;
+		if (length > ((((dev->host_hw_state & H_CBD) >> 24) *
+			sizeof(__u32)) - sizeof(struct heci_msg_hdr))) {
+
+			heci_hdr.length =
+				(((dev->host_hw_state & H_CBD) >> 24) *
+				sizeof(__u32)) -
+				sizeof(struct heci_msg_hdr);
+			heci_hdr.msg_complete = 0;
+		} else {
+			heci_hdr.length = length;
+			heci_hdr.msg_complete = 1;
+		}
+		heci_hdr.host_addr = file_ext->host_client_id;
+		heci_hdr.me_addr = file_ext->me_client_id;
+		heci_hdr.reserved = 0;
+		DBG("call heci_write_message header=%08x.\n",
+		    *((__u32 *) &heci_hdr));
+		spin_unlock(&file_ext->write_io_lock);
+		/*  protect heci low level write */
+		spin_lock_bh(&dev->device_lock);
+		if (!heci_write_message(dev, &heci_hdr,
+			(unsigned char *) (priv_write_cb->request_buffer.data),
+			heci_hdr.length)) {
+
+			spin_unlock_bh(&dev->device_lock);
+			kfree(priv_write_cb->request_buffer.data);
+			priv_write_cb->request_buffer.data = NULL;
+			kfree(priv_write_cb);
+			rets = -ENODEV;
+			priv_write_cb->information = 0;
+			return rets;
+		}
+		file_ext->writing_state = HECI_WRITING;
+		priv_write_cb->information = heci_hdr.length;
+		if (heci_hdr.msg_complete) {
+			flow_ctrl_reduce(dev, file_ext);
+			list_add_tail(&priv_write_cb->cb_list,
+				      &dev->write_waiting_list.heci_cb.cb_list);
+		} else {
+			list_add_tail(&priv_write_cb->cb_list,
+				      &dev->write_list.heci_cb.cb_list);
+		}
+		spin_unlock_bh(&dev->device_lock);
+
+	} else {
+
+		spin_unlock_bh(&dev->device_lock);
+		priv_write_cb->information = 0;
+		file_ext->writing_state = HECI_WRITING;
+		spin_unlock(&file_ext->write_io_lock);
+		list_add_tail(&priv_write_cb->cb_list,
+			      &dev->write_list.heci_cb.cb_list);
+	}
+	return length;
+
+unlock:
+	spin_unlock(&file_ext->write_io_lock);
+fail:
+	kfree(priv_write_cb->request_buffer.data);
+	priv_write_cb->request_buffer.data = NULL;
+	kfree(priv_write_cb->response_buffer.data);
+	priv_write_cb->response_buffer.data = NULL;
+	kfree(priv_write_cb);
+	return rets;
+
+}
+
+/**
+ * heci_ioctl - the IOCTL function
+ */
+static int heci_ioctl(struct inode *inode, struct file *file,
+		      unsigned int cmd, unsigned long data)
+{
+	int rets = 0;
+	int if_num = MINOR(inode->i_rdev);
+	struct heci_file_private *file_ext = file->private_data;
+	/* in user space */
+	struct heci_message_data *u_msg = (struct heci_message_data *) data;
+	struct heci_message_data k_msg;	/* all in kernel on the stack */
+	struct iamt_heci_device *dev = NULL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!heci_device)
+		return -ENODEV;
+
+	dev = pci_get_drvdata(heci_device);
+	if (((if_num != LEGACY_MINOR_NUMBER) && (if_num != HECI_MINOR_NUMBER))
+	     || (!dev) || (!file_ext))
+		return -ENODEV;
+
+	if (dev->heci_state != HECI_ENABLED)
+		return -ENODEV;
+
+	/* first copy from user all data needed */
+	if (copy_from_user(&k_msg, u_msg, sizeof(k_msg))) {
+		DBG("first copy from user all data needed filed\n");
+		return -EFAULT;
+	}
+	DBG("user message size is %d\n", k_msg.size);
+
+	switch (cmd) {
+	case IOCTL_HECI_GET_VERSION:
+		DBG(": IOCTL_HECI_GET_VERSION\n");
+		rets = heci_ioctl_get_version(dev, if_num, u_msg, k_msg,
+					      file_ext);
+		break;
+
+	case IOCTL_HECI_CONNECT_CLIENT:
+		DBG(": IOCTL_HECI_CONNECT_CLIENT.\n");
+		rets = heci_ioctl_connect_client(dev, if_num, u_msg, k_msg,
+						 file);
+		break;
+
+	case IOCTL_HECI_WD:
+		DBG(": IOCTL_HECI_WD.\n");
+		rets = heci_ioctl_wd(dev, if_num, k_msg, file_ext);
+		break;
+
+	case IOCTL_HECI_BYPASS_WD:
+		DBG(": IOCTL_HECI_BYPASS_WD.\n");
+		rets = heci_ioctl_bypass_wd(dev, if_num, k_msg, file_ext);
+		break;
+
+	case IAMT_KCS_SEND_MESSAGE_COMMAND:
+		DBG(": IAMT_KCS_SEND_MESSAGE_COMMAND.\n");
+		rets = legacy_ioctl_send_msg(dev, if_num, k_msg, file);
+		break;
+
+	case IAMT_KCS_RECEIVE_MESSAGE_COMMAND:
+		DBG(": IAMT_KCS_RECEIVE_MESSAGE_COMMAND.\n");
+		rets = legacy_ioctl_recv_msg(dev, if_num, u_msg, k_msg, file);
+		break;
+
+	default:
+		rets = -EINVAL;
+		break;
+	}
+	return rets;
+}
+
+/**
+ * heci_legacy_poll - the poll function
+ */
+static unsigned int heci_legacy_poll(struct file *file, poll_table *wait)
+{
+	int if_num = MINOR((file->f_dentry->d_inode->i_rdev));
+	unsigned int mask = 0;
+	struct iamt_heci_device *dev = NULL;
+	struct heci_file_private *file_ext = file->private_data;
+
+	if (!heci_device || !file_ext)
+		return mask;
+
+	dev = pci_get_drvdata(heci_device);
+
+	if ((if_num != LEGACY_MINOR_NUMBER) || (!dev))
+		return mask;
+
+	spin_lock_bh(&dev->device_lock);
+	if (dev->heci_state != HECI_ENABLED) {
+		spin_unlock_bh(&dev->device_lock);
+		return mask;
+	}
+	spin_unlock_bh(&dev->device_lock);
+
+	if (file_ext == &dev->legacy_file_ext) {
+		poll_wait(file, &dev->legacy_file_ext.wait, wait);
+		spin_lock(&dev->legacy_file_ext.file_lock);
+		if (dev->legacy_state == HECI_LEGACY_READ_COMPLETE
+		    && dev->legacy_file_object == file) {
+			mask |= (POLLIN | POLLRDNORM);
+			spin_lock_bh(&dev->device_lock);
+			DBG("run next pthi legacy cb\n");
+			run_next_legacy_cmd(dev);
+			spin_unlock_bh(&dev->device_lock);
+		}
+		spin_unlock(&dev->legacy_file_ext.file_lock);
+	}
+
+	return mask;
+}
+
+/**
+ * heci_poll - the poll function
+ */
+static unsigned int heci_poll(struct file *file, poll_table *wait)
+{
+	int if_num = MINOR((file->f_dentry->d_inode->i_rdev));
+	unsigned int mask = 0;
+	struct heci_file_private *file_ext = file->private_data;
+	struct iamt_heci_device *dev = NULL;
+
+	if (!heci_device)
+		return mask;
+
+	dev = pci_get_drvdata(heci_device);
+
+	if ((if_num != HECI_MINOR_NUMBER) || (!dev) || (!file_ext))
+		return mask;
+
+	spin_lock_bh(&dev->device_lock);
+	if (dev->heci_state != HECI_ENABLED) {
+		spin_unlock_bh(&dev->device_lock);
+		return mask;
+	}
+	spin_unlock_bh(&dev->device_lock);
+
+	if (file_ext == &dev->legacy_file_ext) {
+		poll_wait(file, &dev->legacy_file_ext.wait, wait);
+		spin_lock(&dev->legacy_file_ext.file_lock);
+		if (dev->legacy_state == HECI_LEGACY_READ_COMPLETE
+		    && dev->legacy_file_object == file) {
+			mask |= (POLLIN | POLLRDNORM);
+			spin_lock_bh(&dev->device_lock);
+			DBG("run next pthi cb");
+			run_next_legacy_cmd(dev);
+			spin_unlock_bh(&dev->device_lock);
+		}
+		spin_unlock(&dev->legacy_file_ext.file_lock);
+
+	} else{
+		poll_wait(file, &file_ext->tx_wait, wait);
+		spin_lock(&file_ext->write_io_lock);
+		if (HECI_WRITE_COMPLETE == file_ext->writing_state)
+			mask |= (POLLIN | POLLRDNORM);
+
+		spin_unlock(&file_ext->write_io_lock);
+	}
+
+	return mask;
+}
+
+#ifdef CONFIG_PM
+static int heci_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct iamt_heci_device *device = pci_get_drvdata(pdev);
+	int err = 0;
+
+	/* Stop watchdog if exists */
+	del_timer_sync(&device->wd_timer);
+	if (device->wd_file_ext.state == HECI_FILE_CONNECTED
+	    && device->wd_timeout) {
+		spin_lock_bh(&device->device_lock);
+		g_sus_wd_timeout = device->wd_timeout;
+		device->wd_timeout = 0;
+		device->wd_due_counter = 0;
+		memcpy(device->wd_data, stop_wd_params, HECI_WD_PARAMS_SIZE);
+		device->stop = 1;
+		if (device->host_buffer_is_empty &&
+		    flow_ctrl_creds(device, &device->wd_file_ext)) {
+			device->host_buffer_is_empty = 0;
+			if (!heci_send_wd(device))
+				DBG("Send stop WD  failed\n");
+			else
+				flow_ctrl_reduce(device, &device->wd_file_ext);
+
+			device->wd_pending = 0;
+		} else {
+			device->wd_pending = 1;
+		}
+		spin_unlock_bh(&device->device_lock);
+		device->wd_stoped = 0;
+
+		err = wait_event_interruptible_timeout(device->wait_stop_wd,
+						       (device->wd_stoped),
+						       10 * HZ);
+		if (!device->wd_stoped)
+			DBG("stop wd failed to complete.\n");
+		else {
+			DBG("stop wd complete %d.\n", err);
+			err = 0;
+		}
+	}
+	/* Set new heci state */
+	spin_lock_bh(&device->device_lock);
+	if (device->heci_state == HECI_ENABLED ||
+	    device->heci_state == HECI_RECOVERING_FROM_RESET) {
+		device->heci_state = HECI_POWER_DOWN;
+		heci_reset(device, 0);
+	}
+	spin_unlock_bh(&device->device_lock);
+
+	pci_save_state(pdev);
+
+	pci_disable_device(pdev);
+	free_irq(pdev->irq, device);
+
+	pci_set_power_state(pdev, PCI_D3hot);
+
+	return err;
+}
+
+static int heci_resume(struct pci_dev *pdev)
+{
+	struct iamt_heci_device *device = NULL;
+	int err = 0;
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+
+	device = pci_get_drvdata(pdev);
+	if (!device)
+		return -ENODEV;
+
+	/* request and enable interrupt   */
+	device->irq = pdev->irq;
+	err = request_irq(device->irq, heci_isr_interrupt, IRQF_SHARED,
+			heci_driver_name, device);
+	if (err) {
+		printk(KERN_ERR "%s: Request_irq failure. irq = %d \n",
+		       THIS_MODULE->name, device->irq);
+		return err;
+	}
+
+	spin_lock_bh(&device->device_lock);
+	device->heci_state = HECI_POWER_UP;
+	heci_reset(device, 1);
+	spin_unlock_bh(&device->device_lock);
+
+	/* Start watchdog if stopped in suspend */
+	if (g_sus_wd_timeout != 0) {
+		device->wd_timeout = g_sus_wd_timeout;
+
+		memcpy(device->wd_data, start_wd_params, HECI_WD_PARAMS_SIZE);
+		memcpy(device->wd_data + HECI_WD_PARAMS_SIZE,
+		       &device->wd_timeout, sizeof(__u16));
+		device->wd_due_counter = 1;
+
+		if (device->wd_timeout)
+			mod_timer(&device->wd_timer, jiffies);
+
+		g_sus_wd_timeout = 0;
+	}
+	return err;
+}
+#endif
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("Intel(R) AMT Management Interface");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_VERSION(DRIVER_VERSION);
diff --git a/drivers/char/heci/heci_version.h b/drivers/char/heci/heci_version.h
new file mode 100644
index 0000000..95a2698
--- /dev/null
+++ b/drivers/char/heci/heci_version.h
@@ -0,0 +1,56 @@
+/*
+ * Part of Intel(R) Manageability Engine Interface Linux driver
+ *
+ * Copyright (c) 2006-2007 Intel Corp.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ *
+ */
+
+#ifndef HECI_VERSION_H
+#define HECI_VERSION_H
+
+#define MAJOR_VERSION              3
+#define MINOR_VERSION              1
+#define QUICK_FIX_NUMBER        0
+#define VER_BUILD               38
+
+#define str(s) name(s)
+#define name(s) #s
+#define DRIVER_V1		str(MAJOR_VERSION) "." str(MINOR_VERSION)
+#define DRIVER_V2		str(QUICK_FIX_NUMBER) "." str(VER_BUILD)
+
+#define DRIVER_VERSION	DRIVER_V1 "." DRIVER_V2
+
+#endif
diff --git a/drivers/char/heci/interrupt.c b/drivers/char/heci/interrupt.c
new file mode 100644
index 0000000..dfbf58e
--- /dev/null
+++ b/drivers/char/heci/interrupt.c
@@ -0,0 +1,1596 @@
+/*
+ * Part of Intel(R) Manageability Engine Interface Linux driver
+ *
+ * Copyright (c) 2006-2007 Intel Corp.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ *
+ */
+
+#include <linux/kthread.h>
+#include <linux/uaccess.h>
+
+#include "heci.h"
+#include "heci_interface.h"
+
+/**
+ *  interrupt function prototypes
+ */
+static void heci_bh_handler(struct work_struct *work);
+static int heci_bh_read_handler(struct io_heci_list *complete_list,
+		struct iamt_heci_device *dev,
+		__s32 *slots);
+static int heci_bh_write_handler(struct io_heci_list *complete_list,
+		struct iamt_heci_device *dev,
+		__s32 *slots);
+static void heci_bh_read_bus_message(struct iamt_heci_device *dev,
+		struct heci_msg_hdr *heci_hdr);
+static int heci_bh_read_pthi_message(struct io_heci_list *complete_list,
+		struct iamt_heci_device *dev,
+		struct heci_msg_hdr *heci_hdr);
+static int heci_bh_read_client_message(struct io_heci_list *complete_list,
+		struct iamt_heci_device *dev,
+		struct heci_msg_hdr *heci_hdr);
+static void heci_client_connect_response(struct iamt_heci_device *dev,
+		struct hbm_client_connect_response *connect_res);
+static void heci_client_disconnect_response(struct iamt_heci_device *dev,
+		struct hbm_client_connect_response *disconnect_res);
+static void heci_client_flow_control_response(struct iamt_heci_device *dev,
+		struct hbm_flow_control *flow_control);
+static void heci_client_disconnect_request(struct iamt_heci_device *dev,
+		struct hbm_client_disconnect_request *disconnect_req);
+
+
+/**
+ * heci_isr_interrupt - The ISR of the HECI device
+ * @irq: The irq number
+ * @dev_id: pointer to the device structure
+ * @regs: the register values
+ *
+ * @return :
+ * irqreturn_t
+ */
+irqreturn_t heci_isr_interrupt(int irq, void *dev_id)
+{
+	int err;
+	struct iamt_heci_device *device = (struct iamt_heci_device *) dev_id;
+	device->host_hw_state = read_heci_register(device, H_CSR);
+
+	if ((device->host_hw_state & H_IS) != H_IS)
+		return IRQ_NONE;
+
+	/* disable interrupts */
+	device->host_hw_state &= ~H_IE;
+	/* acknowledge interrupt and stop interupts */
+	write_heci_register(device, H_CSR, device->host_hw_state);
+	/**
+	 * Our device interrupted, schedule work the heci_bh_handler
+	 * to handle the interrupt processing. This needs to be a
+	 * workqueue item since the handler can sleep.
+	 */
+	PREPARE_WORK(&device->work, heci_bh_handler);
+	DBG("schedule work the heci_bh_handler \n");
+	err = schedule_work(&device->work);
+	if (!err) {
+		printk(KERN_ERR "%s: schedule the heci_bh_handler"
+		       " failed error=%x\n", THIS_MODULE->name, err);
+	}
+	return IRQ_HANDLED;
+}
+
+/**
+ * _heci_cmpl: process completed operation.
+  * @priv_cb_pos: callback block.
+ * @file_ext: file extension.
+ *
+ * @return :
+ * none.
+ */
+static void _heci_cmpl(struct heci_file_private *file_ext,
+				struct heci_cb_private *priv_cb_pos)
+{
+	if (priv_cb_pos->major_file_operations == HECI_WRITE) {
+		kfree(priv_cb_pos->request_buffer.data);
+		priv_cb_pos->request_buffer.data = NULL;
+		kfree(priv_cb_pos);
+		priv_cb_pos = NULL;
+		DBG("completing write  call back.\n");
+		file_ext->writing_state = HECI_WRITE_COMPLETE;
+		if ((&file_ext->tx_wait) &&
+		    waitqueue_active(&file_ext->tx_wait))
+			wake_up_interruptible(&file_ext->tx_wait);
+
+	} else if (priv_cb_pos->major_file_operations == HECI_READ
+				&& HECI_READING == file_ext->reading_state) {
+		DBG("completing read call back information= %lu\n",
+				priv_cb_pos->information);
+		file_ext->reading_state = HECI_READ_COMPLETE;
+		if ((&file_ext->rx_wait) &&
+		    waitqueue_active(&file_ext->rx_wait))
+			wake_up_interruptible(&file_ext->rx_wait);
+
+	}
+}
+
+/**
+ * _heci_cmpl_legacy: process completed legacy operation.
+ * @dev: device object.
+ * @priv_cb_pos: callback block.
+ *
+ * @return :
+ * none.
+ */
+static void _heci_cmpl_legacy(struct iamt_heci_device *dev,
+				struct heci_cb_private *priv_cb_pos)
+{
+	if (dev->legacy_canceled != 1) {
+		dev->legacy_state = HECI_LEGACY_READ_COMPLETE;
+		dev->legacy_stall_timer = 0;
+		memcpy(priv_cb_pos->response_buffer.data,
+				dev->legacy_msg_buf,
+				dev->legacy_msg_buf_index);
+		list_add_tail(&priv_cb_pos->cb_list,
+				&dev->pthi_read_complete_list.heci_cb.cb_list);
+		DBG("pthi read completed\n");
+	} else {
+		run_next_legacy_cmd(dev);
+	}
+	if (&dev->legacy_file_ext.wait) {
+		DBG("completing pthi call back.\n");
+		wake_up_interruptible(&dev->legacy_file_ext.wait);
+	}
+}
+/**
+ * heci_bh_handler - function called after ISR to handle the interrupt
+ * processing.
+ * @data: pointer to the device structure
+ *
+ * NOTE: This function is called by schedule work
+ * @return :
+ * none;
+ */
+static void heci_bh_handler(struct work_struct *work)
+{
+	struct iamt_heci_device *dev =
+		container_of(work, struct iamt_heci_device, work);
+	struct io_heci_list complete_list;
+	__s32 slots;
+	int rets;
+	struct heci_cb_private *cb_pos = NULL, *cb_next = NULL;
+	struct heci_file_private *file_ext = NULL;
+	int bus_message_received = 0;
+	struct task_struct *tsk;
+
+	DBG("function called after ISR to handle the interrupt processing.\n");
+	/* initialize our complete list */
+	spin_lock_bh(&dev->device_lock);
+	heci_initialize_list(&complete_list, dev);
+	dev->host_hw_state = read_heci_register(dev, H_CSR);
+	dev->me_hw_state = read_heci_register(dev, ME_CSR_HA);
+
+	/* check if ME wants a reset */
+	if (((dev->me_hw_state & ME_RDY_HRA) == 0)
+	    && (dev->heci_state != HECI_RESETING)
+	    && (dev->heci_state != HECI_INITIALIZING)) {
+		DBG("FW not ready.\n");
+		heci_reset(dev, 1);
+		spin_unlock_bh(&dev->device_lock);
+		return;
+	}
+
+	/*  check if we need to start the dev */
+	if ((dev->host_hw_state & H_RDY) == 0) {
+		if ((dev->me_hw_state & ME_RDY_HRA) == ME_RDY_HRA) {
+			DBG("we need to start the dev.\n");
+			dev->host_hw_state |= (H_IE | H_IG | H_RDY);
+			write_heci_register(dev, H_CSR, dev->host_hw_state);
+			if (dev->heci_state == HECI_INITIALIZING) {
+				dev->recvd_msg = 1;
+				spin_unlock_bh(&dev->device_lock);
+				wake_up_interruptible(&dev->wait_recvd_msg);
+				return;
+
+			} else {
+				spin_unlock_bh(&dev->device_lock);
+				tsk = kthread_run(heci_initialize_clients,
+						  dev, "heci");
+				if (IS_ERR(tsk)) {
+					int rc = PTR_ERR(tsk);
+					printk(KERN_WARNING "heci: Unable to"
+					"start the heci thread: %d\n", rc);
+				}
+				return;
+			}
+		} else {
+			DBG("Enable interrupt FW not ready \n");
+			dev->host_hw_state |= (H_IE);
+			write_heci_register(dev, H_CSR, dev->host_hw_state);
+			spin_unlock_bh(&dev->device_lock);
+			return;
+		}
+	}
+	/* check slots avalable for reading */
+	slots = count_full_read_slots(dev);
+	DBG("slots =%08x  extra_write_index =%08x.\n",
+		slots, dev->extra_write_index);
+	while ((slots > 0) && (!dev->extra_write_index)) {
+		DBG("slots =%08x  extra_write_index =%08x.\n", slots,
+				dev->extra_write_index);
+		DBG("call heci_bh_read_handler.\n");
+		rets = heci_bh_read_handler(&complete_list, dev, &slots);
+		if (rets != 0)
+			goto end;
+	}
+	rets = heci_bh_write_handler(&complete_list, dev, &slots);
+end:
+	DBG("end of bottom half function.\n");
+	dev->host_hw_state = read_heci_register(dev, H_CSR);
+	dev->host_buffer_is_empty = host_buffer_is_empty(dev);
+
+	if ((dev->host_hw_state & H_IS) == H_IS) {
+		PREPARE_WORK(&dev->work, heci_bh_handler);
+		DBG("schedule work the heci_bh_handler.\n");
+		rets = schedule_work(&dev->work);
+		if (!rets) {
+			printk(KERN_ERR "%s: schedule the heci_bh_handler"
+			       " failed error=%x\n", THIS_MODULE->name, rets);
+		}
+	} else {
+		dev->host_hw_state |= H_IE;
+	}
+
+	write_heci_register(dev, H_CSR, dev->host_hw_state);
+
+
+	if (dev->recvd_msg && waitqueue_active(&dev->wait_recvd_msg)) {
+		DBG("received waiting bus message\n");
+		bus_message_received = 1;
+	}
+	spin_unlock_bh(&dev->device_lock);
+	if (bus_message_received) {
+		DBG("wake up dev->wait_recvd_msg\n");
+		wake_up_interruptible(&dev->wait_recvd_msg);
+		bus_message_received = 0;
+	}
+	if ((complete_list.status != 0)
+	    || list_empty(&complete_list.heci_cb.cb_list))
+		return;
+
+
+	list_for_each_entry_safe(cb_pos, cb_next,
+			&complete_list.heci_cb.cb_list, cb_list) {
+		file_ext = (struct heci_file_private *)cb_pos->file_private;
+		list_del(&cb_pos->cb_list);
+		if ((file_ext) && (file_ext != &dev->legacy_file_ext)) {
+			DBG("completing call back.\n");
+			_heci_cmpl(file_ext, cb_pos);
+			cb_pos = NULL;
+		} else if (file_ext == &dev->legacy_file_ext) {
+			_heci_cmpl_legacy(dev, cb_pos);
+		}
+	}
+}
+
+
+/**
+ * heci_bh_read_handler - bottom half read routine after ISR to
+ * handle the read processing.
+ *
+ *
+ * @complete_list - An instance of our list structure
+ * @dev - Device object for our driver
+ * @slots         - slots to read.
+ * @return :
+ *  0 on success,
+ *  negative on failure.
+ */
+static int heci_bh_read_handler(struct io_heci_list *cmpl_list,
+		struct iamt_heci_device *dev,
+		__s32 *slots)
+{
+	struct heci_msg_hdr *heci_hdr;
+	int ret = 0;
+	struct heci_file_private *file_pos = NULL;
+	struct heci_file_private *file_next = NULL;
+
+	if (!dev->rd_msg_hdr) {
+		dev->rd_msg_hdr = read_heci_register(dev, ME_CB_RW);
+		DBG("slots=%08x.\n", *slots);
+		(*slots)--;
+		DBG("slots=%08x.\n", *slots);
+	}
+	heci_hdr = (struct heci_msg_hdr *) &dev->rd_msg_hdr;
+	DBG("heci_hdr->length =%d\n", heci_hdr->length);
+
+	if ((heci_hdr->reserved) || !(dev->rd_msg_hdr)) {
+		DBG("corrupted message header.\n");
+		ret = -ECORRUPTED_MESSAGE_HEADER;
+		goto end;
+	}
+
+	if (heci_hdr->host_addr || heci_hdr->me_addr) {
+		list_for_each_entry_safe(file_pos, file_next,
+				&dev->file_list, link) {
+			DBG("list_for_each_entry_safe read host"
+					" client = %d, ME client = %d\n",
+					file_pos->host_client_id,
+					file_pos->me_client_id);
+			if ((file_pos->host_client_id == heci_hdr->host_addr)
+			    && (file_pos->me_client_id == heci_hdr->me_addr))
+				break;
+		}
+
+		if (&file_pos->link == &dev->file_list) {
+			DBG("corrupted message header\n");
+			ret = -ECORRUPTED_MESSAGE_HEADER;
+			goto end;
+		}
+	}
+	if (((*slots) * sizeof(__u32)) < heci_hdr->length) {
+		DBG("we can't read the message slots=%08x.\n", *slots);
+		/* we can't read the message */
+		ret = -ERANGE;
+		goto end;
+	}
+
+	/* decide where to read the message too */
+	if (!heci_hdr->host_addr) {
+		DBG("call heci_bh_read_bus_message.\n");
+		heci_bh_read_bus_message(dev, heci_hdr);
+		DBG("end heci_bh_read_bus_message.\n");
+	} else if (heci_hdr->host_addr == dev->legacy_file_ext.host_client_id
+		   && HECI_FILE_CONNECTED == dev->legacy_file_ext.state
+		   && dev->legacy_state == HECI_LEGACY_READING) {
+		DBG("call heci_bh_read_legacy_message.\n");
+		DBG("heci_hdr->length =%d\n", heci_hdr->length);
+		ret = heci_bh_read_pthi_message(cmpl_list, dev, heci_hdr);
+		if (ret != 0)
+			goto end;
+
+	} else {
+		DBG("call heci_bh_read_client_message.\n");
+		ret = heci_bh_read_client_message(cmpl_list, dev, heci_hdr);
+		if (ret != 0)
+			goto end;
+
+	}
+
+	/* reset the number of slots and header */
+	*slots = count_full_read_slots(dev);
+	dev->rd_msg_hdr = 0;
+
+	if (*slots == -ESLOTS_OVERFLOW) {
+		/* overflow - reset */
+		DBG("reseting due to slots overflow\n");
+		/* set the event since message has been read */
+		ret = -ERANGE;
+		goto end;
+	}
+end:
+	return ret;
+}
+
+
+/**
+ * heci_bh_read_bus_message - bottom half read routine after ISR to
+ * handle the read bus message cmd  processing.
+ *
+ * @complete_list - An instance of our list structure
+ * @dev - Device object for our driver
+ * @buffer        - message buffer will be filled
+ * @heci_hdr   - header of bus message
+ *
+ * @return :
+ * none;
+ */
+static void heci_bh_read_bus_message(struct iamt_heci_device *dev,
+		struct heci_msg_hdr *heci_hdr)
+{
+	struct heci_bus_message *heci_msg;
+	struct hbm_host_version_response *version_res;
+	struct hbm_client_connect_response *connect_res;
+	struct hbm_client_connect_response *disconnect_res;
+	struct hbm_flow_control *flow_control;
+	struct hbm_props_response *props_res;
+	struct hbm_host_enum_response *enum_res;
+	struct hbm_client_disconnect_request *disconnect_req;
+	struct hbm_host_stop_request *h_stop_req;
+	int i;
+	unsigned char *buffer;
+
+	buffer = NULL;
+	/*  read the message to our buffer */
+	buffer = (unsigned char *) dev->rd_msg_buf;
+	BUG_ON(heci_hdr->length >= sizeof(dev->rd_msg_buf));
+	heci_read_slots(dev, buffer, heci_hdr->length);
+	heci_msg = (struct heci_bus_message *) buffer;
+
+	switch (*(__u8 *) heci_msg) {
+	case HOST_START_RES_CMD:
+		version_res = (struct hbm_host_version_response *) heci_msg;
+		if (version_res->host_version_supported) {
+			dev->version.major_version = HBM_MAJOR_VERSION;
+			dev->version.minor_version = HBM_MINOR_VERSION;
+		} else {
+			dev->version = version_res->me_max_version;
+		}
+		dev->recvd_msg = 1;
+		DBG("host start response message received.\n");
+		break;
+
+	case CLIENT_CONNECT_RES_CMD:
+		connect_res =
+			(struct hbm_client_connect_response *) heci_msg;
+		heci_client_connect_response(dev, connect_res);
+		DBG("client connect response message received.\n");
+		wake_up(&dev->wait_recvd_msg);
+		break;
+
+	case CLIENT_DISCONNECT_RES_CMD:
+		disconnect_res =
+			(struct hbm_client_connect_response *) heci_msg;
+		heci_client_disconnect_response(dev,	 disconnect_res);
+		DBG("client disconnect response message received.\n");
+		wake_up(&dev->wait_recvd_msg);
+		break;
+
+	case FLOW_CONTROL_CMD:
+		flow_control = (struct hbm_flow_control *) heci_msg;
+		heci_client_flow_control_response(dev, flow_control);
+		DBG("client flow control response message received.\n");
+		break;
+	case HOST_CLIENT_PROPERTEIS_RES_CMD:
+		props_res = (struct hbm_props_response *) heci_msg;
+		if (props_res->status != 0) {
+			BUG_ON(1);
+			break;
+		}
+		for (i = 0; i < dev->num_heci_me_clients; i++) {
+			if (dev->me_clients[i].client_id ==
+					props_res->address) {
+				dev->me_clients[i].props =
+					props_res->client_properties;
+				break;
+			}
+
+		}
+		dev->recvd_msg = 1;
+		break;
+	case HOST_ENUM_RES_CMD:
+		enum_res = (struct hbm_host_enum_response *) heci_msg;
+		memcpy(dev->heci_me_clients, enum_res->valid_addresses, 32);
+		dev->recvd_msg = 1;
+		break;
+	case HOST_STOP_RES_CMD:
+		dev->heci_state = HECI_DISABLED;
+		DBG("Reseting becase of FW stop response\n");
+		heci_reset(dev, 1);
+		break;
+	case CLIENT_DISCONNECT_REQ_CMD:
+		/* search for client */
+		disconnect_req =
+			(struct hbm_client_disconnect_request *) heci_msg;
+		heci_client_disconnect_request(dev, disconnect_req);
+		break;
+	case ME_STOP_REQ_CMD:
+		/* prepare stop request */
+		heci_hdr = (struct heci_msg_hdr *) &dev->ext_msg_buf[0];
+		heci_hdr->host_addr = 0;
+		heci_hdr->me_addr = 0;
+		heci_hdr->length = sizeof(struct hbm_host_stop_request);
+		heci_hdr->msg_complete = 1;
+		heci_hdr->reserved = 0;
+		h_stop_req =
+			(struct hbm_host_stop_request *) &dev->ext_msg_buf[1];
+		memset(h_stop_req, 0, sizeof(struct hbm_host_stop_request));
+		h_stop_req->cmd.cmd = HOST_STOP_REQ_CMD;
+		h_stop_req->reason = DRIVER_STOP_REQUEST;
+		h_stop_req->reserved[0] = 0;
+		h_stop_req->reserved[1] = 0;
+		dev->extra_write_index = 2;
+		break;
+
+	default:
+		BUG_ON(1);
+		break;
+
+	}
+}
+
+/**
+ * heci_bh_read_legacy_message - bottom half read routine after ISR to
+ * handle the read legacy message data processing.
+ *
+ * @complete_list - An instance of our list structure
+ * @dev - Device object for our driver
+ * @buffer        - message buffer will be filled
+ * @heci_hdr   - header of legacy message
+ *
+ * @return :
+ *  0 on success,
+ *  negative on failure.
+ */
+static int heci_bh_read_pthi_message(struct io_heci_list *complete_list,
+		struct iamt_heci_device *dev,
+		struct heci_msg_hdr *heci_hdr)
+{
+	struct heci_file_private *file_ext = NULL;
+	struct heci_cb_private *priv_cb = NULL;
+	int rets = 0;
+	unsigned char *buffer = NULL;
+
+	BUG_ON(heci_hdr->me_addr != dev->legacy_file_ext.me_client_id);
+	BUG_ON(dev->legacy_state != HECI_LEGACY_READING);
+
+	buffer = (unsigned char *) (dev->legacy_msg_buf +
+			dev->legacy_msg_buf_index);
+	BUG_ON(sizeof(dev->legacy_msg_buf) <
+			(dev->legacy_msg_buf_index + heci_hdr->length));
+
+	heci_read_slots(dev, buffer, heci_hdr->length);
+
+	dev->legacy_msg_buf_index += heci_hdr->length;
+
+	if (heci_hdr->msg_complete) {
+		DBG("pthi_message_buffer_index=%d\n", heci_hdr->length);
+		DBG("completed  pthi read.\n ");
+		if (!dev->legacy_current_cb)
+			return -ENODEV;
+		priv_cb = dev->legacy_current_cb;
+		dev->legacy_current_cb = NULL;
+		file_ext = (struct heci_file_private *)priv_cb->file_private;
+		if (!file_ext)
+			return -ENODEV;
+		dev->legacy_stall_timer = 0;
+		priv_cb->information =	dev->legacy_msg_buf_index;
+		priv_cb->read_time = get_seconds();
+		if (dev->legacy_ioctl && file_ext == &dev->legacy_file_ext) {
+			/* found the legacy cb */
+			DBG("complete the pthi read cb.\n ");
+			if (&dev->legacy_file_ext) {
+				DBG("add the pthi read cb to complete.\n ");
+				list_add_tail(&priv_cb->cb_list,
+					      &complete_list->heci_cb.cb_list);
+			}
+		}
+	}
+	return rets;
+}
+
+static int _heci_bh_state_ok(struct heci_file_private *file_ext,
+					struct heci_msg_hdr *heci_hdr)
+{
+	return ((file_ext->host_client_id == heci_hdr->host_addr)
+		&& (file_ext->me_client_id == heci_hdr->me_addr)
+		&& (file_ext->state == HECI_FILE_CONNECTED)
+		&& (HECI_READ_COMPLETE != file_ext->reading_state));
+}
+
+/**
+ * heci_bh_read_client_message - bottom half read routine after ISR to
+ * handle the read heci client message data  processing.
+ *
+ * @complete_list - An instance of our list structure
+ * @dev - Device object for our driver
+ * @buffer        - message buffer will be filled
+ * @heci_hdr   - header of heci client message
+ *
+ * @return :
+ *  0 on success,
+ *  negative on failure.
+ */
+static int heci_bh_read_client_message(struct io_heci_list *complete_list,
+		struct iamt_heci_device *dev,
+		struct heci_msg_hdr *heci_hdr)
+{
+	struct heci_file_private *file_ext = NULL;
+	struct heci_cb_private *priv_cb_pos = NULL, *priv_cb_next = NULL;
+	unsigned char *buffer = NULL;
+
+	DBG("Start client msg \n");
+	if (!((dev->read_list.status == 0) &&
+	      !list_empty(&dev->read_list.heci_cb.cb_list)))
+		goto quit;
+
+	list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+			&dev->read_list.heci_cb.cb_list, cb_list) {
+		file_ext = (struct heci_file_private *)
+				priv_cb_pos->file_private;
+		if (_heci_bh_state_ok(file_ext, heci_hdr)) {
+			spin_lock(&file_ext->read_io_lock);
+			file_ext->reading_state = HECI_READING;
+			buffer = (unsigned char *)
+				(priv_cb_pos->response_buffer.data +
+				priv_cb_pos->information);
+			BUG_ON(priv_cb_pos->response_buffer.size <
+					heci_hdr->length +
+					priv_cb_pos->information);
+
+			if (priv_cb_pos->response_buffer.size <
+					heci_hdr->length +
+					priv_cb_pos->information) {
+				DBG(" message overflow.\n");
+				list_del(&priv_cb_pos->cb_list);
+				spin_unlock(&file_ext->read_io_lock);
+				return -ENOMEM;
+			}
+			if (buffer) {
+				heci_read_slots(dev, buffer,
+						heci_hdr->length);
+			}
+			priv_cb_pos->information += heci_hdr->length;
+			if (heci_hdr->msg_complete) {
+				file_ext->status = 0;
+				list_del(&priv_cb_pos->cb_list);
+				spin_unlock(&file_ext->read_io_lock);
+				DBG("completed read host client = %d,"
+					"ME client = %d, "
+					"data length = %lu\n",
+					file_ext->host_client_id,
+					file_ext->me_client_id,
+					priv_cb_pos->information);
+
+				*(priv_cb_pos->response_buffer.data +
+					priv_cb_pos->information) = '\0';
+				DBG("priv_cb_pos->res_buffer - %s\n",
+					priv_cb_pos->response_buffer.data);
+				list_add_tail(&priv_cb_pos->cb_list,
+					&complete_list->heci_cb.cb_list);
+			} else {
+				spin_unlock(&file_ext->read_io_lock);
+			}
+
+			break;
+		}
+
+	}
+
+quit:
+	DBG("Message read\n");
+	if (!buffer) {
+		heci_read_slots(dev, (unsigned char *) dev->rd_msg_buf,
+						heci_hdr->length);
+		DBG("discarding message, header=%08x.\n",
+				*(__u32 *) dev->rd_msg_buf);
+	}
+
+	return 0;
+}
+
+/**
+ * _heci_bh_legacy_read: prepare to read legacy data.
+ * @dev: device object.
+ * @slots: free slotsl.
+ * @return :
+ * 0, OK; otherwise, error.
+ */
+static int _heci_bh_legacy_read(struct iamt_heci_device *dev,	__s32 *slots)
+{
+
+	if (((*slots) * sizeof(__u32)) >= (sizeof(struct heci_msg_hdr)
+			+ sizeof(struct hbm_flow_control))) {
+		*slots -= (sizeof(struct heci_msg_hdr) +
+				sizeof(struct hbm_flow_control) + 3) / 4;
+		if (!heci_send_flow_control(dev, &dev->legacy_file_ext)) {
+			DBG("legacy flow control failed\n");
+		} else {
+			DBG("legacy flow control success\n");
+			dev->legacy_state = HECI_LEGACY_READING;
+			dev->legacy_flow_control_pending = 0;
+			dev->legacy_msg_buf_index = 0;
+			dev->legacy_msg_buf_size = 0;
+			dev->legacy_stall_timer = LEGACY_STALL_TIMER;
+			dev->host_buffer_is_empty = host_buffer_is_empty(dev);
+		}
+		return 0;
+	} else {
+		return -ECOMPLETE_MESSAGE;
+	}
+}
+
+/**
+ * _heci_bh_close: process close related operation.
+ * @dev: device object.
+ * @slots: free slotsl.
+ * @priv_cb_pos: callback block.
+ * @file_ext: file extension.
+ * @cmpl_list: complete list.
+ *
+ * @return :
+ * 0, OK; otherwise, error.
+ */
+static int _heci_bh_close(struct iamt_heci_device *dev,	__s32 *slots,
+			struct heci_cb_private *priv_cb_pos,
+			struct heci_file_private *file_ext,
+			struct io_heci_list *cmpl_list)
+{
+	if ((*slots * sizeof(__u32)) >= (sizeof(struct heci_msg_hdr) +
+			sizeof(struct hbm_client_disconnect_request))) {
+		*slots -= (sizeof(struct heci_msg_hdr) +
+			sizeof(struct hbm_client_disconnect_request) + 3) / 4;
+
+		if (!heci_disconnect(dev, file_ext)) {
+			file_ext->status = 0;
+			priv_cb_pos->information = 0;
+			list_del(&priv_cb_pos->cb_list);
+			list_add_tail(&priv_cb_pos->cb_list,
+				      &cmpl_list->heci_cb.cb_list);
+			return -ECOMPLETE_MESSAGE;
+		} else {
+			file_ext->state = HECI_FILE_DISCONNECTING;
+			file_ext->status = 0;
+			priv_cb_pos->information = 0;
+			list_del(&priv_cb_pos->cb_list);
+			list_add_tail(&priv_cb_pos->cb_list,
+			&dev->ctrl_rd_list.heci_cb.cb_list);
+			file_ext->timer_count = CONNECT_TIMEOUT;
+		}
+	} else {
+		/* return the cancel routine */
+		return -ECORRUPTED_MESSAGE_HEADER;
+	}
+
+	return 0;
+}
+
+/**
+ * _heci_hb_close: process read related operation.
+ * @dev: device object.
+ * @slots: free slotsl.
+ * @priv_cb_pos: callback block.
+ * @file_ext: file extension.
+ * @cmpl_list: complete list.
+ *
+ * @return :
+ * 0, OK; otherwise, error.
+ */
+static int _heci_bh_read(struct iamt_heci_device *dev,	__s32 *slots,
+			struct heci_cb_private *priv_cb_pos,
+			struct heci_file_private *file_ext,
+			struct io_heci_list *cmpl_list)
+{
+	if ((*slots * sizeof(__u32)) >= (sizeof(struct heci_msg_hdr) +
+			sizeof(struct hbm_flow_control))) {
+		*slots -= (sizeof(struct heci_msg_hdr) +
+			sizeof(struct hbm_flow_control) + 3) / 4;
+		if (!heci_send_flow_control(dev, file_ext)) {
+			file_ext->status = -ENODEV;
+			priv_cb_pos->information = 0;
+			list_del(&priv_cb_pos->cb_list);
+			list_add_tail(&priv_cb_pos->cb_list,
+					&cmpl_list->heci_cb.cb_list);
+			return -ENODEV;
+		} else {
+			list_del(&priv_cb_pos->cb_list);
+			list_add_tail(&priv_cb_pos->cb_list,
+					&dev->read_list.heci_cb.cb_list);
+		}
+	} else {
+		/* return the cancel routine */
+		list_del(&priv_cb_pos->cb_list);
+		return -ECORRUPTED_MESSAGE_HEADER;
+	}
+
+	return 0;
+}
+
+
+/**
+ * _heci_bh_ioctl: process ioctl related operation.
+ * @dev: device object.
+ * @slots: free slotsl.
+ * @priv_cb_pos: callback block.
+ * @file_ext: file extension.
+ * @cmpl_list: complete list.
+ *
+ * @return :
+ * 0, OK; otherwise, error.
+ */
+static int _heci_bh_ioctl(struct iamt_heci_device *dev,	__s32 *slots,
+			struct heci_cb_private *priv_cb_pos,
+			struct heci_file_private *file_ext,
+			struct io_heci_list *cmpl_list)
+{
+	if ((*slots * sizeof(__u32)) >= (sizeof(struct heci_msg_hdr) +
+			sizeof(struct hbm_client_connect_request))) {
+		file_ext->state = HECI_FILE_CONNECTING;
+		*slots -= (sizeof(struct heci_msg_hdr) +
+			sizeof(struct hbm_client_connect_request) + 3) / 4;
+		if (!heci_connect(dev, file_ext)) {
+			file_ext->status = -ENODEV;
+			priv_cb_pos->information = 0;
+			list_del(&priv_cb_pos->cb_list);
+			return -ENODEV;
+		} else {
+			list_del(&priv_cb_pos->cb_list);
+			list_add_tail(&priv_cb_pos->cb_list,
+			&dev->ctrl_rd_list.heci_cb.cb_list);
+			file_ext->timer_count = CONNECT_TIMEOUT;
+		}
+	} else {
+		/* return the cancel routine */
+		list_del(&priv_cb_pos->cb_list);
+		return -ECORRUPTED_MESSAGE_HEADER;
+	}
+
+	return 0;
+}
+
+/**
+ * _heci_bh_cmpl: process completed and no-legacy operation.
+ * @dev: device object.
+ * @slots: free slotsl.
+ * @priv_cb_pos: callback block.
+ * @file_ext: file extension.
+ * @cmpl_list: complete list.
+ *
+ * @return :
+ * 0, OK; otherwise, error.
+ */
+static int _heci_bh_cmpl(struct iamt_heci_device *dev,	__s32 *slots,
+			struct heci_cb_private *priv_cb_pos,
+			struct heci_file_private *file_ext,
+			struct io_heci_list *cmpl_list)
+{
+	struct heci_msg_hdr *heci_hdr = NULL;
+
+	if ((*slots * sizeof(__u32)) >= (sizeof(struct heci_msg_hdr) +
+			(priv_cb_pos->request_buffer.size -
+			priv_cb_pos->information))) {
+		heci_hdr = (struct heci_msg_hdr *) &dev->wr_msg_buf[0];
+		heci_hdr->host_addr = file_ext->host_client_id;
+		heci_hdr->me_addr = file_ext->me_client_id;
+		heci_hdr->length = ((priv_cb_pos->request_buffer.size) -
+				(priv_cb_pos->information));
+		heci_hdr->msg_complete = 1;
+		heci_hdr->reserved = 0;
+		DBG("priv_cb_pos->request_buffer.size =%d"
+			"heci_hdr->msg_complete= %d\n",
+				priv_cb_pos->request_buffer.size,
+				heci_hdr->msg_complete);
+		DBG("priv_cb_pos->information  =%lu\n",
+				priv_cb_pos->information);
+		DBG("heci_hdr->length  =%d\n",
+				heci_hdr->length);
+		*slots -= (sizeof(struct heci_msg_hdr) +
+				heci_hdr->length + 3) / 4;
+		if (!heci_write_message(dev, heci_hdr,
+				(unsigned char *)
+				(priv_cb_pos->request_buffer.data +
+				priv_cb_pos->information),
+				heci_hdr->length)) {
+			file_ext->status = -ENODEV;
+			list_del(&priv_cb_pos->cb_list);
+			list_add_tail(&priv_cb_pos->cb_list,
+				&cmpl_list->heci_cb.cb_list);
+			return -ENODEV;
+		} else {
+			flow_ctrl_reduce(dev, file_ext);
+			file_ext->status = 0;
+			priv_cb_pos->information += heci_hdr->length;
+			list_del(&priv_cb_pos->cb_list);
+			list_add_tail(&priv_cb_pos->cb_list,
+				&dev->write_waiting_list.heci_cb.cb_list);
+		}
+	} else if (*slots == ((dev->host_hw_state & H_CBD) >> 24)) {
+		/* buffer is still empty */
+		heci_hdr = (struct heci_msg_hdr *) &dev->wr_msg_buf[0];
+		heci_hdr->host_addr = file_ext->host_client_id;
+		heci_hdr->me_addr = file_ext->me_client_id;
+		heci_hdr->length =
+			(*slots * sizeof(__u32)) - sizeof(struct heci_msg_hdr);
+		heci_hdr->msg_complete = 0;
+		heci_hdr->reserved = 0;
+
+		(*slots) -= (sizeof(struct heci_msg_hdr) +
+				heci_hdr->length + 3) / 4;
+		if (!heci_write_message(dev, heci_hdr,
+					(unsigned char *)
+					(priv_cb_pos->request_buffer.data +
+					priv_cb_pos->information),
+					heci_hdr->length)) {
+			file_ext->status = -ENODEV;
+			list_del(&priv_cb_pos->cb_list);
+			list_add_tail(&priv_cb_pos->cb_list,
+				&cmpl_list->heci_cb.cb_list);
+			return -ENODEV;
+		} else {
+			priv_cb_pos->information += heci_hdr->length;
+			DBG("priv_cb_pos->request_buffer.size =%d"
+					" heci_hdr->msg_complete= %d\n",
+					priv_cb_pos->request_buffer.size,
+					heci_hdr->msg_complete);
+			DBG("priv_cb_pos->information  =%lu\n",
+					priv_cb_pos->information);
+			DBG("heci_hdr->length  =%d\n", heci_hdr->length);
+		}
+		return -ECOMPLETE_MESSAGE;
+	} else {
+		return -ECORRUPTED_MESSAGE_HEADER;
+	}
+
+	return 0;
+}
+
+/**
+ * _heci_bh_cmpl_legacy: process completed legacy operation.
+ * @dev: device object.
+ * @slots: free slotsl.
+ * @priv_cb_pos: callback block.
+ * @file_ext: file extension.
+ * @cmpl_list: complete list.
+ *
+ * @return :
+ * 0, OK; otherwise, error.
+ */
+static int _heci_bh_cmpl_legacy(struct iamt_heci_device *dev, __s32 *slots,
+			struct heci_cb_private *priv_cb_pos,
+			struct heci_file_private *file_ext,
+			struct io_heci_list *cmpl_list)
+{
+	struct heci_msg_hdr *heci_hdr = NULL;
+
+	if ((*slots * sizeof(__u32)) >= (sizeof(struct heci_msg_hdr) +
+			dev->legacy_msg_buf_size -
+			dev->legacy_msg_buf_index)) {
+		heci_hdr = (struct heci_msg_hdr *) &dev->wr_msg_buf[0];
+		heci_hdr->host_addr = file_ext->host_client_id;
+		heci_hdr->me_addr = file_ext->me_client_id;
+		heci_hdr->length = dev->legacy_msg_buf_size -
+			dev->legacy_msg_buf_index;
+		heci_hdr->msg_complete = 1;
+		heci_hdr->reserved = 0;
+
+		*slots -= (sizeof(struct heci_msg_hdr) +
+				heci_hdr->length + 3) / 4;
+
+		if (!heci_write_message(dev, heci_hdr,
+					(dev->legacy_msg_buf +
+					dev->legacy_msg_buf_index),
+					heci_hdr->length)) {
+			dev->legacy_state = HECI_LEGACY_IDLE;
+			file_ext->status = -ENODEV;
+			list_del(&priv_cb_pos->cb_list);
+			return -ENODEV;
+		} else {
+			flow_ctrl_reduce(dev, file_ext);
+			dev->legacy_msg_buf_index += heci_hdr->length;
+			list_del(&priv_cb_pos->cb_list);
+			priv_cb_pos->information = dev->legacy_msg_buf_index;
+			file_ext->status = 0;
+			dev->legacy_state = HECI_LEGACY_FLOW_CONTROL;
+			dev->legacy_flow_control_pending = 1;
+			/* save legacy cb sent to pthi client */
+			dev->legacy_current_cb = priv_cb_pos;
+			list_add_tail(&priv_cb_pos->cb_list,
+				&dev->write_waiting_list.heci_cb.cb_list);
+
+		}
+	} else if (*slots == ((dev->host_hw_state & H_CBD) >> 24)) {
+			/* buffer is still empty */
+		heci_hdr = (struct heci_msg_hdr *) &dev->wr_msg_buf[0];
+		heci_hdr->host_addr = file_ext->host_client_id;
+		heci_hdr->me_addr = file_ext->me_client_id;
+		heci_hdr->length =
+			(*slots * sizeof(__u32)) - sizeof(struct heci_msg_hdr);
+		heci_hdr->msg_complete = 0;
+		heci_hdr->reserved = 0;
+
+		*slots -= (sizeof(struct heci_msg_hdr) +
+				heci_hdr->length + 3) / 4;
+
+		if (!heci_write_message(dev, heci_hdr,
+					(dev->legacy_msg_buf +
+					dev->legacy_msg_buf_index),
+					heci_hdr->length)) {
+			file_ext->status = -ENODEV;
+			list_del(&priv_cb_pos->cb_list);
+		} else {
+			dev->legacy_msg_buf_index += heci_hdr->length;
+		}
+		return -ECOMPLETE_MESSAGE;
+	} else {
+		return -ECORRUPTED_MESSAGE_HEADER;
+	}
+
+	return 0;
+}
+
+/**
+ * heci_bh_write_handler - bottom half write routine after
+ * ISR to handle the write processing.
+ *
+ * @complete_list - An instance of our list structure
+ * @dev - Device object for our driver
+ * @slots         - slots to write.
+ * @return :
+ *  0 on success,
+ *  negative on failure.
+ */
+static int heci_bh_write_handler(struct io_heci_list *cmpl_list,
+		struct iamt_heci_device *dev,
+		__s32 *slots)
+{
+
+	struct heci_file_private *file_ext = NULL;
+	struct heci_cb_private *priv_cb_pos = NULL, *priv_cb_next = NULL;
+	struct io_heci_list *list;
+	int ret;
+
+	if (!host_buffer_is_empty(dev)) {
+		DBG("host buffer is not empty.\n");
+		return 0;
+	}
+	dev->write_hang = -1;
+	*slots = count_empty_write_slots(dev);
+	/* complete all waiting for write CB */
+	DBG("complete all waiting for write CB.\n");
+
+	list = &dev->write_waiting_list;
+	if (list->status == 0
+	    && !list_empty(&list->heci_cb.cb_list)) {
+		list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+				&list->heci_cb.cb_list, cb_list) {
+			file_ext =	(struct heci_file_private *)
+					priv_cb_pos->file_private;
+			file_ext->status = 0;
+			list_del(&priv_cb_pos->cb_list);
+			if (HECI_WRITING == file_ext->writing_state &&
+				(priv_cb_pos->major_file_operations ==
+					HECI_WRITING) &&
+				file_ext != &dev->legacy_file_ext) {
+				DBG("HECI WRITE COMPLETE\n");
+				file_ext->writing_state = HECI_WRITE_COMPLETE;
+				list_add_tail(&priv_cb_pos->cb_list,
+					      &cmpl_list->heci_cb.cb_list);
+			}
+			if (file_ext == &dev->legacy_file_ext) {
+				DBG("check legacy flow control\n");
+				if (dev->legacy_flow_control_pending) {
+					ret = _heci_bh_legacy_read(dev, slots);
+					if (ret != 0)
+						return ret;
+				}
+			}
+
+		}
+	}
+
+	if (dev->stop && !dev->wd_pending) {
+		dev->wd_stoped = 1;
+		wake_up_interruptible(&dev->wait_stop_wd);
+		return 0;
+	}
+
+	if (dev->extra_write_index != 0) {
+		DBG("extra_write_index =%d\n",	dev->extra_write_index);
+		heci_write_message(dev,
+				(struct heci_msg_hdr *) &dev->ext_msg_buf[0],
+				(unsigned char *) &dev->ext_msg_buf[1],
+				(dev->extra_write_index - 1) * sizeof(__u32));
+		*slots -= dev->extra_write_index;
+		dev->extra_write_index = 0;
+	}
+	if (dev->heci_state == HECI_ENABLED) {
+		if (dev->wd_pending
+		    && flow_ctrl_creds(dev, &dev->wd_file_ext)) {
+			if (!heci_send_wd(dev))
+				DBG("Wd send failed\n");
+			else
+				flow_ctrl_reduce(dev, &dev->wd_file_ext);
+
+			dev->wd_pending = 0;
+
+			if (dev->wd_timeout != 0) {
+				*slots -= (sizeof(struct heci_msg_hdr) +
+					 HECI_START_WD_DATA_SIZE + 3) / 4;
+				dev->wd_due_counter = 2;
+			} else {
+				*slots -= (sizeof(struct heci_msg_hdr) +
+					 HECI_WD_PARAMS_SIZE + 3) / 4;
+				dev->wd_due_counter = 0;
+			}
+
+		}
+	}
+	if (dev->stop)
+		return ~ENODEV;
+
+	/* complete control write list CB */
+	if (dev->ctrl_wr_list.status == 0) {
+		/* complete control write list CB */
+		DBG("complete control write list CB\n ");
+		list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+				&dev->ctrl_wr_list.heci_cb.cb_list, cb_list) {
+			file_ext = (struct heci_file_private *)
+				priv_cb_pos->file_private;
+			if (!file_ext) {
+				list_del(&priv_cb_pos->cb_list);
+				return -ENODEV;
+			}
+			switch (priv_cb_pos->major_file_operations) {
+			case HECI_CLOSE:
+				/* send disconnect message */
+				ret = _heci_bh_close(dev, slots,
+						     priv_cb_pos,
+						     file_ext, cmpl_list);
+				if (ret != 0)
+					return ret;
+
+				break;
+			case HECI_READ:
+				/* send flow control message */
+				ret = _heci_bh_read(dev, slots,
+						    priv_cb_pos,
+						    file_ext, cmpl_list);
+				if (ret != 0)
+					return ret;
+
+				break;
+			case HECI_IOCTL:
+				/* connect message */
+				if (!other_client_is_connecting(dev, file_ext))
+					continue;
+				ret = _heci_bh_ioctl(dev, slots,
+						     priv_cb_pos,
+						     file_ext, cmpl_list);
+				if (ret != 0)
+					return ret;
+
+				break;
+
+			default:
+				BUG_ON(1);
+			}
+
+		}
+	}
+	/* complete  write list CB */
+	if (dev->write_list.status == 0
+	    && !list_empty(&dev->write_list.heci_cb.cb_list)) {
+		DBG("complete write list CB \n");
+		list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+				&dev->write_list.heci_cb.cb_list, cb_list) {
+			file_ext = (struct heci_file_private *)
+					priv_cb_pos->file_private;
+
+			if ((file_ext != NULL) &&
+			    (file_ext != &dev->legacy_file_ext)) {
+				if (!flow_ctrl_creds(dev, file_ext)) {
+					DBG("No flow control credentials"
+					    "for client %d, not sending\n",
+					    file_ext->host_client_id);
+					continue;
+				}
+				ret = _heci_bh_cmpl(dev, slots,
+						    priv_cb_pos,
+						    file_ext, cmpl_list);
+				if (ret != 0)
+					return ret;
+
+			} else if (file_ext == &dev->legacy_file_ext) {
+				/* LEGACY IOCTL */
+				DBG("complete pthi write cb\n");
+				if (!flow_ctrl_creds(dev, file_ext)) {
+					DBG("No flow control credentials"
+					    "for pthi client %d\n",
+					    file_ext->host_client_id);
+					continue;
+				}
+				ret = _heci_bh_cmpl_legacy(dev, slots,
+							   priv_cb_pos,
+							   file_ext,
+							   cmpl_list);
+				if (ret != 0)
+					return ret;
+
+			}
+
+		}
+	}
+	return 0;
+}
+
+
+/**
+ * is_treat_specially_client  - check if the message belong
+ * to the file extension .
+ * @file_ext -extension of the file object
+ * @connect_res    -connect response bus message
+ * @dev -Device object for our driver
+ *
+ * @return :
+ * 1 if empty
+ * 0 - otherwise.
+ */
+static int is_treat_specially_client(struct heci_file_private *file_ext,
+		struct hbm_client_connect_response *rs)
+{
+	int ret = 0;
+
+	if ((file_ext->host_client_id == rs->host_addr) &&
+	    (file_ext->me_client_id == rs->me_addr)) {
+		if (rs->status == 0) {
+			DBG("client connect status = 0x%08x.\n", rs->status);
+			file_ext->state = HECI_FILE_CONNECTED;
+			file_ext->status = 0;
+		} else {
+			DBG("client connect status = 0x%08x.\n", rs->status);
+			file_ext->state = HECI_FILE_DISCONNECTED;
+			file_ext->status = -ENODEV;
+		}
+		ret = 1;
+	}
+	DBG("client state = %d.\n", file_ext->state);
+	return ret;
+}
+
+/**
+ * heci_client_connect_response  - connect response bh routine
+ *
+ * @dev -Device object for our driver
+ * @connect_res    -connect response bus message
+ * @complete_list - An instance of our list structure
+ *
+ * @return :
+ * none;
+ */
+static void heci_client_connect_response(struct iamt_heci_device *dev,
+		struct hbm_client_connect_response *rs)
+{
+
+	struct heci_file_private *file_ext = NULL;
+	struct heci_cb_private *priv_cb_pos = NULL, *priv_cb_next = NULL;
+
+	/* if WD or legacy client treat specially */
+
+	if ((is_treat_specially_client(&(dev->wd_file_ext), rs)) ||
+	    (is_treat_specially_client(&(dev->legacy_file_ext), rs)))
+		return;
+
+	if (dev->ctrl_rd_list.status == 0
+	    && !list_empty(&dev->ctrl_rd_list.heci_cb.cb_list)) {
+		list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+			&dev->ctrl_rd_list.heci_cb.cb_list, cb_list) {
+			file_ext = (struct heci_file_private *)
+					priv_cb_pos->file_private;
+			if (!file_ext) {
+				list_del(&priv_cb_pos->cb_list);
+				return;
+			}
+			if (HECI_IOCTL == priv_cb_pos->major_file_operations) {
+				if (is_treat_specially_client(file_ext, rs)) {
+					list_del(&priv_cb_pos->cb_list);
+					file_ext->status = 0;
+					file_ext->timer_count = 0;
+					break;
+				}
+			}
+		}
+	}
+}
+
+/**
+ * heci_client_disconnect_response  - disconnect response bh routine
+ *
+ * @dev -Device object for our driver
+ * @disconnect_res    -disconnect response bus message
+ * @complete_list - An instance of our list structure
+ *
+ * @return :
+ * none;
+ */
+static void heci_client_disconnect_response(struct iamt_heci_device *dev,
+					struct hbm_client_connect_response *rs)
+{
+	struct heci_file_private *file_ext = NULL;
+	struct heci_cb_private *priv_cb_pos = NULL, *priv_cb_next = NULL;
+
+	if (dev->ctrl_rd_list.status == 0
+	    && !list_empty(&dev->ctrl_rd_list.heci_cb.cb_list)) {
+		list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+				&dev->ctrl_rd_list.heci_cb.cb_list, cb_list) {
+			file_ext = (struct heci_file_private *)
+				priv_cb_pos->file_private;
+
+			if (!file_ext) {
+				list_del(&priv_cb_pos->cb_list);
+				return;
+			}
+
+			DBG("list_for_each_entry_safe in ctrl_rd_list.\n");
+			if ((file_ext->host_client_id == rs->host_addr) &&
+				(file_ext->me_client_id == rs->me_addr)) {
+
+				list_del(&priv_cb_pos->cb_list);
+				if (rs->status == 0) {
+					file_ext->state =
+					    HECI_FILE_DISCONNECTED;
+				}
+
+				file_ext->status = 0;
+				file_ext->timer_count = 0;
+				break;
+			}
+		}
+	}
+}
+
+/**
+ * same_flow_addr: tell they have same address.
+ * @file: file extension.
+ * @flow: flow control.
+ * @return :
+ * 1, same; 0,not.
+ */
+static int same_flow_addr(struct heci_file_private *file,
+					struct hbm_flow_control *flow)
+{
+	if ((file->host_client_id == flow->host_addr)
+	    && (file->me_client_id == flow->me_addr))
+		return 1;
+
+	return 0;
+}
+
+/**
+ * add_single_flow_creds: add single buffer credentials.
+ * @file: file extension.
+ * @flow: flow control.
+ * @return :
+ * none.
+ */
+static void add_single_flow_creds(struct iamt_heci_device *dev,
+				  struct hbm_flow_control *flow)
+{
+	struct heci_me_client *client = NULL;
+	int i;
+
+	for (i = 0; i < dev->num_heci_me_clients; i++) {
+		client = &dev->me_clients[i];
+		if (flow->me_addr == client->client_id) {
+			if (client->props.single_recv_buf != 0) {
+				client->flow_ctrl_creds++;
+				DBG("rece flow ctrl msg ME %d (single).\n",
+				    flow->me_addr);
+				DBG("flow control credentials=%d.\n",
+				    client->flow_ctrl_creds);
+			} else {
+				BUG_ON(1);	/* error in flow control */
+			}
+		}
+	}
+}
+/**
+ * heci_client_flow_control_response  - flow control response bh routine
+ *
+ * @dev -Device object for our driver
+ * @flow_control    -flow control response bus message
+ *
+ * @return :
+ * none;
+ */
+static void heci_client_flow_control_response(struct iamt_heci_device *dev,
+		struct hbm_flow_control *flow_control)
+{
+	struct heci_file_private *file_pos = NULL;
+	struct heci_file_private *file_next = NULL;
+
+	if (flow_control->host_addr == 0) {
+		/* single receive buffer */
+		add_single_flow_creds(dev, flow_control);
+	} else {
+		/* normal connection */
+		list_for_each_entry_safe(file_pos, file_next,
+				&dev->file_list, link) {
+			DBG("list_for_each_entry_safe in file_list\n");
+
+			DBG("file_ext  of host client %d ME client %d.\n",
+			    file_pos->host_client_id,
+			    file_pos->me_client_id);
+			DBG("flow ctrl msg for host %d ME %d.\n",
+			    flow_control->host_addr,
+			    flow_control->me_addr);
+			if (same_flow_addr(file_pos, flow_control)) {
+				DBG("recv ctrl msg for host  %d ME %d.\n",
+				    flow_control->host_addr,
+				    flow_control->me_addr);
+				file_pos->flow_ctrl_creds++;
+				DBG("flow control credentials=%d.\n",
+				    file_pos->flow_ctrl_creds);
+				break;
+			}
+		}
+	}
+}
+
+/**
+ * same_disconn_addr: tell they have same address
+ * @file: file extension
+ * @disconn: disconnection request.
+ * @return :
+ * 1, same; 0,not.
+ */
+static int same_disconn_addr(struct heci_file_private *file,
+			     struct hbm_client_disconnect_request *disconn)
+{
+	if ((file->host_client_id == disconn->host_addr)
+	    && (file->me_client_id == disconn->me_addr))
+		return 1;
+
+	return 0;
+}
+
+/**
+ * heci_client_disconnect_request  - disconnect request bh routine
+ *
+ * @dev -Device object for our driver
+ * @disconnect_req    -disconnect request bus message
+ *
+ * @return :
+ * none;
+ */
+static void heci_client_disconnect_request(struct iamt_heci_device *dev,
+		struct hbm_client_disconnect_request *disconnect_req)
+{
+	struct heci_msg_hdr *heci_hdr;
+	struct hbm_client_connect_response *disconnect_res;
+	struct heci_file_private *file_pos = NULL;
+	struct heci_file_private *file_next = NULL;
+
+	list_for_each_entry_safe(file_pos, file_next, &dev->file_list, link) {
+		if (same_disconn_addr(file_pos, disconnect_req)) {
+			DBG("disconn request host client %d ME client %d.\n",
+					disconnect_req->host_addr,
+					disconnect_req->me_addr);
+			file_pos->state = HECI_FILE_DISCONNECTED;
+			file_pos->timer_count = 0;
+			if (file_pos == &dev->wd_file_ext) {
+				dev->wd_due_counter = 0;
+				dev->wd_pending = 0;
+			} else if (file_pos == &dev->legacy_file_ext)
+				dev->legacy_timer = 0;
+
+			/* prepare disconnect response */
+			heci_hdr =
+				(struct heci_msg_hdr *) &dev->ext_msg_buf[0];
+			heci_hdr->host_addr = 0;
+			heci_hdr->me_addr = 0;
+			heci_hdr->length =
+				sizeof(struct hbm_client_connect_response);
+			heci_hdr->msg_complete = 1;
+			heci_hdr->reserved = 0;
+
+			disconnect_res =
+				(struct hbm_client_connect_response *)
+				&dev->ext_msg_buf[1];
+			disconnect_res->host_addr = file_pos->host_client_id;
+			disconnect_res->me_addr = file_pos->me_client_id;
+			*(__u8 *) (&disconnect_res->cmd) =
+				CLIENT_DISCONNECT_RES_CMD;
+			disconnect_res->status = 0;
+			dev->extra_write_index = 2;
+			break;
+		}
+	}
+}
+
+
+/**
+ * free_legacy: free legacy related memory
+ * @dev: heci device
+ *
+ * @return :
+ * none;
+ */
+static void free_legacy(struct iamt_heci_device *dev)
+{
+	kfree(dev->legacy_current_cb->request_buffer.data);
+	dev->legacy_current_cb->request_buffer.data = NULL;
+	kfree(dev->legacy_current_cb->response_buffer.data);
+	dev->legacy_current_cb->response_buffer.data = NULL;
+	kfree(dev->legacy_current_cb);
+}
+
+/**
+ * heci_timer - timer function .
+ * @data: pointer to the device structure
+ *
+ * NOTE: This function is called by timer interrupt work
+ * @return :
+ * none;
+ */
+void heci_wd_timer(unsigned long data)
+{
+	struct iamt_heci_device *dev = (struct iamt_heci_device *) data;
+
+	DBG("send watchdog.\n");
+	spin_lock_bh(&dev->device_lock);
+	if (dev->heci_state != HECI_ENABLED) {
+		mod_timer(&dev->wd_timer, round_jiffies(jiffies + 2 * HZ));
+		spin_unlock_bh(&dev->device_lock);
+		return;
+	}
+	if (dev->wd_file_ext.state != HECI_FILE_CONNECTED) {
+		mod_timer(&dev->wd_timer, round_jiffies(jiffies + 2 * HZ));
+		spin_unlock_bh(&dev->device_lock);
+		return;
+	}
+	/*** Watchdog ***/
+	if ((dev->wd_due_counter != 0) && (dev->wd_bypass == 0)) {
+		if (--dev->wd_due_counter == 0) {
+			if (dev->host_buffer_is_empty &&
+			    flow_ctrl_creds(dev, &dev->wd_file_ext)) {
+				dev->host_buffer_is_empty = 0;
+				if (!heci_send_wd(dev)) {
+					DBG("Wd send failed\n");
+				} else {
+					flow_ctrl_reduce(dev,
+							 &dev->wd_file_ext);
+				}
+
+				if (dev->wd_timeout != 0)
+					dev->wd_due_counter = 2;
+				else
+					dev->wd_due_counter = 0;
+
+			} else
+				dev->wd_pending = 1;
+
+		}
+	}
+	if (dev->legacy_stall_timer != 0) {
+		if (--dev->legacy_stall_timer == 0) {
+			DBG("Reseting because of hang to PTHI\n");
+			heci_reset(dev, 1);
+			dev->legacy_msg_buf_size = 0;
+			dev->legacy_msg_buf_index = 0;
+			dev->legacy_canceled = 0;
+			dev->legacy_ioctl = 1;
+			dev->legacy_state = HECI_LEGACY_IDLE;
+			dev->legacy_timer = 0;
+			spin_unlock_bh(&dev->device_lock);
+
+			if (dev->legacy_current_cb)
+				free_legacy(dev);
+
+			spin_lock_bh(&dev->device_lock);
+			dev->legacy_file_object = NULL;
+			dev->legacy_current_cb = NULL;
+			run_next_legacy_cmd(dev);
+		}
+	}
+	mod_timer(&dev->wd_timer, round_jiffies(jiffies + 2 * HZ));
+	spin_unlock_bh(&dev->device_lock);
+}
diff --git a/drivers/char/heci/io_heci.c b/drivers/char/heci/io_heci.c
new file mode 100644
index 0000000..3ff13dd
--- /dev/null
+++ b/drivers/char/heci/io_heci.c
@@ -0,0 +1,1138 @@
+/*
+ * Part of Intel(R) Manageability Engine Interface Linux driver
+ *
+ * Copyright (c) 2003 - 2007 Intel Corp.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/fcntl.h>
+#include <linux/aio.h>
+#include <linux/pci.h>
+#include <linux/reboot.h>
+#include <linux/poll.h>
+#include <linux/init.h>
+#include <linux/kdev_t.h>
+#include <linux/ioctl.h>
+#include <linux/cdev.h>
+#include <linux/list.h>
+#include <linux/unistd.h>
+#include <linux/delay.h>
+#include <linux/uaccess.h>
+
+#include "heci_data_structures.h"
+#include "heci.h"
+#include "heci_interface.h"
+#include "heci_version.h"
+
+
+/**
+ * heci_ioctl_get_version - the get driver version IOCTL function
+ * @dev -Device object for our driver
+ * @if_num  minor number
+ * @*u_msg pointer to user data struct in user space
+ * @k_msg data in kernel on the stack
+ * @file_ext -extension of the file object
+ *
+ * @return :
+ *  0 on success,
+ *  negative on failure.
+ */
+int heci_ioctl_get_version(struct iamt_heci_device *dev, int if_num,
+			   struct heci_message_data *u_msg,
+			   struct heci_message_data k_msg,
+			   struct heci_file_private *file_ext)
+{
+
+	int rets = 0;
+	struct heci_driver_version *version;
+	struct heci_message_data res_msg;
+	res_msg.data = NULL;
+
+	if ((if_num != HECI_MINOR_NUMBER) || (!dev)
+	    || (!file_ext))
+		return -ENODEV;
+
+	if (k_msg.size < (sizeof(struct heci_driver_version) - 2)) {
+		DBG("user buffer less than heci_driver_version.\n");
+		return -EMSGSIZE;
+	}
+
+	res_msg.data = kmalloc(sizeof(struct heci_driver_version), GFP_KERNEL);
+	if (!res_msg.data) {
+		DBG("failed allocation response buffer size = %d.\n",
+		    (int) sizeof(struct heci_driver_version));
+		return -ENOMEM;
+	}
+
+	version = (struct heci_driver_version *) res_msg.data;
+	version->major = MAJOR_VERSION;
+	version->minor = MINOR_VERSION;
+	version->hotfix = QUICK_FIX_NUMBER;
+	if (k_msg.size < sizeof(struct heci_driver_version)) {
+		res_msg.size = sizeof(struct heci_driver_version) - 2;
+	} else {
+		version->build = VER_BUILD;
+		res_msg.size = sizeof(struct heci_driver_version);
+	}
+	rets = file_ext->status;
+	/* now copy the data to user space */
+	if (copy_to_user(k_msg.data, res_msg.data, res_msg.size)) {
+		rets = -EFAULT;
+		goto end;
+	}
+	if (put_user(res_msg.size, &u_msg->size)) {
+		rets = -EFAULT;
+		goto end;
+	}
+end:
+	kfree(res_msg.data);
+	return rets;
+}
+
+/**
+ * heci_ioctl_connect_client - the connect to fw client IOCTL function
+ * @dev -Device object for our driver
+ * @if_num  minor number
+ * @*u_msg pointer to user data struct in user space
+ * @k_msg data in kernel on the stack
+ * @file_ext -extension of the file object
+ *
+ * @return :
+ *  0 on success,
+ *  negative on failure.
+ */
+int heci_ioctl_connect_client(struct iamt_heci_device *dev, int if_num,
+			      struct heci_message_data *u_msg,
+			      struct heci_message_data k_msg,
+			      struct file *file)
+{
+
+	int rets = 0;
+	struct heci_message_data req_msg, res_msg;
+	struct heci_cb_private *priv_cb = NULL;
+	struct heci_client *client;
+	struct heci_file_private *file_ext = NULL;
+	struct heci_file_private *file_pos = NULL;
+	struct heci_file_private *file_next = NULL;
+	struct heci_file_private *file_ext_temp = NULL;
+
+	struct heci_cb_private *priv_cb_pos = NULL;
+	struct heci_cb_private *priv_cb_next = NULL;
+	long timeout = 15;	/*15 second */
+	__u8 i;
+	int err = 0;
+	res_msg.data = NULL;
+	req_msg.data = NULL;
+
+	if ((if_num != HECI_MINOR_NUMBER) || (!dev) || (!file))
+		return -ENODEV;
+
+	file_ext = file->private_data;
+	if (!file_ext)
+		return -ENODEV;
+
+	if (k_msg.size != sizeof(struct guid)) {
+		DBG("user buffer size is not equal to size of struct "
+				"guid(16).\n");
+		return -EMSGSIZE;
+	}
+
+	req_msg.data = kmalloc(sizeof(struct guid), GFP_KERNEL);
+	res_msg.data = kmalloc(sizeof(struct heci_client), GFP_KERNEL);
+
+	if (!res_msg.data) {
+		DBG("failed allocation response buffer size = %d.\n",
+		    (int) sizeof(struct heci_client));
+		kfree(req_msg.data);
+		req_msg.data = NULL;
+		return -ENOMEM;
+	}
+	if (!req_msg.data) {
+		DBG("failed allocation request buffer size = %d.\n",
+		    (int) sizeof(struct guid));
+		kfree(res_msg.data);
+		res_msg.data = NULL;
+		return -ENOMEM;
+	}
+	req_msg.size = sizeof(struct guid);
+	res_msg.size = sizeof(struct heci_client);
+	if (!k_msg.data) {
+		rets = -EIO;
+		goto end;
+	}
+
+	/* copy the message to kernel space -
+	 * use a pointer already copied into kernel space
+	 */
+	if (copy_from_user(req_msg.data, k_msg.data, k_msg.size)) {
+		rets = -EFAULT;
+		goto end;
+	}
+	/* buffered ioctl cb */
+	priv_cb = kmalloc(sizeof(struct heci_cb_private), GFP_KERNEL);
+	if (!priv_cb) {
+		rets = -ENOMEM;
+		goto end;
+	}
+	INIT_LIST_HEAD(&priv_cb->cb_list);
+	priv_cb->response_buffer.data = res_msg.data;
+	priv_cb->response_buffer.size = res_msg.size;
+	priv_cb->request_buffer.data = req_msg.data;
+	priv_cb->request_buffer.size = req_msg.size;
+	priv_cb->major_file_operations = HECI_IOCTL;
+	spin_lock_bh(&dev->device_lock);
+	if (dev->heci_state != HECI_ENABLED) {
+		rets = -ENODEV;
+		spin_unlock_bh(&dev->device_lock);
+		goto end;
+	}
+	if ((file_ext->state != HECI_FILE_INITIALIZING) &&
+	    (file_ext->state != HECI_FILE_DISCONNECTED)) {
+		rets = -EBUSY;
+		spin_unlock_bh(&dev->device_lock);
+		goto end;
+	}
+
+	/* find ME client we're trying to connect to */
+	for (i = 0; i < dev->num_heci_me_clients; i++) {
+		if (memcmp((struct guid *)req_msg.data,
+			    &dev->me_clients[i].props.protocol_name,
+			    sizeof(struct guid)) == 0) {
+			if (dev->me_clients[i].props.fixed_address == 0) {
+				file_ext->me_client_id =
+				    dev->me_clients[i].client_id;
+				file_ext->state = HECI_FILE_CONNECTING;
+			}
+			break;
+		}
+	}
+	/* if we're connecting to PTHI client so we will use the exist
+	 * connection
+	 */
+	if (memcmp((struct guid *)req_msg.data, &heci_pthi_guid,
+				sizeof(struct guid)) == 0) {
+		if (dev->legacy_file_ext.state != HECI_FILE_CONNECTED) {
+			rets = -ENODEV;
+			spin_unlock_bh(&dev->device_lock);
+			goto end;
+		}
+		dev->heci_host_clients[file_ext->host_client_id / 8] &=
+			~(1 << (file_ext->host_client_id % 8));
+		list_for_each_entry_safe(file_pos,
+		    file_next, &dev->file_list, link) {
+			if (heci_fe_same_id(file_ext, file_pos)) {
+				DBG("remove file extension node host"
+				    " client = %d, ME client = %d\n",
+				    file_pos->host_client_id,
+				    file_pos->me_client_id);
+				list_del(&file_pos->link);
+			}
+
+		}
+		DBG("free file extension memory\n");
+		kfree(file_ext);
+		file_ext = NULL;
+		file->private_data = &dev->legacy_file_ext;
+		client = (struct heci_client *) res_msg.data;
+		client->max_msg_length =
+			dev->me_clients[i].props.max_msg_length;
+		client->protocol_version =
+			dev->me_clients[i].props.protocol_version;
+		rets = dev->legacy_file_ext.status;
+		spin_unlock_bh(&dev->device_lock);
+
+		/* now copy the data to user space */
+		if (copy_to_user(k_msg.data, res_msg.data, res_msg.size)) {
+			rets = -EFAULT;
+			goto end;
+		}
+		if (put_user(res_msg.size, &u_msg->size)) {
+			rets = -EFAULT;
+			goto end;
+		}
+		goto end;
+	}
+	spin_lock(&file_ext->file_lock);
+	if (file_ext->state != HECI_FILE_CONNECTING) {
+		rets = -ENODEV;
+		spin_unlock(&file_ext->file_lock);
+		spin_unlock_bh(&dev->device_lock);
+		goto end;
+	}
+	spin_unlock(&file_ext->file_lock);
+	/* prepare the output buffer */
+	client = (struct heci_client *) res_msg.data;
+	client->max_msg_length = dev->me_clients[i].props.max_msg_length;
+	client->protocol_version = dev->me_clients[i].props.protocol_version;
+	if (dev->host_buffer_is_empty
+	    && !other_client_is_connecting(dev, file_ext)) {
+		dev->host_buffer_is_empty = 0;
+		if (!heci_connect(dev, file_ext)) {
+			rets = -ENODEV;
+			spin_unlock_bh(&dev->device_lock);
+			goto end;
+		} else {
+			file_ext->timer_count = CONNECT_TIMEOUT;
+			priv_cb->file_private = file_ext;
+			list_add_tail(&priv_cb->cb_list,
+				      &dev->ctrl_rd_list.heci_cb.
+				      cb_list);
+		}
+
+
+	} else {
+		priv_cb->file_private = file_ext;
+		DBG("add connect cb to control write list\n");
+		list_add_tail(&priv_cb->cb_list,
+			      &dev->ctrl_wr_list.heci_cb.cb_list);
+	}
+	spin_unlock_bh(&dev->device_lock);
+	err = wait_event_timeout(dev->wait_recvd_msg,
+			(HECI_FILE_CONNECTED == file_ext->state
+			 || HECI_FILE_DISCONNECTED == file_ext->state),
+			timeout * HZ);
+
+	if (HECI_FILE_CONNECTED == file_ext->state) {
+		DBG("successfully to connect to FW client.\n");
+		rets = file_ext->status;
+		/* now copy the data to user space */
+		if (copy_to_user(k_msg.data, res_msg.data, res_msg.size)) {
+			rets = -EFAULT;
+			goto end;
+		}
+		if (put_user(res_msg.size, &u_msg->size)) {
+			rets = -EFAULT;
+			goto end;
+		}
+		goto end;
+	} else {
+		DBG("failed to connect to FW client.file_ext->state = %d\n",
+		    file_ext->state);
+		if (!err) {
+			DBG("wait_event_interruptible_timeout failed on client"
+			    " connect message fw response message\n");
+		}
+		rets = -EFAULT;
+		goto remove_list;
+	}
+
+remove_list:
+	if (priv_cb) {
+		spin_lock_bh(&dev->device_lock);
+		if (dev->ctrl_rd_list.status == 0 &&
+		    !list_empty(&dev->ctrl_rd_list.heci_cb.cb_list)) {
+			list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+			    &dev->ctrl_rd_list.heci_cb.cb_list, cb_list) {
+				file_ext_temp =
+					(struct heci_file_private *)
+						priv_cb_pos->file_private;
+				if (file_ext_temp) {
+					if (heci_fe_same_id(file_ext,
+							    file_ext_temp))
+						list_del(&priv_cb_pos->cb_list);
+
+				}
+
+			}
+		}
+		if (dev->ctrl_wr_list.status == 0 &&
+		    !list_empty(&dev->ctrl_wr_list.heci_cb.cb_list)) {
+			list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+			    &dev->ctrl_wr_list.heci_cb.cb_list, cb_list) {
+				file_ext_temp =
+					(struct heci_file_private *)
+						priv_cb_pos->file_private;
+				if (file_ext_temp) {
+					if (heci_fe_same_id(file_ext,
+							    file_ext_temp))
+						list_del(&priv_cb_pos->cb_list);
+
+				}
+
+			}
+		}
+		spin_unlock_bh(&dev->device_lock);
+	}
+end:
+	DBG("free connect cb memory");
+	kfree(req_msg.data);
+	req_msg.data = NULL;
+	kfree(res_msg.data);
+	res_msg.data = NULL;
+	kfree(priv_cb);
+	priv_cb = NULL;
+	return rets;
+}
+
+/**
+ * heci_ioctl_wd  - the wd IOCTL function
+ * @dev -Device object for our driver
+ * @if_num  minor number
+ * @k_msg data in kernel on the stack
+ * @file_ext -extension of the file object
+ *
+ * @return :
+ *  0 on success,
+ *  negative on failure.
+ */
+int heci_ioctl_wd(struct iamt_heci_device *dev, int if_num,
+		  struct heci_message_data k_msg,
+		  struct heci_file_private *file_ext)
+{
+	int rets = 0;
+	struct heci_message_data req_msg;	/*in kernel on the stack */
+
+	if (if_num != HECI_MINOR_NUMBER)
+		return -ENODEV;
+
+	spin_lock(&file_ext->file_lock);
+	if (k_msg.size != HECI_WATCHDOG_DATA_SIZE) {
+		DBG("User buffer has invalid size.\n");
+		spin_unlock(&file_ext->file_lock);
+		return -EMSGSIZE;
+	}
+	spin_unlock(&file_ext->file_lock);
+
+	req_msg.data = kmalloc(HECI_WATCHDOG_DATA_SIZE, GFP_KERNEL);
+	if (!req_msg.data) {
+		DBG("failed allocation request buffer size = %d.\n",
+		    HECI_WATCHDOG_DATA_SIZE);
+		return -ENOMEM;
+	}
+	req_msg.size = HECI_WATCHDOG_DATA_SIZE;
+
+	/* copy the message to kernel space - use a pointer already
+	 * copied into kernel space
+	 */
+	if (copy_from_user(req_msg.data, k_msg.data, req_msg.size)) {
+		rets = -EFAULT;
+		goto end;
+	}
+	spin_lock_bh(&dev->device_lock);
+	if (dev->heci_state != HECI_ENABLED) {
+		rets = -ENODEV;
+		spin_unlock_bh(&dev->device_lock);
+		goto end;
+	}
+
+	if (dev->wd_file_ext.state != HECI_FILE_CONNECTED) {
+		rets = -ENODEV;
+		spin_unlock_bh(&dev->device_lock);
+		goto end;
+	}
+	if (!dev->asf_mode) {
+		rets = -EIO;
+		spin_unlock_bh(&dev->device_lock);
+		goto end;
+	}
+
+	memcpy(&dev->wd_data[HECI_WD_PARAMS_SIZE], req_msg.data,
+	       HECI_WATCHDOG_DATA_SIZE);
+
+	dev->wd_timeout = (req_msg.data[1] << 8) + req_msg.data[0];
+	if (dev->wd_timeout == 0) {
+		memcpy(dev->wd_data, &stop_wd_params,
+		       HECI_WD_PARAMS_SIZE);
+		dev->wd_pending = 0;
+		dev->wd_due_counter = 1;	/* next timer */
+	} else {
+		memcpy(dev->wd_data, &start_wd_params,
+		       HECI_WD_PARAMS_SIZE);
+		dev->wd_pending = 0;
+		dev->wd_due_counter = 1;
+		mod_timer(&dev->wd_timer, jiffies);
+	}
+	spin_unlock_bh(&dev->device_lock);
+end:
+	kfree(req_msg.data);
+	req_msg.data = NULL;
+	return rets;
+}
+
+
+/**
+ * heci_ioctl_bypass_wd  - the bypass_wd IOCTL function
+ * @dev -Device object for our driver
+ * @if_num  minor number
+ * @k_msg data in kernel on the stack
+ * @file_ext -extension of the file object
+ *
+ * @return :
+ *  0 on success,
+ *  negative on failure.
+ */
+int heci_ioctl_bypass_wd(struct iamt_heci_device *dev, int if_num,
+		  struct heci_message_data k_msg,
+		  struct heci_file_private *file_ext)
+{
+	__u8 flag = 0;
+	int rets = 0;
+
+	if (if_num != HECI_MINOR_NUMBER)
+		return -ENODEV;
+
+	spin_lock(&file_ext->file_lock);
+	if (k_msg.size < 1) {
+		DBG("user buffer less than HECI_WATCHDOG_DATA_SIZE .\n");
+		spin_unlock(&file_ext->file_lock);
+		return -EMSGSIZE;
+	}
+	spin_unlock(&file_ext->file_lock);
+	if (copy_from_user(&flag, k_msg.data, 1)) {
+		rets = -EFAULT;
+		goto end;
+	}
+
+	spin_lock_bh(&dev->device_lock);
+	flag = flag ?(1):(0);
+	dev->wd_bypass = flag;
+	spin_unlock_bh(&dev->device_lock);
+end:
+	return rets;
+}
+
+
+/**
+ * legacy_ioctl_send_msg - send cmd data to pthi client
+ * @dev -Device object for our driver
+ * @if_num  minor number
+ * @*u_msg pointer to user data struct in user space
+ * @k_msg data in kernel on the stack
+ * @file_ext -extension of the file object
+ *
+ * @return :
+ *  0 on success,
+ *  negative on failure.
+ */
+int legacy_ioctl_send_msg(struct iamt_heci_device *dev, int if_num,
+			      struct heci_message_data k_msg,
+			      struct file *file)
+{
+
+	int rets = 0;
+	struct heci_message_data req_msg, res_msg; /*in kernel on the stack */
+	struct heci_cb_private *priv_cb = NULL;
+	struct heci_file_private *file_ext = file->private_data;
+	__u8 i;
+	req_msg.data = NULL;
+	res_msg.data = NULL;
+
+	if ((if_num != LEGACY_MINOR_NUMBER) || (!dev))
+		return -ENODEV;
+
+	if (!file_ext)
+		return -ENODEV;
+
+	spin_lock_bh(&dev->device_lock);
+	for (i = 0; i < dev->num_heci_me_clients; i++) {
+		if (dev->me_clients[i].client_id ==
+		    dev->legacy_file_ext.me_client_id)
+			break;
+	}
+
+	BUG_ON(dev->me_clients[i].client_id != file_ext->me_client_id);
+	if ((i == dev->num_heci_me_clients) ||
+	    (dev->me_clients[i].client_id
+		!= dev->legacy_file_ext.me_client_id)) {
+		spin_unlock_bh(&dev->device_lock);
+		return -ENODEV;
+	} else if ((k_msg.size > dev->me_clients[i].props.max_msg_length)
+		    || (k_msg.size <= 0)) {
+		spin_unlock_bh(&dev->device_lock);
+		return -EMSGSIZE;
+	}
+
+
+	spin_unlock_bh(&dev->device_lock);
+	req_msg.data = kmalloc(k_msg.size, GFP_KERNEL);
+	res_msg.data = kmalloc(LEGACY_MTU, GFP_KERNEL);
+
+	if (!res_msg.data) {
+		DBG("failed allocation response buffer size = %d.\n",
+		    (int) sizeof(struct heci_client));
+		kfree(req_msg.data);
+		req_msg.data = NULL;
+		return -ENOMEM;
+	}
+	if (!req_msg.data) {
+		DBG("failed allocation request buffer size = %d.\n",
+		    (int) sizeof(struct guid));
+		kfree(res_msg.data);
+		res_msg.data = NULL;
+		return -ENOMEM;
+	}
+	req_msg.size = k_msg.size;
+	res_msg.size = LEGACY_MTU;
+	if (!k_msg.data) {
+		rets = -EIO;
+		goto end;
+	}
+
+	/* copy the message to kernel space - use a pointer already
+	 * copied into kernel space
+	 */
+	if (copy_from_user(req_msg.data, k_msg.data, k_msg.size)) {
+		rets = -EFAULT;
+		goto end;
+	}
+	/* buffered ioctl cb */
+	priv_cb = kmalloc(sizeof(struct heci_cb_private), GFP_KERNEL);
+	if (!priv_cb) {
+		rets = -ENOMEM;
+		goto end;
+	}
+	INIT_LIST_HEAD(&priv_cb->cb_list);
+
+	priv_cb->request_buffer.data = req_msg.data;
+	priv_cb->request_buffer.size = req_msg.size;
+	priv_cb->response_buffer.data = res_msg.data;
+	priv_cb->response_buffer.size = res_msg.size;
+	priv_cb->major_file_operations = HECI_IOCTL;
+	priv_cb->information = 0;
+	priv_cb->file_object = file;
+	priv_cb->file_private = file_ext;
+	spin_lock_bh(&dev->device_lock);
+
+	if (dev->heci_state != HECI_ENABLED) {
+		rets = -ENODEV;
+		spin_unlock_bh(&dev->device_lock);
+		goto end;
+	}
+	if (dev->legacy_file_ext.state != HECI_FILE_CONNECTED) {
+		rets = -ENODEV;
+		spin_unlock_bh(&dev->device_lock);
+		goto end;
+	}
+
+
+	if (!list_empty(&dev->pthi_cmd_list.heci_cb.cb_list) ||
+	    (dev->legacy_state != HECI_LEGACY_IDLE)) {
+		DBG("pthi_state = %d\n", (int) dev->legacy_state);
+		DBG("add PTHI cb to pthi cmd waiting list");
+		list_add_tail(&priv_cb->cb_list,
+			      &dev->pthi_cmd_list.heci_cb.cb_list);
+
+	} else {
+		DBG("call pthi write\n");
+		rets = pthi_write(dev, priv_cb);
+
+		if (rets != 0) {
+			DBG("pthi write failed with status = %d\n", rets);
+			spin_unlock_bh(&dev->device_lock);
+			goto end;
+		}
+	}
+	spin_unlock_bh(&dev->device_lock);
+	return rets;
+end:
+	kfree(req_msg.data);
+	req_msg.data = NULL;
+	kfree(res_msg.data);
+	res_msg.data = NULL;
+	kfree(priv_cb);
+	priv_cb = NULL;
+	return rets;
+}
+
+
+/**
+ * legacy_ioctl_recv_msg - receive  cmd data from pthi client
+ * @dev -Device object for our driver
+ * @if_num  minor number
+ * @*u_msg pointer to user data struct in user space
+ * @k_msg data in kernel on the stack
+ * @file_ext -extension of the file object
+ *
+ * @return :
+ *  0 on success,
+ *  negative on failure.
+ */
+int legacy_ioctl_recv_msg(struct iamt_heci_device *dev, int if_num,
+				 struct heci_message_data *u_msg,
+				 struct heci_message_data k_msg,
+				 struct file *file)
+{
+	int rets = 0;
+	struct heci_message_data req_msg, res_msg;
+	struct heci_cb_private *priv_cb = NULL;
+	struct heci_file_private *file_ext = file->private_data;
+	__u8 i;
+	struct heci_file_private *file_ext_list_temp = NULL;
+	struct heci_cb_private *priv_cb_pos = NULL;
+	struct heci_cb_private *priv_cb_next = NULL;
+
+	res_msg.data = NULL;
+	req_msg.data = NULL;
+
+	if ((if_num != LEGACY_MINOR_NUMBER) || (!dev))
+		return -ENODEV;
+
+	spin_lock_bh(&dev->device_lock);
+	if (!file_ext) {
+		spin_unlock_bh(&dev->device_lock);
+		return -ENODEV;
+	}
+	for (i = 0; i < dev->num_heci_me_clients; i++) {
+		if (dev->me_clients[i].client_id ==
+		    dev->legacy_file_ext.me_client_id)
+			break;
+	}
+
+	BUG_ON(dev->me_clients[i].client_id != file_ext->me_client_id);
+	if ((i == dev->num_heci_me_clients)
+	    || (dev->me_clients[i].client_id
+	       != dev->legacy_file_ext.me_client_id)) {
+		spin_unlock_bh(&dev->device_lock);
+		return -ENODEV;
+	}
+
+	if (dev->pthi_read_complete_list.status == 0) {
+		list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+		    &dev->pthi_read_complete_list.heci_cb.cb_list, cb_list) {
+			file_ext_list_temp = (struct heci_file_private *)
+			    priv_cb_pos->file_private;
+			if (file_ext_list_temp) {
+				if ((file_ext == &dev->legacy_file_ext) &&
+				    (priv_cb_pos->file_object == file)) {
+					list_del(&priv_cb_pos->cb_list);
+					priv_cb = priv_cb_pos;
+					break;
+				}
+			}
+
+		}
+	}
+	if (!priv_cb) {
+		spin_unlock_bh(&dev->device_lock);
+		return -EAGAIN;
+	}
+
+
+	res_msg.data = priv_cb->response_buffer.data;
+	res_msg.size = priv_cb->response_buffer.size;
+	req_msg.data = priv_cb->request_buffer.data;
+	req_msg.size = priv_cb->request_buffer.size;
+	DBG("pthi priv_cb->response_buffer size - %d\n",
+	    priv_cb->response_buffer.size);
+	DBG("pthi priv_cb->information - %lu\n",
+	    priv_cb->information);
+	spin_unlock_bh(&dev->device_lock);
+
+	if (res_msg.size < priv_cb->information) {
+		rets = -EMSGSIZE;
+		goto end;
+	}
+	/* now copy the data to user space */
+	if (copy_to_user(k_msg.data, res_msg.data, priv_cb->information)) {
+		rets = -EFAULT;
+		goto end;
+	}
+	if (put_user(priv_cb->information, &u_msg->size)) {
+		rets = -EFAULT;
+		goto end;
+	}
+end:
+	kfree(req_msg.data);
+	kfree(res_msg.data);
+	kfree(priv_cb);
+	return rets;
+}
+
+/**
+ * find_pthi_read_list_entry - finds a PTHIlist entry for current file
+ * @dev -Device object for our driver
+ *
+ * @return :
+ *  returned a list entry on success,
+ *  NULL on failure.
+ */
+struct heci_cb_private *find_pthi_read_list_entry(
+		struct iamt_heci_device *dev,
+		struct file *file,
+		struct heci_file_private *file_ext)
+{
+	struct heci_file_private *file_ext_temp = NULL;
+	struct heci_cb_private *priv_cb_pos = NULL;
+	struct heci_cb_private *priv_cb_next = NULL;
+
+	if (dev->pthi_read_complete_list.status == 0 &&
+	    !list_empty(&dev->pthi_read_complete_list.heci_cb.cb_list)) {
+		list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+		    &dev->pthi_read_complete_list.heci_cb.cb_list, cb_list) {
+			file_ext_temp = (struct heci_file_private *)
+				priv_cb_pos->file_private;
+			if (file_ext_temp) {
+				if ((file_ext == &dev->legacy_file_ext) &&
+				    (priv_cb_pos->file_object == file))
+					return priv_cb_pos;
+
+			}
+		}
+	}
+	return NULL;
+}
+/**
+ * pthi_read - read data from pthi client
+ * @dev -Device object for our driver
+ * @if_num  minor number
+ * @*u_msg pointer to user data in user space
+ * @length-user data length
+ *
+ * @return :
+ *  returned data length on success,
+ *  zero if no data to read,
+ *  negative on failure.
+ */
+int pthi_read(struct iamt_heci_device *dev, int if_num, struct file *file,
+	      char *ubuf, size_t length, loff_t *offset)
+{
+
+	int rets = 0;
+	struct heci_cb_private *priv_cb = NULL;
+	struct heci_file_private *file_ext = file->private_data;
+	__u8 i;
+	unsigned long currtime = get_seconds();
+
+	if ((if_num != HECI_MINOR_NUMBER) || (!dev))
+		return -ENODEV;
+
+	if (!file_ext)
+		return -ENODEV;
+
+	spin_lock_bh(&dev->device_lock);
+	for (i = 0; i < dev->num_heci_me_clients; i++) {
+		if (dev->me_clients[i].client_id ==
+		    dev->legacy_file_ext.me_client_id)
+			break;
+	}
+	BUG_ON(dev->me_clients[i].client_id != file_ext->me_client_id);
+	if ((i == dev->num_heci_me_clients)
+	    || (dev->me_clients[i].client_id !=
+		dev->legacy_file_ext.me_client_id)) {
+		DBG("PTHI client not found\n");
+		spin_unlock_bh(&dev->device_lock);
+		return -ENODEV;
+	}
+	priv_cb = find_pthi_read_list_entry(dev, file, file_ext);
+	if (!priv_cb) {
+		spin_unlock_bh(&dev->device_lock);
+		return 0; /* No more data to read */
+	} else {
+		if (priv_cb &&
+		    (currtime - priv_cb->read_time > LEGACY_READ_TIMER)) {
+			/* 15 sec for the message has expired */
+			list_del(&priv_cb->cb_list);
+			spin_unlock_bh(&dev->device_lock);
+			rets = -ETIMEDOUT;
+			goto free;
+		}
+		/* if the whole message will fit remove it from the list */
+		if ((priv_cb->information >= *offset)  &&
+		    (length >= (priv_cb->information - *offset)))
+			list_del(&priv_cb->cb_list);
+		else if ((priv_cb->information > 0) &&
+		    (priv_cb->information <= *offset)) {
+			/* end of the message has been reached */
+			list_del(&priv_cb->cb_list);
+			rets = 0;
+			spin_unlock_bh(&dev->device_lock);
+			goto free;
+		}
+		/* else means that not full buffer will be read and do not
+		 * remove message from deletion list
+		 */
+	}
+	DBG("pthi priv_cb->response_buffer size - %d\n",
+	    priv_cb->response_buffer.size);
+	DBG("pthi priv_cb->information - %lu\n",
+	    priv_cb->information);
+	spin_unlock_bh(&dev->device_lock);
+
+	/* length is being turncated to PAGE_SIZE, however,
+	 * the information may be longer */
+	length = length < (priv_cb->information - *offset) ?
+			length : (priv_cb->information - *offset);
+
+	if (copy_to_user(ubuf,
+			 priv_cb->response_buffer.data + *offset,
+			 length))
+		rets = -EFAULT;
+	else {
+		rets = length;
+		if ((*offset + length) < priv_cb->information) {
+			*offset += length;
+			goto out;
+		}
+	}
+	DBG("free pthi cb memory\n");
+free:
+	*offset = 0;
+	kfree(priv_cb->request_buffer.data);
+	kfree(priv_cb->response_buffer.data);
+	kfree(priv_cb);
+out:
+	return rets;
+}
+
+/**
+ * heci_start_read  - the start read client message function.
+ * @dev -Device object for our driver
+ * @if_num  minor number
+ * @file_ext -extension of the file object
+ *
+ * @return :
+ *  0 on success,
+ *  negative on failure.
+ */
+int heci_start_read(struct iamt_heci_device *dev, int if_num,
+		    struct heci_file_private *file_ext)
+{
+	int rets = 0;
+	__u8 i;
+	struct heci_cb_private *priv_cb = NULL;
+
+	if ((if_num != HECI_MINOR_NUMBER) || (!dev) || (!file_ext)) {
+		DBG("receive wrong function input param\n.");
+		return -ENODEV;
+	}
+	if (file_ext->state != HECI_FILE_CONNECTED)
+		return -ENODEV;
+
+	spin_lock_bh(&dev->device_lock);
+	if (dev->heci_state != HECI_ENABLED) {
+		spin_unlock_bh(&dev->device_lock);
+		return -ENODEV;
+	}
+	spin_unlock_bh(&dev->device_lock);
+	DBG("check if read is pending\n");
+	if ((file_ext->read_pending) || (file_ext->read_cb != NULL)) {
+		DBG("read is pending");
+		return -EBUSY;
+	}
+	priv_cb = kmalloc(sizeof(struct heci_cb_private), GFP_KERNEL);
+	if (!priv_cb)
+		return -ENOMEM;
+
+	DBG("allocation call back success\n");
+	DBG("host client = %d, ME client = %d\n",
+	    file_ext->host_client_id, file_ext->me_client_id);
+	spin_lock_bh(&dev->device_lock);
+	for (i = 0; i < dev->num_heci_me_clients; i++) {
+		if (dev->me_clients[i].client_id == file_ext->me_client_id)
+			break;
+
+	}
+
+	BUG_ON(dev->me_clients[i].client_id != file_ext->me_client_id);
+	if ((i == dev->num_heci_me_clients)) {
+		rets = -ENODEV;
+		goto unlock;
+	}
+
+	priv_cb->response_buffer.size = dev->me_clients[i].props.max_msg_length;
+	spin_unlock_bh(&dev->device_lock);
+	priv_cb->response_buffer.data =
+	    kmalloc(priv_cb->response_buffer.size, GFP_KERNEL);
+	if (!priv_cb->response_buffer.data) {
+		rets = -ENOMEM;
+		goto fail;
+	}
+	DBG("allocation call back data success\n");
+	priv_cb->major_file_operations = HECI_READ;
+	/* make sure information is zero before we start */
+	priv_cb->information = 0;
+	priv_cb->file_private = (void *) file_ext;
+	file_ext->read_cb = priv_cb;
+	spin_lock_bh(&dev->device_lock);
+	if (dev->host_buffer_is_empty) {
+		dev->host_buffer_is_empty = 0;
+		if (!heci_send_flow_control(dev, file_ext)) {
+			rets = -ENODEV;
+			goto unlock;
+		} else {
+			list_add_tail(&priv_cb->cb_list,
+				      &dev->read_list.heci_cb.cb_list);
+		}
+	} else {
+		list_add_tail(&priv_cb->cb_list,
+			      &dev->ctrl_wr_list.heci_cb.cb_list);
+	}
+	spin_unlock_bh(&dev->device_lock);
+	return rets;
+unlock:
+	spin_unlock_bh(&dev->device_lock);
+fail:
+	kfree(priv_cb->response_buffer.data);
+	priv_cb->response_buffer.data = NULL;
+	priv_cb->file_private = NULL;
+	kfree(priv_cb);
+	return rets;
+}
+
+/**
+ * pthi_write - write legacy data to pthi client
+ * @dev -Device object for our driver
+ * @priv_cb - heci call back struct
+ * @return :
+ *  0 on success,
+ *  negative on failure.
+ */
+int pthi_write(struct iamt_heci_device *dev,
+	       struct heci_cb_private *priv_cb)
+{
+	int rets = 0;
+	struct heci_msg_hdr heci_hdr;
+
+	if ((!dev) || (!priv_cb))
+		return -ENODEV;
+
+	DBG("write data to pthi client\n");
+
+	dev->legacy_state = HECI_LEGACY_WRITING;
+	dev->legacy_current_cb = priv_cb;
+	dev->legacy_file_object = priv_cb->file_object;
+	dev->legacy_canceled = 0;
+	dev->legacy_ioctl = 1;
+	dev->legacy_msg_buf_size = priv_cb->request_buffer.size;
+	memcpy(dev->legacy_msg_buf, priv_cb->request_buffer.data,
+	    priv_cb->request_buffer.size);
+
+	if (flow_ctrl_creds(dev, &dev->legacy_file_ext) &&
+	    dev->host_buffer_is_empty) {
+		dev->host_buffer_is_empty = 0;
+		if (priv_cb->request_buffer.size >
+		    (((dev->host_hw_state & H_CBD) >> 24) *
+		    sizeof(__u32)) - sizeof(struct heci_msg_hdr)) {
+			heci_hdr.length =
+			    (((dev->host_hw_state & H_CBD) >> 24) *
+			    sizeof(__u32)) - sizeof(struct heci_msg_hdr);
+			heci_hdr.msg_complete = 0;
+		} else {
+			heci_hdr.length = priv_cb->request_buffer.size;
+			heci_hdr.msg_complete = 1;
+		}
+
+		heci_hdr.host_addr = dev->legacy_file_ext.host_client_id;
+		heci_hdr.me_addr = dev->legacy_file_ext.me_client_id;
+		heci_hdr.reserved = 0;
+		dev->legacy_msg_buf_index += heci_hdr.length;
+		if (!heci_write_message(dev, &heci_hdr,
+					(unsigned char *) (dev->legacy_msg_buf),
+					heci_hdr.length))
+			return -ENODEV;
+
+		if (heci_hdr.msg_complete) {
+			flow_ctrl_reduce(dev, &dev->legacy_file_ext);
+			dev->legacy_flow_control_pending = 1;
+			dev->legacy_state = HECI_LEGACY_FLOW_CONTROL;
+			DBG("add pthi cb to write waiting list\n");
+			dev->legacy_current_cb = priv_cb;
+			dev->legacy_file_object = priv_cb->file_object;
+			list_add_tail(&priv_cb->cb_list,
+				      &dev->write_waiting_list.heci_cb.cb_list);
+		} else {
+			DBG("message does not complete, "
+					"so add pthi cb to write list\n");
+			list_add_tail(&priv_cb->cb_list,
+				      &dev->write_list.heci_cb.cb_list);
+		}
+	} else {
+		if (!(dev->host_buffer_is_empty))
+			DBG("host buffer is not empty");
+
+		DBG("No flow control credentials, "
+				"so add legacy cb to write list\n");
+		list_add_tail(&priv_cb->cb_list,
+			      &dev->write_list.heci_cb.cb_list);
+	}
+	return rets;
+}
+
+/**
+ * legacy_ioctl_send_msg - send cmd data to pthi client
+ * @dev -Device object for our driver
+ * @return :
+ *  0 on success,
+ *  negative on failure.
+ */
+void run_next_legacy_cmd(struct iamt_heci_device *dev)
+{
+	struct heci_file_private *file_ext_tmp = NULL;
+	struct heci_cb_private *priv_cb_pos = NULL;
+	struct heci_cb_private *priv_cb_next = NULL;
+	int status = 0;
+
+	if (!dev)
+		return;
+
+	dev->legacy_msg_buf_size = 0;
+	dev->legacy_msg_buf_index = 0;
+	dev->legacy_canceled = 0;
+	dev->legacy_ioctl = 1;
+	dev->legacy_state = HECI_LEGACY_IDLE;
+	dev->legacy_timer = 0;
+	dev->legacy_file_object = NULL;
+
+	if (dev->pthi_cmd_list.status == 0 &&
+	    !list_empty(&dev->pthi_cmd_list.heci_cb.cb_list)) {
+		DBG("complete pthi cmd_list CB\n ");
+
+		list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+		    &dev->pthi_cmd_list.heci_cb.cb_list, cb_list) {
+			list_del(&priv_cb_pos->cb_list);
+			file_ext_tmp = (struct heci_file_private *)
+					priv_cb_pos->file_private;
+
+			if ((file_ext_tmp) &&
+			    (file_ext_tmp == &dev->legacy_file_ext)) {
+				status = pthi_write(dev, priv_cb_pos);
+				if (status != 0) {
+					DBG("pthi write failed status = %d\n",
+							status);
+					return;
+				}
+				break;
+			}
+		}
+	}
+}
