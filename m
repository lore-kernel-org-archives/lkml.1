Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbYAIDzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbYAIDzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 22:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYAIDzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 22:55:40 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:28602 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbYAIDzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 22:55:39 -0500
Date: Wed, 9 Jan 2008 04:55:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: More breakage in native_rdtsc out of line in git-x86
Message-ID: <20080109035534.GA30321@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 09 Jan 2008 03:49:25.0901 (UTC) FILETIME=[A0E28BD0:01C85272]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I had some boot failures here with git-x86 with init and hotplug all 
segfaulting early on userland with new glibc.  Bisecting found

commit 6aea5bc37fa790eaf3a942f0785985914568e214
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sat Jan 5 13:27:08 2008 +0100

    x86: move native_read_tsc() offline
    
    move native_read_tsc() offline.

I think the problem is that the vsyscall/vdso code calls it through
vread and for that it has to be exported. There seems to be also
another bug with the old style vsyscalls not using the TSC vread
that masks it on older glibc

Stepping with gdb through old style vgettimeofday() confirms that RDTSC is 
not used.

A long time ago we had a similar problem once and it was because of a 
problem exporting the vsyscall variables in vmlinux.lds.S -- looks like that 
has reappeared.

I think the new glibc shows it because it uses the vDSO not 
the older vsyscall and the new vDSO probably still works. Anyways haven't 
investigated why that is in detail yet, but that's a separate 
regression.

Back to the boot failure:

Unfortunately simply adding __vsyscall_fn to native_read_tsc doesn't 
work -- causes early kernel faults like

PANIC: early exception rip ffffffffff600105 error 10 cr2 ffffffffff600105
Pid: 0, comm: swapper Not tainted 2.6.24-rc6 #58

Call Trace:
 [<ffffffff80211dec>] native_sched_clock+0x9/0x3f
 [<ffffffff8022b758>] init_idle+0x33/0xd1
 [<ffffffff80825449>] sched_init+0x26d/0x283
 [<ffffffff80815899>] start_kernel+0x10b/0x2bd
 [<ffffffff80815114>] _sinittext+0x114/0x11b

Not sure why that is -- in theory the vsyscall functions should be callable 
from the main kernel. Might be a binutils problem or another code
regression.

Anyways it looks like the only good fix is to either revert that or
fork into two functions one for vread() and another for normal tsc ->read()

This is all in addition to the problem of it having incorrect barriers.
I note that my original patch didn't have any of these problems.

I'm using the appended revert patch here as a workaround for now.

-Andi


Revert rdtsc out of line change

Reverts 

commit 6aea5bc37fa790eaf3a942f0785985914568e214
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sat Jan 5 13:27:08 2008 +0100

    x86: move native_read_tsc() offline

    move native_read_tsc() offline.

The function is called by vsyscalls in ring 3, so it can't be out of line this way.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/x86/kernel/rtc.c
===================================================================
--- linux.orig/arch/x86/kernel/rtc.c
+++ linux/arch/x86/kernel/rtc.c
@@ -194,14 +194,3 @@ int update_persistent_clock(struct times
 {
 	return set_rtc_mmss(now.tv_sec);
 }
-
-unsigned long long native_read_tsc(void)
-{
-	DECLARE_ARGS(val, low, high);
-
-	asm volatile("rdtsc" : EAX_EDX_RET(val, low, high));
-	rdtsc_barrier();
-
-	return EAX_EDX_VAL(val, low, high);
-}
-
Index: linux/include/asm-x86/msr.h
===================================================================
--- linux.orig/include/asm-x86/msr.h
+++ linux/include/asm-x86/msr.h
@@ -91,7 +91,13 @@ static inline int native_write_msr_safe(
 	return err;
 }
 
-extern unsigned long long native_read_tsc(void);
+static inline unsigned long long native_read_tsc(void)
+{
+	DECLARE_ARGS(val, low, high);
+
+	asm volatile("rdtsc" : EAX_EDX_RET(val, low, high));
+	return EAX_EDX_VAL(val, low, high);
+}
 
 static inline unsigned long long native_read_pmc(int counter)
 {


