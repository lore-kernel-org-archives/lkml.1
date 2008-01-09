Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbYAITOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbYAITOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 14:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYAITO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 14:14:26 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4733 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbYAITOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 14:14:25 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: David Miller <davem@davemloft.net>
Subject: sparc64: ultra 60 fails to boot with 64kB pages
Date: Wed, 9 Jan 2008 20:14:16 +0100
User-Agent: KMail/1.9.7
Cc: sparclinux@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801092014.18787.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	I found this kconfig info on kernel page size:

'8KB and 64KB work quite well, since Sparc ELF sections provide for up to 64KB alignment.'

so I thought I'll give it a try. I tested 2.6.24-rc7 and it stopped right after

'Remapping the kernel ... done'

At first I wanted to bisect this but soon I found there is no kernel that boots with
64k pages on that machine. I tested 2.6.24-rc7, 2.6.23, 2.6.22, 2.6.20 and 2.6.16.
2.6.24-rc7 dies right after 'Remapping the kernel ... done' text. So I added:

#define DBGRK() prom_printf("%s:%d\n", __FILE__, __LINE__);

and ivoked it a bunch of times in arch/sparc64/mm/init.c to see where it stops.
Here is main portion of the diff:

--- a/arch/sparc64/mm/init.c
+++ b/arch/sparc64/mm/init.c
@@ -1328,6 +1328,7 @@ pgd_t swapper_pg_dir[2048];
 static void sun4u_pgprot_init(void);
 static void sun4v_pgprot_init(void);
 
+#define DBGRK() prom_printf("%s:%d\n", __FILE__, __LINE__);
 void __init paging_init(void)
 {
        unsigned long end_pfn, pages_avail, shift, phys_base;
@@ -1402,30 +1403,38 @@ void __init paging_init(void)
                swapper_low_pmd_dir + (shift / sizeof(pgd_t)));
        
        inherit_prom_mappings();
-       
+
        read_obp_memory("reg", &pall[0], &pall_ents);
 
        init_kpte_bitmap();
 
        /* Ok, we can use our TLB miss and window trap handlers safely.  */
        setup_tba();
+       DBGRK(); <---------- line 1413 from http://tuxland.pl/misc/sparc64/sparc64-2.6.24-rc7.jpg
 
        __flush_tlb_all(); <--------------------------- this function fails
+       DBGRK();
 
        if (tlb_type == hypervisor)
                sun4v_ktsb_register();
+       DBGRK();
 
        /* Setup bootmem... */
        pages_avail = 0;
        last_valid_pfn = end_pfn = bootmem_init(&pages_avail, phys_base);
+       DBGRK();
 
        max_mapnr = last_valid_pfn;
+       DBGRK();
 
        kernel_physical_mapping_init();
+       DBGRK();
 
        real_setup_per_cpu_areas();
+       DBGRK();
 
        prom_build_devicetree();
+       DBGRK();
 
        if (tlb_type == hypervisor)
                sun4v_mdesc_init();
@@ -1908,33 +1917,44 @@ void __flush_tlb_all(void)
        unsigned long pstate;
        int i;
 
+       DBGRK(); <------------------------ the next DBGRK() to be called afrer line 1413
        __asm__ __volatile__("flushw\n\t"
                             "rdpr      %%pstate, %0\n\t"
                             "wrpr      %0, %1, %%pstate"
                             : "=r" (pstate)
                             : "i" (PSTATE_IE));

(Please note that line numbers differ from pure 2.6.24-rc7 as I put this debug
stuff in there.)

Now please take a look at http://tuxland.pl/misc/sparc64/sparc64-2.6.24-rc7.jpg
and you'll see that __flush_tlb_all() fails. I assume that at least first DBGRK()
in __flush_tlb_all() gets printed but then gets overwritten with the garbage
you see in screenshot).

2.6.16 produces a bit more info which you can find here:
http://tuxland.pl/misc/sparc64/sparc64-2.6.16.jpg

The modified arch/sparc64/mm/init.c from 2.6.24-rc7 (to match it with the screen attached earlier)
is available here: http://tuxland.pl/misc/sparc64/init.c

2.6.24-rc7 config: http://tuxland.pl/misc/sparc64/sparc64-64kB-config-2.6.24-rc7

Kernels 2.6.20 and newer produce the same output as 2.6.24-rc7.

So ... am I doing something wrong here or something is broken?

Regards,

	Mariusz


The box is sun ultra 60 with two cpus and 1G of ram.

$ cat /proc/cpuinfo 
cpu             : TI UltraSparc II  (BlackBird)
fpu             : UltraSparc II integrated FPU
prom            : OBP 3.17.0 1998/10/23 11:26
type            : sun4u
ncpus probed    : 2
ncpus active    : 2
D$ parity tl1   : 0
I$ parity tl1   : 0
Cpu0ClkTck      : 000000001ad1cbeb
Cpu2ClkTck      : 000000001ad1cbeb
MMU Type        : Spitfire
State:
CPU0:           online
CPU2:           online

$ cat /proc/zoneinfo 
Node 0, zone   Normal
  pages free     109267
        min      501
        low      626
        high     751
        scanned  0 (a: 0 i: 0)
        spanned  393114
        present  125792
    nr_free_pages 109267
    nr_inactive  5760
    nr_active    4147
    nr_anon_pages 995
    nr_mapped    538
    nr_file_pages 8914
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 5664
    nr_slab_unreclaimable 871
    nr_page_table_pages 47
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
        protection: (0, 0)
  pagesets
    cpu: 0 pcp: 0
              count: 88
              high:  90
              batch: 15
    cpu: 0 pcp: 1
              count: 5
              high:  30
              batch: 7
  vm stats threshold: 16
    cpu: 2 pcp: 0
              count: 31
              high:  90
              batch: 15
    cpu: 2 pcp: 1
              count: 5
              high:  30
              batch: 7
  vm stats threshold: 16
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         0

$ cat /proc/buddyinfo 
Node 0, zone   Normal     25      5      0     16      5      2      4      1      0      0    106

$ cat /proc/interrupts 
           CPU0       CPU2       
  0:      32290      29965     <NULL>  timer
  1:          0          0      sun4u  PSYCHO_PCIERR
  2:          0          0      sun4u  PSYCHO_UE
  3:          0          0      sun4u  PSYCHO_CE
  8:          5          0      sun4u  su(kbd)
  9:          0          0      sun4u  su(mouse)
 14:       2302          0      sun4u  eth0
 15:       6379          0      sun4u  sym53c8xx
 16:          0         30      sun4u  sym53c8xx
 17:          0          0      sun4u  PSYCHO_PCIERR

# lspci 
0000:00:00.0 Host bridge: Sun Microsystems Computer Corp. Psycho PCI Bus Module
0000:00:01.0 Bridge: Sun Microsystems Computer Corp. EBUS (rev 01)
0000:00:01.1 Ethernet controller: Sun Microsystems Computer Corp. Happy Meal (rev 01)
0000:00:03.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875 (rev 14)
0000:00:03.1 SCSI storage controller: LSI Logic / Symbios Logic 53c875 (rev 14)
0001:00:00.0 Host bridge: Sun Microsystems Computer Corp. Psycho PCI Bus Module
