Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752710AbXLEAow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbXLEAow (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 4 Dec 2007 19:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbXLEAon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 19:44:43 -0500
Received: from pool-71-245-101-243.ptldor.fios.verizon.net ([71.245.101.243]:63799
	"EHLO scooby.int.st.wgz.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751324AbXLEAom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 19:44:42 -0500
From: "Brett T. Warden" <brett.warden@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Cc: "Brett T. Warden" <brett.warden@gmail.com>
Subject: [PATCH] bw-qcam: Adds module parameter 'aggressive' to skip polite auto-detection prior to direct initialization.
Date: Tue,  4 Dec 2007 16:44:41 -0800
Message-Id: <11968154813878-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: 11968136532167-git-send-email-
References: 11968136532167-git-send-email-
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting aggressive=1 bypasses the friendly auto-detection by polling the status register, and instead attempts to initialize the qcam directly. Not friendly to other parallel devices, but much more reliable than the auto-detection.

Signed-off-by: Brett T. Warden <brett.warden@gmail.com>
---
 drivers/media/video/bw-qcam.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/bw-qcam.c b/drivers/media/video/bw-qcam.c
index 5842352..b74a9cb 100644
--- a/drivers/media/video/bw-qcam.c
+++ b/drivers/media/video/bw-qcam.c
@@ -82,11 +82,16 @@ OTHER DEALINGS IN THE SOFTWARE.
 static unsigned int maxpoll=250;   /* Maximum busy-loop count for qcam I/O */
 static unsigned int yieldlines=4;  /* Yield after this many during capture */
 static int video_nr = -1;
+static unsigned int aggressive;		/* Whether to probe aggressively */
 
 module_param(maxpoll, int, 0);
 module_param(yieldlines, int, 0);
 module_param(video_nr, int, 0);
 
+/* Set aggressive=1 to avoid detection by polling status register and
+ * immediately attempt to initialize qcam */
+module_param(aggressive, int, 0);
+
 static inline int read_lpstatus(struct qcam_device *q)
 {
 	return parport_read_status(q->pport);
@@ -331,6 +336,9 @@ static int qc_detect(struct qcam_device *q)
 	int count = 0;
 	int i;
 
+	if (aggressive)
+		return 1;
+
 	lastreg = reg = read_lpstatus(q) & 0xf0;
 
 	for (i = 0; i < 500; i++)
@@ -354,12 +362,12 @@ static int qc_detect(struct qcam_device *q)
 
 	/* Be (even more) liberal in what you accept...  */
 
-/*	if (count > 30 && count < 200) */
 	if (count > 20 && count < 400) {
 		return 1;	/* found */
 	} else {
 		printk(KERN_ERR "No Quickcam found on port %s\n",
 			q->pport->name);
+		printk(KERN_DEBUG "Quickcam detection counter: %u\n", count);
 		return 0;	/* not found */
 	}
 }
-- 
1.5.2.5

