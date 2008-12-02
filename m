Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbYLBWvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbYLBWvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYLBWvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:51:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:40626 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbYLBWvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:51:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=q2IX7dOFPqa1BM5Zltfxp1ybJLsfG6CLENJvOBLmLSAwMUvKxgMS0Zx0+Oc7DsurYE
         uMClbRYjZhG4EEhxoJo1W04lVjM5eitUqrlMAarIla4LnG8Ip28pfGzZIfQ3osYgp0TK
         z6KGe3KvkUCWf51/db9UwHaZ9Uk4LlG66chYA=
Message-ID: <4935BBDA.1020404@gmail.com>
Date: Tue, 02 Dec 2008 23:51:06 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: wli@holomorphy.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2] hugetlb: unsigned ret cannot be negative.
References: <4931295B.7080105@gmail.com> <20081202140223.7d5f3538.akpm@linux-foundation.org>
In-Reply-To: <20081202140223.7d5f3538.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 29 Nov 2008 06:36:59 -0500
> roel kluin <roel.kluin@gmail.com> wrote:
> 
>> unsigned long ret cannot be negative, but ret can get -EFAULT.
>>
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>> ---
>> hugetlbfs_read_actor() returns int,
>> see 
>> vi fs/hugetlbfs/inode.c +187
>>
>> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
>> index 61edc70..0af64e4 100644
>> --- a/fs/hugetlbfs/inode.c
>> +++ b/fs/hugetlbfs/inode.c
>> @@ -252,6 +252,7 @@ static ssize_t hugetlbfs_read(struct file *filp, char __user *buf,
>>  	for (;;) {
>>  		struct page *page;
>>  		unsigned long nr, ret;
>> +		int ra;
>>  
>>  		/* nr is the maximum number of bytes to copy from this page */
>>  		nr = huge_page_size(h);
>> @@ -279,15 +280,16 @@ static ssize_t hugetlbfs_read(struct file *filp, char __user *buf,
>>  			/*
>>  			 * We have the page, copy it to user space buffer.
>>  			 */
>> -			ret = hugetlbfs_read_actor(page, offset, buf, len, nr);
>> +			ra = hugetlbfs_read_actor(page, offset, buf, len, nr);
>>  		}
>> -		if (ret < 0) {
>> +		if (ra < 0) {

> `ra' can obviously be used uninitialised here.  The compiler reports
> this, too.

Yes, it was incomplete as well, sorry. This should be OK.
(checkpatch tested)
--------------->8----------------8<---------------------
unsigned long ret cannot be negative, but ret can get -EFAULT.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 61edc70..07fa7e3 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -252,6 +252,7 @@ static ssize_t hugetlbfs_read(struct file *filp, char __user *buf,
 	for (;;) {
 		struct page *page;
 		unsigned long nr, ret;
+		int ra;
 
 		/* nr is the maximum number of bytes to copy from this page */
 		nr = huge_page_size(h);
@@ -274,16 +275,19 @@ static ssize_t hugetlbfs_read(struct file *filp, char __user *buf,
 			 */
 			ret = len < nr ? len : nr;
 			if (clear_user(buf, ret))
-				ret = -EFAULT;
+				ra = -EFAULT;
+			else
+				ra = 0;
 		} else {
 			/*
 			 * We have the page, copy it to user space buffer.
 			 */
-			ret = hugetlbfs_read_actor(page, offset, buf, len, nr);
+			ra = hugetlbfs_read_actor(page, offset, buf, len, nr);
+			ret = ra;
 		}
-		if (ret < 0) {
+		if (ra < 0) {
 			if (retval == 0)
-				retval = ret;
+				retval = ra;
 			if (page)
 				page_cache_release(page);
 			goto out;

