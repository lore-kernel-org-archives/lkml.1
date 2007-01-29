Return-Path: <linux-kernel-owner+w=401wt.eu-S1752027AbXA2UTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbXA2UTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 15:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbXA2UTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 15:19:38 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47808 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbXA2UTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 15:19:37 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Auke Kok <auke-jan.h.kok@intel.com>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH] i386: In assign_irq_vector look at all vectors before giving up
References: <45BA82DA.6050201@intel.com>
	<m1bqkku8bp.fsf@ebiederm.dsl.xmission.com>
	<45BE443B.3080407@intel.com>
	<Pine.LNX.4.64.0701291135080.3611@woody.linux-foundation.org>
Date: Mon, 29 Jan 2007 13:19:05 -0700
In-Reply-To: <Pine.LNX.4.64.0701291135080.3611@woody.linux-foundation.org>
	(Linus Torvalds's message of "Mon, 29 Jan 2007 11:36:22 -0800 (PST)")
Message-ID: <m1k5z5io1y.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When the world was a simple and static place setting up irqs was easy.
It sufficed to allocate a linux irq number and a find a free cpu
vector we could receive that linux irq on.  In those days it was
a safe assumption that any allocated vector was actually in use
so after one global pass through all of the vectors we would have
none left.

These days things are much more dynamic with interrupt controllers
(in the form of MSI or MSI-X) appearing on plug in cards and linux
irqs appearing and disappearing.  As these irqs come and go vectors
are allocated and freed,  invalidating the ancient assumption that all
allocated vectors stayed in use forever.

So this patch modifies the vector allocator to walk through every
possible vector before giving up, and to check to see if a vector
is in use before assigning it.  With these changes we stop leaking
freed vectors and it becomes possible to allocate and free irq vectors
all day long.

This changed was modeled after the vector allocator on x86_64 where
this limitation has already been removed.  In essence we don't update
the static variables that hold the position of the last vector we
allocated until have successfully allocated another vector.  This
allows us to detect if we have completed one complete scan through
all of the possible vectors.

Acked-by: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

---
 arch/i386/kernel/io_apic.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

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
-- 
1.4.4.1.g278f

