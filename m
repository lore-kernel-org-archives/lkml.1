Return-Path: <linux-kernel-owner+w=401wt.eu-S934762AbZKYOID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934762AbZKYOID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:08:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934668AbZKYOIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:08:01 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:35418 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934630AbZKYOH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:07:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=e1Uh4FSPGCPHexXHZGnOJ5wSyjEAfIo0PHFNdnLcT58v5tKwhdEvSzW4ZZdQ/eU1TZ
         RuBwcD9b8pfC7cPc9He2wCmCfeLWi1sIyjxA1B38J7ngPNjYQCz5fbHOXnuufBZ6KDIp
         Gzv/t9g6SL+mi366SUb3GQaNijDf8uWrkcYys=
Date: Wed, 25 Nov 2009 22:12:19 +0800
From: "Liuweni" <qingshenlwy@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "viro" <viro@zeniv.linux.org.uk>, "akpm" <akpm@linux-foundation.org>,
       "jack" <jack@suse.cz>, "npiggin" <npiggin@suse.de>,
       "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "strongzgy" <strongzgy@gmail.com>, "xgr178" <xgr178@163.com>,
       "Liu Hui" <onlyflyer@gmail.com>
Subject: [PATCH 2/3]fs/inode: iunique() Optimize Performance
Message-ID: <200911252212166092236@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
Change log:
Change the hash operation from division to shift. It will cost less time.
Also, I change the divisor from L1_CACHE_BYTES to L1_CACHE_SHIFT.
In the cache.h, the most L1_CACHE_BYTES defined as "(1 << L1_CACHE_SHIFT)".
---
Signed-off-by: Liuwenyi<qingshenlwy@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
diff --git a/fs/inode.c b/fs/inode.c
index 4d8e3be..397d65f 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -605,8 +605,8 @@ static unsigned long hash(struct super_block *sb, unsigned long hashval)
 {
 	unsigned long tmp;
 
-	tmp = (hashval * (unsigned long)sb) ^ (GOLDEN_RATIO_PRIME + hashval) /
-			L1_CACHE_BYTES;
+	tmp = (hashval * (unsigned long)sb) ^ (GOLDEN_RATIO_PRIME + hashval) >>
+			L1_CACHE_SHIFT;
 	tmp = tmp ^ ((tmp ^ GOLDEN_RATIO_PRIME) >> I_HASHBITS);
 	return tmp & I_HASHMASK;
 }

 				
--------------
Best Regards,
Liuweni
2009-11-25

