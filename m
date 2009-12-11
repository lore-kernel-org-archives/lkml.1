Return-Path: <linux-kernel-owner+w=401wt.eu-S1762277AbZLKEgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762277AbZLKEgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761413AbZLKEg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:29 -0500
Received: from kroah.org ([198.145.64.141]:36739 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759512AbZLKEfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:50 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:39 2009
Message-Id: <20091211042738.873362487@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:24:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [20/90] ext4: Take page lock before looking at attached buffer_heads flags
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0020-ext4-Take-page-lock-before-looking-at-attached-buffe.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit a827eaffff07c7d58a4cb32158cbeb4849f4e33a)

In order to check whether the buffer_heads are mapped we need to hold
page lock. Otherwise a reclaim can cleanup the attached buffer_heads.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5298,12 +5298,21 @@ int ext4_page_mkwrite(struct vm_area_str
 	else
 		len = PAGE_CACHE_SIZE;
 
+	lock_page(page);
+	/*
+	 * return if we have all the buffers mapped. This avoid
+	 * the need to call write_begin/write_end which does a
+	 * journal_start/journal_stop which can block and take
+	 * long time
+	 */
 	if (page_has_buffers(page)) {
-		/* return if we have all the buffers mapped */
 		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
-				       ext4_bh_unmapped))
+					ext4_bh_unmapped)) {
+			unlock_page(page);
 			goto out_unlock;
+		}
 	}
+	unlock_page(page);
 	/*
 	 * OK, we need to fill the hole... Do write_begin write_end
 	 * to do block allocation/reservation.We are not holding


