Return-Path: <linux-kernel-owner+w=401wt.eu-S1751637AbXCEWly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbXCEWly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbXCEWlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:41:53 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:26170 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932495AbXCEWlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:41:25 -0500
Date: Mon, 5 Mar 2007 23:41:25 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: wein@de.ibm.com
Subject: [S390] dasd: Use default recovery for SNSS requests
Message-ID: <20070305224124.GG22630@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Weinhuber <wein@de.ibm.com>

[S390] dasd: Use default recovery for SNSS requests

For extended error reporting we sometimes have to start an
Sense Subsystem Status request (SNSS). When this request needs
to be recovered for some reason, the recovery request will
fail with 'command reject'.
Our usual recovery procedure will retry the failed request by
creating a new request and chaining the failed request from that
one. SNSS requests, though, must not be chained from anything,
so the recovery request will fail permanently.
Use the default recovery for SNSS request, which will just restart
the original request without further ado.

Signed-off-by: Stefan Weinhuber <wein@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/block/dasd_eer.c |    1 +
 1 files changed, 1 insertion(+)

diff -urpN linux-2.6/drivers/s390/block/dasd_eer.c linux-2.6-patched/drivers/s390/block/dasd_eer.c
--- linux-2.6/drivers/s390/block/dasd_eer.c	2007-03-05 22:51:36.000000000 +0100
+++ linux-2.6-patched/drivers/s390/block/dasd_eer.c	2007-03-05 22:51:53.000000000 +0100
@@ -461,6 +461,7 @@ int dasd_eer_enable(struct dasd_device *
 	cqr->device = device;
 	cqr->retries = 255;
 	cqr->expires = 10 * HZ;
+	clear_bit(DASD_CQR_FLAGS_USE_ERP, &cqr->flags);
 
 	cqr->cpaddr->cmd_code = DASD_ECKD_CCW_SNSS;
 	cqr->cpaddr->count = SNSS_DATA_SIZE;
