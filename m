Return-Path: <linux-kernel-owner+w=401wt.eu-S1759694AbZIQCrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759694AbZIQCrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 22:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756735AbZIQCrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 22:47:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51700 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbZIQCrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 22:47:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 17 Sep 2009 11:45:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Am?rico_Wang <xiyou.wangcong@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 3/3][mmotm] updateing size of kcore
Message-Id: <20090917114509.a9eb9f2c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090917114138.e14a1183.kamezawa.hiroyu@jp.fujitsu.com>
References: <2375c9f90909160235m1f052df0qb001f8243ed9291e@mail.gmail.com>
	<1bc66b163326564dafb5a7dd8959fd56.squirrel@webmail-b.css.fujitsu.com>
	<20090917114138.e14a1183.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After memory hotplug (or other events in future), kcore size
can be modified.

To update inode->i_size, we have to know inode/dentry but we
can't get it from inside /proc directly.
But considerinyg memory hotplug, kcore image is updated only when
it's opened. Then, updating inode->i_size at open() is enough.

Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/proc/kcore.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: mmotm-2.6.31-Sep14/fs/proc/kcore.c
===================================================================
--- mmotm-2.6.31-Sep14.orig/fs/proc/kcore.c
+++ mmotm-2.6.31-Sep14/fs/proc/kcore.c
@@ -546,6 +546,11 @@ static int open_kcore(struct inode *inod
 		return -EPERM;
 	if (kcore_need_update)
 		kcore_update_ram();
+	if (i_size_read(inode) != proc_root_kcore->size) {
+		mutex_lock(&inode->i_mutex);
+		i_size_write(inode, proc_root_kcore->size);
+		mutex_unlock(&inode->i_mutex);
+	}
 	return 0;
 }
 

