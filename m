Return-Path: <linux-kernel-owner+w=401wt.eu-S932985AbZKXNtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbZKXNtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 08:49:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932957AbZKXNtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 08:49:11 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:53626 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944AbZKXNtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 08:49:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=BKRGv8MylrVzdC42xCj7Pqnu5CUrOhTsPviqCdlf9HnfB4a2B0x2DZ3k/18fv+N1bK
         8fxOmKK1ObZnjuPlWdnbdRkJwLRXzHVrvYv7TfttxHsrfl99REASLdpFu/xZ+GUhGesl
         deQxoufIT164WWXxHRMR2X5WXM1pyIaa3L5Sg=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 2/4] cfq-iosched: fix no-idle preemption logic
Date: Tue, 24 Nov 2009 14:49:02 +0100
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911241449.02473.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An incoming no-idle queue should preempt the active no-idle queue
only if the active queue is idling due to service tree empty.
Previous code was buggy in two ways:
* it relied on service_tree field to be set on the active queue, while
  it is not set when the code is idling for a new request
* it didn't check for the service tree empty condition, so could lead to
  LIFO behaviour if multiple queues with depth > 1 were preempting each
  other on an non-NCQ device.

Reported-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 6925ab9..2a304f4 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2401,8 +2401,9 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	if (cfq_class_idle(cfqq))
 		return true;
 
-	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD
-	    && new_cfqq->service_tree == cfqq->service_tree)
+	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD &&
+	    cfqq_type(new_cfqq) == SYNC_NOIDLE_WORKLOAD &&
+	    new_cfqq->service_tree->count == 1)
 		return true;
 
 	/*
-- 
1.6.2.5


