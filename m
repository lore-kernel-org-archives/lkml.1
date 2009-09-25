Return-Path: <linux-kernel-owner+w=401wt.eu-S1751814AbZIYTFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbZIYTFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 15:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbZIYTFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 15:05:50 -0400
Received: from relay1.sgi.com ([192.48.179.29]:42144 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750936AbZIYTFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 15:05:48 -0400
Date: Fri, 25 Sep 2009 14:05:50 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Russ Anderson <rja@sgi.com>
Subject: [bug] x86_64 with efi hits BUG_ON() in arch/x86/mm/pageattr.c:184
Message-ID: <20090925190550.GA15445@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a boot problem on x86_64 with efi that prevents
the linux-2.6 and linux-next trees from booting on SGI UV
hardware.

The code hits a BUG_ON() in arch/x86/mm/pageattr.c:184
------------------------------------------------------
static void cpa_flush_range(unsigned long start, int numpages, int cache)
{
        unsigned int i, level;
        unsigned long addr;

        BUG_ON(irqs_disabled());
        WARN_ON(PAGE_ALIGN(start) != start);

        on_each_cpu(__cpa_flush_range, NULL, 1);
------------------------------------------------------

What is happening is in start_kernel() interrupts are 
disabled.  timekeeping_init() eventually calls 
rotines that call change_page_attr_set_clr() which calls
cpa_flush_range() tripping BUG_ON(irqs_disabled()).  

In init/main.c
------------------------------------------------------
asmlinkage void __init start_kernel(void)
[...]
        preempt_disable();
        if (!irqs_disabled()) {
                printk(KERN_WARNING "start_kernel(): bug: interrupts were "
                                "enabled *very* early, fixing it\n");
                local_irq_disable();
        }
        rcu_init();
        /* init some links before init_ISA_irqs() */
        early_irq_init();
        init_IRQ();
        prio_tree_init();
        init_timers();
        hrtimers_init();
        softirq_init();
        timekeeping_init(); <-- HERE
        time_init();
        profile_init();
        if (!irqs_disabled())
                printk(KERN_CRIT "start_kernel(): bug: interrupts were "
                                 "enabled early\n");
        early_boot_irqs_on();
        local_irq_enable();
------------------------------------------------------

Possible solutions are to enable interrupts earlier,
call timekeeping_init() later, or change the code under
timekeeping_init() to not need interrupts enabled.

I have not gitbisected to find the source of the breakage.
My guess is it broke between 9/24 and 9/25.


I changed the BUG_ON() to WARN_ON() to get a backtrace
and added local_irq_enable().  Then the kernel booted.

Output with the WARN_ON():
------------------------------------------------------
fs0:\efi\SuSE> elilo rja
ELILO
Loading kernel vmlinuz-2.6.31-rja-static-31...  done
Loading file initrd-2.6.31-rja-static-31...done
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-rja-static-31 (root@uv10-sys) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP Wed Sep 23 16:19:40 CDT 2009
[    0.000000] Command line: BOOT_IMAGE=scsi0:\efi\SuSE\vmlinuz-2.6.31-rja-static-31 root=/dev/sda7  nobau kdb=on console=ttyS0,115200n8 splash=silent crashkernel=256M-:128M showopts console=ttyS0,115200n8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
[    0.000000]  BIOS-e820: 000000000008f000 - 0000000000090000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000000090000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000795d8000 (usable)
[    0.000000]  BIOS-e820: 00000000795d8000 - 0000000079608000 (unusable)
[    0.000000]  BIOS-e820: 0000000079608000 - 000000007abea000 (usable)
[    0.000000]  BIOS-e820: 000000007abea000 - 000000007ac3a000 (reserved)
[    0.000000]  BIOS-e820: 000000007ac3a000 - 000000007ac8a000 (unusable)
[    0.000000]  BIOS-e820: 000000007ac8a000 - 000000007acda000 (reserved)
[    0.000000]  BIOS-e820: 000000007acda000 - 000000007ad72000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007ad72000 - 000000007adba000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007adba000 - 000000007adda000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007adda000 - 000000007adfa000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007adfa000 - 000000007ee94000 (usable)
[    0.000000]  BIOS-e820: 000000007ee94000 - 000000007ef14000 (reserved)
[    0.000000]  BIOS-e820: 000000007ef14000 - 000000007f000000 (usable)
[    0.000000]  BIOS-e820: 0000000080000000 - 0000000090000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f4000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000feb00000 - 00000000fec00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000480000000 (usable)
[    0.000000]  BIOS-e820: 0000001000000000 - 00000013ff000000 (usable)
[    0.000000]  BIOS-e820: 0000002000000000 - 00000023ff000000 (usable)
[    0.000000]  BIOS-e820: 00000ef800000000 - 00000f0000000000 (reserved)
[    0.000000] EFI v2.10 by INTEL 
[    0.000000]  ACPI 2.0=0x7adf9014  SMBIOS=0x7acb9000  UVsystab=0x7ac0b000 
[    0.000000] Kernel-defined memdesc doesn't match the one from EFI!
[    0.000000] EFI: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000001000) (0MB)
[    0.000000] EFI: mem01: type=7, attr=0xf, range=[0x0000000000001000-0x0000000000060000) (0MB)
[    0.000000] EFI: mem02: type=3, attr=0xf, range=[0x0000000000060000-0x000000000008f000) (0MB)
[    0.000000] EFI: mem03: type=10, attr=0xf, range=[0x000000000008f000-0x0000000000090000) (0MB)
[    0.000000] EFI: mem04: type=3, attr=0xf, range=[0x0000000000090000-0x00000000000a0000) (0MB)
[    0.000000] EFI: mem05: type=2, attr=0xf, range=[0x0000000000100000-0x0000000000500000) (4MB)
[    0.000000] EFI: mem06: type=7, attr=0xf, range=[0x0000000000500000-0x0000000000c00000) (7MB)
[    0.000000] EFI: mem07: type=3, attr=0xf, range=[0x0000000000c00000-0x0000000001000000) (4MB)
[    0.000000] EFI: mem08: type=7, attr=0xf, range=[0x0000000001000000-0x0000000010000000) (240MB)
[    0.000000] EFI: mem09: type=3, attr=0xf, range=[0x0000000010000000-0x0000000010052000) (0MB)
[    0.000000] EFI: mem10: type=7, attr=0xf, range=[0x0000000010052000-0x0000000077efd000) (1662MB)
[    0.000000] EFI: mem11: type=2, attr=0xf, range=[0x0000000077efd000-0x000000007844c000) (5MB)
[    0.000000] EFI: mem12: type=1, attr=0xf, range=[0x000000007844c000-0x0000000078540000) (0MB)
[    0.000000] EFI: mem13: type=7, attr=0xf, range=[0x0000000078540000-0x0000000078563000) (0MB)
[    0.000000] EFI: mem14: type=4, attr=0xf, range=[0x0000000078563000-0x00000000785ad000) (0MB)
[    0.000000] EFI: mem15: type=7, attr=0xf, range=[0x00000000785ad000-0x00000000785c4000) (0MB)
[    0.000000] EFI: mem16: type=2, attr=0xf, range=[0x00000000785c4000-0x00000000785c9000) (0MB)
[    0.000000] EFI: mem17: type=7, attr=0xf, range=[0x00000000785c9000-0x00000000785ca000) (0MB)
[    0.000000] EFI: mem18: type=2, attr=0xf, range=[0x00000000785ca000-0x00000000785ee000) (0MB)
[    0.000000] EFI: mem19: type=4, attr=0xf, range=[0x00000000785ee000-0x00000000787a3000) (1MB)
[    0.000000] EFI: mem20: type=7, attr=0xf, range=[0x00000000787a3000-0x00000000787a4000) (0MB)
[    0.000000] EFI: mem21: type=2, attr=0xf, range=[0x00000000787a4000-0x00000000787a5000) (0MB)
[    0.000000] EFI: mem22: type=4, attr=0xf, range=[0x00000000787a5000-0x00000000787b5000) (0MB)
[    0.000000] EFI: mem23: type=2, attr=0xf, range=[0x00000000787b5000-0x00000000787c7000) (0MB)
[    0.000000] EFI: mem24: type=7, attr=0xf, range=[0x00000000787c7000-0x00000000787c8000) (0MB)
[    0.000000] EFI: mem25: type=2, attr=0xf, range=[0x00000000787c8000-0x00000000787c9000) (0MB)
[    0.000000] EFI: mem26: type=4, attr=0xf, range=[0x00000000787c9000-0x00000000787ca000) (0MB)
[    0.000000] EFI: mem27: type=2, attr=0xf, range=[0x00000000787ca000-0x00000000787cb000) (0MB)
[    0.000000] EFI: mem28: type=4, attr=0xf, range=[0x00000000787cb000-0x00000000787cc000) (0MB)
[    0.000000] EFI: mem29: type=2, attr=0xf, range=[0x00000000787cc000-0x00000000787d5000) (0MB)
[    0.000000] EFI: mem30: type=4, attr=0xf, range=[0x00000000787d5000-0x00000000787d6000) (0MB)
[    0.000000] EFI: mem31: type=2, attr=0xf, range=[0x00000000787d6000-0x00000000787de000) (0MB)
[    0.000000] EFI: mem32: type=4, attr=0xf, range=[0x00000000787de000-0x00000000787e6000) (0MB)
[    0.000000] EFI: mem33: type=2, attr=0xf, range=[0x00000000787e6000-0x00000000787e7000) (0MB)
[    0.000000] EFI: mem34: type=4, attr=0xf, range=[0x00000000787e7000-0x0000000079143000) (9MB)
[    0.000000] EFI: mem35: type=3, attr=0xf, range=[0x0000000079143000-0x0000000079152000) (0MB)
[    0.000000] EFI: mem36: type=4, attr=0xf, range=[0x0000000079152000-0x0000000079190000) (0MB)
[    0.000000] EFI: mem37: type=3, attr=0xf, range=[0x0000000079190000-0x000000007919e000) (0MB)
[    0.000000] EFI: mem38: type=4, attr=0xf, range=[0x000000007919e000-0x00000000791aa000) (0MB)
[    0.000000] EFI: mem39: type=3, attr=0xf, range=[0x00000000791aa000-0x00000000791b1000) (0MB)
[    0.000000] EFI: mem40: type=4, attr=0xf, range=[0x00000000791b1000-0x00000000791b4000) (0MB)
[    0.000000] EFI: mem41: type=3, attr=0xf, range=[0x00000000791b4000-0x00000000791cd000) (0MB)
[    0.000000] EFI: mem42: type=4, attr=0xf, range=[0x00000000791cd000-0x00000000791ce000) (0MB)
[    0.000000] EFI: mem43: type=3, attr=0xf, range=[0x00000000791ce000-0x00000000791d9000) (0MB)
[    0.000000] EFI: mem44: type=4, attr=0xf, range=[0x00000000791d9000-0x00000000791de000) (0MB)
[    0.000000] EFI: mem45: type=3, attr=0xf, range=[0x00000000791de000-0x00000000791df000) (0MB)
[    0.000000] EFI: mem46: type=4, attr=0xf, range=[0x00000000791df000-0x00000000791e0000) (0MB)
[    0.000000] EFI: mem47: type=3, attr=0xf, range=[0x00000000791e0000-0x00000000791e7000) (0MB)
[    0.000000] EFI: mem48: type=4, attr=0xf, range=[0x00000000791e7000-0x00000000791e8000) (0MB)
[    0.000000] EFI: mem49: type=3, attr=0xf, range=[0x00000000791e8000-0x0000000079201000) (0MB)
[    0.000000] EFI: mem50: type=4, attr=0xf, range=[0x0000000079201000-0x0000000079202000) (0MB)
[    0.000000] EFI: mem51: type=3, attr=0xf, range=[0x0000000079202000-0x000000007920c000) (0MB)
[    0.000000] EFI: mem52: type=4, attr=0xf, range=[0x000000007920c000-0x000000007920e000) (0MB)
[    0.000000] EFI: mem53: type=3, attr=0xf, range=[0x000000007920e000-0x000000007921b000) (0MB)
[    0.000000] EFI: mem54: type=4, attr=0xf, range=[0x000000007921b000-0x000000007921e000) (0MB)
[    0.000000] EFI: mem55: type=3, attr=0xf, range=[0x000000007921e000-0x0000000079220000) (0MB)
[    0.000000] EFI: mem56: type=4, attr=0xf, range=[0x0000000079220000-0x00000000795ca000) (3MB)
[    0.000000] EFI: mem57: type=3, attr=0xf, range=[0x00000000795ca000-0x00000000795d8000) (0MB)
[    0.000000] EFI: mem58: type=5, attr=0x800000000000000f, range=[0x00000000795d8000-0x0000000079608000) (0MB)
[    0.000000] EFI: mem59: type=4, attr=0xf, range=[0x0000000079608000-0x0000000079612000) (0MB)
[    0.000000] EFI: mem60: type=3, attr=0xf, range=[0x0000000079612000-0x0000000079626000) (0MB)
[    0.000000] EFI: mem61: type=4, attr=0xf, range=[0x0000000079626000-0x000000007962a000) (0MB)
[    0.000000] EFI: mem62: type=3, attr=0xf, range=[0x000000007962a000-0x000000007962e000) (0MB)
[    0.000000] EFI: mem63: type=4, attr=0xf, range=[0x000000007962e000-0x000000007962f000) (0MB)
[    0.000000] EFI: mem64: type=3, attr=0xf, range=[0x000000007962f000-0x000000007963c000) (0MB)
[    0.000000] EFI: mem65: type=4, attr=0xf, range=[0x000000007963c000-0x000000007963d000) (0MB)
[    0.000000] EFI: mem66: type=3, attr=0xf, range=[0x000000007963d000-0x0000000079640000) (0MB)
[    0.000000] EFI: mem67: type=4, attr=0xf, range=[0x0000000079640000-0x0000000079641000) (0MB)
[    0.000000] EFI: mem68: type=3, attr=0xf, range=[0x0000000079641000-0x000000007964b000) (0MB)
[    0.000000] EFI: mem69: type=4, attr=0xf, range=[0x000000007964b000-0x0000000079695000) (0MB)
[    0.000000] EFI: mem70: type=3, attr=0xf, range=[0x0000000079695000-0x00000000796a0000) (0MB)
[    0.000000] EFI: mem71: type=4, attr=0xf, range=[0x00000000796a0000-0x00000000796a1000) (0MB)
[    0.000000] EFI: mem72: type=3, attr=0xf, range=[0x00000000796a1000-0x00000000796a7000) (0MB)
[    0.000000] EFI: mem73: type=4, attr=0xf, range=[0x00000000796a7000-0x00000000796b3000) (0MB)
[    0.000000] EFI: mem74: type=3, attr=0xf, range=[0x00000000796b3000-0x00000000796b5000) (0MB)
[    0.000000] EFI: mem75: type=4, attr=0xf, range=[0x00000000796b5000-0x00000000796d2000) (0MB)
[    0.000000] EFI: mem76: type=3, attr=0xf, range=[0x00000000796d2000-0x00000000796d5000) (0MB)
[    0.000000] EFI: mem77: type=4, attr=0xf, range=[0x00000000796d5000-0x00000000796d8000) (0MB)
[    0.000000] EFI: mem78: type=3, attr=0xf, range=[0x00000000796d8000-0x00000000796da000) (0MB)
[    0.000000] EFI: mem79: type=4, attr=0xf, range=[0x00000000796da000-0x00000000796db000) (0MB)
[    0.000000] EFI: mem80: type=3, attr=0xf, range=[0x00000000796db000-0x00000000796dc000) (0MB)
[    0.000000] EFI: mem81: type=4, attr=0xf, range=[0x00000000796dc000-0x00000000797b1000) (0MB)
[    0.000000] EFI: mem82: type=3, attr=0xf, range=[0x00000000797b1000-0x00000000797bf000) (0MB)
[    0.000000] EFI: mem83: type=4, attr=0xf, range=[0x00000000797bf000-0x00000000797e6000) (0MB)
[    0.000000] EFI: mem84: type=3, attr=0xf, range=[0x00000000797e6000-0x00000000797ef000) (0MB)
[    0.000000] EFI: mem85: type=4, attr=0xf, range=[0x00000000797ef000-0x0000000079802000) (0MB)
[    0.000000] EFI: mem86: type=3, attr=0xf, range=[0x0000000079802000-0x0000000079804000) (0MB)
[    0.000000] EFI: mem87: type=4, attr=0xf, range=[0x0000000079804000-0x0000000079810000) (0MB)
[    0.000000] EFI: mem88: type=3, attr=0xf, range=[0x0000000079810000-0x0000000079835000) (0MB)
[    0.000000] EFI: mem89: type=4, attr=0xf, range=[0x0000000079835000-0x000000007983d000) (0MB)
[    0.000000] EFI: mem90: type=3, attr=0xf, range=[0x000000007983d000-0x000000007983f000) (0MB)
[    0.000000] EFI: mem91: type=4, attr=0xf, range=[0x000000007983f000-0x0000000079850000) (0MB)
[    0.000000] EFI: mem92: type=3, attr=0xf, range=[0x0000000079850000-0x0000000079856000) (0MB)
[    0.000000] EFI: mem93: type=4, attr=0xf, range=[0x0000000079856000-0x000000007985f000) (0MB)
[    0.000000] EFI: mem94: type=3, attr=0xf, range=[0x000000007985f000-0x0000000079863000) (0MB)
[    0.000000] EFI: mem95: type=4, attr=0xf, range=[0x0000000079863000-0x0000000079865000) (0MB)
[    0.000000] EFI: mem96: type=3, attr=0xf, range=[0x0000000079865000-0x0000000079867000) (0MB)
[    0.000000] EFI: mem97: type=4, attr=0xf, range=[0x0000000079867000-0x0000000079a87000) (2MB)
[    0.000000] EFI: mem98: type=3, attr=0xf, range=[0x0000000079a87000-0x0000000079ab9000) (0MB)
[    0.000000] EFI: mem99: type=2, attr=0xf, range=[0x0000000079ab9000-0x0000000079aba000) (0MB)
[    0.000000] EFI: mem100: type=4, attr=0xf, range=[0x0000000079aba000-0x0000000079abc000) (0MB)
[    0.000000] EFI: mem101: type=3, attr=0xf, range=[0x0000000079abc000-0x0000000079abf000) (0MB)
[    0.000000] EFI: mem102: type=4, attr=0xf, range=[0x0000000079abf000-0x0000000079ac2000) (0MB)
[    0.000000] EFI: mem103: type=3, attr=0xf, range=[0x0000000079ac2000-0x0000000079acf000) (0MB)
[    0.000000] EFI: mem104: type=4, attr=0xf, range=[0x0000000079acf000-0x0000000079ad0000) (0MB)
[    0.000000] EFI: mem105: type=3, attr=0xf, range=[0x0000000079ad0000-0x0000000079ae2000) (0MB)
[    0.000000] EFI: mem106: type=4, attr=0xf, range=[0x0000000079ae2000-0x0000000079ae4000) (0MB)
[    0.000000] EFI: mem107: type=3, attr=0xf, range=[0x0000000079ae4000-0x0000000079aed000) (0MB)
[    0.000000] EFI: mem108: type=4, attr=0xf, range=[0x0000000079aed000-0x0000000079aef000) (0MB)
[    0.000000] EFI: mem109: type=3, attr=0xf, range=[0x0000000079aef000-0x0000000079af2000) (0MB)
[    0.000000] EFI: mem110: type=4, attr=0xf, range=[0x0000000079af2000-0x0000000079af3000) (0MB)
[    0.000000] EFI: mem111: type=3, attr=0xf, range=[0x0000000079af3000-0x0000000079af4000) (0MB)
[    0.000000] EFI: mem112: type=4, attr=0xf, range=[0x0000000079af4000-0x0000000079af5000) (0MB)
[    0.000000] EFI: mem113: type=3, attr=0xf, range=[0x0000000079af5000-0x0000000079af7000) (0MB)
[    0.000000] EFI: mem114: type=4, attr=0xf, range=[0x0000000079af7000-0x0000000079af8000) (0MB)
[    0.000000] EFI: mem115: type=3, attr=0xf, range=[0x0000000079af8000-0x0000000079afd000) (0MB)
[    0.000000] EFI: mem116: type=4, attr=0xf, range=[0x0000000079afd000-0x0000000079afe000) (0MB)
[    0.000000] EFI: mem117: type=3, attr=0xf, range=[0x0000000079afe000-0x0000000079b01000) (0MB)
[    0.000000] EFI: mem118: type=4, attr=0xf, range=[0x0000000079b01000-0x0000000079f01000) (4MB)
[    0.000000] EFI: mem119: type=3, attr=0xf, range=[0x0000000079f01000-0x0000000079f10000) (0MB)
[    0.000000] EFI: mem120: type=4, attr=0xf, range=[0x0000000079f10000-0x0000000079f12000) (0MB)
[    0.000000] EFI: mem121: type=3, attr=0xf, range=[0x0000000079f12000-0x0000000079f1b000) (0MB)
[    0.000000] EFI: mem122: type=4, attr=0xf, range=[0x0000000079f1b000-0x0000000079f1c000) (0MB)
[    0.000000] EFI: mem123: type=3, attr=0xf, range=[0x0000000079f1c000-0x0000000079f1f000) (0MB)
[    0.000000] EFI: mem124: type=4, attr=0xf, range=[0x0000000079f1f000-0x0000000079f23000) (0MB)
[    0.000000] EFI: mem125: type=3, attr=0xf, range=[0x0000000079f23000-0x0000000079f26000) (0MB)
[    0.000000] EFI: mem126: type=4, attr=0xf, range=[0x0000000079f26000-0x0000000079f27000) (0MB)
[    0.000000] EFI: mem127: type=3, attr=0xf, range=[0x0000000079f27000-0x0000000079f29000) (0MB)
[    0.000000] EFI: mem128: type=4, attr=0xf, range=[0x0000000079f29000-0x000000007abea000) (12MB)
[    0.000000] EFI: mem129: type=6, attr=0x800000000000000f, range=[0x000000007abea000-0x000000007ac0b000) (0MB)
[    0.000000] EFI: mem130: type=6, attr=0x800000000000000f, range=[0x000000007ac0b000-0x000000007ac3a000) (0MB)
[    0.000000] EFI: mem131: type=5, attr=0x800000000000000f, range=[0x000000007ac3a000-0x000000007ac59000) (0MB)
[    0.000000] EFI: mem132: type=5, attr=0x800000000000000f, range=[0x000000007ac59000-0x000000007ac8a000) (0MB)
[    0.000000] EFI: mem133: type=0, attr=0xf, range=[0x000000007ac8a000-0x000000007acb6000) (0MB)
[    0.000000] EFI: mem134: type=0, attr=0xf, range=[0x000000007acb6000-0x000000007acda000) (0MB)
[    0.000000] EFI: mem135: type=10, attr=0xf, range=[0x000000007acda000-0x000000007ad69000) (0MB)
[    0.000000] EFI: mem136: type=10, attr=0xf, range=[0x000000007ad69000-0x000000007ad72000) (0MB)
[    0.000000] EFI: mem137: type=9, attr=0xf, range=[0x000000007ad72000-0x000000007adba000) (0MB)
[    0.000000] EFI: mem138: type=10, attr=0xf, range=[0x000000007adba000-0x000000007adda000) (0MB)
[    0.000000] EFI: mem139: type=9, attr=0xf, range=[0x000000007adda000-0x000000007ade5000) (0MB)
[    0.000000] EFI: mem140: type=9, attr=0xf, range=[0x000000007ade5000-0x000000007adfa000) (0MB)
[    0.000000] EFI: mem141: type=4, attr=0xf, range=[0x000000007adfa000-0x000000007ee94000) (64MB)
[    0.000000] EFI: mem142: type=6, attr=0x800000000000000f, range=[0x000000007ee94000-0x000000007ef14000) (0MB)
[    0.000000] EFI: mem143: type=4, attr=0xf, range=[0x000000007ef14000-0x000000007f000000) (0MB)
[    0.000000] EFI: mem144: type=7, attr=0xf, range=[0x0000000100000000-0x0000000480000000) (14336MB)
[    0.000000] EFI: mem145: type=7, attr=0xf, range=[0x0000001000000000-0x00000013ff000000) (16368MB)
[    0.000000] EFI: mem146: type=7, attr=0xf, range=[0x0000002000000000-0x00000023ff000000) (16368MB)
[    0.000000] EFI: mem147: type=11, attr=0x8000000000000001, range=[0x0000000080000000-0x0000000090000000) (256MB)
[    0.000000] EFI: mem148: type=11, attr=0x8000000000000001, range=[0x00000000f4000000-0x00000000fc000000) (128MB)
[    0.000000] EFI: mem149: type=11, attr=0x8000000000000001, range=[0x00000000feb00000-0x00000000fec00000) (1MB)
[    0.000000] EFI: mem150: type=11, attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
[    0.000000] EFI: mem151: type=11, attr=0x8000000000000001, range=[0x00000ef800000000-0x00000efc00000000) (16384MB)
[    0.000000] EFI: mem152: type=11, attr=0x8000000000000001, range=[0x00000efc00000000-0x00000f0000000000) (16384MB)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x23ff000 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] x2apic enabled by BIOS, switching to x2apic ops
[    0.000000] last_pfn = 0x7f000 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000008f000 (usable)
[    0.000000]  modified: 000000000008f000 - 0000000000090000 (ACPI NVS)
[    0.000000]  modified: 0000000000090000 - 00000000000a0000 (usable)
[    0.000000]  modified: 0000000000100000 - 00000000795d8000 (usable)
[    0.000000]  modified: 00000000795d8000 - 0000000079608000 (unusable)
[    0.000000]  modified: 0000000079608000 - 000000007abea000 (usable)
[    0.000000]  modified: 000000007abea000 - 000000007ac3a000 (reserved)
[    0.000000]  modified: 000000007ac3a000 - 000000007ac8a000 (unusable)
[    0.000000]  modified: 000000007ac8a000 - 000000007acda000 (reserved)
[    0.000000]  modified: 000000007acda000 - 000000007ad72000 (ACPI NVS)
[    0.000000]  modified: 000000007ad72000 - 000000007adba000 (ACPI data)
[    0.000000]  modified: 000000007adba000 - 000000007adda000 (ACPI NVS)
[    0.000000]  modified: 000000007adda000 - 000000007adfa000 (ACPI data)
[    0.000000]  modified: 000000007adfa000 - 000000007ee94000 (usable)
[    0.000000]  modified: 000000007ee94000 - 000000007ef14000 (reserved)
[    0.000000]  modified: 000000007ef14000 - 000000007f000000 (usable)
[    0.000000]  modified: 0000000080000000 - 0000000090000000 (reserved)
[    0.000000]  modified: 00000000f4000000 - 00000000fc000000 (reserved)
[    0.000000]  modified: 00000000feb00000 - 00000000fec00000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000480000000 (usable)
[    0.000000]  modified: 0000001000000000 - 00000013ff000000 (usable)
[    0.000000]  modified: 0000002000000000 - 00000023ff000000 (usable)
[    0.000000]  modified: 00000ef800000000 - 00000f0000000000 (reserved)
[    0.000000] init_memory_mapping: 0000000000000000-000000007f000000
[    0.000000] init_memory_mapping: 0000000100000000-00000023ff000000
[    0.000000] RAMDISK: 03200000 - 0374e7f9
[    0.000000] ACPI: RSDP 000000007adf9014 00024 (v02    SGI)
[    0.000000] ACPI: XSDT 000000007adf9120 0006C (v01    SGI      UVH 00000002      01000013)
[    0.000000] ACPI: FACP 000000007adf7000 000F4 (v04    SGI      UVH 00000002 MSFT 01000013)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0000000000000450/0 20090521 tbfadt-557
[    0.000000] ACPI Warning: Invalid length for Pm2ControlBlock: 0, using default 8 20090521 tbfadt-607
[    0.000000] ACPI: DSDT 000000007ad72000 2399A (v02    SGI      UVH 00000002 MSFT 01000013)
[    0.000000] ACPI: FACS 000000007adba000 00040
[    0.000000] ACPI: SSDT 000000007adee000 0821E (v01  INTEL    SGIUV 00000003 INTL 20061109)
[    0.000000] ACPI: HPET 000000007aded000 00038 (v01    SGI      UVH 00000002 MSFT 01000013)
[    0.000000] ACPI: SLIT 000000007adec000 00035 (v01    SGI      UVH 00000002 MSFT 00000001)
[    0.000000] ACPI: APIC 000000007adea000 00388 (v02    SGI      UVH 00000002 MSFT 00000001)
[    0.000000] ACPI: SRAT 000000007ade9000 003D0 (v02    SGI      UVH 00000002 MSFT 00000001)
[    0.000000] ACPI: MCFG 000000007ade7000 0006C (v01    SGI      UVH 00000002 MSFT 00000001)
[    0.000000] ACPI: SPCR 000000007ade6000 00050 (v01                 00000000      00000000)
[    0.000000] ACPI: DMAR 000000007ade5000 00050 (v01    SGI      UVH 00000002 MSFT 01000013)
[    0.000000] Setting APIC routing to UV large system.
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 2 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 4 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 6 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 16 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 18 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 20 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 22 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 64 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 66 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 68 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 70 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 80 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 82 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 84 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 86 -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 128 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 130 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 132 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 134 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 144 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 146 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 148 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 150 -> Node 2
[    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 3 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 5 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 7 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 17 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 19 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 21 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 23 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 65 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 67 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 69 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 71 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 81 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 83 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 85 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 87 -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 129 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 131 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 133 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 135 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 145 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 147 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 149 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 151 -> Node 2
[    0.000000] SRAT: Node 0 PXM 0 0-80000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-480000000
[    0.000000] SRAT: Node 1 PXM 1 1000000000-1400000000
[    0.000000] SRAT: Node 2 PXM 2 2000000000-2400000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000480000000
[    0.000000]   NODE_DATA [0000000000009040 - 000000000003d03f]
[    0.000000]   bootmap [000000000012e000 -  00000000001bdfff] pages 90
[    0.000000] (10 early reservations) ==> bootmem [0000000000 - 0480000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0001b06a7c]    TEXT DATA BSS ==> [0001000000 - 0001b06a7c]
[    0.000000]   #3 [0003200000 - 000374e7f9]          RAMDISK ==> [0003200000 - 000374e7f9]
[    0.000000]   #4 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
[    0.000000]   #5 [00785ca018 - 00785cbcc8]       EFI memmap ==> [00785ca018 - 00785cbcc8]
[    0.000000]   #6 [0001b07000 - 0001b070bc]              BRK ==> [0001b07000 - 0001b070bc]
[    0.000000]   #7 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
[    0.000000]   #8 [0000100000 - 000012e000]          PGTABLE ==> [0000100000 - 000012e000]
[    0.000000]   #9 [0000009000 - 0000009035]        ACPI SLIT ==> [0000009000 - 0000009035]
[    0.000000] Bootmem setup node 1 0000001000000000-0000001400000000
[    0.000000]   NODE_DATA [0000001000000000 - 0000001000033fff]
[    0.000000]   bootmap [0000001000034000 -  00000010000b3fff] pages 80
[    0.000000] (10 early reservations) ==> bootmem [1000000000 - 1400000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
[    0.000000]   #2 [0001000000 - 0001b06a7c]    TEXT DATA BSS
[    0.000000]   #3 [0003200000 - 000374e7f9]          RAMDISK
[    0.000000]   #4 [000009ec00 - 0000100000]    BIOS reserved
[    0.000000]   #5 [00785ca018 - 00785cbcc8]       EFI memmap
[    0.000000]   #6 [0001b07000 - 0001b070bc]              BRK
[    0.000000]   #7 [0000008000 - 0000009000]          PGTABLE
[    0.000000]   #8 [0000100000 - 000012e000]          PGTABLE
[    0.000000]   #9 [0000009000 - 0000009035]        ACPI SLIT
[    0.000000] Bootmem setup node 2 0000002000000000-00000023ff000000
[    0.000000]   NODE_DATA [0000002000000000 - 0000002000033fff]
[    0.000000]   bootmap [0000002000034000 -  00000020000b3dff] pages 80
[    0.000000] (10 early reservations) ==> bootmem [2000000000 - 23ff000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
[    0.000000]   #2 [0001000000 - 0001b06a7c]    TEXT DATA BSS
[    0.000000]   #3 [0003200000 - 000374e7f9]          RAMDISK
[    0.000000]   #4 [000009ec00 - 0000100000]    BIOS reserved
[    0.000000]   #5 [00785ca018 - 00785cbcc8]       EFI memmap
[    0.000000]   #6 [0001b07000 - 0001b070bc]              BRK
[    0.000000]   #7 [0000008000 - 0000009000]          PGTABLE
[    0.000000]   #8 [0000100000 - 000012e000]          PGTABLE
[    0.000000]   #9 [0000009000 - 0000009035]        ACPI SLIT
[    0.000000] Reserving 128MB of memory at 64MB for crashkernel (System RAM: 147440MB)
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x023ff000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[10] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x0000008f
[    0.000000]     0: 0x00000090 -> 0x000000a0
[    0.000000]     0: 0x00000100 -> 0x000795d8
[    0.000000]     0: 0x00079608 -> 0x0007abea
[    0.000000]     0: 0x0007adfa -> 0x0007ee94
[    0.000000]     0: 0x0007ef14 -> 0x0007f000
[    0.000000]     0: 0x00100000 -> 0x00480000
[    0.000000]     1: 0x01000000 -> 0x013ff000
[    0.000000]     2: 0x02000000 -> 0x023ff000
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] Setting APIC routing to UV large system.
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x00] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x02] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x04] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x06] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x10] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x12] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x14] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x16] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x40] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x42] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x44] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x46] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x50] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x52] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x54] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x56] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x80] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x82] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x84] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x86] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x90] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x92] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x94] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x96] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x01] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x03] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x05] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x07] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x11] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x13] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x15] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x17] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x41] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x43] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x45] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x47] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x51] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x53] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x55] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x57] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x81] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x83] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x85] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x87] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x91] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x93] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x95] enabled)
[    0.000000] ACPI: LSAPIC (acpi_id[0x00] lsapic_id[0x00] lsapic_eid[0x97] enabled)
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec02000] gsi_base[24])
[  0000  0.00] IOAPIC[1]: apic_id 9, version 32, address 0xfec02000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 48 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000008f000 - 0000000000090000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000795d8000 - 0000000079608000
[    0.000000] PM: Registered nosave memory: 000000007abea000 - 000000007ac3a000
[    0.000000] PM: Registered nosave memory: 000000007ac3a000 - 000000007ac8a000
[    0.000000] PM: Registered nosave memory: 000000007ac8a000 - 000000007acda000
[    0.000000] PM: Registered nosave memory: 000000007acda000 - 000000007ad72000
[    0.000000] PM: Registered nosave memory: 000000007ad72000 - 000000007adba000
[    0.000000] PM: Registered nosave memory: 000000007adba000 - 000000007adda000
[    0.000000] PM: Registered nosave memory: 000000007adda000 - 000000007adfa000
[    0.000000] PM: Registered nosave memory: 000000007ee94000 - 000000007ef14000
[    0.000000] PM: Registered nosave memory: 000000007f000000 - 0000000080000000
[    0.000000] PM: Registered nosave memory: 0000000080000000 - 0000000090000000
[    0.000000] PM: Registered nosave memory: 0000000090000000 - 00000000f4000000
[    0.000000] PM: Registered nosave memory: 00000000f4000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000feb00000
[    0.000000] PM: Registered nosave memory: 00000000feb00000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 0000000100000000
[    0.000000] PM: Registered nosave memory: 0000000480000000 - 0000001000000000
[    0.000000] PM: Registered nosave memory: 00000013ff000000 - 0000002000000000
[    0.000000] Allocating PCI resources starting at 90000000 (gap: 90000000:64000000)
[    0.000000] NR_CPUS:4096 nr_cpumask_bits:48 nr_cpu_ids:48 nr_node_ids:3
[    0.000000] PERCPU: Embedded 37 pages/cpu @ffff880036600000 s120792 r8192 d22568 u262144
[    0.000000] Built 3 zonelists in Zone order, mobility grouping on.  Total pages: 12390583
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=scsi0:\efi\SuSE\vmlinuz-2.6.31-rja-static-31 root=/dev/sda7  nobau kdb=on console=ttyS0,115200n8 splash=silent crashkernel=256M-:128M showopts console=ttyS0,115200n8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.000000] Memory: 49368928k/150978560k available (4729k kernel code, 100699288k absent, 910344k reserved, 3319k data, 1380k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=48, Nodes=3
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:33024 nr_irqs:1200
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/mm/pageattr.c:185 change_page_attr_set_clr+0x2ee/0x3e7()
[    0.000000] Hardware name: Stoutland Platform
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rja-static-31 #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8103110e>] ? change_page_attr_set_clr+0x2ee/0x3e7
[    0.000000]  [<ffffffff81048e96>] warn_slowpath_common+0x77/0xa4
[    0.000000]  [<ffffffff81048ed2>] warn_slowpath_null+0xf/0x11
[    0.000000]  [<ffffffff8103110e>] change_page_attr_set_clr+0x2ee/0x3e7
[    0.000000]  [<ffffffff810dd32c>] ? __slab_alloc+0x1dd/0x380
[    0.000000]  [<ffffffff810312e7>] change_page_attr_clear+0x2a/0x2c
[    0.000000]  [<ffffffff81031381>] set_memory_x+0x21/0x23
[    0.000000]  [<ffffffff8180baef>] early_runtime_code_mapping_set_exec+0x6d/0x92
[    0.000000]  [<ffffffff8180bb6d>] efi_call_phys_prelog+0xe/0x59
[    0.000000]  [<ffffffff8180b282>] phys_efi_get_time+0x12/0x34
[    0.000000]  [<ffffffff81026930>] efi_get_time+0x16/0x56
[    0.000000]  [<ffffffff81011d8f>] read_persistent_clock+0x25/0x4a
[    0.000000]  [<ffffffff81815867>] timekeeping_init+0x14/0x118
[    0.000000]  [<ffffffff81814ac7>] ? softirq_init+0x9d/0xbb
[    0.000000]  [<ffffffff817fc329>] start_kernel+0x215/0x392
[    0.000000]  [<ffffffff817fba7a>] x86_64_start_reservations+0xaa/0xae
[    0.000000]  [<ffffffff817fbb5f>] x86_64_start_kernel+0xe1/0xe8
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000000] UV HACK: cpa_flush_range irqs_disabled, re-enabling
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [ttyS0] enabled
------------------------------------------------------------
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
