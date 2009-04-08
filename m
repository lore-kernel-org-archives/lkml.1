Return-Path: <linux-kernel-owner+w=401wt.eu-S1762580AbZDHHHC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762580AbZDHHHC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:07:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758439AbZDHHGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:06:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55165 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760458AbZDHHGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:06:49 -0400
Message-ID: <49DC4D32.5030301@cn.fujitsu.com>
Date: Wed, 08 Apr 2009 15:07:30 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/6] sysfs: use memdup_user()
References: <49DC4CC0.9050805@cn.fujitsu.com>
In-Reply-To: <49DC4CC0.9050805@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove open-coded memdup_user().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/sysfs/bin.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 93e0c02..9345806 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -157,14 +157,9 @@ static ssize_t write(struct file *file, const char __user *userbuf,
 			count = size - offs;
 	}
 
-	temp = kmalloc(count, GFP_KERNEL);
-	if (!temp)
-		return -ENOMEM;
-
-	if (copy_from_user(temp, userbuf, count)) {
-		count = -EFAULT;
-		goto out_free;
-	}
+	temp = memdup_user(userbuf, count);
+	if (IS_ERR(temp))
+		return PTR_ERR(temp);
 
 	mutex_lock(&bb->mutex);
 
@@ -176,8 +171,6 @@ static ssize_t write(struct file *file, const char __user *userbuf,
 	if (count > 0)
 		*off = offs + count;
 
-out_free:
-	kfree(temp);
 	return count;
 }
 
-- 
1.5.4.rc3

