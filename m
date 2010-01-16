Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab0APQPj (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 11:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900Ab0APQPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 11:15:37 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:63613 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab0APQPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 11:15:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=bb+46FLy2dVspn0rPL26ywGWcQRuT8AqReJ1Gu231RefKNQ6xGy4Ap8E9/i7mOsqmK
         eayjqITaCYhKCXi3HBf9pCKHwGdhnnFxTYxkG0DJoRHoD/9WnY2ajq//FuI/NdvONiuh
         xMPxFrd7fFdZQ1m2sF57cOR9Bo9hOw6XKVVYU=
Subject: [PATCH -mmotm-2010-01-15-15-34] Fix wrong offset for vma merge in
 mbind
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Jan 2010 01:15:28 +0900
Message-ID: <1263658528.2162.6.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm-fix-mbind-vma-merge-problem.patch added vma_merge in mbind
to merge mergeable vmas.
But it passed wrong offset of vm_file.

This patch fixes it.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---
 mm/mempolicy.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 9751f3f..7e529d0 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -570,6 +570,7 @@ static int mbind_range(struct mm_struct *mm, unsigned long start,
 	struct vm_area_struct *prev;
 	struct vm_area_struct *vma;
 	int err = 0;
+	pgoff_t pgoff;
 	unsigned long vmstart;
 	unsigned long vmend;
 
@@ -582,9 +583,9 @@ static int mbind_range(struct mm_struct *mm, unsigned long start,
 		vmstart = max(start, vma->vm_start);
 		vmend   = min(end, vma->vm_end);
 
+		pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
 		prev = vma_merge(mm, prev, vmstart, vmend, vma->vm_flags,
-				  vma->anon_vma, vma->vm_file, vma->vm_pgoff,
-				  new_pol);
+				  vma->anon_vma, vma->vm_file, pgoff, new_pol);
 		if (prev) {
 			vma = prev;
 			next = vma->vm_next;
-- 
1.6.3.3



-- 
Kind regards,
Minchan Kim

