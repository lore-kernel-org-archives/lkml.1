Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbYCJNUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbYCJNUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 09:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYCJNUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 09:20:34 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:35534 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYCJNUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 09:20:33 -0400
Message-ID: <47D5359D.5000909@in.ibm.com>
Date: Mon, 10 Mar 2008 18:50:29 +0530
From: Chandru <chandru@in.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, jdmason@kudzu.us,
       Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: [RFC] [Patch] calgary iommu: Use the first kernel's tce tables
 in kdump
References: <1191962414.24134.68.camel@chandru> <20071009210623.GK4335@rhun.haifa.ibm.com> <20071010053057.GA24434@in.ibm.com> <20071014054110.GB4399@rhun.haifa.ibm.com> <20071015062919.GA4598@in.ibm.com> <476F4064.8010601@in.ibm.com>
In-Reply-To: <476F4064.8010601@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chandru wrote:
> Hi Muli,
>
> I have tried to work with CCR ,CSR, CSMR, CSAR, CFGRW, GBRERRM  
> registers but have been unable to make calgary generate an exception 
> upon error condition.  In alloc_tce_table() , I am setting WRITE_ONLY 
> access permission bit to tce entries but it isn't helping.  Would you 
> kindly let me know how we can make calgary to generate an exception in 
> error conditions ?.
>
> Thanks,
> Chandru
>
>
Hello Andrew,

Could you pls consider the attached patch for inclusion in mainline.

Thanks,
Chandru

Signed-off-by: Chandru S <chandru@in.ibm.com>
---

--- arch/x86/kernel/pci-calgary_64.c.orig       2008-03-10 
15:54:08.000000000 +0530
+++ arch/x86/kernel/pci-calgary_64.c    2008-03-10 16:34:20.000000000 +0530
@@ -36,6 +36,7 @@
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
 #include <linux/iommu-helper.h>
+#include <linux/crash_dump.h>
 #include <asm/gart.h>
 #include <asm/calgary.h>
 #include <asm/tce.h>
@@ -166,6 +167,8 @@ static void calgary_dump_error_regs(stru
 static void calioc2_handle_quirks(struct iommu_table *tbl, struct 
pci_dev *dev);
 static void calioc2_tce_cache_blast(struct iommu_table *tbl);
 static void calioc2_dump_error_regs(struct iommu_table *tbl);
+static void calgary_init_bitmap_from_tce_table(struct iommu_table *tbl);
+static void grab_tce_space_from_tar(void);

 static struct cal_chipset_ops calgary_chip_ops = {
        .handle_quirks = calgary_handle_quirks,
@@ -828,7 +831,11 @@ static int __init calgary_setup_tar(stru

        tbl = pci_iommu(dev->bus);
        tbl->it_base = (unsigned long)bus_info[dev->bus->number].tce_space;
-       tce_free(tbl, 0, tbl->it_size);
+
+       if (is_kdump_kernel())
+               calgary_init_bitmap_from_tce_table(tbl);
+       else
+               tce_free(tbl, 0, tbl->it_size);

        if (is_calgary(dev->device))
                tbl->chip_ops = &calgary_chip_ops;
@@ -1186,6 +1193,9 @@ static int __init calgary_locate_bbars(v
                }
        }

+       if (is_kdump_kernel())
+               grab_tce_space_from_tar();
+
        return 0;

 error:
@@ -1276,6 +1286,24 @@ static inline int __init determine_tce_t
        return ret;
 }

+/*
+ * calgary_init_bitmap_from_tce_table():
+ * Funtion for kdump case. In the second/kdump kernel initialize
+ * the bitmap based on the tce table entries obtained from first kernel
+ */
+static void calgary_init_bitmap_from_tce_table(struct iommu_table *tbl)
+{
+       u64 *tp;
+       unsigned int index;
+       tp = ((u64 *)tbl->it_base);
+       for (index = 0 ; index < tbl->it_size; index++) {
+               if (*tp != 0x0)
+                       set_bit(index, tbl->it_map);
+
+               tp++;
+       }
+}
+
 static int __init build_detail_arrays(void)
 {
        unsigned long ptr;
@@ -1338,12 +1366,52 @@ static int __init calgary_bus_has_device
        return (val != 0xffffffff);
 }

+/*
+ * grab_tce_space_from_tar():
+ * Function for kdump case. Grab the tce tables from first kernel
+ * by reading the contents of the base adress register of calgary iommu
+ */
+static void grab_tce_space_from_tar()
+{
+       int bus;
+       void __iomem *target;
+       unsigned long tce_space;
+
+       for (bus = 0; bus < MAX_PHB_BUS_NUM; bus++) {
+               struct calgary_bus_info *info = &bus_info[bus];
+               unsigned short pci_device;
+               u32 val;
+
+               val = read_pci_config(bus, 0, 0, 0);
+               pci_device = (val & 0xFFFF0000) >> 16;
+
+               if (!is_cal_pci_dev(pci_device))
+                       continue;
+
+               if (info->translation_disabled)
+                       continue;
+
+               if (calgary_bus_has_devices(bus, pci_device) ||
+                   translate_empty_slots) {
+                       target = calgary_reg(bus_info[bus].bbar,
+                                               tar_offset(bus));
+                       tce_space = be64_to_cpu(readq(target));
+                       tce_space = tce_space & TAR_SW_BITS;
+
+                       BUG_ON(specified_table_size > TCE_TABLE_SIZE_8M);
+
+                       tce_space = tce_space & (~specified_table_size);
+                       info->tce_space = (u64 *)__va(tce_space);
+               }
+       }
+}
+
 void __init detect_calgary(void)
 {
        int bus;
        void *tbl;
        int calgary_found = 0;
-       unsigned long ptr;
+       unsigned long ptr, max_pfn;
        unsigned int offset, prev_offset;
        int ret;

@@ -1393,7 +1461,8 @@ void __init detect_calgary(void)
                return;
        }

-       specified_table_size = determine_tce_table_size(end_pfn * 
PAGE_SIZE);
+       max_pfn = is_kdump_kernel() ? saved_max_pfn : end_pfn ;
+       specified_table_size = determine_tce_table_size(max_pfn * 
PAGE_SIZE);

        for (bus = 0; bus < MAX_PHB_BUS_NUM; bus++) {
                struct calgary_bus_info *info = &bus_info[bus];
@@ -1411,10 +1480,16 @@ void __init detect_calgary(void)

                if (calgary_bus_has_devices(bus, pci_device) ||
                    translate_empty_slots) {
-                       tbl = alloc_tce_table();
-                       if (!tbl)
-                               goto cleanup;
-                       info->tce_space = tbl;
+                       /*
+                        * If this is a kdump kernel find and use
+                        * the tce tables from first kernel
+                        */
+                       if (!is_kdump_kernel()) {
+                               tbl = alloc_tce_table();
+                               if (!tbl)
+                                       goto cleanup;
+                               info->tce_space = tbl;
+                       }
                        calgary_found = 1;
                }
        }
--- include/linux/crash_dump.h.orig     2008-03-10 15:54:33.000000000 +0530
+++ include/linux/crash_dump.h  2008-03-10 16:30:12.000000000 +0530
@@ -21,6 +21,13 @@ extern struct proc_dir_entry *proc_vmcor
 #endif

 #define vmcore_elf_check_arch(x) (elf_check_arch(x) || 
vmcore_elf_check_arch_cross(x))
+extern unsigned long saved_max_pfn;
+static inline int is_kdump_kernel(void)
+{
+       return (elfcorehdr_addr != ELFCORE_ADDR_MAX) ? 1 : 0 ;
+}
+#else /* !CONFIG_CRASH_DUMP */
+static inline is_kdump_kernel(void) { return 0; }

 #endif /* CONFIG_CRASH_DUMP */
 #endif /* LINUX_CRASHDUMP_H */


