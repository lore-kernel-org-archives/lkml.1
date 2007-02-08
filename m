Return-Path: <linux-kernel-owner+w=401wt.eu-S1161505AbXBHAdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161505AbXBHAdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161506AbXBHAdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:33:25 -0500
Received: from ns2.suse.de ([195.135.220.15]:34076 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422850AbXBHAci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:32:38 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Oliver Neukum <oliver@neukum.name>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 21/28] sysfs: error handling in sysfs, fill_read_buffer()
Date: Wed,  7 Feb 2007 16:30:09 -0800
Message-Id: <11708946903974-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11708946871208-git-send-email-greg@kroah.com>
References: <20070208002908.GA4796@kroah.com> <11708946163722-git-send-email-greg@kroah.com> <1170894620889-git-send-email-greg@kroah.com> <11708946251265-git-send-email-greg@kroah.com> <11708946283719-git-send-email-greg@kroah.com> <11708946362677-git-send-email-greg@kroah.com> <11708946391465-git-send-email-greg@kroah.com> <11708946432920-git-send-email-greg@kroah.com> <11708946472324-git-send-email-greg@kroah.com> <1170894650872-git-send-email-greg@kroah.com> <11708946533931-git-send-email-greg@kroah.com> <11708946561557-git-send-email-greg@kroah.com> <11708946601643-git-send-email-greg@kroah.com> <1170894664547-git-send-email-greg@kroah.com> <11708946672133-git-send-email-greg@kroah.com> <1170894670676-git-send-email-greg@kroah.com> <11708946734097-git-send-email-greg@kroah.com> <11708946762594-git-send-email-greg@kroah.com> <11708946802786-git-send-email-greg@kroah.com> <11708946832214-git-send-email-greg@kroah.com> <11708946871208-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Neukum <oliver@neukum.name>

if a driver returns an error in fill_read_buffer(), the buffer will be
marked as filled. Subsequent reads will return eof. But there is
no data because of an error, not because it has been read.
Not marking the buffer filled is the obvious fix.

Signed-off-by: Oliver Neukum <oliver@neukum.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/file.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 46618f8..c0e1176 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -83,7 +83,8 @@ remove_from_collection(struct sysfs_buffer *buffer, struct inode *node)
  *	Allocate @buffer->page, if it hasn't been already, then call the
  *	kobject's show() method to fill the buffer with this attribute's 
  *	data. 
- *	This is called only once, on the file's first read. 
+ *	This is called only once, on the file's first read unless an error
+ *	is returned.
  */
 static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer)
 {
@@ -101,12 +102,13 @@ static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer
 
 	buffer->event = atomic_read(&sd->s_event);
 	count = ops->show(kobj,attr,buffer->page);
-	buffer->needs_read_fill = 0;
 	BUG_ON(count > (ssize_t)PAGE_SIZE);
-	if (count >= 0)
+	if (count >= 0) {
+		buffer->needs_read_fill = 0;
 		buffer->count = count;
-	else
+	} else {
 		ret = count;
+	}
 	return ret;
 }
 
-- 
1.4.4.4

