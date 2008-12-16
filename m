Return-Path: <linux-kernel-owner+w=401wt.eu-S1757011AbYLPTqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbYLPTqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbYLPTq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:46:27 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2686 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbYLPTq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:46:26 -0500
Subject: Re: mm: Don't touch uninitialized variable in do_pages_stat_array()
From: Joe Perches <joe@perches.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Brice Goglin <Brice.Goglin@inria.fr>,
       Christoph Lameter <clameter@sgi.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <200812161859.mBGIx1kR018513@hera.kernel.org>
References: <200812161859.mBGIx1kR018513@hera.kernel.org>
Content-Type: text/plain
Date: Tue, 16 Dec 2008 11:47:01 -0800
Message-Id: <1229456821.20606.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-16 at 18:59 +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c095adbc211f9f4e990eac7d6cb440de35e4f05f
> Commit:     c095adbc211f9f4e990eac7d6cb440de35e4f05f
> Parent:     a3dd15444baa9c7522c8457ab564c41219dfb44c
> Author:     KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> AuthorDate: Tue Dec 16 16:06:43 2008 +0900
> Committer:  Linus Torvalds <torvalds@linux-foundation.org>
> CommitDate: Tue Dec 16 08:19:23 2008 -0800
> 
>     mm: Don't touch uninitialized variable in do_pages_stat_array()
>     
>     Commit 80bba1290ab5122c60cdb73332b26d288dc8aedd removed one necessary
>     variable initialization.  As a result following warning happened:
>     
>         CC      mm/migrate.o
>       mm/migrate.c: In function 'sys_move_pages':
>       mm/migrate.c:1001: warning: 'err' may be used uninitialized in this function
>     
>     More unfortunately, if find_vma() failed, kernel read uninitialized
>     memory.
>     
>     Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>     CC: Brice Goglin <Brice.Goglin@inria.fr>
>     Cc: Christoph Lameter <clameter@sgi.com>
>     Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>     Cc: Nick Piggin <npiggin@suse.de>
>     Cc: Hugh Dickins <hugh@veritas.com>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  mm/migrate.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index d8f0766..037b096 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -998,7 +998,7 @@ static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
>  		unsigned long addr = (unsigned long)(*pages);
>  		struct vm_area_struct *vma;
>  		struct page *page;
> -		int err;
> +		int err = -EFAULT;
>  
>  		vma = find_vma(mm, addr);
>  		if (!vma)
> --

Perhaps this is more legible and avoids
the unnecessary assignments to err.

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/mm/migrate.c b/mm/migrate.c
index 037b096..ddfeeac 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -998,22 +998,25 @@ static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
 		unsigned long addr = (unsigned long)(*pages);
 		struct vm_area_struct *vma;
 		struct page *page;
-		int err = -EFAULT;
+		int err;
 
 		vma = find_vma(mm, addr);
-		if (!vma)
+		if (!vma) {
+			err = -EFAULT;
 			goto set_status;
+		}
 
 		page = follow_page(vma, addr, 0);
-
-		err = PTR_ERR(page);
-		if (IS_ERR(page))
+		if (IS_ERR(page)) {
+			err = PTR_ERR(page);
 			goto set_status;
+		}
 
-		err = -ENOENT;
 		/* Use PageReserved to check for zero page */
-		if (!page || PageReserved(page))
+		if (!page || PageReserved(page)) {
+			err = -ENOENT;
 			goto set_status;
+		}
 
 		err = page_to_nid(page);
 set_status:


