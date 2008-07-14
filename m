Return-Path: <linux-kernel-owner+w=401wt.eu-S1756981AbYGNIIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbYGNIIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 04:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755486AbYGNIIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 04:08:01 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38156 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976AbYGNIIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 04:08:00 -0400
Date: Mon, 14 Jul 2008 17:11:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2][-mm][resend] res_counter limit change support ebusy
Message-Id: <20080714171154.e1cc9943.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an interface to set limit. This is necessary to memory resource controller
because it shrinks usage at set limit.

(*) Other controller may not need this interface to shrink usage because
    shrinking is not necessary or impossible.

This is an enhancement.
named as res_counter-limit-change-ebusy.patch

Changelog:
  - fixed white space bug.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


 include/linux/res_counter.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: linux-2.6.26-rc8-mm1/include/linux/res_counter.h
===================================================================
--- linux-2.6.26-rc8-mm1.orig/include/linux/res_counter.h
+++ linux-2.6.26-rc8-mm1/include/linux/res_counter.h
@@ -176,4 +176,19 @@ static inline bool res_counter_can_add(s
 	return ret;
 }
 
+static inline int res_counter_set_limit(struct res_counter *cnt,
+	unsigned long long limit)
+{
+	unsigned long flags;
+	int ret = -EBUSY;
+
+	spin_lock_irqsave(&cnt->lock, flags);
+	if (cnt->usage < limit) {
+		cnt->limit = limit;
+		ret = 0;
+	}
+	spin_unlock_irqrestore(&cnt->lock, flags);
+	return ret;
+}
+
 #endif

