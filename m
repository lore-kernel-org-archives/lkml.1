Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbYG2B3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbYG2B3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYG2B3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:29:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:10875 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbYG2B3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:29:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=q0KZ/jdtG0+0bnRZwiaa11Z01YJVX0EpkK5v9Epd7Gw84bh+xjY0V/KchFqMSG0Xlf
         2Kf7HhvUlzm0jSuHZIkloYhxtPOxKF5N6mTBJNYzmtvQ3EOD7dEoS1szeYCUdW2cIG6F
         K9ONEfQ004Twh/dlekhGqVeSlaM5q8Z0jTwsE=
Date: Tue, 29 Jul 2008 05:29:08 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/13] proc tty: introduce ->proc_fops
Message-ID: <20080729012908.GA3135@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add struct tty_operations:proc_fops .

The intent is gradual switch of TTY drivers from ->read_proc usage.
proc entries are created with proc_create_data() which even fixes
early-read races.

Eventually ->read_proc code will be removed from TTY code, thus helping
remove ->read_proc from whole proc code.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/proc_tty.c         |   21 +++++++++++++--------
 include/linux/tty_driver.h |    3 +++
 2 files changed, 16 insertions(+), 8 deletions(-)

--- a/fs/proc/proc_tty.c
+++ b/fs/proc/proc_tty.c
@@ -144,17 +144,22 @@ void proc_tty_register_driver(struct tty_driver *driver)
 {
 	struct proc_dir_entry *ent;
 		
-	if (!driver->ops->read_proc || !driver->driver_name ||
-	    driver->proc_entry)
+	if (!driver->driver_name || driver->proc_entry)
 		return;
-
-	ent = create_proc_entry(driver->driver_name, 0, proc_tty_driver);
-	if (!ent)
+	if (driver->ops->proc_fops) {
+		ent = proc_create_data(driver->driver_name, 0, proc_tty_driver,
+				       driver->ops->proc_fops, driver);
+		if (!ent)
+			return;
+	} else if (driver->ops->read_proc) {
+		ent = create_proc_entry(driver->driver_name, 0, proc_tty_driver);
+		if (!ent)
+			return;
+		ent->read_proc = driver->ops->read_proc;
+		ent->data = driver;
+	} else
 		return;
-	ent->read_proc = driver->ops->read_proc;
 	ent->owner = driver->owner;
-	ent->data = driver;
-
 	driver->proc_entry = ent;
 }
 
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -203,6 +203,9 @@ struct tty_operations {
 	void (*send_xchar)(struct tty_struct *tty, char ch);
 	int (*read_proc)(char *page, char **start, off_t off,
 			  int count, int *eof, void *data);
+#ifdef CONFIG_PROC_FS
+	const struct file_operations *proc_fops;
+#endif
 	int (*tiocmget)(struct tty_struct *tty, struct file *file);
 	int (*tiocmset)(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear);
-- 
1.5.4.5


