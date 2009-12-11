Return-Path: <linux-kernel-owner+w=401wt.eu-S1762603AbZLKEzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762603AbZLKEzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbZLKEfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:35:55 -0500
Received: from kroah.org ([198.145.64.141]:52862 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758927AbZLKEfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:36 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:27 2009
Message-Id: <20091211042726.960452135@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:24:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peng Tao <bergwolf@gmail.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [05/90] ext4: fix journal ref count in move_extent_par_page
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0005-ext4-fix-journal-ref-count-in-move_extent_par_page.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 91cc219ad963731191247c5f2db4118be2bc341a)

move_extent_par_page calls a_ops->write_begin() to increase journal
handler's reference count. However, if either mext_replace_branches()
or ext4_get_block fails, the increased reference count isn't
decreased. This will cause a later attempt to umount of the fs to hang
forever. The patch addresses the issue by calling ext4_journal_stop()
if page is not NULL (which means a_ops->write_end() isn't invoked).

Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/move_extent.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -871,6 +871,7 @@ out:
 		if (PageLocked(page))
 			unlock_page(page);
 		page_cache_release(page);
+		ext4_journal_stop(handle);
 	}
 out2:
 	ext4_journal_stop(handle);


