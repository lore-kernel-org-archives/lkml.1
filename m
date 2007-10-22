Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbXJVXK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbXJVXK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 19:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbXJVXKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 19:10:19 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:56665 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbXJVXKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 19:10:17 -0400
From: thomas.mingarelli@hp.com
To: linux-kernel@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, thomas.mingarelli@hp.com
Message-Id: <20071022180711.5246.49013.sendpatchset@tmingo.cca.cpqcorp.net>
Subject: [HP ProLiant WatchDog driver] hpwdt HP WatchDog Patch <resend>
Date: Mon, 22 Oct 2007 19:09:51 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hp is providing a Hardware WatchDog Timer driver that will only work with the
specific HW Timer located in the HP ProLiant iLO 2 ASIC. The iLO 2 HW Timer
will generate a Non-maskable Interrupt (NMI) 9 seconds before physically
resetting the server, by removing power, so that the event can be logged to
the HP Integrated Management Log (IML), a Non-Volatile Random Access Memory
(NVRAM). The logging of the event is performed using the HP ProLiant ROM via
an Industry Standard access known as a BIOS Service Directory Entry.

Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>

--- linux-2.6.23.1/drivers/char/watchdog/Makefile.orig	2007-10-12 11:43:44.000000000 -0500
+++ linux-2.6.23.1/drivers/char/watchdog/Makefile	2007-10-15 07:56:31.000000000 -0500
@@ -118,3 +118,10 @@
 
 # Architecture Independant
 obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o
+
+#
+# Makefile for the hp WatchDog driver.
+#
+CFLAGS_hpwdt.o += -O
+obj-$(CONFIG_HP_WATCHDOG) += hpwdt.o
+
--- linux-2.6.23.1/drivers/char/watchdog/Kconfig.orig	2007-10-12 11:43:44.000000000 -0500
+++ linux-2.6.23.1/drivers/char/watchdog/Kconfig	2007-10-15 07:57:27.000000000 -0500
@@ -55,6 +55,19 @@
 	  To compile this driver as a module, choose M here: the
 	  module will be called softdog.
 
+config HP_WATCHDOG
+        tristate "Hewlett-Packard watchdog"
+        depends on WATCHDOG && X86
+        help
+          A software monitoring watchdog and NMI sourcing driver. This driver
+          will detect lockups and provide stack trace. Also, when an NMI
+          occurs this driver will make the necessary BIOS calls to log
+          the cause of the NMI. This is a driver that will only load on a
+          HP ProLiant system with a minimum of iLO2 support.
+          To compile this driver as a module, choose M here: the
+          module will be called hpwdt.
+
+
 # ALPHA Architecture
 
 # ARM Architecture
--- linux-2.6.23.1/drivers/char/watchdog/hpwdt.c.orig	2007-10-15 07:53:12.000000000 -0500
+++ linux-2.6.23.1/drivers/char/watchdog/hpwdt.c	2007-10-22 11:53:06.000000000 -0500
@@ -1 +1,878 @@
+/*
+ *   HP WatchDog Driver
+ *   based on
+ *
+ *   SoftDog	0.05:	A Software Watchdog Device
+ *
+ *   (c) Copyright 2007 Hewlett-Packard Development Company, L.P.
+ *   Thomas Mingarelli <thomas.mingarelli@hp.com>
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   version 2 as published by the Free Software Foundation
+ *
+ */
 
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/kdebug.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/notifier.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/reboot.h>
+#include <linux/sched.h>
+#include <linux/timer.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/watchdog.h>
+#include <asm/desc.h>
+
+#define PCI_BIOS32_SD_VALUE		0x5F32335F
+#define CRU_BIOS_SIGNATURE_VALUE	0x55524324
+#define PCI_BIOS32_PARAGRAPH_LEN	16
+#define PCI_ROM_BASE1			0x000F0000
+#define ROM_SIZE			0x0FFFF
+
+struct bios32_service_dir {
+	u32 signature;
+	u32 entry_point;
+	u8 revision;
+	u8 length;
+	u8 checksum;
+	u8 reserved[5];
+};
+
+
+/*
+ * smbios_entry_point     - defines SMBIOS entry point structure
+ *
+ * anchor_string[4]       - anchor string (_SM_)
+ * check_sum              - checksum of the entry point structure
+ * length                 - length of the entry point structure
+ * major_ver              - major version (02h for revision 2.1)
+ * minor_ver              - minor version (01h for revision 2.1)
+ * max_struct_size        - size of the largest SMBIOS structure
+ * revision               - entry point structure revision implemented
+ * reserved[5]            - reserved
+ * intermediate_anchor[5] - intermediate anchor string (_DM_)
+ * intermediate_check_sum - intermediate checksum
+ * table_length           - structure table length
+ * table_address          - structure table address
+ * number_structs         - number of structures present
+ * bcd_revision           - BCD revision
+ */
+struct smbios_entry_point {
+	u8 anchor_string[4];
+	u8 check_sum;
+	u8 length;
+	u8 major_ver;
+	u8 minor_ver;
+	u16 max_struct_size;
+	u8 revision;
+	u8 reserved[5];
+	u8 intermediate_anchor[5];
+	u8 intermediate_check_sum;
+	u16 table_length;
+	u64 table_address;
+	u16 number_structs;
+	u8 bcd_revision;
+};
+
+
+/* type 212 */
+struct smbios_cru64_info {
+	u8 type;
+	u8 byte_length;
+	u16 handle;
+	u32 signature;
+	u64 physical_address;
+	u32 double_length;
+	u32 double_offset;
+};
+
+struct smbios_header {
+	u8 byte_type;
+	u8 byte_length;
+	u16 handle;
+};
+
+struct cmn_registers {
+	union {
+		struct {
+			u8 ral;
+			u8 rah;
+			u16 rea2;
+		};
+		u32 reax;
+	} u1;
+	union {
+		struct {
+			u8 rbl;
+			u8 rbh;
+			u8 reb2l;
+			u8 reb2h;
+		};
+		u32 rebx;
+	} u2;
+	union {
+		struct {
+			u8 rcl;
+			u8 rch;
+			u16 rec2;
+		};
+		u32 recx;
+	} u3;
+	union {
+		struct {
+			u8 rdl;
+			u8 rdh;
+			u16 red2;
+		};
+		u32 redx;
+	} u4;
+
+	u32 resi;
+	u32 redi;
+	u16 rds;
+	u16 res;
+	u32 reflags;
+}  __attribute__((packed));
+
+#define SMBIOS_CRU64_INFORMATION              212
+
+static unsigned int soft_margin = 2;	/* in minutes */
+static unsigned long __iomem *hpwdt_timer_reg;
+static unsigned long __iomem *hpwdt_timer_con;
+static unsigned int reload;
+static unsigned int new_margin;
+static u16 tbl_len;
+static u64 tbl_addr;
+static int die_reg;
+static int pci_enable;
+
+static DEFINE_SPINLOCK(rom_lock);
+
+static void *gpVirtRomCRUAddr;
+static void *gpBios32Map;
+static unsigned char *gpBios32EntryPoint;
+static void *p_mem_addr;
+
+static struct cmn_registers cmn_regs;
+
+static struct pci_device_id hpwdt_devices[] = {
+	{
+	 .vendor = PCI_VENDOR_ID_COMPAQ,
+	 .device = 0xB203,
+	 .subvendor = PCI_ANY_ID,
+	 .subdevice = PCI_ANY_ID,
+	},
+	{0},			/* terminate list */
+};
+
+MODULE_DEVICE_TABLE(pci, hpwdt_devices);
+
+asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
+			       unsigned long *pRomEntry)
+{
+#ifdef CONFIG_X86_64
+	asm("pushq      %rbp            \n\t"
+	    "movq       %rsp, %rbp      \n\t"
+	    "pushq      %rax            \n\t"
+	    "pushq      %rbx            \n\t"
+	    "pushq      %rdx            \n\t"
+	    "pushq      %r12            \n\t"
+	    "pushq      %r9             \n\t"
+	    "movq       %rsi, %r12      \n\t"
+	    "movq       %rdi, %r9       \n\t"
+	    "movl       4(%r9),%ebx     \n\t"
+	    "movl       8(%r9),%ecx     \n\t"
+	    "movl       12(%r9),%edx    \n\t"
+	    "movl       16(%r9),%esi    \n\t"
+	    "movl       20(%r9),%edi    \n\t"
+	    "movl       (%r9),%eax      \n\t"
+	    "call       *%r12           \n\t"
+	    "pushfq                     \n\t"
+	    "popq        %r12           \n\t"
+	    "popfq                      \n\t"
+	    "movl       %eax, (%r9)     \n\t"
+	    "movl       %ebx, 4(%r9)    \n\t"
+	    "movl       %ecx, 8(%r9)    \n\t"
+	    "movl       %edx, 12(%r9)   \n\t"
+	    "movl       %esi, 16(%r9)   \n\t"
+	    "movl       %edi, 20(%r9)   \n\t"
+	    "movq       %r12, %rax      \n\t"
+	    "movl       %eax, 28(%r9)   \n\t"
+	    "popq       %r9             \n\t"
+	    "popq       %r12            \n\t"
+	    "popq       %rdx            \n\t"
+	    "popq       %rbx            \n\t"
+	    "popq       %rax            \n\t"
+	    "leave                      \n\t" "ret");
+#endif
+
+#ifdef CONFIG_X86_32
+	asm("pushl       %ebp               \n\t"
+	    "movl        %esp, %ebp         \n\t"
+	    "pusha                          \n\t"
+	    "pushf                          \n\t"
+	    "push        %es                \n\t"
+	    "push        %ds                \n\t"
+	    "pop         %es                \n\t"
+	    "movl        8(%ebp),%eax       \n\t"
+	    "movl        4(%eax),%ebx       \n\t"
+	    "movl        8(%eax),%ecx       \n\t"
+	    "movl        12(%eax),%edx      \n\t"
+	    "movl        16(%eax),%esi      \n\t"
+	    "movl        20(%eax),%edi      \n\t"
+	    "movl        (%eax),%eax        \n\t"
+	    "push        %cs                \n\t"
+	    "call        *12(%ebp)          \n\t"
+	    "pushf                          \n\t"
+	    "pushl       %eax               \n\t"
+	    "movl        8(%ebp),%eax       \n\t"
+	    "movl        %ebx,4(%eax)       \n\t"
+	    "movl        %ecx,8(%eax)       \n\t"
+	    "movl        %edx,12(%eax)      \n\t"
+	    "movl        %esi,16(%eax)      \n\t"
+	    "movl        %edi,20(%eax)      \n\t"
+	    "movw        %ds,24(%eax)       \n\t"
+	    "movw        %es,26(%eax)       \n\t"
+	    "popl        %ebx               \n\t"
+	    "movl        %ebx,(%eax)        \n\t"
+	    "popl        %ebx               \n\t"
+	    "movl        %ebx,28(%eax)      \n\t"
+	    "pop         %es                \n\t"
+	    "popf                           \n\t"
+	    "popa                           \n\t"
+	    "leave                          \n\t" "ret");
+#endif
+}
+
+/*
+ *	smbios_get_record
+ *
+ *	Routine Description:
+ *    	This function will get the next record in the SMB Tables
+ *
+ *	Return Value:
+ *     	1        :  SUCCESS - if record found
+ *     	0        :  FAILURE - if record not found
+ */
+int smbios_get_record(unsigned char **pp_record, void *smbios_table_ptr)
+{
+	unsigned char *buffer;
+	struct smbios_header *header_ptr;
+
+	/*
+	 * if pp_record is NULL, find the first record
+	 */
+	if (*pp_record == 0) {
+		*pp_record = smbios_table_ptr;
+		buffer = smbios_table_ptr;
+	} else {
+		header_ptr = (struct smbios_header *) * pp_record;
+		buffer = *pp_record;
+
+		/*
+		 * skip over the structure itself
+		 */
+		*pp_record += header_ptr->byte_length;
+
+		buffer += header_ptr->byte_length;
+
+		/*
+		 * skip over any strings following the structure
+		 */
+		while (*buffer || *(buffer + 1))
+			buffer++;
+
+		/*
+		 * skip over the double NULL characters
+		 */
+		buffer += 2;
+	}
+	if (buffer >= ((unsigned char *)smbios_table_ptr + tbl_len))
+		return 0;
+
+	*pp_record = buffer;
+	return 1;
+}
+
+/*
+ *	smbios_get_record_by_type
+ *
+ *	Routine Description:
+ *	This function will get a record in the SMB Table by the type specified
+ *
+ *	Return Value:
+ *     	1        :  SUCCESS - if record found
+ *     	0        :  FAILURE - if record not found
+ */
+int smbios_get_record_by_type(unsigned char type, unsigned short copy,
+			      void **pp_record, void *smbios_table_ptr)
+{
+	unsigned char *save_state_ptr = NULL;
+	struct smbios_header *header_ptr;
+
+	while (smbios_get_record(&save_state_ptr, smbios_table_ptr)) {
+		header_ptr = (struct smbios_header *) save_state_ptr;
+		if (header_ptr->byte_type == type) {
+			if (copy == 0) {
+				*pp_record = (void *)save_state_ptr;
+				return 1;
+			} else
+				copy--;
+		}
+	}
+	return 0;
+}
+
+/*
+ *	smbios_get_64bit_cru_info
+ *
+ *	Routine Description:
+ *	This routine will collect the 64bit CRU entry point from SMBIOS
+ *	table.
+ *
+ *	Return Value:
+ *     	0        :  SUCCESS
+ *     	<0       :  FAILURE
+ */
+int __devinit smbios_get_64bit_cru_info(void)
+{
+	unsigned short copy;
+	unsigned char *record_ptr = NULL;
+	struct smbios_cru64_info *smbios_cru64_ptr;
+	unsigned long cru_physical_address;
+	void *smbios_table_ptr;
+	int retval = -ENOMEM;
+
+	smbios_table_ptr = ioremap((unsigned int)tbl_addr, tbl_len);
+	if (!smbios_table_ptr)
+		return retval;
+
+	copy = 0;
+	while (smbios_get_record_by_type
+	       (SMBIOS_CRU64_INFORMATION, copy, (void *)&record_ptr,
+	       smbios_table_ptr)) {
+		/*
+		 * In the event the ROM has a bug, let's print this
+		 * out and quit before we get into trouble.
+		 */
+		if (!record_ptr) {
+			printk(KERN_WARNING
+			       "hpwdt: smbios: Missing SMBIOS_CRU64_INFO!\n");
+			retval = -ENODEV;
+			break;
+		}
+		smbios_cru64_ptr = (struct smbios_cru64_info *) record_ptr;
+		if (smbios_cru64_ptr->signature == CRU_BIOS_SIGNATURE_VALUE) {
+
+			cru_physical_address =
+			    smbios_cru64_ptr->physical_address +
+			    smbios_cru64_ptr->double_offset;
+			gpVirtRomCRUAddr =
+			    ioremap((unsigned long)cru_physical_address,
+				    smbios_cru64_ptr->double_length);
+			if (gpVirtRomCRUAddr)
+				retval = 0;
+			break;
+		}
+	}
+
+	iounmap(smbios_table_ptr);
+	return retval;
+}
+
+/*
+ *	smbios_detect
+ *
+ *	Routine Description:
+ *    	This function parses SMBIOS to retrieve the 64 bit CRU Service.
+ *
+ *	Return Value:
+ *     	0        :  SUCCESS
+ *     	<0       :  FAILURE
+ */
+int smbios_detect(void)
+{
+	unsigned char *p_virtual_rom;
+	unsigned char *p;
+	struct smbios_entry_point *pEPS;
+	int retval = -ENOMEM;
+
+	/*
+	 * Search from 0x0f0000 through 0x0fffff, inclusive.
+	 */
+	p_virtual_rom = ioremap(PCI_ROM_BASE1, ROM_SIZE);
+	if (!p_virtual_rom)
+		return retval;
+
+	for (p = p_virtual_rom; p < p_virtual_rom + ROM_SIZE; p += 16) {
+		pEPS = (struct smbios_entry_point *) p;
+		if ((strncmp((char *)pEPS->anchor_string, "_SM_",
+			     sizeof(pEPS->anchor_string))) == 0) {
+			tbl_addr = pEPS->table_address;
+			tbl_len = pEPS->table_length;
+			retval = 0;
+			break;
+		}
+	}
+	iounmap(p_virtual_rom);
+	return retval;
+}
+
+/*
+ *	cru_detect
+ *
+ *	Routine Description:
+ *    	This function uses the 32-bit BIOS Service Directory record to
+ *    	search for a $CRU record.
+ *
+ *	Return Value:
+ *     	0        :  SUCCESS
+ *     	<0       :  FAILURE
+ */
+int __devinit cru_detect(void)
+{
+	unsigned long cru_physical_address;
+	unsigned long cru_length;
+	unsigned long physical_bios_base = 0;
+	unsigned long physical_bios_offset = 0;
+	int retval = -ENODEV;
+
+	cmn_regs.u1.reax = CRU_BIOS_SIGNATURE_VALUE;
+
+	asminline_call(&cmn_regs, (unsigned long *)gpBios32EntryPoint);
+
+	if (cmn_regs.u1.ral != 0) {
+		printk(KERN_WARNING
+		       "hpwdt: Call succeeded but with an error: 0x%x\n",
+		       cmn_regs.u1.ral);
+	} else {
+		physical_bios_base = cmn_regs.u2.rebx;
+		physical_bios_offset = cmn_regs.u4.redx;
+		cru_length = cmn_regs.u3.recx;
+		cru_physical_address =
+		    physical_bios_base + physical_bios_offset;
+
+		/* If the values look OK, then map it in. */
+		if ((physical_bios_base + physical_bios_offset)) {
+			gpVirtRomCRUAddr =
+			    ioremap(cru_physical_address, cru_length);
+			if (gpVirtRomCRUAddr)
+				retval = 0;
+		}
+
+		printk(KERN_DEBUG "hpwdt: CRU Base Address:   0x%lx\n",
+			physical_bios_base);
+		printk(KERN_DEBUG "hpwdt: CRU Offset Address: 0x%lx\n",
+			physical_bios_offset);
+		printk(KERN_DEBUG "hpwdt: CRU Length:         0x%lx\n",
+			cru_length);
+		printk(KERN_DEBUG "hpwdt: CRU Mapped Address: 0x%x\n",
+			(unsigned int)&gpVirtRomCRUAddr);
+	}
+	iounmap(gpBios32Map);
+	return retval;
+}
+
+/*
+ *	valid_checksum
+ */
+static int valid_checksum(void *header_ptr, unsigned char size)
+{
+	unsigned char i;
+	unsigned char check_sum = 0;
+	unsigned char *ptr = header_ptr;
+
+	/*
+	 * calculate checksum of size bytes. This should add up
+	 * to zero if we have a valid header.
+	 */
+	for (i = 0; i < size; i++, ptr++)
+		check_sum = (check_sum + (*ptr));
+
+	return ((check_sum == 0) && (size > 0));
+}
+
+/*
+ *	check_for_bios32_support
+ *
+ *	Routine Description:
+ *    	This function determine if a pointer is pointing to the
+ *    	32 bit BIOS Directory Services entry in ROM space.
+ *
+ *	Return Value:
+ *	1 - if found the correct signature
+ *	0 - unable to find _32_
+ */
+static int check_for_bios32_support(struct bios32_service_dir *bios_32_ptr)
+{
+	/*
+	 * Search for signature by checking equal to the swizzled value
+	 * instead of calling another routine to perform a strcmp.
+	 */
+	if (bios_32_ptr->signature == PCI_BIOS32_SD_VALUE) {
+		if (valid_checksum((void *)bios_32_ptr,
+			((unsigned char)(bios_32_ptr->length *
+				PCI_BIOS32_PARAGRAPH_LEN))))
+		return 1;
+	}
+	return 0;
+}
+
+/*
+ *	find_32bit_bios_sd
+ *
+ *	Routine Description:
+ *    	This function find the 32-bit BIOS Service Directory
+ *
+ *	Return Value:
+ *     	0        :  SUCCESS
+ *     	<0       :  FAILURE
+ */
+int __devinit find_32bit_bios_sd(void)
+{
+	struct bios32_service_dir *bios_32_data_ptr;
+	unsigned long map_entry, map_offset;
+	void *pRomVirtAddr;
+	unsigned char *p;
+	int retval = -ENOMEM;
+
+	pRomVirtAddr = ioremap(PCI_ROM_BASE1, ROM_SIZE);
+	if (!pRomVirtAddr) {
+		printk(KERN_WARNING "hpwdt: Unable to map in BIOS ROM.\n");
+		return retval;
+	}
+
+	/*
+	 * BIOS32 spec indicates that the signature will be
+	 * paragraph-aligned, so we'll skip by 16 bytes each pass
+	 * through the loop.
+	 */
+	for (p = pRomVirtAddr;
+	     p < ((unsigned char *)pRomVirtAddr + ROM_SIZE); p += 16) {
+
+		if (!check_for_bios32_support((struct bios32_service_dir *) p))
+			continue;
+
+		/* Found a Service Directory. */
+		bios_32_data_ptr = (struct bios32_service_dir *) p;
+
+		/*
+		 * According to the spec, we're looking for the
+		 * first 4KB-aligned address below the entrypoint
+		 * listed in the header. The Service Directory code
+		 * is guaranteed to occupy no more than 2 4KB pages.
+		 */
+		map_entry = bios_32_data_ptr->entry_point & ~(PAGE_SIZE - 1);
+		map_offset = bios_32_data_ptr->entry_point - map_entry;
+
+		gpBios32Map = ioremap(map_entry, (2 * PAGE_SIZE));
+
+		if (gpBios32Map) {
+			/* This will be unmapped in cru_detect. */
+			gpBios32EntryPoint = gpBios32Map + map_offset;
+			retval = 0;
+		}
+		break;
+	}
+	iounmap(pRomVirtAddr);
+	return retval;
+}
+
+static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
+			    void *dummy)
+{
+	static unsigned long rom_pl;
+	static int die_nmi_called;
+
+	if (ulReason == DIE_NMI || ulReason == DIE_NMI_IPI) {
+		spin_lock_irqsave(&rom_lock, rom_pl);
+		if (!die_nmi_called)
+			asminline_call(&cmn_regs, gpVirtRomCRUAddr);
+		die_nmi_called = 1;
+		spin_unlock_irqrestore(&rom_lock, rom_pl);
+		if (cmn_regs.u1.ral == 0) {
+			printk(KERN_WARNING "hpwdt: An NMI occurred, "
+			       "but unable to determine source.\n");
+		} else {
+			panic("An NMI occurred, please see the Integrated "
+				"Management Log for details.\n");
+		}
+	}
+	return NOTIFY_STOP;
+}
+
+/*
+ *	Refresh the timer.
+ */
+static void hpwdt_ping(void)
+{
+	writew(reload, hpwdt_timer_reg);
+}
+
+static int hpwdt_open(struct inode *inode, struct file *file)
+{
+	reload = ((soft_margin * 60) * 1000) / 128;
+	/*
+	 * Setting this bit is irreversible; once enabled, there is
+	 * no way to disable the watchdog.
+	 */
+	writew(0x85, hpwdt_timer_con);
+	return 0;
+}
+
+/*
+ *	Shut off the timer.
+ *	Note: if we really have enabled the watchdog, there
+ *	is no way to turn off.
+ */
+static int hpwdt_release(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static ssize_t
+hpwdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+{
+	/*
+	 *      Refresh the timer.
+	 */
+	if (len)
+		hpwdt_ping();
+
+	return len;
+}
+
+static struct watchdog_info ident = {
+	.options = WDIOF_SETTIMEOUT,
+	.identity = "HP Integrated Lights-Out HW Watchdog Timer",
+};
+
+static long
+hpwdt_ioctl(struct file *file, unsigned int cmd,
+	    unsigned long arg)
+{
+	int ret = -ENOIOCTLCMD;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		ret = 0;
+		if (copy_to_user((void *)arg, &ident, sizeof(ident)))
+			ret = -EFAULT;
+		break;
+
+	case WDIOC_GETSTATUS:
+		ret = 0;
+		break;
+
+	case WDIOC_GETBOOTSTATUS:
+		ret = put_user(0, (int *)arg);
+		break;
+
+	case WDIOC_KEEPALIVE:
+		hpwdt_ping();
+		ret = 0;
+		break;
+
+	case WDIOC_SETTIMEOUT:
+		ret = get_user(new_margin, (int *)arg);
+		if (ret)
+			break;
+
+		/* Arbitrary, can't find the card's limits */
+		if (new_margin < 2 || new_margin > 30) {
+			ret = -EINVAL;
+			break;
+		}
+
+		soft_margin = new_margin;
+		printk(KERN_DEBUG
+			"hpwdt: New timer passed in is %d minutes.\n",
+			new_margin);
+		reload = ((soft_margin * 60) * 1000) / 128;
+		hpwdt_ping();
+		/* Fall */
+	case WDIOC_GETTIMEOUT:
+		ret = put_user(new_margin, (int *)arg);
+		break;
+	}
+	return ret;
+}
+
+static struct file_operations hpwdt_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = hpwdt_write,
+	.unlocked_ioctl = hpwdt_ioctl,
+	.open = hpwdt_open,
+	.release = hpwdt_release,
+};
+
+static struct miscdevice hpwdt_miscdev = {
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &hpwdt_fops,
+};
+
+static struct notifier_block die_notifier = {
+	.notifier_call = hpwdt_pretimeout,
+	.priority = 0x7FFFFFFF,
+};
+
+static int __devinit hpwdt_init_one(struct pci_dev *dev,
+				    const struct pci_device_id *ent)
+{
+	int retval;
+
+	if (pci_enable_device(dev)) {
+		printk(KERN_WARNING
+		       "hpwdt: Not possible to enable PCI Device\n");
+		return -ENODEV;
+	}
+	pci_enable = 1;
+
+	/*
+	 * First let's find out if we are on an iLO2 server. We will
+	 * not run on a legacy ASM box.
+	 */
+	if (dev->subsystem_vendor != PCI_VENDOR_ID_HP) {
+		printk(KERN_WARNING
+		       "hpwdt: This server does not have an iLO2 ASIC.\n");
+		pci_disable_device(dev);
+		return -ENODEV;
+	}
+
+	retval = misc_register(&hpwdt_miscdev);
+	if (retval < 0) {
+		pci_disable_device(dev);
+		return retval;
+	}
+
+	p_mem_addr = ioremap((unsigned long)pci_resource_start(dev, 1), 0x80);
+	if (!p_mem_addr) {
+		retval = -ENOMEM;
+		goto error_out;
+	}
+	hpwdt_timer_reg = (p_mem_addr + 0x70);
+	hpwdt_timer_con = (p_mem_addr + 0x72);
+
+#ifndef CONFIG_X86_64
+	/*
+	 * Let's try to map in the ROM for 32 bit Operating Systems because
+	 * we need get the CRU Service through the 32 Bit BIOS SD.
+	 * This is not the case for 64 bit Operating Systems where we get
+	 * that service through SMBIOS.
+	 */
+	retval = find_32bit_bios_sd();
+	if (retval < 0) {
+		printk(KERN_WARNING
+		       "hpwdt: No 32 Bit BIOS Service Directory found.\n");
+		goto error_out;
+	}
+
+	retval = cru_detect();
+	if (retval < 0) {
+		printk(KERN_WARNING
+		       "hpwdt: Unable to detect 32 Bit CRU Service.\n");
+		goto error_out;
+	}
+#else
+	retval = smbios_detect();
+	if (retval < 0) {
+		printk(KERN_WARNING "hpwdt: No 64 Bit SMBIOS found.\n");
+		goto error_out;
+	}
+
+	retval = smbios_get_64bit_cru_info();
+	if (retval < 0) {
+		printk(KERN_WARNING
+		       "hpwdt: Unable to detect the 64 Bit CRU Service.\n");
+		goto error_out;
+	}
+#endif
+	/*
+	 * We know this is the only CRU call we need to make so lets keep as
+	 * few instructions as possible once the NMI comes in.
+	 */
+	memset(&cmn_regs, 0, sizeof(struct cmn_registers));
+	cmn_regs.u1.rah = 0x0D;
+	cmn_regs.u1.ral = 0x02;
+
+	retval = register_die_notifier(&die_notifier);
+	if (retval != 0) {
+		printk(KERN_WARNING
+		       "hpwdt: Unable to register a die notifier.\n");
+		goto error_out;
+	}
+	die_reg = 1;
+
+	new_margin = soft_margin;
+	printk("hp Watchdog Timer Driver: 1.00, timer margin: %d minutes\n",
+		new_margin);
+
+	return 0;
+error_out:
+	printk(KERN_WARNING "hpwdt: NMI support is not possible.\n");
+	misc_deregister(&hpwdt_miscdev);
+	if (pci_enable)
+		pci_disable_device(dev);
+	if (p_mem_addr)
+		iounmap(p_mem_addr);
+	if (gpVirtRomCRUAddr)
+		iounmap(gpVirtRomCRUAddr);
+	return retval;
+}
+
+static void __devexit hpwdt_exit(struct pci_dev *dev)
+{
+	if (die_reg)
+		unregister_die_notifier(&die_notifier);
+
+	if (pci_enable)
+		pci_disable_device(dev);
+
+	misc_deregister(&hpwdt_miscdev);
+	if (p_mem_addr)
+		iounmap(p_mem_addr);
+	if (gpVirtRomCRUAddr)
+		iounmap(gpVirtRomCRUAddr);
+}
+
+static struct pci_driver hpwdt_driver = {
+	.name = "hpwdt",
+	.id_table = hpwdt_devices,
+	.probe = hpwdt_init_one,
+	.remove = __devexit_p(hpwdt_exit),
+};
+
+static void __exit hpwdt_cleanup(void)
+{
+	pci_unregister_driver(&hpwdt_driver);
+}
+
+static int __init hpwdt_init(void)
+{
+	return pci_register_driver(&hpwdt_driver);
+}
+
+MODULE_AUTHOR("Tom Mingarelli");
+MODULE_DESCRIPTION("hp watchdog driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+
+module_param(soft_margin, int, 0);
+MODULE_PARM_DESC(soft_margin, "Watchdog timeout in minutes");
+
+module_init(hpwdt_init);
+module_exit(hpwdt_cleanup);
