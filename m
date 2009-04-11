Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbZDKDFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbZDKDFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 23:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbZDKDFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 23:05:04 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45522 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbZDKDFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 23:05:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LCuiTdbv4s4pQewyQJ9Zxzi9d0t2FKqlB4UqOopxFONqWBc5dJWmcS/zLtjfulzdi0
         sZZxpO9nfU0Oc4gJqf5EsctuYoW2T4s2s4QZCF+bwIld7HLWsvfwqSai+Kr3KgZFVziC
         +INKpDHFavYJU0gVcZbRGRac8bHjPFuLJBYTA=
MIME-Version: 1.0
Date: Sat, 11 Apr 2009 09:04:59 +0600
Message-ID: <b9df5fa10904102004g51265d9axc8d07278bfdb6ba0@mail.gmail.com>
Subject: [PATCH] x86: Fix section mismatches in mpparse.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix section mismatch

In arch/x86/kernel/mpparse.c, smp_reserve_bootmem() has been called
and also refers to a function which is in .init section. Thus causes
the first warning. And check_irq_src() also requires an __init,
because it refers to an .init section.

Thanks

  LD      arch/x86/kernel/built-in.o
WARNING: arch/x86/kernel/built-in.o(.text+0x10881): Section mismatch
in reference from the function smp_reserve_bootmem() to the function
.init.text:get_mpc_size()
The function smp_reserve_bootmem() references
the function __init get_mpc_size().
This is often because smp_reserve_bootmem lacks a __init
annotation or the annotation of get_mpc_size is wrong.

WARNING: arch/x86/kernel/built-in.o(.text+0x108d9): Section mismatch
in reference from the function check_irq_src() to the function
.init.text:get_MP_intsrc_index()
The function check_irq_src() references
the function __init get_MP_intsrc_index().
This is often because check_irq_src lacks a __init
annotation or the annotation of get_MP_intsrc_index is wrong.

WARNING: arch/x86/kernel/built-in.o(.text+0x108ed): Section mismatch
in reference from the function check_irq_src() to the function
.init.text:assign_to_mpc_intsrc()
The function check_irq_src() references
the function __init assign_to_mpc_intsrc().
This is often because check_irq_src lacks a __init
annotation or the annotation of assign_to_mpc_intsrc is wrong.

WARNING: arch/x86/kernel/built-in.o(.text+0x10908): Section mismatch
in reference from the function check_irq_src() to the function
.init.text:print_mp_irq_info()
The function check_irq_src() references
the function __init print_mp_irq_info().
This is often because check_irq_src lacks a __init
annotation or the annotation of print_mp_irq_info is wrong.

WARNING: arch/x86/kernel/built-in.o(.text+0x1091a): Section mismatch
in reference from the function check_irq_src() to the variable
.init.data:m_spare
The function check_irq_src() references
the variable __initdata m_spare.
This is often because check_irq_src lacks a __initdata
annotation or the annotation of m_spare is wrong.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/arch/x86/kernel/mpparse.c	2009-04-10 22:28:49.000000000 +0600
+++ rakib/arch/x86/kernel/mpparse.c	2009-04-10 23:15:36.975376512 +0600
@@ -679,7 +679,7 @@ void __init get_smp_config(void)
 	__get_smp_config(0);
 }

-static void smp_reserve_bootmem(struct mpf_intel *mpf)
+static void __init smp_reserve_bootmem(struct mpf_intel *mpf)
 {
 	unsigned long size = get_mpc_size(mpf->physptr);
 #ifdef CONFIG_X86_32
@@ -838,7 +838,7 @@ static int  __init get_MP_intsrc_index(s

 static struct mpc_intsrc __initdata *m_spare[SPARE_SLOT_NUM];

-static void check_irq_src(struct mpc_intsrc *m, int *nr_m_spare)
+static void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare)
 {
 	int i;

@@ -866,7 +866,8 @@ static void check_irq_src(struct mpc_int
 	}
 }
 #else /* CONFIG_X86_IO_APIC */
-static inline void check_irq_src(struct mpc_intsrc *m, int *nr_m_spare) {}
+static
+inline void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare) {}
 #endif /* CONFIG_X86_IO_APIC */

 static int check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length,
