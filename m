Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbXIYSuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbXIYSuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 14:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbXIYSuC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 14:50:02 -0400
Received: from gw.goop.org ([64.81.55.164]:39809 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbXIYSuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 14:50:00 -0400
Message-ID: <46F95858.40206@goop.org>
Date: Tue, 25 Sep 2007 11:50:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, osth@freesurf.ch
Subject: [PATCH] xen: execve's error paths don't pin the mm before unpinning
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

execve's error paths don't activate (and therefore pin) the mm before
calling exit_mmap to free it up, so don't try to unpin unless it is
actually pinned.  This prevents a BUG_ON from triggering.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: osth@freesurf.ch

---
 arch/i386/xen/mmu.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

===================================================================
--- a/arch/i386/xen/mmu.c
+++ b/arch/i386/xen/mmu.c
@@ -558,6 +558,9 @@ void xen_exit_mmap(struct mm_struct *mm)
 	put_cpu();
 
 	spin_lock(&mm->page_table_lock);
-	xen_pgd_unpin(mm->pgd);
+
+	/* pgd may not be pinned in the error exit path of execve */
+	if (PagePinned(virt_to_page(mm->pgd)))
+		xen_pgd_unpin(mm->pgd);
 	spin_unlock(&mm->page_table_lock);
 }


