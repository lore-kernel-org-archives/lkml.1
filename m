Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbZJBIjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbZJBIjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 04:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbZJBIjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 04:39:52 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41427 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbZJBIju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 04:39:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] Fix strstrip() abuse in elv_iosched_store()
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20091002173635.5F6C.A69D9226@jp.fujitsu.com>
References: <20091002173635.5F6C.A69D9226@jp.fujitsu.com>
Message-Id: <20091002173803.5F6F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  2 Oct 2009 17:39:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


elv_iosched_store() ignore the return value of strstrip().
it makes small inconsistent behavior.

This patch fixes it.


 <before>
 ====================================
 # cd /sys/block/{blockdev}/queue

 case1:
 # echo "anticipatory" > scheduler
 # cat scheduler
 noop [anticipatory] deadline cfq

 case2:
 # echo "anticipatory " > scheduler
 # cat scheduler
 noop [anticipatory] deadline cfq

 case3:
 # echo " anticipatory" > scheduler
 bash: echo: write error: Invalid argument

 <after>
 ====================================
 # cd /sys/block/{blockdev}/queue

 case1:
 # echo "anticipatory" > scheduler
 # cat scheduler
 noop [anticipatory] deadline cfq

 case2:
 # echo "anticipatory " > scheduler
 # cat scheduler
 noop [anticipatory] deadline cfq

 case3:
 # echo " anticipatory" > scheduler
 noop [anticipatory] deadline cfq


Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 block/elevator.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: b/block/elevator.c
===================================================================
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -1059,9 +1059,7 @@ ssize_t elv_iosched_store(struct request
 		return count;
 
 	strlcpy(elevator_name, name, sizeof(elevator_name));
-	strstrip(elevator_name);
-
-	e = elevator_get(elevator_name);
+	e = elevator_get(strstrip(elevator_name));
 	if (!e) {
 		printk(KERN_ERR "elevator: type %s not found\n", elevator_name);
 		return -EINVAL;


