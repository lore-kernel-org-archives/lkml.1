Return-Path: <linux-kernel-owner+w=401wt.eu-S933862AbXEUT23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862AbXEUT23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765377AbXEUTVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:21:34 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46351 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765301AbXEUTV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:21:27 -0400
Message-Id: <20070521191725.598671000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:42 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, jack@ucw.cz,
       haveblue@us.ibm.com, molletts@yahoo.com
Subject: [patch 30/69] udf: decrement correct link count in udf_rmdir
Content-Disposition: inline; filename=udf-decrement-correct-link-count-in-udf_rmdir.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Stephen Mollett <molletts@yahoo.com>

It appears that a minor thinko occurred in udf_rmdir and the
(already-cleared) link count on the directory that is being removed was
being decremented instead of the link count on its parent directory.  This
gives rise to lots of kernel messages similar to:

UDF-fs warning (device loop1): udf_rmdir: empty directory has nlink != 2 (8)

when removing directory trees.  No other ill effects have been observed but
I guess it could theoretically result in the link count overflowing on a
very long-lived, much modified directory.

Signed-off-by: Stephen Mollett <molletts@yahoo.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 fs/udf/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.21.1.orig/fs/udf/namei.c
+++ linux-2.6.21.1/fs/udf/namei.c
@@ -878,7 +878,7 @@ static int udf_rmdir(struct inode * dir,
 			inode->i_nlink);
 	clear_nlink(inode);
 	inode->i_size = 0;
-	inode_dec_link_count(inode);
+	inode_dec_link_count(dir);
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = current_fs_time(dir->i_sb);
 	mark_inode_dirty(dir);
 

-- 
