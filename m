Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758Ab0AIRBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0AIRBb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 12:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202Ab0AIRBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 12:01:30 -0500
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:48795 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab0AIRBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 12:01:30 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B48B66D.8050406@cam.ac.uk>
Date: Sat, 09 Jan 2010 17:01:33 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20091029)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
CC: error27@gmail.com
Subject: [PATCH 2/2] staging: iio: Fix incorrect existence check for a shared
 event pointer.
References: <4B48B57E.40300@cam.ac.uk>
In-Reply-To: <4B48B57E.40300@cam.ac.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 A second smatch detected error. First part fixes in a typo
 in the comment directly above that I noticed whilst trying
 to remember what this code actually does. Second part is
 the actual fix.  I'm fairly amazed this one never caused
 trouble in testing as it is in one of the most common paths.

 drivers/staging/iio/industrialio-core.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index 87799b2..4ff683a 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -292,16 +292,16 @@ ssize_t iio_event_chrdev_read(struct file *filep,
 	mutex_unlock(&ev_int->event_list_lock);
 	/*
 	 * Possible concurency issue if an update of this event is on its way
-	 * through. May lead to new even being removed whilst the reported event
-	 * was the unescalated event. In typical use case this is not a problem
-	 * as userspace will say read half the buffer due to a 50% full event
-	 * which would make the correct 100% full incorrect anyway.
+	 * through. May lead to new event being removed whilst the reported
+	 * event was the unescalated event. In typical use case this is not a
+	 * problem as userspace will say read half the buffer due to a 50%
+	 * full event which would make the correct 100% full incorrect anyway.
 	 */
-	spin_lock(&el->shared_pointer->lock);
-	if (el->shared_pointer)
+	if (el->shared_pointer) {
+		spin_lock(&el->shared_pointer->lock);
 		(el->shared_pointer->ev_p) = NULL;
-	spin_unlock(&el->shared_pointer->lock);
-
+		spin_unlock(&el->shared_pointer->lock);
+	}
 	kfree(el);
 
 	return len;
-- 
1.6.4.4
