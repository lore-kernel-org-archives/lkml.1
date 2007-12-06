Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbXLFOyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbXLFOyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 09:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbXLFOyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 09:54:01 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:33565 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbXLFOyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 09:54:00 -0500
Date: Thu, 6 Dec 2007 15:53:59 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Wim Van Sebroeck <wim@iguana.be>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Mingarelli <thomas.mingarelli@hp.com>
Subject: Re: [WATCHDOG] HP ProLiant WatchDog driver
In-Reply-To: <20071204184310.GE2668@infomag.infomag.iguana.be>
Message-ID: <Pine.LNX.4.64.0712061540250.19266@fbirervta.pbzchgretzou.qr>
References: <20071204184310.GE2668@infomag.infomag.iguana.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 4 2007 19:43, Wim Van Sebroeck wrote:
>@@ -69,6 +69,8 @@ obj-$(CONFIG_WAFER_WDT) += wafer5823wdt.o
> obj-$(CONFIG_I6300ESB_WDT) += i6300esb.o
> obj-$(CONFIG_ITCO_WDT) += iTCO_wdt.o iTCO_vendor_support.o
> obj-$(CONFIG_IT8712F_WDT) += it8712f_wdt.o
>+CFLAGS_hpwdt.o += -O
>+obj-$(CONFIG_HP_WATCHDOG) += hpwdt.o

Why is it necessary to build with -O?

>+struct smbios_entry_point {
>+	u8 anchor_string[4];
>+	u8 check_sum;
>+	u8 length;
>+	u8 major_ver;
>+	u8 minor_ver;
>+	u16 max_struct_size;
>+	u8 revision;
>+	u8 reserved[5];
>+	u8 intermediate_anchor[5];
>+	u8 intermediate_check_sum;
>+	u16 table_length;
>+	u64 table_address;
>+	u16 number_structs;
>+	u8 bcd_revision;
>+};

Possibly need __attribute__((packed))?

>+struct cmn_registers {
>+	union {
>+		struct {
>+			u8 ral;
>+			u8 rah;
>+			u16 rea2;
>+		};
>+		u32 reax;
>+	} u1;
>+	union {
>+		struct {
>+			u8 rbl;
>+			u8 rbh;
>+			u8 reb2l;
>+			u8 reb2h;
>+		};
>+		u32 rebx;
>+	} u2;
>+	union {
>+		struct {
>+			u8 rcl;
>+			u8 rch;
>+			u16 rec2;
>+		};
>+		u32 recx;
>+	} u3;
>+	union {
>+		struct {
>+			u8 rdl;
>+			u8 rdh;
>+			u16 red2;
>+		};
>+		u32 redx;
>+	} u4;
>+
>+	u32 resi;
>+	u32 redi;
>+	u16 rds;
>+	u16 res;
>+	u32 reflags;
>+}  __attribute__((packed));

Hm, could not pt_regs be reused?

>+static struct pci_device_id hpwdt_devices[] = {
>+	{
>+	 .vendor = PCI_VENDOR_ID_COMPAQ,
>+	 .device = 0xB203,
>+	 .subvendor = PCI_ANY_ID,
>+	 .subdevice = PCI_ANY_ID,
>+	},
>+	{0},			/* terminate list */

Looks redundant comment to me.

>+};
>+		/* If the values look OK, then map it in. */
>+		if ((physical_bios_base + physical_bios_offset)) {

For readability,
		if (physical_bios_base + physical_bios_offset != 0)

>+		printk(KERN_DEBUG "hpwdt: CRU Base Address:   0x%lx\n",
>+			physical_bios_base);
>+		printk(KERN_DEBUG "hpwdt: CRU Offset Address: 0x%lx\n",
>+			physical_bios_offset);
>+		printk(KERN_DEBUG "hpwdt: CRU Length:         0x%lx\n",
>+			cru_length);
>+		printk(KERN_DEBUG "hpwdt: CRU Mapped Address: 0x%x\n",
>+			(unsigned int)&gpVirtRomCRUAddr);

Use %p instead.

>+	/*
>+	 * calculate checksum of size bytes. This should add up
>+	 * to zero if we have a valid header.
>+	 */
>+	for (i = 0; i < size; i++, ptr++)
>+		check_sum = (check_sum + (*ptr));
		check_sum += *ptr;

>+	return ((check_sum == 0) && (size > 0));

() can go.

>+static int check_for_bios32_support(struct bios32_service_dir *bios_32_ptr)
>+{
>+	/*
>+	 * Search for signature by checking equal to the swizzled value
>+	 * instead of calling another routine to perform a strcmp.
>+	 */
>+	if (bios_32_ptr->signature == PCI_BIOS32_SD_VALUE) {
>+		if (valid_checksum((void *)bios_32_ptr,
>+			((unsigned char)(bios_32_ptr->length *
>+				PCI_BIOS32_PARAGRAPH_LEN))))
>+		return 1;
>+	}
>+	return 0;
>+}

Perhaps..

static bool check_for_bios32_support(struct bios32_service_dir *bios_32_ptr)
{
	/*
	 * Search for signature by checking equal to the swizzled value
	 * instead of calling another routine to perform a strcmp.
	 */
	return bios_32_ptr->signature == PCI_BIOS32_SD_VALUE &&
	       valid_checksum((void *)bios_32_ptr,
               (unsigned char)(bios_32_ptr->length * PCI_BIOS32_PARAGRAPH_LEN))
}

>+int __devinit find_32bit_bios_sd(void)
>+{
>+	void *pRomVirtAddr;
>+	for (p = pRomVirtAddr;
>+	     p < ((unsigned char *)pRomVirtAddr + ROM_SIZE); p += 16) {

Cast not needed.

>+		if (!check_for_bios32_support((struct bios32_service_dir *) p))
>+			continue;
>+
>+		/* Found a Service Directory. */
>+		bios_32_data_ptr = (struct bios32_service_dir *) p;

Cast not needed.

>+int smbios_get_record(unsigned char **pp_record, void *smbios_table_ptr)
>+{
>[...]
>+	if (buffer >= ((unsigned char *)smbios_table_ptr + tbl_len))
>+		return 0;

cast not needed..................

>+int smbios_get_record_by_type(unsigned char type, unsigned short copy,
>+			      void **pp_record, void *smbios_table_ptr)
>+{
>+	unsigned char *save_state_ptr = NULL;
>+	struct smbios_header *header_ptr;
>+
>+	while (smbios_get_record(&save_state_ptr, smbios_table_ptr)) {
>+		header_ptr = (struct smbios_header *) save_state_ptr;
>+		if (header_ptr->byte_type == type) {
>+			if (copy == 0) {
>+				*pp_record = (void *)save_state_ptr;

cast (ahem) not needed. Done too much C++? ;-)
Check the rest.

>+static void hpwdt_stop(void)
>+{
>+	unsigned long data;
>+
>+	data = readw(hpwdt_timer_con);
>+	data &= 0xFE;
>+	writew(data, hpwdt_timer_con);
>+}

Would this work?

static inline void hpwdt_stop(void)
{
	writew(readw(hpwdt_timer_con) & 0xFE, hpwdt_timer_con);
}

>+static int __devinit detect_bios_directory(void)
>+{
>+	if (HPWDT_ARCH == 32) {
>+		return find_32bit_bios_sd();
>+	} else {
>+		return smbios_detect();
>+	}
>+}

-{}

>+static int __devinit detect_cru_service(void)
>+{
>+	if (HPWDT_ARCH == 32) {
>+		return cru_detect();
>+	} else {
>+		return smbios_get_64bit_cru_info();
>+	}
>+}

-{}

>+	hpwdt_timer_reg = (p_mem_addr + 0x70);
>+	hpwdt_timer_con = (p_mem_addr + 0x72);

-()

>+	/* Make sure that we have a valid soft_margin */
>+	if (hpwdt_change_timer(soft_margin)) {
>+		hpwdt_change_timer(DEFAULT_MARGIN);
>+	}

-{}
check others.

