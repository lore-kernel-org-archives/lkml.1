Return-Path: <linux-kernel-owner+w=401wt.eu-S1423138AbXBBOV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423138AbXBBOV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 09:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423157AbXBBOV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 09:21:57 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:34248 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423138AbXBBOV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 09:21:56 -0500
Date: Fri, 2 Feb 2007 15:21:54 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: cornelia.huck@de.ibm.com
Subject: [S390] cio: Catch operand exceptions on stsch.
Message-ID: <20070202142154.GB30839@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

[S390] cio: Catch operand exceptions on stsch.
 
If we have a subchannel id which has been generated via
for_each_subchannel(), it might contain an invalid subchannel set id.
We need to catch the ensuing operand exception by using stsch_err()
instead of stsch() in all possible cases.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/chsc.c |    2 +-
 drivers/s390/cio/css.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -urpN linux-2.6/drivers/s390/cio/chsc.c linux-2.6-patched/drivers/s390/cio/chsc.c
--- linux-2.6/drivers/s390/cio/chsc.c	2007-02-02 14:04:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/chsc.c	2007-02-02 14:04:41.000000000 +0100
@@ -608,7 +608,7 @@ __chp_add_new_sch(struct subchannel_id s
 	struct schib schib;
 	int ret;
 
-	if (stsch(schid, &schib))
+	if (stsch_err(schid, &schib))
 		/* We're through */
 		return need_rescan ? -EAGAIN : -ENXIO;
 
diff -urpN linux-2.6/drivers/s390/cio/css.c linux-2.6-patched/drivers/s390/cio/css.c
--- linux-2.6/drivers/s390/cio/css.c	2007-02-02 14:04:19.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/css.c	2007-02-02 14:04:41.000000000 +0100
@@ -296,7 +296,7 @@ static int css_evaluate_new_subchannel(s
 		/* Will be done on the slow path. */
 		return -EAGAIN;
 	}
-	if (stsch(schid, &schib) || !schib.pmcw.dnv) {
+	if (stsch_err(schid, &schib) || !schib.pmcw.dnv) {
 		/* Unusable - ignore. */
 		return 0;
 	}
