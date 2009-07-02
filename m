Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbZGBNJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbZGBNJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 09:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbZGBNIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 09:08:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60308 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbZGBNIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 09:08:54 -0400
Date: Thu, 2 Jul 2009 09:05:00 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: npiggin@suse.de, stable@kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] mm: mark page accessed before we write_end
Message-ID: <20090702130500.GF16713@dhcp231-156.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

In testing a backport of the write_begin/write_end AOPs, a 10% re-read
regression was noticed when running iozone.  This regression was introduced
because the old AOPs would always do a mark_page_accessed(page) after the
commit_write, but when the new AOPs where introduced, the only place this was
kept was in pagecache_write_end().  This patch does the same thing in the
generic case as what is done in pagecache_write_end(), which is just to mark
the page accessed before we do write_end().  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 mm/filemap.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 2239671..ccea3b6 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2272,6 +2272,7 @@ again:
 		pagefault_enable();
 		flush_dcache_page(page);
 
+		mark_page_accessed(page);
 		status = a_ops->write_end(file, mapping, pos, bytes, copied,
 						page, fsdata);
 		if (unlikely(status < 0))
-- 
1.5.4.3

