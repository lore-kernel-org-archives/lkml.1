Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab0BBGsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 01:48:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60935 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753547Ab0BBGr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 01:47:57 -0500
Message-ID: <4B67CAA9.4070108@cn.fujitsu.com>
Date: Tue, 02 Feb 2010 14:48:09 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>, "J. Bruce Fields" <bfields@citi.umich.edu>
CC: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH] sunrpc/cache: fix module refcnt leak in a failure path
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't forget to release the module refcnt if seq_open()
returns failure.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 net/sunrpc/cache.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 39bddba..b7af6b2 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1233,8 +1233,10 @@ static int content_open(struct inode *inode, struct file *file,
 	if (!cd || !try_module_get(cd->owner))
 		return -EACCES;
 	han = __seq_open_private(file, &cache_content_op, sizeof(*han));
-	if (han == NULL)
+	if (han == NULL) {
+		module_put(cd->owner);
 		return -ENOMEM;
+	}
 
 	han->cd = cd;
 	return 0;
-- 
1.6.3
