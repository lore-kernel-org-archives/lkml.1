Return-Path: <linux-kernel-owner+w=401wt.eu-S1751448AbXKIHcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbXKIHcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 02:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbXKIHbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 02:31:52 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:45298 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbXKIHbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 02:31:52 -0500
Date: Fri, 9 Nov 2007 07:31:07 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH mm] unionfs: clear partial read
Message-ID: <Pine.LNX.4.64.0711090728130.22720@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

unionfs_do_readpage forgot to clear the rest of the page when vfs_read
does not fill the page: fix that.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 fs/unionfs/mmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- 2.6.24-rc1-mm1/fs/unionfs/mmap.c	2007-11-04 13:48:02.000000000 +0000
+++ linux/fs/unionfs/mmap.c	2007-11-06 13:51:02.000000000 +0000
@@ -176,7 +176,8 @@ static int unionfs_do_readpage(struct fi
 	err = vfs_read(lower_file, page_data, PAGE_CACHE_SIZE,
 		       &lower_file->f_pos);
 	set_fs(old_fs);
-
+	if (err >= 0 && err < PAGE_CACHE_SIZE)
+		memset(page_data + err, 0, PAGE_CACHE_SIZE - err);
 	kunmap(page);
 
 	if (err < 0)
