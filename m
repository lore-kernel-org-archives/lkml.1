Return-Path: <linux-kernel-owner+w=401wt.eu-S1030608AbXCSVlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030608AbXCSVlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030360AbXCSVkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:40:36 -0400
Received: from mail.suse.de ([195.135.220.2]:55576 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965028AbXCSVkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:40:14 -0400
Date: Mon, 19 Mar 2007 14:38:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, npiggin@suse.de, hugh@veritas.com,
       pbadari@us.ibm.com
Subject: [patch 09/31] mm: fix madvise infinine loop
Message-ID: <20070319213821.GK9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mm-fix-madvise-infinine-loop.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nick Piggin <npiggin@suse.de>

madvise(MADV_REMOVE) can go into an infinite loop or cause an oops if the
call covers a region from the start of a vma, and extending past that vma.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Acked-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/madvise.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -155,11 +155,14 @@ static long madvise_dontneed(struct vm_a
  * Other filesystems return -ENOSYS.
  */
 static long madvise_remove(struct vm_area_struct *vma,
+				struct vm_area_struct **prev,
 				unsigned long start, unsigned long end)
 {
 	struct address_space *mapping;
         loff_t offset, endoff;
 
+	*prev = vma;
+
 	if (vma->vm_flags & (VM_LOCKED|VM_NONLINEAR|VM_HUGETLB))
 		return -EINVAL;
 
@@ -199,7 +202,7 @@ madvise_vma(struct vm_area_struct *vma, 
 		error = madvise_behavior(vma, prev, start, end, behavior);
 		break;
 	case MADV_REMOVE:
-		error = madvise_remove(vma, start, end);
+		error = madvise_remove(vma, prev, start, end);
 		break;
 
 	case MADV_WILLNEED:

-- 
