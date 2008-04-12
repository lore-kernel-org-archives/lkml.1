Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbYDLVJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbYDLVJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 17:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbYDLVJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 17:09:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:4869 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbYDLVJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 17:09:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=k/IBnbERXtRFv59lzClHVyyQ3stiSZwRmatuk2xuvqo+SBlGYE2nWfLnkOHLIKClydho01KkZuzqdywJm2CmMF9OFYp5rfT2CYc68ptVKwSUNXffCLWeQSy3kyvV4zAs14sH56dOjUplfdALvZaUb6/ut1wx/xcAK80VuA/YE2A=
Date: Sun, 13 Apr 2008 01:04:52 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: [PATCH] tty: remove ->write_proc hooks
Message-ID: <20080412210452.GD9151@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty drivers are using ->read_proc hook, but not ->write_proc.
Remove the latter, before anyone notices.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/char/tty_io.c       |    1 -
 drivers/s390/char/con3215.c |    2 +-
 drivers/s390/char/tty3270.c |    2 +-
 fs/proc/proc_tty.c          |    5 +----
 include/linux/tty_driver.h  |    4 ----
 5 files changed, 3 insertions(+), 11 deletions(-)

--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -3983,7 +3983,6 @@ void tty_set_operations(struct tty_driver *driver,
 	driver->wait_until_sent = op->wait_until_sent;
 	driver->send_xchar = op->send_xchar;
 	driver->read_proc = op->read_proc;
-	driver->write_proc = op->write_proc;
 	driver->tiocmget = op->tiocmget;
 	driver->tiocmset = op->tiocmset;
 #ifdef CONFIG_CONSOLE_POLL
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -1138,7 +1138,7 @@ tty3215_init(void)
 	/*
 	 * Initialize the tty_driver structure
 	 * Entries in tty3215_driver that are NOT initialized:
-	 * proc_entry, set_termios, flush_buffer, set_ldisc, write_proc
+	 * proc_entry, set_termios, flush_buffer, set_ldisc
 	 */
 
 	driver->owner = THIS_MODULE;
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -1780,7 +1780,7 @@ static int __init tty3270_init(void)
 	/*
 	 * Initialize the tty_driver structure
 	 * Entries in tty3270_driver that are NOT initialized:
-	 * proc_entry, set_termios, flush_buffer, set_ldisc, write_proc
+	 * proc_entry, set_termios, flush_buffer, set_ldisc
 	 */
 	driver->owner = THIS_MODULE;
 	driver->driver_name = "ttyTUB";
--- a/fs/proc/proc_tty.c
+++ b/fs/proc/proc_tty.c
@@ -192,16 +192,13 @@ void proc_tty_register_driver(struct tty_driver *driver)
 {
 	struct proc_dir_entry *ent;
 		
-	if ((!driver->read_proc && !driver->write_proc) ||
-	    !driver->driver_name ||
-	    driver->proc_entry)
+	if (!driver->read_proc || !driver->driver_name || driver->proc_entry)
 		return;
 
 	ent = create_proc_entry(driver->driver_name, 0, proc_tty_driver);
 	if (!ent)
 		return;
 	ent->read_proc = driver->read_proc;
-	ent->write_proc = driver->write_proc;
 	ent->owner = driver->owner;
 	ent->data = driver;
 
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -153,8 +153,6 @@ struct tty_operations {
 	void (*send_xchar)(struct tty_struct *tty, char ch);
 	int (*read_proc)(char *page, char **start, off_t off,
 			  int count, int *eof, void *data);
-	int (*write_proc)(struct file *file, const char __user *buffer,
-			  unsigned long count, void *data);
 	int (*tiocmget)(struct tty_struct *tty, struct file *file);
 	int (*tiocmset)(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear);
@@ -221,8 +219,6 @@ struct tty_driver {
 	void (*send_xchar)(struct tty_struct *tty, char ch);
 	int (*read_proc)(char *page, char **start, off_t off,
 			  int count, int *eof, void *data);
-	int (*write_proc)(struct file *file, const char __user *buffer,
-			  unsigned long count, void *data);
 	int (*tiocmget)(struct tty_struct *tty, struct file *file);
 	int (*tiocmset)(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear);
-- 
1.5.3.7


