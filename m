Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbYDMIxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbYDMIxo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 04:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757131AbYDMIxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 04:53:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:15150 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796AbYDMIxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:53:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=RqcloIdABdkUQxYWE8+K5WVVY91Uxb5Uku9sZ7evdhUjYc3RR8myqJzEtiU1WssZlNoyzJ+c2ndYEvB9km67+0TRA4eVS+s4k894Qk9HIXZilwK9Mcxal8ddfkWaNU/JzGpkMp+kWEhw1ZYwZ3cmYQJ4TiTp24JHYeefQxcon1U=
Date: Sun, 13 Apr 2008 12:48:43 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org
Subject: [PATCH] Fix concurrent read from /proc/videocodecs
Message-ID: <20080413084843.GA7227@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Observation one: ->write_proc and ->data assignments aren't needed. Removed.
Observation two: codecs lists are unprotected. Patch doesn't fix this.
Observation three:
	/proc/videocodecs printout is done to temporary _global_ buffer which
	is freed in between. Consequently, two users hitting this file can
	screwup each other.

Steps to reproduce:

	modprobe videocodec
	while true; do cat /proc/videocodecs &>/dev/null; done &
	while true; do cat /proc/videocodecs &>/dev/null; done &

The fix is switching to seq_files, this removes code, especially some
line-length "logic".

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 Tested on empty file, I don't have hardware.

 drivers/media/video/videocodec.c |  113 ++++++---------------------------------
 1 file changed, 19 insertions(+), 94 deletions(-)

--- a/drivers/media/video/videocodec.c
+++ b/drivers/media/video/videocodec.c
@@ -39,6 +39,7 @@
 
 #ifdef CONFIG_PROC_FS
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <asm/uaccess.h>
 #endif
 
@@ -320,56 +321,22 @@ videocodec_unregister (const struct videocodec *codec)
 }
 
 #ifdef CONFIG_PROC_FS
-/* ============ */
-/* procfs stuff */
-/* ============ */
-
-static char *videocodec_buf = NULL;
-static int videocodec_bufsize;
-
-static int
-videocodec_build_table (void)
+static int proc_videocodecs_show(struct seq_file *m, void *v)
 {
 	struct codec_list *h = codeclist_top;
 	struct attached_list *a;
-	int i = 0, size;
-
-	// sum up amount of slaves plus their attached masters
-	while (h) {
-		i += h->attached + 1;
-		h = h->next;
-	}
-#define LINESIZE 100
-	size = LINESIZE * (i + 1);
 
-	dprintk(3, "videocodec_build table: %d entries, %d bytes\n", i,
-		size);
-
-	kfree(videocodec_buf);
-	videocodec_buf = kmalloc(size, GFP_KERNEL);
-
-	if (!videocodec_buf)
-		return 0;
-
-	i = 0;
-	i += scnprintf(videocodec_buf + i, size - 1,
-		      "<S>lave or attached <M>aster name  type flags    magic    ");
-	i += scnprintf(videocodec_buf + i, size -i - 1, "(connected as)\n");
+	seq_printf(m, "<S>lave or attached <M>aster name  type flags    magic    ");
+	seq_printf(m, "(connected as)\n");
 
 	h = codeclist_top;
 	while (h) {
-		if (i > (size - LINESIZE))
-			break;	// security check
-		i += scnprintf(videocodec_buf + i, size -i -1,
-			      "S %32s %04x %08lx %08lx (TEMPLATE)\n",
+		seq_printf(m, "S %32s %04x %08lx %08lx (TEMPLATE)\n",
 			      h->codec->name, h->codec->type,
 			      h->codec->flags, h->codec->magic);
 		a = h->list;
 		while (a) {
-			if (i > (size - LINESIZE))
-				break;	// security check
-			i += scnprintf(videocodec_buf + i, size -i -1,
-				      "M %32s %04x %08lx %08lx (%s)\n",
+			seq_printf(m, "M %32s %04x %08lx %08lx (%s)\n",
 				      a->codec->master_data->name,
 				      a->codec->master_data->type,
 				      a->codec->master_data->flags,
@@ -380,54 +347,21 @@ videocodec_build_table (void)
 		h = h->next;
 	}
 
-	return i;
+	return 0;
 }
 
-//The definition:
-//typedef int (read_proc_t)(char *page, char **start, off_t off,
-//                          int count, int *eof, void *data);
-
-static int
-videocodec_info (char  *buffer,
-		 char **buffer_location,
-		 off_t  offset,
-		 int    buffer_length,
-		 int   *eof,
-		 void  *data)
+static int proc_videocodecs_open(struct inode *inode, struct file *file)
 {
-	int size;
-
-	dprintk(3, "videocodec_info: offset: %ld, len %d / size %d\n",
-		offset, buffer_length, videocodec_bufsize);
-
-	if (offset == 0) {
-		videocodec_bufsize = videocodec_build_table();
-	}
-	if ((offset < 0) || (offset >= videocodec_bufsize)) {
-		dprintk(4,
-			"videocodec_info: call delivers no result, return 0\n");
-		*eof = 1;
-		return 0;
-	}
-
-	if (buffer_length < (videocodec_bufsize - offset)) {
-		dprintk(4, "videocodec_info: %ld needed, %d got\n",
-			videocodec_bufsize - offset, buffer_length);
-		size = buffer_length;
-	} else {
-		dprintk(4, "videocodec_info: last reading of %ld bytes\n",
-			videocodec_bufsize - offset);
-		size = videocodec_bufsize - offset;
-		*eof = 1;
-	}
-
-	memcpy(buffer, videocodec_buf + offset, size);
-	/* doesn't work...                           */
-	/* copy_to_user(buffer, videocodec_buf+offset, size); */
-	/* *buffer_location = videocodec_buf+offset; */
-
-	return size;
+	return single_open(file, proc_videocodecs_show, NULL);
 }
+
+static const struct file_operations videocodecs_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= proc_videocodecs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif
 
 /* ===================== */
@@ -444,16 +378,8 @@ videocodec_init (void)
 	       VIDEOCODEC_VERSION);
 
 #ifdef CONFIG_PROC_FS
-	videocodec_buf = NULL;
-	videocodec_bufsize = 0;
-
-	videocodec_proc_entry = create_proc_entry("videocodecs", 0, NULL);
-	if (videocodec_proc_entry) {
-		videocodec_proc_entry->read_proc = videocodec_info;
-		videocodec_proc_entry->write_proc = NULL;
-		videocodec_proc_entry->data = NULL;
-		videocodec_proc_entry->owner = THIS_MODULE;
-	} else {
+	videocodec_proc_entry = proc_create("videocodecs", 0, NULL, &videocodecs_proc_fops);
+	if (!videocodec_proc_entry) {
 		dprintk(1, KERN_ERR "videocodec: can't init procfs.\n");
 	}
 #endif
@@ -465,7 +391,6 @@ videocodec_exit (void)
 {
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("videocodecs", NULL);
-	kfree(videocodec_buf);
 #endif
 }
 

