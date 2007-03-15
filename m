Return-Path: <linux-kernel-owner+w=401wt.eu-S1422987AbXCOWUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422987AbXCOWUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933862AbXCOWTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:19:41 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33709 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933822AbXCOWP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:28 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 12 of 33] IB/ipath - fix bad argument to clear_bit that
	trashed memory and/or crashed
X-Mercurial-Node: 84a9691cf7ff54ce76de402d2353a451ba9c555b
Message-Id: <84a9691cf7ff54ce76de.1173995096@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:44:56 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Bryan O'Sullivan <bos@pathscale.com>
# Date 1173994465 25200
# Node ID 84a9691cf7ff54ce76de402d2353a451ba9c555b
# Parent  c793dc8a526564b73018924a707bcb21052f8f36
IB/ipath - fix bad argument to clear_bit that trashed memory and/or crashed

Code was converted from a &= ~mask to clear_bit, but the bit was left shifted
instead of being used directly, so we were either trashing memory several
pages away, or sometimes taking a kernel page fault on an invalid page.

Signed-off-by: Dave Olson <dave.olson@qlogic.com>
Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r c793dc8a5265 -r 84a9691cf7ff drivers/infiniband/hw/ipath/ipath_intr.c
--- a/drivers/infiniband/hw/ipath/ipath_intr.c	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_intr.c	Thu Mar 15 14:34:25 2007 -0700
@@ -842,11 +842,10 @@ static void handle_urcv(struct ipath_dev
 		struct ipath_portdata *pd = dd->ipath_pd[i];
 		if (portr & (1 << i) && pd && pd->port_cnt &&
 			test_bit(IPATH_PORT_WAITING_RCV, &pd->port_flag)) {
-			int rcbit;
 			clear_bit(IPATH_PORT_WAITING_RCV,
 				  &pd->port_flag);
-			rcbit = i + INFINIPATH_R_INTRAVAIL_SHIFT;
-			clear_bit(1UL << rcbit, &dd->ipath_rcvctrl);
+			clear_bit(i + INFINIPATH_R_INTRAVAIL_SHIFT,
+				  &dd->ipath_rcvctrl);
 			wake_up_interruptible(&pd->port_wait);
 			rcvdint = 1;
 		}
