Return-Path: <linux-kernel-owner+w=401wt.eu-S1759190AbXIYAnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190AbXIYAnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 20:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbXIYAnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 20:43:31 -0400
Received: from gw.goop.org ([64.81.55.164]:45217 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604AbXIYAna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 20:43:30 -0400
Message-ID: <46F859B2.8000209@goop.org>
Date: Mon, 24 Sep 2007 17:43:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: osth@freesurf.ch
CC: linux-kernel@vger.kernel.org
Subject: Re: Xen kernel 2.6.23-rc7 bug at xen_mc_flush (arch/i386/xen/multicalls.c:68)
References: <46E1184D0000CFD8@mta-fs-be-07.sunrise.ch>
In-Reply-To: <46E1184D0000CFD8@mta-fs-be-07.sunrise.ch>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

osth@freesurf.ch wrote:
> Using kernel 2.6.23-rc7 as xen domU client system I observe a kernel bug
> which occurs reproducibly when calling a shell from midnight commander F2
> context menu or with testcase given below  (However most other programs seem
> to
> be well behaved and do not trigger this bug). - A kernel compiled with debug
> info gives:
>   

Hm, it just seems that its trying to unpin an mm on the error path of
execve, and so it hasn't been pinned.  The simplest way to reproduce is:

$ echo foo > foo
$ chmod +x foo
$ ./foo

Anyway, try this patch.

    J

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


