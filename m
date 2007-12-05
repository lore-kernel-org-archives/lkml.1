Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753357AbXLEAVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbXLEAVu (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 4 Dec 2007 19:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXLEAVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 19:21:41 -0500
Received: from pool-71-245-101-243.ptldor.fios.verizon.net ([71.245.101.243]:57241
	"EHLO scooby.int.st.wgz.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750806AbXLEAVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 19:21:40 -0500
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Dec 2007 19:21:40 EST
From: "Brett T. Warden" <brett.warden@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] bw-qcam: adds parameter aggressive to skip passive detection and directly attempt initialization
Date: Tue,  4 Dec 2007 16:14:13 -0800
Message-Id: <11968136532167-git-send-email->
X-Mailer: git-send-email 1.5.2.5
Signed-off-by: Brett T. Warden <brett.warden@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---

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
