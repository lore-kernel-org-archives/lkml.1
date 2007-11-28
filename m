Return-Path: <linux-kernel-owner+w=401wt.eu-S1762318AbXK1Wyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762318AbXK1Wyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762055AbXK1Wxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:53:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:41989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762045AbXK1Wxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:53:40 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Miao Xie <miaox@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 6/6] sysfs: fix off-by-one error in fill_read_buffer()
Date: Wed, 28 Nov 2007 14:52:20 -0800
Message-Id: <1196290340-28828-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071128224746.GA28410@kroah.com>
References: <20071128224746.GA28410@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miao Xie <miaox@cn.fujitsu.com>

I found that there is a off-by-one problem in the following code.

Version:	2.6.24-rc2
File:		fs/sysfs/file.c:118-122
Function:	fill_read_buffer
--------------------------------------------------------------------
	count = ops->show(kobj, attr_sd->s_attr.attr, buffer->page);

	sysfs_put_active_two(attr_sd);

	BUG_ON(count > (ssize_t)PAGE_SIZE);
--------------------------------------------------------------------

Because according to the specification of the sysfs and the implement of
the show methods, the show methods return the number of bytes which would
be generated for the given input, excluding the trailing null.So if the
return value of the show methods equals PAGE_SIZE - 1, the buffer is full
in fact.  And if the return value equals PAGE_SIZE, the resulting string
was already truncated,or buffer overflow occurred.

This patch fixes an off-by-one error in fill_read_buffer.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Tejun Heo <teheo@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/file.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 27d1785..4045bdc 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -119,7 +119,11 @@ static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer
 
 	sysfs_put_active_two(attr_sd);
 
-	BUG_ON(count > (ssize_t)PAGE_SIZE);
+	/*
+	 * The code works fine with PAGE_SIZE return but it's likely to
+	 * indicate truncated result or overflow in normal use cases.
+	 */
+	BUG_ON(count >= (ssize_t)PAGE_SIZE);
 	if (count >= 0) {
 		buffer->needs_read_fill = 0;
 		buffer->count = count;
-- 
1.5.3.4

