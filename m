Return-Path: <linux-kernel-owner+w=401wt.eu-S1756462AbZDXIBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462AbZDXIBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 04:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbZDXIBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 04:01:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:3771 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbZDXIBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 04:01:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,240,1239001200"; 
   d="scan'208";a="406442833"
Date: Fri, 24 Apr 2009 10:00:55 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: mingo@elte.hu, a.p.zijlstra@chello.nl, akpm@linux-foundation.org
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       hpa@zytor.com
Subject: [rfc 2/2] x86, bts: use physically non-contiguous trace buffer
Message-ID: <20090424100055.A30408@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use vmalloc to allocate the branch trace buffer.

Peter Zijlstra suggested to use vmalloc rather than kmalloc to
allocate the potentially multi-page branch trace buffer.

Is there a way to have vmalloc allocate a physically non-contiguous
buffer for test purposes? Ideally, the memory area would have big
holes in it with sensitive data in between so I would know immediately
when this is overwritten.


Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/kernel/ptrace.c |    5 	3 +	2 -	0 !
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: b/arch/x86/kernel/ptrace.c
===================================================================
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -22,6 +22,7 @@
 #include <linux/seccomp.h>
 #include <linux/signal.h>
 #include <linux/workqueue.h>
+#include <linux/vmalloc.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -626,7 +627,7 @@ static int alloc_bts_buffer(struct bts_c
 	if (err < 0)
 		return err;
 
-	buffer = kzalloc(size, GFP_KERNEL);
+	buffer = vmalloc(size);
 	if (!buffer)
 		goto out_refund;
 
@@ -646,7 +647,7 @@ static inline void free_bts_buffer(struc
 	if (!context->buffer)
 		return;
 
-	kfree(context->buffer);
+	vfree(context->buffer);
 	context->buffer = NULL;
 
 	refund_locked_memory(context->mm, context->size);
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

