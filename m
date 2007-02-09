Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbXBIXCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbXBIXCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 18:02:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbXBIXCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 18:02:09 -0500
Received: from zakalwe.fi ([80.83.5.154]:48930 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbXBIXCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 18:02:07 -0500
Date: Sat, 10 Feb 2007 01:01:30 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Gerd Knorr <kraxel@bytesex.org>, v4l-dvb-maintainer@linuxtv.org,
       mchehab@infradead.org
Subject: [PATCH] saa7134: cleanup
Message-ID: <20070209230130.GB11613@zakalwe.fi>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline

A cleanup patch against 2.6.20 for saa7134 video4linux driver:

 - use generic sort instead of bubblesort
 - removed useless saa7134_video_fini function
 - small coding style changes

Signed-off-by: Heikki Orsila <heikki.orsila@iki.fi>

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd

--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="saa7134-cleanup.diff"

diff -urp linux-2.6.20-org/drivers/media/video/saa7134/saa7134-core.c linux-2.6.20/drivers/media/video/saa7134/saa7134-core.c
--- linux-2.6.20-org/drivers/media/video/saa7134/saa7134-core.c	2007-02-04 20:44:54.000000000 +0200
+++ linux-2.6.20/drivers/media/video/saa7134/saa7134-core.c	2007-02-10 00:51:01.000000000 +0200
@@ -703,7 +703,6 @@ static int saa7134_hwfini(struct saa7134
 		saa7134_ts_fini(dev);
 	saa7134_input_fini(dev);
 	saa7134_vbi_fini(dev);
-	saa7134_video_fini(dev);
 	saa7134_tvaudio_fini(dev);
 	return 0;
 }
diff -urp linux-2.6.20-org/drivers/media/video/saa7134/saa7134-video.c linux-2.6.20/drivers/media/video/saa7134/saa7134-video.c
--- linux-2.6.20-org/drivers/media/video/saa7134/saa7134-video.c	2007-02-04 20:44:54.000000000 +0200
+++ linux-2.6.20/drivers/media/video/saa7134/saa7134-video.c	2007-02-10 00:51:01.000000000 +0200
@@ -26,6 +26,7 @@
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/sort.h>
 
 #include "saa7134-reg.h"
 #include "saa7134.h"
@@ -516,14 +517,12 @@ static int res_get(struct saa7134_dev *d
 	return 1;
 }
 
-static
-int res_check(struct saa7134_fh *fh, unsigned int bit)
+static int res_check(struct saa7134_fh *fh, unsigned int bit)
 {
 	return (fh->resources & bit);
 }
 
-static
-int res_locked(struct saa7134_dev *dev, unsigned int bit)
+static int res_locked(struct saa7134_dev *dev, unsigned int bit)
 {
 	return (dev->resources & bit);
 }
@@ -732,25 +731,6 @@ struct cliplist {
 	__u8  disable;
 };
 
-static void sort_cliplist(struct cliplist *cl, int entries)
-{
-	struct cliplist swap;
-	int i,j,n;
-
-	for (i = entries-2; i >= 0; i--) {
-		for (n = 0, j = 0; j <= i; j++) {
-			if (cl[j].position > cl[j+1].position) {
-				swap = cl[j];
-				cl[j] = cl[j+1];
-				cl[j+1] = swap;
-				n++;
-			}
-		}
-		if (0 == n)
-			break;
-	}
-}
-
 static void set_cliplist(struct saa7134_dev *dev, int reg,
 			struct cliplist *cl, int entries, char *name)
 {
@@ -784,15 +764,27 @@ static int clip_range(int val)
 	return val;
 }
 
+/* Sort into smallest position first order */
+static int cliplist_cmp(const void *a, const void *b)
+{
+	const struct cliplist *cla = a;
+	const struct cliplist *clb = b;
+	if (cla->position < clb->position)
+		return -1;
+	if (cla->position > clb->position)
+		return 1;
+	return 0;
+}
+
 static int setup_clipping(struct saa7134_dev *dev, struct v4l2_clip *clips,
 			  int nclips, int interlace)
 {
 	struct cliplist col[16], row[16];
-	int cols, rows, i;
+	int cols = 0, rows = 0, i;
 	int div = interlace ? 2 : 1;
 
-	memset(col,0,sizeof(col)); cols = 0;
-	memset(row,0,sizeof(row)); rows = 0;
+	memset(col, 0, sizeof(col));
+	memset(row, 0, sizeof(row));
 	for (i = 0; i < nclips && i < 8; i++) {
 		col[cols].position = clip_range(clips[i].c.left);
 		col[cols].enable   = (1 << i);
@@ -808,8 +800,8 @@ static int setup_clipping(struct saa7134
 		row[rows].disable  = (1 << i);
 		rows++;
 	}
-	sort_cliplist(col,cols);
-	sort_cliplist(row,rows);
+	sort(col, cols, sizeof col[0], cliplist_cmp, NULL);
+	sort(row, rows, sizeof row[0], cliplist_cmp, NULL);
 	set_cliplist(dev,0x380,col,cols,"cols");
 	set_cliplist(dev,0x384,row,rows,"rows");
 	return 0;
@@ -1261,19 +1253,14 @@ static struct videobuf_queue* saa7134_qu
 
 static int saa7134_resource(struct saa7134_fh *fh)
 {
-	int res = 0;
+	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return RESOURCE_VIDEO;
 
-	switch (fh->type) {
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		res = RESOURCE_VIDEO;
-		break;
-	case V4L2_BUF_TYPE_VBI_CAPTURE:
-		res = RESOURCE_VBI;
-		break;
-	default:
-		BUG();
-	}
-	return res;
+	if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE)
+		return RESOURCE_VBI;
+
+	BUG();
+	return 0;
 }
 
 static int video_open(struct inode *inode, struct file *file)
@@ -1461,8 +1448,7 @@ static int video_release(struct inode *i
 	return 0;
 }
 
-static int
-video_mmap(struct file *file, struct vm_area_struct * vma)
+static int video_mmap(struct file *file, struct vm_area_struct * vma)
 {
 	struct saa7134_fh *fh = file->private_data;
 
@@ -2461,12 +2447,6 @@ int saa7134_video_init2(struct saa7134_d
 	return 0;
 }
 
-int saa7134_video_fini(struct saa7134_dev *dev)
-{
-	/* nothing */
-	return 0;
-}
-
 void saa7134_irq_video_intl(struct saa7134_dev *dev)
 {
 	static const char *st[] = {
diff -urp linux-2.6.20-org/drivers/media/video/saa7134/saa7134.h linux-2.6.20/drivers/media/video/saa7134/saa7134.h
--- linux-2.6.20-org/drivers/media/video/saa7134/saa7134.h	2007-02-04 20:44:54.000000000 +0200
+++ linux-2.6.20/drivers/media/video/saa7134/saa7134.h	2007-02-10 00:51:01.000000000 +0200
@@ -633,7 +633,6 @@ int saa7134_common_ioctl(struct saa7134_
 
 int saa7134_video_init1(struct saa7134_dev *dev);
 int saa7134_video_init2(struct saa7134_dev *dev);
-int saa7134_video_fini(struct saa7134_dev *dev);
 void saa7134_irq_video_intl(struct saa7134_dev *dev);
 void saa7134_irq_video_done(struct saa7134_dev *dev, unsigned long status);
 

--UlVJffcvxoiEqYs2--
