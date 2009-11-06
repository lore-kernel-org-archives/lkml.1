Return-Path: <linux-kernel-owner+w=401wt.eu-S932695AbZKFWct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695AbZKFWct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932497AbZKFWXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:13 -0500
Received: from kroah.org ([198.145.64.141]:56925 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760198AbZKFWXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:05 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:45 2009
Message-Id: <20091106221545.853603990@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bo Liu <bo-liu@hotmail.com>, Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: [52/99] mm: remove incorrect swap_count() from try_to_unuse()
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=mm-remove-incorrect-swap_count-from-try_to_unuse.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Bo Liu <bo-liu@hotmail.com>

commit 32c5fc10e79a7053ac5728b01a0bff55cbcb9d49 upstream.

In try_to_unuse(), swcount is a local copy of *swap_map, including the
SWAP_HAS_CACHE bit; but a wrong comparison against swap_count(*swap_map),
which masks off the SWAP_HAS_CACHE bit, succeeded where it should fail.

That had the effect of resetting the mm from which to start searching
for the next swap page, to an irrelevant mm instead of to an mm in which
this swap page had been found: which may increase search time by ~20%.
But we're used to swapoff being slow, so never noticed the slowdown.

Remove that one spurious use of swap_count(): Bo Liu thought it merely
redundant, Hugh rewrote the description since it was measurably wrong.

Signed-off-by: Bo Liu <bo-liu@hotmail.com>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/swapfile.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1149,8 +1149,7 @@ static int try_to_unuse(unsigned int typ
 				} else
 					retval = unuse_mm(mm, entry, page);
 
-				if (set_start_mm &&
-				    swap_count(*swap_map) < swcount) {
+				if (set_start_mm && *swap_map < swcount) {
 					mmput(new_start_mm);
 					atomic_inc(&mm->mm_users);
 					new_start_mm = mm;


