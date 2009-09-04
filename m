Return-Path: <linux-kernel-owner+w=401wt.eu-S933963AbZIDUNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933963AbZIDUNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933954AbZIDUNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:13:37 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:60230 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933952AbZIDUNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:13:37 -0400
Subject: Re: [PATCH: x86] Print the hypervisor returned tsc_khz during boot.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090904074938.GE20598@elte.hu>
References: <1251076103.29422.32.camel@ank32.eng.vmware.com>
	 <20090904074938.GE20598@elte.hu>
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 04 Sep 2009 13:13:39 -0700
Message-Id: <1252095219.12518.13.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>...

> Makes sense. Note, arch/x86/kernel/tsc.c changed recently so this 
> patch does not apply anymore - mind merging it on top of that and 
> re-send it?

Sure, here is the one which fits on top of current tip. 

I also added a print statement for the case where the TSC frequecy
cannot be read from vmware's hypervisor.

Thanks.
--

On an AMD-64 system the processor frequency that is printed during
system boot, may be different than the tsc frequency that was returned
by the hypervisor, due to the value returned from calibrate_cpu. For
debugging timekeeping or other related issues it might be better to get
the tsc_khz value returned by the hypervisor.

The patch below now prints the tsc frequency that the VMware hypervisor
returned. Please consider for tip.

---
Signed-off-by: Alok N Kataria <akataria@vmware.com>

Index: linux-x86-tree.git/arch/x86/kernel/cpu/vmware.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/kernel/cpu/vmware.c	2009-09-04 12:59:45.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/cpu/vmware.c	2009-09-04 13:01:41.000000000 -0700
@@ -58,6 +58,9 @@ static unsigned long vmware_get_tsc_khz(
 	tsc_hz = eax | (((uint64_t)ebx) << 32);
 	do_div(tsc_hz, 1000);
 	BUG_ON(tsc_hz >> 32);
+	printk(KERN_INFO "TSC freq read from hypervisor : %lu.%03lu MHz\n",
+			 (unsigned long) tsc_hz / 1000,
+			 (unsigned long) tsc_hz % 1000);
 	return tsc_hz;
 }
 
@@ -69,6 +72,9 @@ void __init vmware_platform_setup(void)
 
 	if (ebx != UINT_MAX)
 		x86_platform.calibrate_tsc = vmware_get_tsc_khz;
+	else
+		printk(KERN_WARNING
+		       "Failed to get TSC freq from the hypervisor\n");
 }
 
 /*


