Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbZKMPL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbZKMPL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 10:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbZKMPLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 10:11:40 -0500
Received: from mtagate4.de.ibm.com ([195.212.17.164]:36497 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136AbZKMPJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 10:09:07 -0500
Message-Id: <20091113150915.398821774@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 13 Nov 2009 16:08:58 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 34/52] [PATCH] cio: ensure proper locking during device recognition
References: <20091113150824.351347652@de.ibm.com>
Content-Disposition: inline; filename=133-cio-recognition-locking.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Device recognition needs to be started with the ccw device lock
held to prevent race conditions between I/O starting and interrupt
reception.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/device.c |    2 ++
 1 file changed, 2 insertions(+)

Index: quilt-2.6/drivers/s390/cio/device.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/device.c	2009-11-13 16:08:18.000000000 +0100
+++ quilt-2.6/drivers/s390/cio/device.c	2009-11-13 16:08:19.000000000 +0100
@@ -488,7 +488,9 @@
 {
 	/* Do device recognition, if needed. */
 	if (cdev->private->state == DEV_STATE_BOXED) {
+		spin_lock_irq(cdev->ccwlock);
 		ccw_device_recognition(cdev);
+		spin_unlock_irq(cdev->ccwlock);
 		wait_event(cdev->private->wait_q,
 			   cdev->private->flags.recog_done);
 		if (cdev->private->state != DEV_STATE_OFFLINE)

