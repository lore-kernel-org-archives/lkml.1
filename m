Return-Path: <linux-kernel-owner+w=401wt.eu-S1760328AbXKHLHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760328AbXKHLHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 06:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756698AbXKHLGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 06:06:51 -0500
Received: from [222.73.24.84] ([222.73.24.84]:49488 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755670AbXKHLGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 06:06:50 -0500
Message-ID: <4732EDD2.2050406@cn.fujitsu.com>
Date: Thu, 08 Nov 2007 19:06:58 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: gregkh@suse.de
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] sysfs: fix  off-by-one error in fill_read_buffer
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,everyone.
   I found that there is a off-by-one problem in the following code.

Version:	2.6.24-rc2
File:		fs/sysfs/file.c:118-122
Function:	fill_read_buffer
--------------------------------------------------------------------
	count = ops->show(kobj, attr_sd->s_attr.attr, buffer->page);

	sysfs_put_active_two(attr_sd);

	BUG_ON(count > (ssize_t)PAGE_SIZE);
--------------------------------------------------------------------
Because according to the specification of the sysfs and the implement of the
show methods, the show methods return the number of bytes which would be
generated for the given input, excluding the trailing null.So if the return
value of the show methods equals PAGE_SIZE - 1, the buffer is full in fact.
And if the return value equals PAGE_SIZE, the resulting string was already
truncated,or buffer overflow occurred.

This patch fixes an off-by-one error in fill_read_buffer.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

---
  fs/sysfs/file.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 27d1785..f98d66d 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -119,7 +119,7 @@ static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer

  	sysfs_put_active_two(attr_sd);

-	BUG_ON(count > (ssize_t)PAGE_SIZE);
+	BUG_ON(count >= (ssize_t)PAGE_SIZE);
  	if (count >= 0) {
  		buffer->needs_read_fill = 0;
  		buffer->count = count;
-- 
1.5.3



