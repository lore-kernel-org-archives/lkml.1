Return-Path: <linux-kernel-owner+w=401wt.eu-S934557AbZIEAdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934557AbZIEAdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934532AbZIEAdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:33:47 -0400
Received: from kroah.org ([198.145.64.141]:42057 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934546AbZIEAUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:32 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:47 2009
Message-Id: <20090905001447.691518033@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:13:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 05/71] x86: dont call ->send_IPI_mask() with an empty mask
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=x86-don-t-call-send_ipi_mask-with-an-empty-mask.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Linus Torvalds <torvalds@linux-foundation.org>

commit b04e6373d694e977c95ae0ae000e2c1e2cf92d73 upstream.

As noted in 83d349f35e1ae72268c5104dbf9ab2ae635425d4 ("x86: don't send
an IPI to the empty set of CPU's"), some APIC's will be very unhappy
with an empty destination mask.  That commit added a WARN_ON() for that
case, and avoided the resulting problem, but didn't fix the underlying
reason for why those empty mask cases happened.

This fixes that, by checking the result of 'cpumask_andnot()' of the
current CPU actually has any other CPU's left in the set of CPU's to be
sent a TLB flush, and not calling down to the IPI code if the mask is
empty.

The reason this started happening at all is that we started passing just
the CPU mask pointers around in commit 4595f9620 ("x86: change
flush_tlb_others to take a const struct cpumask"), and when we did that,
the cpumask was no longer thread-local.

Before that commit, flush_tlb_mm() used to create it's own copy of
'mm->cpu_vm_mask' and pass that copy down to the low-level flush
routines after having tested that it was not empty.  But after changing
it to just pass down the CPU mask pointer, the lower level TLB flush
routines would now get a pointer to that 'mm->cpu_vm_mask', and that
could still change - and become empty - after the test due to other
CPU's having flushed their own TLB's.

See

	http://bugzilla.kernel.org/show_bug.cgi?id=13933

for details.

Tested-by: Thomas Björnell <thomas.bjornell@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/tlb.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -183,18 +183,17 @@ static void flush_tlb_others_ipi(const s
 
 	f->flush_mm = mm;
 	f->flush_va = va;
-	cpumask_andnot(to_cpumask(f->flush_cpumask),
-		       cpumask, cpumask_of(smp_processor_id()));
+	if (cpumask_andnot(to_cpumask(f->flush_cpumask), cpumask, cpumask_of(smp_processor_id()))) {
+		/*
+		 * We have to send the IPI only to
+		 * CPUs affected.
+		 */
+		apic->send_IPI_mask(to_cpumask(f->flush_cpumask),
+			      INVALIDATE_TLB_VECTOR_START + sender);
 
-	/*
-	 * We have to send the IPI only to
-	 * CPUs affected.
-	 */
-	apic->send_IPI_mask(to_cpumask(f->flush_cpumask),
-		      INVALIDATE_TLB_VECTOR_START + sender);
-
-	while (!cpumask_empty(to_cpumask(f->flush_cpumask)))
-		cpu_relax();
+		while (!cpumask_empty(to_cpumask(f->flush_cpumask)))
+			cpu_relax();
+	}
 
 	f->flush_mm = NULL;
 	f->flush_va = 0;


