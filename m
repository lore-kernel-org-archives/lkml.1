Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbZCCPkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbZCCPkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZCCPkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:40:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:21158 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbZCCPkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:40:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=EvrQ654kwpM3GhY9KuqGh8Q4XKDF40gaNUuTejUzBgWKZwwAFxtlpZzMQgYlca0QjO
         2Svi97xKWMUqXosn/9tF8fVGB+Uzc2C55Ymo4oeWYRpwPliC7ON5oH+HffTkpZU81NMp
         WVzz4lF0CbrW5xQq9lqq3jLa0YJ1KMEFbnbQQ=
Message-ID: <49AD4F52.8070205@gmail.com>
Date: Tue, 03 Mar 2009 16:40:02 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] hppfs: hppfs_read_file() may return -ERROR
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI: hppfs_read_file() is at: vi fs/hppfs/hppfs.c +212
------------------------------>8-------------8<---------------------------------
hppfs_read_file() may return (ssize_t) -ENOMEM, or -EFAULT. when stored in
size_t 'count', these errors will not be noticed, a large value will be added to
*ppos.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/fs/hppfs/hppfs.c b/fs/hppfs/hppfs.c
index b278f7f..a5089a6 100644
--- a/fs/hppfs/hppfs.c
+++ b/fs/hppfs/hppfs.c
@@ -280,7 +280,12 @@ static ssize_t hppfs_read(struct file *file, char __user *buf, size_t count,
 			       "errno = %d\n", err);
 			return err;
 		}
-		count = hppfs_read_file(hppfs->host_fd, buf, count);
+		err = hppfs_read_file(hppfs->host_fd, buf, count);
+		if (err < 0) {
+			printk(KERN_ERR "hppfs_read: read failed: %d\n", err);
+			return err;
+		}
+		count = err;
 		if (count > 0)
 			*ppos += count;
 	}
