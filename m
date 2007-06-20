Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbXFTMC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbXFTMC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 08:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbXFTMCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 08:02:20 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:28044
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753093AbXFTMCT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 08:02:19 -0400
Message-Id: <46793389.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 20 Jun 2007 13:02:49 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <yhlu.kernel@gmail.com>, "Andi Kleen" <ak@suse.de>
Cc: <torvalds@osdl.org>, <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: Re: [patches] [PATCH for 2.6.22] [10/10] x86_64: fix link
	warningbetween for .text and .init.text
References: <200706201223.443613000@suse.de>
 <20070620102339.2812014ACF@wotan.suse.de>
In-Reply-To: <20070620102339.2812014ACF@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the right way I think. With mtrr_bp_init being __init, get_mtrr_state
can then also be __init, making the other two changes unnecessary. I had
submitted a patch to that effect about a week ago. Beyond that patch, as
I now looked at this again, it would seem to me that print_fixed can then in
fact also be __init (rather than being __cpuinit).

Jan

>>> Andi Kleen <ak@suse.de> 20.06.07 12:23 >>>

From: "Yinghai Lu" <yhlu.kernel@gmail.com>

WARNING: arch/x86_64/kernel/built-in.o(.text+0xace9): Section
mismatch: reference to .init.text: (between 'get_mtrr_state' and
'mtrr_wrmsr')
WARNING: arch/x86_64/kernel/built-in.o(.text+0xad09): Section
mismatch: reference to .init.text: (between 'get_mtrr_state' and
'mtrr_wrmsr')
WARNING: arch/x86_64/kernel/built-in.o(.text+0xad38): Section
mismatch: reference to .init.text: (between 'get_mtrr_state' and
'mtrr_wrmsr')
WARNING: drivers/built-in.o(.text+0x3a680): Section mismatch:
reference to .init.text:acpi_map_pxm_to_node (between 'acpi_get_node'
and 'acpi_lock_ac_dir')

AK: also marked mtrr_bp_init __init to avoid some more warnings

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/cpu/mtrr/generic.c |    4 ++--
 arch/i386/kernel/cpu/mtrr/main.c    |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux/arch/i386/kernel/cpu/mtrr/generic.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mtrr/generic.c
+++ linux/arch/i386/kernel/cpu/mtrr/generic.c
@@ -42,7 +42,7 @@ static int mtrr_show;
 module_param_named(show, mtrr_show, bool, 0);
 
 /*  Get the MSR pair relating to a var range  */
-static void __init
+static void
 get_mtrr_var_range(unsigned int index, struct mtrr_var_range *vr)
 {
 	rdmsr(MTRRphysBase_MSR(index), vr->base_lo, vr->base_hi);
@@ -68,7 +68,7 @@ void mtrr_save_fixed_ranges(void *info)
 	get_fixed_ranges(mtrr_state.fixed_ranges);
 }
 
-static void __cpuinit print_fixed(unsigned base, unsigned step, const mtrr_type*types)
+static void print_fixed(unsigned base, unsigned step, const mtrr_type*types)
 {
 	unsigned i;
 
Index: linux/arch/i386/kernel/cpu/mtrr/main.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mtrr/main.c
+++ linux/arch/i386/kernel/cpu/mtrr/main.c
@@ -644,7 +644,7 @@ static struct sysdev_driver mtrr_sysdev_
  * initialized (i.e. before smp_init()).
  * 
  */
-void mtrr_bp_init(void)
+__init void mtrr_bp_init(void)
 {
 	init_ifs();
 

_______________________________________________
patches mailing list
patches@x86-64.org 
https://www.x86-64.org/mailman/listinfo/patches 


