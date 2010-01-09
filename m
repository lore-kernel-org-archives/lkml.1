Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746Ab0AIQ5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab0AIQ5c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 11:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712Ab0AIQ5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 11:57:31 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:51463 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab0AIQ5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 11:57:30 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B48B57E.40300@cam.ac.uk>
Date: Sat, 09 Jan 2010 16:57:34 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20091029)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
CC: error27@gmail.com
Subject: [PATCH 1/2] staging: iio: Ensure mutex is correctly unlocked in __iio_push_event
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---

 This error was picked up by running the smatch static
 checker over all the IIO subsytem.
 
 Whilst there are some false positives in some of the
 drivers, it picked up two real errors in the core. I
 was very impressed at the quality of the reporting and
 so Dan you can add me to your list of users as I'll be
 making frequent use of it in the future!

 drivers/staging/iio/industrialio-core.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index 768f448..87799b2 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -79,11 +79,14 @@ EXPORT_SYMBOL(__iio_change_event);
 	/* Does anyone care? */
 	mutex_lock(&ev_int->event_list_lock);
 	if (test_bit(IIO_BUSY_BIT_POS, &ev_int->handler.flags)) {
-		if (ev_int->current_events == ev_int->max_events)
+		if (ev_int->current_events == ev_int->max_events) {
+			mutex_unlock(&ev_int->event_list_lock);
 			return 0;
+		}
 		ev = kmalloc(sizeof(*ev), GFP_KERNEL);
 		if (ev == NULL) {
 			ret = -ENOMEM;
+			mutex_unlock(&ev_int->event_list_lock);
 			goto error_ret;
 		}
 		ev->ev.id = ev_code;
-- 
1.6.4.4

