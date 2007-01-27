Return-Path: <linux-kernel-owner+w=401wt.eu-S1752213AbXA0J3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbXA0J3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 04:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbXA0J3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 04:29:33 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38821 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbXA0J3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 04:29:32 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Auke Kok <auke-jan.h.kok@intel.com>
Cc: linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ebiederm@xmission.com, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: Possible regression: MSI vector leakage since 2.6.18-rc5ish (Unable to repeatedly allocate/free MSI interrupt)
References: <45BA82DA.6050201@intel.com>
Date: Sat, 27 Jan 2007 02:28:58 -0700
In-Reply-To: <45BA82DA.6050201@intel.com> (Auke Kok's message of "Fri, 26 Jan
	2007 14:38:18 -0800")
Message-ID: <m1bqkku8bp.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Auke Kok <auke-jan.h.kok@intel.com> writes:

> Hi,
>
> I've established a regression in the MSI vector/irq allocation routine for both
> i386 and x86_64. Our test labs repeatedly modprobe/rmmod the e1000 driver for
> serveral minutes which allocates msi vectors and frees them. These tests have
> been running fine until 2.6.19.
>
> git-bisecting I've established that in between commit
> 04b9267b15206fc902a18de1f78de6c82ca47716 "Eric W. Biederman -- genirq: x86_64
> irq: Remove the msi assumption that irq == vector" and commit
> f29bd1ba68c8c6a0f50bd678bbd5a26674018f7c "Ingo Molnar -- genirq: convert the
> x86_64 architecture to irq-chips" the behaviour broke.
>
> The revisions in between seem to be dependent and give all sorts of other
> issues, so it's rather hard for me to bisect that and give trustworthy results.
>
> the e1000 driver hits the 256-mark cycle (I think - it consistently refuses to
> do 500 msi irq/vector allocations which is my test case) and throws:
>
> e1000: eth4: e1000_request_irq: Unable to allocate MSI interrupt Error: -16
>
> which is caused by a `if ((err = pci_enable_msi(adapter->pdev))) {` call from
> the e1000 driver. It's rather easy to hit this mark with the new 4-port e1000
> adapters :).
>
> as for the e1000 code, I can say that even our oldest msi-enabled e1000 driver
> works fine with 2.6.18 and under. All kernels from 2.6.19 fail consistently.
>
> I mostly suspect commit 7bd007e480672c99d8656c7b7b12ef0549432c37 at the
> moment. Perhaps Eric Biederman can help?
>
> Cheers,
>
> Auke
>

Does this patch fix it for you?  It looks like i386 vector allocate
did not have logic to look through the set of vectors more than once.

The code in this patch is a simplified version of what we have
on x86_64.

Eric


diff --git a/arch/i386/kernel/io_apic.c b/arch/i386/kernel/io_apic.c
index 2424cc9..6a3875f 100644
--- a/arch/i386/kernel/io_apic.c
+++ b/arch/i386/kernel/io_apic.c
@@ -1227,26 +1227,32 @@ static u8 irq_vector[NR_IRQ_VECTORS] __read_mostly = { FIRST_DEVICE_VECTOR , 0 }
 
 static int __assign_irq_vector(int irq)
 {
-	static int current_vector = FIRST_DEVICE_VECTOR, offset = 0;
-	int vector;
+	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
+	int vector, offset, i;
 
 	BUG_ON((unsigned)irq >= NR_IRQ_VECTORS);
 
 	if (irq_vector[irq] > 0)
 		return irq_vector[irq];
 
-	current_vector += 8;
-	if (current_vector == SYSCALL_VECTOR)
-		current_vector += 8;
-
-	if (current_vector >= FIRST_SYSTEM_VECTOR) {
-		offset++;
-		if (!(offset % 8))
-			return -ENOSPC;
-		current_vector = FIRST_DEVICE_VECTOR + offset;
-	}
-
 	vector = current_vector;
+	offset = current_offset;
+next:
+	vector += 8;
+	if (vector >= FIRST_SYSTEM_VECTOR) {
+		offset = (offset + 1) % 8;
+		vector = FIRST_DEVICE_VECTOR + offset;
+	}
+	if (vector == current_vector)
+		return -ENOSPC;
+	if (vector == SYSCALL_VECTOR)
+		goto next;
+	for (i = 0; i < NR_IRQ_VECTORS; i++)
+		if (irq_vector[i] == vector)
+			goto next;
+
+	current_vector = vector;
+	current_offset = offset;
 	irq_vector[irq] = vector;
 
 	return vector;
