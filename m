Return-Path: <linux-kernel-owner+w=401wt.eu-S936454AbZAOWqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936454AbZAOWqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933781AbZAOWEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:04:04 -0500
Received: from kroah.org ([198.145.64.141]:39134 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933670AbZAOWDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:03:55 -0500
Date: Thu, 15 Jan 2009 14:01:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andi Kleen <ak@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 79/85] x86: avoid theoretical vmalloc fault loop
Message-ID: <20090115220159.GB17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-avoid-theoretical-vmalloc-fault-loop.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andi Kleen <andi@firstfloor.org>

commit f313e12308f7c5ea645f18e759d104d088b18615 upstream.

Ajith Kumar noticed:

 I was going through the vmalloc fault handling for x86_64 and am unclear
 about the following lines in the vmalloc_fault() function.

 pgd = pgd_offset(current->mm ?: &init_mm, address);
 pgd_ref = pgd_offset_k(address);

 Here the intention is to get the pgd corresponding to the current process
 and sync it up with the pgd in init_mm(obtained from pgd_offset_k).
 However, for kernel threads current->mm is NULL and hence pgd =
 pgd_offset(init_mm, address) = pgd_ref which means the fault handler
 returns without setting the pgd entry in the MM structure in the context
 of which the kernel thread has faulted.  This could lead to never-ending
 faults and busy looping of kernel threads like pdflush.  So, shouldn't the
 pgd = pgd_offset(current->mm ?: &init_mm, address); be pgd =
 pgd_offset(current->active_mm ?: &init_mm, address);

We can use active_mm unconditionally because it should be always set.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/fault.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -534,7 +534,7 @@ static int vmalloc_fault(unsigned long a
 	   happen within a race in page table update. In the later
 	   case just flush. */
 
-	pgd = pgd_offset(current->mm ?: &init_mm, address);
+	pgd = pgd_offset(current->active_mm, address);
 	pgd_ref = pgd_offset_k(address);
 	if (pgd_none(*pgd_ref))
 		return -1;

