Return-Path: <linux-kernel-owner+w=401wt.eu-S934070AbXKOHMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934070AbXKOHMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932967AbXKOGx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:53:26 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33550 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932910AbXKOGxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:53:23 -0500
Date: Wed, 14 Nov 2007 22:52:41 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [patch 3/3] NFS: Fix a writeback race...
Message-ID: <20071115065241.GD20690@kroah.com>
References: <20071115065014.785638308@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nfs-fix-a-writeback-race.patch"
In-Reply-To: <20071115065220.GA20690@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>

patch 61e930a904966cc37e0a3404276f0b73037e57ca in mainline

This patch fixes a regression that was introduced by commit
44dd151d5c21234cc534c47d7382f5c28c3143cd

We cannot zero the user page in nfs_mark_uptodate() any more, since

  a) We'd be modifying the page without holding the page lock
  b) We can race with other updates of the page, most notably
     because of the call to nfs_wb_page() in nfs_writepage_setup().

Instead, we do the zeroing in nfs_update_request() if we see that we're
creating a request that might potentially be marked as up to date.

Thanks to Olivier Paquet for reporting the bug and providing a test-case.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/write.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -167,8 +167,6 @@ static void nfs_mark_uptodate(struct pag
 		return;
 	if (count != nfs_page_length(page))
 		return;
-	if (count != PAGE_CACHE_SIZE)
-		zero_user_page(page, count, PAGE_CACHE_SIZE - count, KM_USER0);
 	SetPageUptodate(page);
 }
 
@@ -643,7 +641,8 @@ static struct nfs_page * nfs_update_requ
 				return ERR_PTR(error);
 			}
 			spin_unlock(&inode->i_lock);
-			return new;
+			req = new;
+			goto zero_page;
 		}
 		spin_unlock(&inode->i_lock);
 
@@ -671,13 +670,23 @@ static struct nfs_page * nfs_update_requ
 	if (offset < req->wb_offset) {
 		req->wb_offset = offset;
 		req->wb_pgbase = offset;
-		req->wb_bytes = rqend - req->wb_offset;
+		req->wb_bytes = max(end, rqend) - req->wb_offset;
+		goto zero_page;
 	}
 
 	if (end > rqend)
 		req->wb_bytes = end - req->wb_offset;
 
 	return req;
+zero_page:
+	/* If this page might potentially be marked as up to date,
+	 * then we need to zero any uninitalised data. */
+	if (req->wb_pgbase == 0 && req->wb_bytes != PAGE_CACHE_SIZE
+			&& !PageUptodate(req->wb_page))
+		zero_user_page(req->wb_page, req->wb_bytes,
+				PAGE_CACHE_SIZE - req->wb_bytes,
+				KM_USER0);
+	return req;
 }
 
 int nfs_flush_incompatible(struct file *file, struct page *page)

-- 
