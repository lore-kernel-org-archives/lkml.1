Return-Path: <linux-kernel-owner+w=401wt.eu-S1762761AbZDHHI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762761AbZDHHI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbZDHHIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:08:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55618 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbZDHHIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:08:13 -0400
Message-ID: <49DC4D85.5000205@cn.fujitsu.com>
Date: Wed, 08 Apr 2009 15:08:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: vandrove@vc.cvut.cz, LKML <linux-kernel@vger.kernel.org>,
       linware@sh.cvut.cz
Subject: [PATCH 5/6] ncpfs: use memdup_user()
References: <49DC4CC0.9050805@cn.fujitsu.com>
In-Reply-To: <49DC4CC0.9050805@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove open-coded memdup_user()

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/ncpfs/ioctl.c |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/fs/ncpfs/ioctl.c b/fs/ncpfs/ioctl.c
index f54360f..fa038df 100644
--- a/fs/ncpfs/ioctl.c
+++ b/fs/ncpfs/ioctl.c
@@ -660,13 +660,10 @@ outrel:
 			if (user.object_name_len > NCP_OBJECT_NAME_MAX_LEN)
 				return -ENOMEM;
 			if (user.object_name_len) {
-				newname = kmalloc(user.object_name_len, GFP_USER);
-				if (!newname)
-					return -ENOMEM;
-				if (copy_from_user(newname, user.object_name, user.object_name_len)) {
-					kfree(newname);
-					return -EFAULT;
-				}
+				newname = memdup_user(user.object_name,
+						      user.object_name_len);
+				if (IS_ERR(newname))
+					return PTR_ERR(newname);
 			} else {
 				newname = NULL;
 			}
@@ -760,13 +757,9 @@ outrel:
 			if (user.len > NCP_PRIVATE_DATA_MAX_LEN)
 				return -ENOMEM;
 			if (user.len) {
-				new = kmalloc(user.len, GFP_USER);
-				if (!new)
-					return -ENOMEM;
-				if (copy_from_user(new, user.data, user.len)) {
-					kfree(new);
-					return -EFAULT;
-				}
+				new = memdup_user(user.data, user.len);
+				if (IS_ERR(new))
+					return PTR_ERR(new);
 			} else {
 				new = NULL;
 			}
-- 
1.5.4.rc3


