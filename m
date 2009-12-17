Return-Path: <linux-kernel-owner+w=401wt.eu-S965116AbZLQPRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965116AbZLQPRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 10:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936342AbZLQPRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 10:17:48 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:53719 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936196AbZLQPRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 10:17:46 -0500
Subject: [PATCH] ext4: return correct wbc.nr_to_write in ext4_da_writepages
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: tytso@mit.edu, adilger@sun.com
Cc: linux-ext4@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Dec 2009 15:17:43 +0000
Message-Id: <1261063063.4882.38.camel@castor>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext4: always re-base nr_to_write in ext4_da_writepages

When ext4_da_writepages increases the nr_to_write in writeback_control
then it must always re-base the return value.

Without this change, when wb_writeback calculates how many pages were
actually written it can get a negative value and loop more times than
necessary. In tests I have seen nearly all the dirty pages pushed out to
writeback due to this issue.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

----

patch against 2.6.32
tested on x86_64

wb_writeback calculates (MAX_WRITE_PAGES - nr_to_write) & cannot know
that the value got changed.

I'm not sure what the test I removed was for.
Perhaps 
	if (nr_to_writebump)
		wbc->nr_to_write -= nr_to_writebump;
was intended?

regards
Richard

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2c8caa5..52a573c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2999,8 +2999,7 @@ retry:
 out_writepages:
 	if (!no_nrwrite_index_update)
 		wbc->no_nrwrite_index_update = 0;
-	if (wbc->nr_to_write > nr_to_writebump)
-		wbc->nr_to_write -= nr_to_writebump;
+	wbc->nr_to_write -= nr_to_writebump;
 	wbc->range_start = range_start;
 	trace_ext4_da_writepages_result(inode, wbc, ret, pages_written);
 	return ret;


