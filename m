Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbZJDRKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbZJDRKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 13:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756912AbZJDRKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 13:10:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:47071 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbZJDRKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 13:10:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=qh1mxiaXYBSmsPDXdy90sbyHOaBpwc1KqI1sJ+QsOZFR1v9dvGd9JFAbzjxkxJMPLt
         FL4T3h93nsNhr6Jgl+QjcxlErFnqsRnXfFJkQssTZshQG2H2PfSGwmR/1CGxufbzxiBT
         vCvxKfz2dHRATso+EIZS6xgoAw+5Jd5i/qEUY=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: cfq: fix possible problem with jiffies wraparound
Date: Sun, 4 Oct 2009 19:09:07 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200910041909.08282.czoccolo@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RR service tree is indexed by a key that is relative to current jiffies.
This can cause problems on jiffies wraparound.

The patch fixes it using time_before comparison, and changing
the add_front path to use a relative number, too.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 576e92d..495b16d 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -512,8 +512,11 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
                rb_key = cfq_slice_offset(cfqd, cfqq) + jiffies;
                rb_key += cfqq->slice_resid;
                cfqq->slice_resid = 0;
-       } else
-               rb_key = 0;
+       } else {
+               rb_key = -HZ;
+               __cfqq = cfq_rb_first(&cfqd->service_tree);
+               rb_key += __cfqq ? __cfqq->rb_key : jiffies;
+       }
 
        if (!RB_EMPTY_NODE(&cfqq->rb_node)) {
                /*
@@ -547,7 +550,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
                        n = &(*p)->rb_left;
                else if (cfq_class_idle(cfqq) > cfq_class_idle(__cfqq))
                        n = &(*p)->rb_right;
-               else if (rb_key < __cfqq->rb_key)
+               else if (time_before(rb_key, __cfqq->rb_key))
                        n = &(*p)->rb_left;
                else
                        n = &(*p)->rb_right;


