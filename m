Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbYLKAVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbYLKAVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 19:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYLKAVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 19:21:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:35527 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbYLKAVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 19:21:42 -0500
Message-ID: <49405CB6.6010006@kernel.org>
Date: Wed, 10 Dec 2008 16:20:06 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Huang Ying <ying.huang@intel.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "norman@thebacks.co.uk" <norman@thebacks.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Alok Kataria <alokkataria1@gmail.com>,
       =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <"bruno .premont"@restena.lu>,
       "xl@xlsigned.net" <xl@xlsigned.net>, "dsd@gentoo.org" <dsd@gentoo.org>
Subject: Re: [PATCH] Fix VMI crash on boot in 2.6.27+ kernels
References: <1228870222.8766.15.camel@bodhitayantram.eng.vmware.com>	 <86802c440812091715r775d514eh3acf9add9e24184e@mail.gmail.com> <1228953980.8766.42.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1228953980.8766.42.camel@bodhitayantram.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> On Tue, 2008-12-09 at 17:15 -0800, Yinghai Lu wrote:
> 
>> you can not move that late,
>>
>> parse_setup_data==>early_memremap==>__early_ioremap
> 
> How does this look?
> 

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9d5674f..4c381cb 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -794,6 +794,11 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
 
+#ifdef CONFIG_VMI
+	/* VMI may relocate the fixmap; do this before touching ioremap area */
+	vmi_init();
+#endif
+
 	early_cpu_init();
 	early_ioremap_init();
 
@@ -880,12 +885,9 @@ void __init setup_arch(char **cmdline_p)
 	check_efer();
 #endif
 
-#if defined(CONFIG_VMI) && defined(CONFIG_X86_32)
-	/*
-	 * Must be before kernel pagetables are setup
-	 * or fixmap area is touched.
-	 */
-	vmi_init();
+#if defined(CONFIG_VMI)
+	/* Must be before kernel pagetables are setup */
+	vmi_activate();
 #endif
 
 	/* after early param, so could get panic from serial */
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 8b6c393..22fd657 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -960,8 +960,6 @@ static inline int __init activate_vmi(void)
 
 void __init vmi_init(void)
 {
-	unsigned long flags;
-
 	if (!vmi_rom)
 		probe_vmi_rom();
 	else
@@ -973,13 +971,21 @@ void __init vmi_init(void)
 
 	reserve_top_address(-vmi_rom->virtual_top);


it seems still have some problem.
you moved reserve_top_address before parse_parameter...

so
void __init reserve_top_address(unsigned long reserve)
{
        BUG_ON(fixmaps_set > 0);
        printk(KERN_INFO "Reserving virtual address space above 0x%08x\n",
               (int)-reserve);
        __FIXADDR_TOP = -reserve - PAGE_SIZE;
        __VMALLOC_RESERVE += reserve;
}

/*
 * vmalloc=size forces the vmalloc area to be exactly 'size'
 * bytes. This can be used to increase (or decrease) the
 * vmalloc area - the default is 128m.
 */
static int __init parse_vmalloc(char *arg)
{
        if (!arg)
                return -EINVAL;

        /* Add VMALLOC_OFFSET to the parsed value due to vm area guard hole*/
        __VMALLOC_RESERVE = memparse(arg, &arg) + VMALLOC_OFFSET;
        return 0;
}
early_param("vmalloc", parse_vmalloc);

__VMALLOC_RESERVE will be overwriten by vmalloc=...

you may need to split reserve_top_address() to two functions...

YH

