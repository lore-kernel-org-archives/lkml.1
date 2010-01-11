Return-Path: <linux-kernel-owner+w=401wt.eu-S1751578Ab0AKCs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab0AKCs2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 21:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760Ab0AKCs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 21:48:28 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:46693 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab0AKCs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 21:48:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=nn+KZTKAxqsDO1jgWXZ9lBSslvpSU87rQ0UkE273o40oiYaI5NRKjZXm+56iZGaHGU
         wVZXjSybQnXHThh4QRIpO4Tmq+TMeM4lzSsct/nLnXVjlw14K5UlsTV1jKfGUAir3Luy
         CoWMnMmyG3HCabVLuYyb3cIztEzsgyIBLPtFQ=
Date: Mon, 11 Jan 2010 11:46:07 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Izik Eidus <ieidus@redhat.com>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH -mmotm-2010-01-06-14-34] Count minor fault in break_ksm
Message-Id: <20100111114607.1d8cd1e0.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have counted task's maj/min fault after handle_mm_fault.
break_ksm misses that.

I wanted to check by VM_FAULT_ERROR. 
But now break_ksm doesn't handle HWPOISON error. 

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Izik Eidus <ieidus@redhat.com>
---
 mm/ksm.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 56a0da1..3a1fda4 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -367,9 +367,13 @@ static int break_ksm(struct vm_area_struct *vma, unsigned long addr)
 		page = follow_page(vma, addr, FOLL_GET);
 		if (!page)
 			break;
-		if (PageKsm(page))
+		if (PageKsm(page)) {
 			ret = handle_mm_fault(vma->vm_mm, vma, addr,
 							FAULT_FLAG_WRITE);
+			if (!(ret & (VM_FAULT_SIGBUS | VM_FAULT_OOM)
+					|| current->flags & PF_KTHREAD))
+				current->min_flt++;
+		}
 		else
 			ret = VM_FAULT_WRITE;
 		put_page(page);
-- 
1.5.6.3



-- 
Kind regards,
Minchan Kim
