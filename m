Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849Ab0ANWwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849Ab0ANWwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757845Ab0ANWwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:52:17 -0500
Received: from kroah.org ([198.145.64.141]:58191 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757826Ab0ANWwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:52:12 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Jan 14 14:48:07 2010
Message-Id: <20100114224807.086778669@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jan 2010 14:46:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dmitry Monakhov <dmonakhov@openvz.org>, Jan Kara <jack@suse.cz>
Subject: [6/9] quota: Fix dquot_transfer for filesystems different from ext4
In-Reply-To: <20100114224848.GA532@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kara <jack@suse.cz>

commit 05b5d898235401c489c68e1f3bc5706a29ad5713 upstream.

Commit fd8fbfc1 modified the way we find amount of reserved space
belonging to an inode. The amount of reserved space is checked
from dquot_transfer and thus inode_reserved_space gets called
even for filesystems that don't provide get_reserved_space callback
which results in a BUG.

Fix the problem by checking get_reserved_space callback and return 0 if
the filesystem does not provide it.

CC: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/quota/dquot.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1425,6 +1425,9 @@ static void inode_sub_rsv_space(struct i
 static qsize_t inode_get_rsv_space(struct inode *inode)
 {
 	qsize_t ret;
+
+	if (!inode->i_sb->dq_op->get_reserved_space)
+		return 0;
 	spin_lock(&inode->i_lock);
 	ret = *inode_reserved_space(inode);
 	spin_unlock(&inode->i_lock);


