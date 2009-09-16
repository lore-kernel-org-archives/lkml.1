Return-Path: <linux-kernel-owner+w=401wt.eu-S1760606AbZIPWqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760606AbZIPWqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760592AbZIPWqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:46:16 -0400
Received: from kroah.org ([198.145.64.141]:48963 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760361AbZIPWj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:39:57 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:16 2009
Message-Id: <20090916223716.166513955@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 20/45] block: dont assume device has a request list backing in nr_requests store
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=block-don-t-assume-device-has-a-request-list-backing-in-nr_requests-store.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jens Axboe <jens.axboe@oracle.com>

commit b8a9ae779f2c7049071034661e09cb7e1e82250c upstream.

Stacked devices do not. For now, just error out with -EINVAL. Later
we could make the limit apply on stacked devices too, for throttling
reasons.

This fixes

5a54cd13353bb3b88887604e2c980aa01e314309

and should go into 2.6.31 stable as well.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/blk-sysfs.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -40,7 +40,12 @@ queue_requests_store(struct request_queu
 {
 	struct request_list *rl = &q->rq;
 	unsigned long nr;
-	int ret = queue_var_store(&nr, page, count);
+	int ret;
+
+	if (!q->request_fn)
+		return -EINVAL;
+
+	ret = queue_var_store(&nr, page, count);
 	if (nr < BLKDEV_MIN_RQ)
 		nr = BLKDEV_MIN_RQ;
 


