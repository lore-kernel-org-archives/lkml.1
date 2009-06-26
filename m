Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbZFZPrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbZFZPrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 11:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbZFZPrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 11:47:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54238 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbZFZPrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 11:47:45 -0400
Date: Fri, 26 Jun 2009 17:47:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/9] x86: introduce a set of platform feature flags
Message-ID: <20090626154731.GA3153@elte.hu>
References: <43F901BD926A4E43B106BF17856F07556412B7E1@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43F901BD926A4E43B106BF17856F07556412B7E1@orsmsx508.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pan, Jacob jun <jacob.jun.pan@intel.com> wrote:

> +/* X86 base platform features, include PC, legacy free MID devices, etc.
> + * This list provides early and important information to the kernel in a
> + * centralized place such that kernel can make a decision on the best
> + * choice of which system devices to use. e.g. timers or interrupt
> + * controllers.
> + */
> +#define X86_PLATFORM_FEATURE_8259		(0*32+0) /* i8259A PIC */
> +#define X86_PLATFORM_FEATURE_8254		(0*32+1) /* i8253/4 PIT */
> +#define X86_PLATFORM_FEATURE_IOAPIC		(0*32+2) /* IO-APIC */
> +#define X86_PLATFORM_FEATURE_HPET		(0*32+3) /* HPET timer */
> +#define X86_PLATFORM_FEATURE_RTC		(0*32+4) /* real time clock*/
> +#define X86_PLATFORM_FEATURE_FLOPPY		(0*32+5) /* ISA floppy */
> +#define X86_PLATFORM_FEATURE_ISA		(0*32+6) /* ISA/LPC bus */
> +#define X86_PLATFORM_FEATURE_BIOS		(0*32+7) /* BIOS service,
> +							   *  e.g. int calls
> +							   *  EBDA, etc.
> +							   */
> +#define X86_PLATFORM_FEATURE_ACPI		(0*32+8) /* has ACPI support */
> +#define X86_PLATFORM_FEATURE_SFI		(0*32+9) /* has SFI support */
> +#define X86_PLATFORM_FEATURE_8042		(0*32+10) /* i8042 KBC */

Btw., this enumeration of basic PC features isnt bad in itself - and 
if there's a boot-flag based detection method (like on MRST) then 
this can convey a 'should this platform driver attempt to 
initialize' information to the driver, and rather cleanly so.

But there's bad uses of this as well, and those bad uses seem to 
dominate this patch-set. For example:

@@ -504,7 +514,11 @@ static void add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin

        entry = cfg->irq_2_pin;
        if (!entry) {
-               entry = get_one_free_irq_2_pin(node);
+               /* Setup APB timer 0 is prior to kzalloc() becomes ready */
+               if (platform_has(X86_PLATFORM_FEATURE_APBT) && (!pin)) {
+                       entry = get_one_free_irq_2_pin_early(node);
+               } else
+                       entry = get_one_free_irq_2_pin(node);

 static inline void mach_prepare_counter(void)
 {
-	/* Set the Gate high, disable speaker */
-	outb((inb(0x61) & ~0x02) | 0x01, 0x61);
+       if (platform_has(X86_PLATFORM_FEATURE_APBT)) {
+               apbt_prepare_count(CALIBRATE_TIME_MSEC);
+               return;
+       }
+       /* Set the Gate high, disable speaker */
+       if (platform_has(X86_PLATFORM_FEATURE_8254))
+               outb((inb(0x61) & ~0x02) | 0x01, 0x61);


 static inline void mach_countup(unsigned long *count_p)
 {
        unsigned long count = 0;
+       if (platform_has(X86_PLATFORM_FEATURE_APBT)) {
+               apbt_countup(count_p);
+               return;
+       }
        do {
            	count++;
       	} while ((inb_p(0x61) & 0x20) == 0);


Basically, if you see two different pieces of hardware used in the 
same function, next to each other, separated by some 'if 
(platform_has)' (or other flaggery) that's a clear sign that this 
bit should be abstracted out.

Bits that delimit initialization:

@@ -29,7 +31,9 @@ void __init i386_start_kernel(void)
                reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
       	}
 #endif
-	reserve_ebda_region();
+
+       if (platform_has(X86_PLATFORM_FEATURE_BIOS))
+               reserve_ebda_region();

Should probably be pushed out into x86_quirks, to give other 
subarchitectures a chance to turn off EBDA scanning as well.

and generally, instead of open-coding the check:

 #ifdef CONFIG_X86_32
-	probe_roms();
+	if (platform_has(X86_PLATFORM_FEATURE_BIOS))
+               probe_roms();
 #endif

it would be cleaner to add a:

	if (!platform_has(X86_PLATFORM_FEATURE_BIOS))
		return;

early into probe_roms().

	Ingo
