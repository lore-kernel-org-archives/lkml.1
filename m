Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbYK0KhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbYK0KhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:37:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbYK0Kcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:32:39 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:46001 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbYK0KcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:32:21 -0500
Message-Id: <20081127103131.672503551@de.ibm.com>
References: <20081127103020.528516828@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Nov 2008 11:30:34 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jan Glauber <jang@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 14/60] qdio: improve error handling for unexpected buffer states
Content-Disposition: inline; filename=113-qdio-error-handling.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Glauber <jang@linux.vnet.ibm.com>

In case of a qdio internal problem regarding the buffer handling
advance the queue and report the problem with WARN_ON instead
of getting stuck.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/qdio_main.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: quilt-2.6/drivers/s390/cio/qdio_main.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/qdio_main.c
+++ quilt-2.6/drivers/s390/cio/qdio_main.c
@@ -476,9 +476,12 @@ check_next:
 		atomic_sub(count, &q->nr_buf_used);
 		break;
 	case SLSB_CU_INPUT_EMPTY:
+		DBF_DEV_EVENT(DBF_INFO, q->irq_ptr, "in nop");
+		break;
 	case SLSB_P_INPUT_NOT_INIT:
 	case SLSB_P_INPUT_ACK:
-		DBF_DEV_EVENT(DBF_INFO, q->irq_ptr, "in nop");
+		WARN_ON(1);
+		q->first_to_check++;
 		break;
 	default:
 		BUG();
@@ -648,6 +651,9 @@ check_next:
 		DBF_DEV_EVENT(DBF_INFO, q->irq_ptr, "out primed:%1d", q->nr);
 		break;
 	case SLSB_P_OUTPUT_NOT_INIT:
+		WARN_ON(1);
+		q->first_to_check++;
+		break;
 	case SLSB_P_OUTPUT_HALTED:
 		break;
 	default:

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

