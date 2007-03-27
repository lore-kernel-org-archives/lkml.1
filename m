Return-Path: <linux-kernel-owner+w=401wt.eu-S1752982AbXC0Dcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbXC0Dcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 23:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbXC0Dco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 23:32:44 -0400
Received: from ozlabs.org ([203.10.76.45]:35871 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbXC0Dcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 23:32:43 -0400
Subject: Re: [patch 3/5] i386-gdt-pda Update lguest to initialize gdt
	without pda
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       xen-devel@lists.xensource.com, virtualization@lists.osdl.org
In-Reply-To: <20070327002841.672969672@goop.org>
References: <20070327002129.240126099@goop.org>
	 <20070327002841.672969672@goop.org>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 13:32:18 +1000
Message-Id: <1174966338.12230.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 17:21 -0700, Jeremy Fitzhardinge wrote:
> plain text document attachment (lguest-use-percpu.patch)

Thanks for the fixup Jeremy!

	Unfortunately that doesn't quite work.  But it turns out we don't need
to load the GDT at all: we can run off the Host-supplied one until we
load the gdt naturally.

So I prefer this patch:
===
Lguest now doesn't need to touch the GDT at all: it can run on the
Host-supplied boot gdt until it reloads later in the boot process.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
---
 arch/i386/lguest/lguest.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -r 3349222e5f58 arch/i386/lguest/lguest.c
--- a/arch/i386/lguest/lguest.c	Tue Mar 27 12:57:46 2007 +1000
+++ b/arch/i386/lguest/lguest.c	Tue Mar 27 13:28:20 2007 +1000
@@ -34,7 +34,6 @@
 #include <asm/desc.h>
 #include <asm/setup.h>
 #include <asm/e820.h>
-#include <asm/pda.h>
 #include <asm/asm-offsets.h>
 #include <asm/mce.h>
 
@@ -448,10 +447,6 @@ static void lguest_power_off(void)
 {
 	hcall(LHCALL_CRASH, __pa("Power down"), 0, 0);
 }
-
-/* From head.S */
-extern void setup_pda(void);
-extern struct Xgt_desc_struct early_gdt_descr;
 
 static __attribute_used__ __init void lguest_init(void)
 {
@@ -513,11 +508,6 @@ static __attribute_used__ __init void lg
 	/* We use top of mem for initial pagetables. */
 	init_pg_tables_end = __pa(pg0);
 
-	/* set up PDA descriptor */
-	setup_pda();
-	load_gdt(&early_gdt_descr);
-	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_PDA) : "memory");
-
 	reserve_top_address(lguest_data.reserve_mem);
 
 	cpu_detect(&new_cpu_data);


