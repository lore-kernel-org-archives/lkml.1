Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbYIAFKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbYIAFKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 01:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbYIAFJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 01:09:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63304 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbYIAFJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 01:09:55 -0400
Message-ID: <48BB78E7.5080001@cn.fujitsu.com>
Date: Mon, 01 Sep 2008 13:08:55 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] res_counter: fix off-by-one bug in setting limit
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found we can no longer set limit to 0 with 2.6.27-rcX:
 # mount -t cgroup -omemory xxx /mnt
 # mkdir /mnt/0
 # echo 0 > /mnt/0/memory.limit_in_bytes
 bash: echo: write error: Device or resource busy

It turned out 'limit' can't be set to 'usage', which is wrong IMO.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/res_counter.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index fdeadd9..271c1c2 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -166,7 +166,7 @@ static inline int res_counter_set_limit(struct res_counter *cnt,
 	int ret = -EBUSY;
 
 	spin_lock_irqsave(&cnt->lock, flags);
-	if (cnt->usage < limit) {
+	if (cnt->usage <= limit) {
 		cnt->limit = limit;
 		ret = 0;
 	}
-- 1.5.4.rc3 
