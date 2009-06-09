Return-Path: <linux-kernel-owner+w=401wt.eu-S1760941AbZFIKXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760941AbZFIKXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759745AbZFIKTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:19:05 -0400
Received: from kroah.org ([198.145.64.141]:54709 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760636AbZFIKTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:19:04 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:59 2009
Message-Id: <20090609094059.232073474@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:19 -0700
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
       alan@lxorguk.ukuu.org.uk, Mel Gorman <mel@csn.ul.ie>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Ingo Molnar <mingo@elte.hu>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       <starlight@binnacle.cx>, Eric B Munson <ebmunson@us.ibm.com>,
       Adam Litke <agl@us.ibm.com>, Andy Whitcroft <apw@canonical.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 31/87] x86: ignore VM_LOCKED when determining if hugetlb-backed page tables can be shared or not
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=x86-ignore-vm_locked-when-determining-if-hugetlb-backed-page-tables-can-be-shared-or-not.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mel Gorman <mel@csn.ul.ie>

commit 32b154c0b0bae2879bf4e549d861caf1759a3546 upstream.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13302

On x86 and x86-64, it is possible that page tables are shared beween
shared mappings backed by hugetlbfs.  As part of this,
page_table_shareable() checks a pair of vma->vm_flags and they must match
if they are to be shared.  All VMA flags are taken into account, including
VM_LOCKED.

The problem is that VM_LOCKED is cleared on fork().  When a process with a
shared memory segment forks() to exec() a helper, there will be shared
VMAs with different flags.  The impact is that the shared segment is
sometimes considered shareable and other times not, depending on what
process is checking.

What happens is that the segment page tables are being shared but the
count is inaccurate depending on the ordering of events.  As the page
tables are freed with put_page(), bad pmd's are found when some of the
children exit.  The hugepage counters also get corrupted and the Total and
Free count will no longer match even when all the hugepage-backed regions
are freed.  This requires a reboot of the machine to "fix".

This patch addresses the problem by comparing all flags except VM_LOCKED
when deciding if pagetables should be shared or not for hugetlbfs-backed
mapping.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: <starlight@binnacle.cx>
Cc: Eric B Munson <ebmunson@us.ibm.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/hugetlbpage.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -26,12 +26,16 @@ static unsigned long page_table_shareabl
 	unsigned long sbase = saddr & PUD_MASK;
 	unsigned long s_end = sbase + PUD_SIZE;
 
+	/* Allow segments to share if only one is marked locked */
+	unsigned long vm_flags = vma->vm_flags & ~VM_LOCKED;
+	unsigned long svm_flags = svma->vm_flags & ~VM_LOCKED;
+
 	/*
 	 * match the virtual addresses, permission and the alignment of the
 	 * page table page.
 	 */
 	if (pmd_index(addr) != pmd_index(saddr) ||
-	    vma->vm_flags != svma->vm_flags ||
+	    vm_flags != svm_flags ||
 	    sbase < svma->vm_start || svma->vm_end < s_end)
 		return 0;
 


