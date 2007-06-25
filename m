Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbXFYR6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbXFYR6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 13:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXFYR6C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 13:58:02 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43380 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbXFYR6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 13:58:00 -0400
Date: Mon, 25 Jun 2007 12:48:30 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: trevor.highland@gmail.com, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] eCryptfs: zero out last page for llseek/write
Message-ID: <20070625174830.GC27771@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070613185316.GX13465@halcrow.austin.ibm.com> <20070613185456.GY13465@halcrow.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613185456.GY13465@halcrow.austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When one llseek's past the end of the file and then writes, every page
past the previous end of the file should be cleared. Trevor found that
the code, as is, does not assure that the very last page is always
cleared. This patch takes care of that.

This patch, including the two that I sent on June 13th, are bugfixes
to try to clean up the recent llseek() hack job; hopefully they can be
merged before the release of 2.6.22 (I've noticed that we're already
at -rc6).

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>

---
 fs/ecryptfs/mmap.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 6df410c..7d5a43c 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -422,6 +422,8 @@ static int ecryptfs_prepare_write(struct file *file, struct page *page,
 				goto out;
 			}
 		}
+		if (end_of_prev_pg_pos + 1 > i_size_read(page->mapping->host))
+			zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
 	}
 out:
 	return rc;
-- 
1.4.4.4

