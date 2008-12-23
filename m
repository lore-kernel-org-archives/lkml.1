Return-Path: <linux-kernel-owner+w=401wt.eu-S1752393AbYLWVMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbYLWVMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 16:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYLWVMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 16:12:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:41141 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbYLWVMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 16:12:32 -0500
Message-ID: <495153A4.5060201@kernel.org>
Date: Tue, 23 Dec 2008 13:09:56 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu, mel@csn.ul.ie
Subject: Re: [BUG] next-20081216 - WARNING: at kernel/smp.c:333	smp_call_function_mask
References: <20081216223754.0c8e21d4.sfr@canb.auug.org.au> <20081219105441.GA19750@linux.vnet.ibm.com> <86802c440812190351q3118516aif664dd5869c21b2a@mail.gmail.com> <20081219134636.GA11772@linux.vnet.ibm.com> <494C0BF0.3080109@kernel.org> <20081223132127.GA5450@linux.vnet.ibm.com>
In-Reply-To: <20081223132127.GA5450@linux.vnet.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------030008080904070706010106"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030008080904070706010106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Kamalesh Babulal wrote:
> * Yinghai Lu <yinghai@kernel.org> [2008-12-19 13:02:40]:
> 
> 
> 	I tried testing with today's tip/master and it can be reproduced with it.
> 
> root (hd0,0)
>  Filesystem type is ext2fs, partition type 0x83
> kernel /vmlinuz-autotest root=/dev/mapper/VolGroup00-LogVol00 ro console=tty0 c
> onsole=ttyS1,19200 selinux=no debug nmi_watchdog=1 unknown_nmi_panic=1 initcall
> _debug earlyprintk=serial,ttyS1,19200 IDENT=1230036460
>    [Linux-bzImage, setup=0x3000, size=0x273c10]
> initrd /initrd-autotest
>    [Linux-initrd @ 0x37e5f000, 0x190980 bytes]
> 
> Linux version 2.6.28-rc8-autotest-tip (root@bl6-13.ltc.austin.ibm.com) (gcc version 4.1.1 20060525 (Red Hat 4.1.1-1)) #1 SMP Tue Dec 23 06:37:41 CST 2008
> Command line: root=/dev/mapper/VolGroup00-LogVol00 ro console=tty0 console=ttyS1,19200 selinux=no debug nmi_watchdog=1 unknown_nmi_panic=1 initcall_debug earlyprintk=serial,ttyS1,19200 IDENT=1230036460
> Built 1 zonelists in Node order, mobility grouping on.  Total pages: 256240
> Policy zone: DMA32
> Kernel command line: root=/dev/mapper/VolGroup00-LogVol00 ro console=tty0 console=ttyS1,19200 selinux=no debug nmi_watchdog=1 unknown_nmi_panic=1 initcall_debug earlyprintk=serial,ttyS1,19200 IDENT=1230036460
> Initializing CPU#0
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
> IP: [<ffffffff8070e46a>] init_ISA_irqs+0x18/0x53
> PGD 0 

please try attached debug patch.

Thanks

YH

--------------030008080904070706010106
Content-Type: text/x-patch;
 name="sparse_irq_fix1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sparse_irq_fix1.patch"

diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 3e070bb..41b29cf 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -180,6 +180,9 @@ void __init arch_early_irq_init(void)
 	cfg = irq_cfgx;
 	count = ARRAY_SIZE(irq_cfgx);
 
+	printk(KERN_DEBUG
+		 "calling arch_early_irq_init with count=%d\n", count);
+
 	for (i = 0; i < count; i++) {
 		desc = irq_to_desc(i);
 		desc->chip_data = &cfg[i];
diff --git a/init/main.c b/init/main.c
index f10a499..dadff40 100644
--- a/init/main.c
+++ b/init/main.c
@@ -544,10 +544,12 @@ void __init __weak thread_info_cache_init(void)
 
 void __init __weak arch_early_irq_init(void)
 {
+	printk(KERN_DEBUG "calling __weak arch_early_irq_init\n");
 }
 
 void __init __weak early_irq_init(void)
 {
+	printk(KERN_DEBUG "calling __weak early_irq_init\n");
 	arch_early_irq_init();
 }
 
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 6492400..c7f4404 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -56,10 +56,6 @@ void handle_bad_irq(unsigned int irq, struct irq_desc *desc)
 int nr_irqs = NR_IRQS;
 EXPORT_SYMBOL_GPL(nr_irqs);
 
-void __init __attribute__((weak)) arch_early_irq_init(void)
-{
-}
-
 #ifdef CONFIG_SPARSE_IRQ
 static struct irq_desc irq_desc_init = {
 	.irq	    = -1,
@@ -143,6 +139,9 @@ void __init early_irq_init(void)
 	desc = irq_desc_legacy;
 	legacy_count = ARRAY_SIZE(irq_desc_legacy);
 
+	printk(KERN_DEBUG
+		 "calling early_irq_init with legacy_count=%d\n", legacy_count);
+
 	for (i = 0; i < legacy_count; i++) {
 		desc[i].irq = i;
 		desc[i].kstat_irqs = kstat_irqs_legacy[i];

--------------030008080904070706010106--
