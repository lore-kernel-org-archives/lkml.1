Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbYK2LhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbYK2LhW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 06:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbYK2LhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 06:37:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:51645 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbYK2LhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 06:37:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=p6pQrG9bPq2pi/w/Iu4gQmYYp95VIB2HNH+yuylazAl4qgSFJbqbhQT1Aq7593fssx
         XotMyW9jOAfhLkX2dJ01yJRq7JVY9OLSBnm5XXQ5I3Er6BdqLvpwhZJMKq+SXolpYYqK
         /MRc9Inly0mbhcP+BiTwLF1zQEy7WuITuDzn4=
Message-ID: <4931295B.7080105@gmail.com>
Date: Sat, 29 Nov 2008 06:36:59 -0500
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: wli@holomorphy.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] hugetlb: unsigned ret cannot be negative.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsigned long ret cannot be negative, but ret can get -EFAULT.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
hugetlbfs_read_actor() returns int,
see 
vi fs/hugetlbfs/inode.c +187

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 61edc70..0af64e4 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -252,6 +252,7 @@ static ssize_t hugetlbfs_read(struct file *filp, char __user *buf,
 	for (;;) {
 		struct page *page;
 		unsigned long nr, ret;
+		int ra;
 
 		/* nr is the maximum number of bytes to copy from this page */
 		nr = huge_page_size(h);
@@ -279,15 +280,16 @@ static ssize_t hugetlbfs_read(struct file *filp, char __user *buf,
 			/*
 			 * We have the page, copy it to user space buffer.
 			 */
-			ret = hugetlbfs_read_actor(page, offset, buf, len, nr);
+			ra = hugetlbfs_read_actor(page, offset, buf, len, nr);
 		}
-		if (ret < 0) {
+		if (ra < 0) {
 			if (retval == 0)
-				retval = ret;
+				retval = ra;
 			if (page)
 				page_cache_release(page);
 			goto out;
 		}
+		ret = ra;
 
 		offset += ret;
 		retval += ret;

