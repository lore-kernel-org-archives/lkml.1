Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbXHUEi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbXHUEi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 00:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbXHUEiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 00:38:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbXHUEiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 00:38:17 -0400
Date: Tue, 21 Aug 2007 12:38:02 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: linux-kernel@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>, Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH] alsa: replace calls to sys_* with filp_open and vfs_read
Message-ID: <20070821043802.GB17892@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces calls to sys_* with filp_open and vfs_read. And since this
is the last driver in the kernel that uses sys_{read,close}, it kills the
exports as well. sys_open is left exported for sparc64 only.

Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/open.c                             |    4 +-
 fs/read_write.c                       |    1 -
 sound/isa/wavefront/wavefront_synth.c |   47 +++++++++++++++-----------------
 3 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 1d9e5e9..dc121ce 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1056,7 +1056,9 @@ asmlinkage long sys_open(const char __user *filename, int flags, int mode)
 	prevent_tail_call(ret);
 	return ret;
 }
+#ifdef CONFIG_SPARC64
 EXPORT_SYMBOL_GPL(sys_open);
+#endif
 
 asmlinkage long sys_openat(int dfd, const char __user *filename, int flags,
 			   int mode)
@@ -1148,8 +1150,6 @@ out_unlock:
 	return -EBADF;
 }
 
-EXPORT_SYMBOL(sys_close);
-
 /*
  * This routine simulates a hangup on the tty, to arrange that users
  * are given clean terminals at login time.
diff --git a/fs/read_write.c b/fs/read_write.c
index 507ddff..d913d1e 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -370,7 +370,6 @@ asmlinkage ssize_t sys_read(unsigned int fd, char __user * buf, size_t count)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(sys_read);
 
 asmlinkage ssize_t sys_write(unsigned int fd, const char __user * buf, size_t count)
 {
diff --git a/sound/isa/wavefront/wavefront_synth.c b/sound/isa/wavefront/wavefront_synth.c
index bacc51c..40eefa2 100644
--- a/sound/isa/wavefront/wavefront_synth.c
+++ b/sound/isa/wavefront/wavefront_synth.c
@@ -1941,8 +1941,6 @@ wavefront_reset_to_cleanliness (snd_wavefront_t *dev)
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/unistd.h>
-#include <linux/syscalls.h>
 #include <asm/uaccess.h>
 
 
@@ -1953,10 +1951,10 @@ wavefront_download_firmware (snd_wavefront_t *dev, char *path)
 	unsigned char section[WF_SECTION_MAX];
 	signed char section_length; /* yes, just a char; max value is WF_SECTION_MAX */
 	int section_cnt_downloaded = 0;
-	int fd;
-	int c;
-	int i;
-	mm_segment_t fs;
+	int c, i, ret = 0;
+	mm_segment_t fs = get_fs();
+	struct file *filp;
+	loff_t pos;
 
 	/* This tries to be a bit cleverer than the stuff Alan Cox did for
 	   the generic sound firmware, in that it actually knows
@@ -1968,20 +1966,20 @@ wavefront_download_firmware (snd_wavefront_t *dev, char *path)
 	   42 bytes (well, WF_SECTION_MAX) long.
 	*/
 
-	fs = get_fs();
-	set_fs (get_ds());
+	set_fs(get_ds());
 
-	if ((fd = sys_open ((char __user *) path, 0, 0)) < 0) {
-		snd_printk ("Unable to load \"%s\".\n",
-			path);
+	filp = filp_open(path, 0, 0);
+	if (IS_ERR(filp)) {
+		snd_printk("Unable to load \"%s\".\n", path);
 		return 1;
 	}
 
 	while (1) {
 		int x;
 
-		if ((x = sys_read (fd, (char __user *) &section_length, sizeof (section_length))) !=
-		    sizeof (section_length)) {
+		pos = filp->f_pos;
+		x = vfs_read(filp, (char __user *) &section_length, sizeof(section_length), &pos);
+		if (x != sizeof(section_length)) {
 			snd_printk ("firmware read error.\n");
 			goto failure;
 		}
@@ -1996,9 +1994,10 @@ wavefront_download_firmware (snd_wavefront_t *dev, char *path)
 			goto failure;
 		}
 
-		if (sys_read (fd, (char __user *) section, section_length) != section_length) {
-			snd_printk ("firmware section "
-				"read error.\n");
+		pos = filp->f_pos;
+		x = vfs_read(filp, (char __user *) section, section_length, &pos);
+		if (x != section_length) {
+			snd_printk ("firmware section read error.\n");
 			goto failure;
 		}
 
@@ -2034,19 +2033,17 @@ wavefront_download_firmware (snd_wavefront_t *dev, char *path)
 		}
 
 	}
+	goto success;
 
-	sys_close (fd);
-	set_fs (fs);
-	return 0;
-
- failure:
-	sys_close (fd);
-	set_fs (fs);
+failure:
+	ret = 1;
 	snd_printk ("firmware download failed!!!\n");
-	return 1;
+success:
+	filp_close(filp, current->files);
+	set_fs (fs);
+	return ret;
 }
 
-
 static int __devinit
 wavefront_do_reset (snd_wavefront_t *dev)
 

