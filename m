Return-Path: <linux-kernel-owner+w=401wt.eu-S1760027AbXKMDuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027AbXKMDuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 22:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbXKMDuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 22:50:05 -0500
Received: from [222.73.24.84] ([222.73.24.84]:53083 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbXKMDuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 22:50:03 -0500
Message-ID: <47391EFA.4000004@cn.fujitsu.com>
Date: Tue, 13 Nov 2007 11:50:18 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Tejun Heo <teheo@suse.de>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: fix  off-by-one error in fill_read_buffer
References: <4732EDD2.2050406@cn.fujitsu.com> <47385E4A.5030306@suse.de>
In-Reply-To: <47385E4A.5030306@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

on 2007-11-12 22:08 Tejun Heo wrote:
> It isn't strictly a bug.  If the ->show() op fills full PAGE_SIZE and
> returns PAGE_SIZE, the user will get full PAGE_SIZE bytes correctly, so
> it will work.  However, considering normal use cases, return value of
> PAGE_SIZE very likely indicates an error condition, so considering it a
> BUG condition is a good idea.
> 
> Miao, can you please note that the code works fine with PAGE_SIZE return
> but it's likely to indicate truncated result or overflow in normal use
> cases as a comment on top of the BUG_ON()?
> 
> Thanks.

OK, I did it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

---
  fs/sysfs/file.c |    4 +++-
  1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 27d1785..7f6a8d2 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -119,7 +119,9 @@ static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer

  	sysfs_put_active_two(attr_sd);

-	BUG_ON(count > (ssize_t)PAGE_SIZE);
+	/* the code works fine with PAGE_SIZE return but it's likely to
+	   indicate truncated result or overflow in normal use cases. */
+	BUG_ON(count >= (ssize_t)PAGE_SIZE);
  	if (count >= 0) {
  		buffer->needs_read_fill = 0;
  		buffer->count = count;
-- 
1.5.3


