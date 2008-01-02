Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbYABXvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbYABXvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 18:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYABXv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 18:51:27 -0500
Received: from pool-71-245-101-243.ptldor.fios.verizon.net ([71.245.101.243]:59358
	"EHLO scooby.int.st.wgz.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753071AbYABXv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 18:51:27 -0500
From: "Brett T. Warden" <brett.warden@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Cc: Bill Davidsen <davidsen@tmr.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Brett T. Warden" <brett.warden@gmail.com>
Subject: [PATCH] bw-qcam: Adds module parameter 'aggressive' to skip polite auto-detection prior to direct initialization.
Date: Wed,  2 Jan 2008 15:51:24 -0800
Message-Id: <1199317885-1625-1-git-send-email-brett.warden@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: a372714f0712051031n31b933bfw6a5f9cb57b8cb5b8@mail.gmail.com
References: a372714f0712051031n31b933bfw6a5f9cb57b8cb5b8@mail.gmail.com
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
1.5.3.7

