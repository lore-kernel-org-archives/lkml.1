Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbXDZUXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbXDZUXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbXDZUXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:23:03 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:52542 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755010AbXDZUVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:21:09 -0400
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.22 2/5] iw_cxgb3: Fail qp creation if the requested max_inline is too large.
Date: Thu, 26 Apr 2007 15:21:09 -0500
To: rdreier@cisco.com, jeff@garzik.org
Cc: divy@chelsio.com, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-Id: <20070426202107.24234.91018.stgit@dell3.ogc.int>
In-Reply-To: <20070426202057.24234.56383.stgit@dell3.ogc.int>
References: <20070426202057.24234.56383.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fail qp creation if the requested max_inline is too large.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/cxio_wr.h       |    1 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/cxio_wr.h b/drivers/infiniband/hw/cxgb3/cxio_wr.h
index 90d7b89..ff7290e 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_wr.h
+++ b/drivers/infiniband/hw/cxgb3/cxio_wr.h
@@ -38,6 +38,7 @@ #include <linux/timer.h>
 #include "firmware_exports.h"
 
 #define T3_MAX_SGE      4
+#define T3_MAX_INLINE	64
 
 #define Q_EMPTY(rptr,wptr) ((rptr)==(wptr))
 #define Q_FULL(rptr,wptr,size_log2)  ( (((wptr)-(rptr))>>(size_log2)) && \
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 24e0df0..b1128ec 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -780,6 +780,9 @@ static struct ib_qp *iwch_create_qp(stru
 	if (rqsize > T3_MAX_RQ_SIZE)
 		return ERR_PTR(-EINVAL);
 
+	if (attrs->cap.max_inline_data > T3_MAX_INLINE)
+		return ERR_PTR(-EINVAL);
+
 	/*
 	 * NOTE: The SQ and total WQ sizes don't need to be
 	 * a power of two.  However, all the code assumes
