Return-Path: <linux-kernel-owner+w=401wt.eu-S1760252AbZKFWZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252AbZKFWZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932707AbZKFWXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:41 -0500
Received: from kroah.org ([198.145.64.141]:57166 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932692AbZKFWXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:37 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:51 2009
Message-Id: <20091106221550.930885114@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wu Fengguang <fengguang.wu@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: [87/99] vmscan: limit VM_EXEC protection to file pages
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=vmscan-limit-vm_exec-protection-to-file-pages.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Wu Fengguang <fengguang.wu@intel.com>

commit 41e20983fe553b39bc2b00e07c7a379f0c86a4bc upstream.

It is possible to have !Anon but SwapBacked pages, and some apps could
create huge number of such pages with MAP_SHARED|MAP_ANONYMOUS.  These
pages go into the ANON lru list, and hence shall not be protected: we only
care mapped executable files.  Failing to do so may trigger OOM.

Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1298,7 +1298,7 @@ static void shrink_active_list(unsigned 
 			 * IO, plus JVM can create lots of anon VM_EXEC pages,
 			 * so we ignore them here.
 			 */
-			if ((vm_flags & VM_EXEC) && !PageAnon(page)) {
+			if ((vm_flags & VM_EXEC) && page_is_file_cache(page)) {
 				list_add(&page->lru, &l_active);
 				continue;
 			}


