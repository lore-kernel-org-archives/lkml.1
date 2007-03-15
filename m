Return-Path: <linux-kernel-owner+w=401wt.eu-S933936AbXCOW3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933936AbXCOW3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422975AbXCOW2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:28:42 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33697 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbXCOWP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:26 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 06 of 33] IB/ipath - NMI cpu lockup if local loopback used
X-Mercurial-Node: 78ae7bddbd5e205adc12993ad2956e0402ca01d7
Message-Id: <78ae7bddbd5e205adc12.1173995090@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:44:50 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Ralph Campbell <ralph.campbell@qlogic.com>
# Date 1173994464 25200
# Node ID 78ae7bddbd5e205adc12993ad2956e0402ca01d7
# Parent  fa38a027a0853a80c4f7dfc50345c89f195bc85b
IB/ipath - NMI cpu lockup if local loopback used

If a post send is done in loopback and there is no receive queue entry,
the sending QP is put on a timeout list for a while so the receiver has
a chance to post a receive buffer. If the another post send is done,
the code incorrectly tried to put the QP on the timeout list again an
corrupted the timeout list. This eventually leads to a spin lock deadlock
NMI due to the timer function looping forever with the lock held.

Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r fa38a027a085 -r 78ae7bddbd5e drivers/infiniband/hw/ipath/ipath_ruc.c
--- a/drivers/infiniband/hw/ipath/ipath_ruc.c	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_ruc.c	Thu Mar 15 14:34:24 2007 -0700
@@ -265,7 +265,8 @@ again:
 again:
 	spin_lock_irqsave(&sqp->s_lock, flags);
 
-	if (!(ib_ipath_state_ops[sqp->state] & IPATH_PROCESS_SEND_OK)) {
+	if (!(ib_ipath_state_ops[sqp->state] & IPATH_PROCESS_SEND_OK) ||
+	    qp->s_rnr_timeout) {
 		spin_unlock_irqrestore(&sqp->s_lock, flags);
 		goto done;
 	}
