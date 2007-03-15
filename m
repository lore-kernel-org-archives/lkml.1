Return-Path: <linux-kernel-owner+w=401wt.eu-S933933AbXCOWQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933933AbXCOWQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932229AbXCOWPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:15:34 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33691 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407AbXCOWPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:25 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 30 of 33] IB/ipath - check reserved keys
X-Mercurial-Node: bf280d5f83d59788b58c17ff206bc3f54271a790
Message-Id: <bf280d5f83d59788b58c.1173995114@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:45:14 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Robert Walsh <robert.walsh@qlogic.com>
# Date 1173994465 25200
# Node ID bf280d5f83d59788b58c17ff206bc3f54271a790
# Parent  8c4f730dbde3eed6e066ead5be4746d58840f24f
IB/ipath - check reserved keys

Don't let userspace use the direct-physical-map L-key or R-key.

Signed-off-by: Ralph Campbell <ralph.campbell@qlogic.com>

diff -r 8c4f730dbde3 -r bf280d5f83d5 drivers/infiniband/hw/ipath/ipath_keys.c
--- a/drivers/infiniband/hw/ipath/ipath_keys.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_keys.c	Thu Mar 15 14:34:25 2007 -0700
@@ -133,6 +133,12 @@ int ipath_lkey_ok(struct ipath_qp *qp, s
 	 * being reversible by calling bus_to_virt().
 	 */
 	if (sge->lkey == 0) {
+		struct ipath_pd *pd = to_ipd(qp->ibqp.pd);
+
+		if (pd->user) {
+			ret = 0;
+			goto bail;
+		}
 		isge->mr = NULL;
 		isge->vaddr = (void *) sge->addr;
 		isge->length = sge->length;
@@ -206,6 +212,12 @@ int ipath_rkey_ok(struct ipath_qp *qp, s
 	 * (see ipath_get_dma_mr and ipath_dma.c).
 	 */
 	if (rkey == 0) {
+		struct ipath_pd *pd = to_ipd(qp->ibqp.pd);
+
+		if (pd->user) {
+			ret = 0;
+			goto bail;
+		}
 		sge->mr = NULL;
 		sge->vaddr = (void *) vaddr;
 		sge->length = len;
