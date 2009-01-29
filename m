Return-Path: <linux-kernel-owner+w=401wt.eu-S1760665AbZA2Ruo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665AbZA2Ruo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760603AbZA2RuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:50:08 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:34702 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760593AbZA2RuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:50:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Lsp8wyy544Ggobeb7UleOw/U09YowCjVLVowY9uerdJzLDg9PxMAGNO4e75DTaOZra
         KWaAPFZNOTa6Zuu+ABGk2/20z3q3vuHPrTSKN+7oLxettjdhbZ+LiQy9dBk4BVNlWQr/
         IDCBTMjYSSMn6fHtY2fmkJRhXO0Bia0+Rahtw=
Date: Thu, 29 Jan 2009 20:55:49 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 17/17] proc tty: remove struct tty_operations::read_proc
Message-ID: <20090129175549.GQ21643@x200.localdomain>
References: <20090129174830.GA21643@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129174830.GA21643@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct tty_operations::proc_fops took it's place and there is one less
create_proc_read_entry() user now!

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/isdn/capi/capi.c   |    7 -------
 fs/proc/proc_tty.c         |   21 ++++++---------------
 include/linux/tty_driver.h |    2 --
 net/bluetooth/rfcomm/tty.c |    6 ------
 4 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 1b5bf87..8506cc5 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1331,12 +1331,6 @@ static void capinc_tty_send_xchar(struct tty_struct *tty, char ch)
 #endif
 }
 
-static int capinc_tty_read_proc(char *page, char **start, off_t off,
-				int count, int *eof, void *data)
-{
-	return 0;
-}
-
 static struct tty_driver *capinc_tty_driver;
 
 static const struct tty_operations capinc_ops = {
@@ -1358,7 +1352,6 @@ static const struct tty_operations capinc_ops = {
 	.flush_buffer = capinc_tty_flush_buffer,
 	.set_ldisc = capinc_tty_set_ldisc,
 	.send_xchar = capinc_tty_send_xchar,
-	.read_proc = capinc_tty_read_proc,
 };
 
 static int capinc_tty_init(void)
diff --git a/fs/proc/proc_tty.c b/fs/proc/proc_tty.c
index 2b72dbf..f1d4eb8 100644
--- a/fs/proc/proc_tty.c
+++ b/fs/proc/proc_tty.c
@@ -144,23 +144,14 @@ void proc_tty_register_driver(struct tty_driver *driver)
 {
 	struct proc_dir_entry *ent;
 		
-	if (!driver->driver_name || driver->proc_entry)
+	if (!driver->driver_name || driver->proc_entry ||
+	    !driver->ops->proc_fops)
 		return;
 
-	if (driver->ops->proc_fops) {
-		ent = proc_create_data(driver->driver_name, 0, proc_tty_driver,
-				       driver->ops->proc_fops, driver);
-		if (!ent)
-			return;
-	} else if (driver->ops->read_proc) {
-		ent = create_proc_entry(driver->driver_name, 0, proc_tty_driver);
-		if (!ent)
-			return;
-		ent->read_proc = driver->ops->read_proc;
-		ent->data = driver;
-	} else
-		return;
-	ent->owner = driver->owner;
+	ent = proc_create_data(driver->driver_name, 0, proc_tty_driver,
+			       driver->ops->proc_fops, driver);
+	if (ent)
+		ent->owner = driver->owner;
 
 	driver->proc_entry = ent;
 }
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index c9a6957..8615d66 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -252,8 +252,6 @@ struct tty_operations {
 	void (*set_ldisc)(struct tty_struct *tty);
 	void (*wait_until_sent)(struct tty_struct *tty, int timeout);
 	void (*send_xchar)(struct tty_struct *tty, char ch);
-	int (*read_proc)(char *page, char **start, off_t off,
-			  int count, int *eof, void *data);
 	int (*tiocmget)(struct tty_struct *tty, struct file *file);
 	int (*tiocmset)(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear);
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index d030c69..58a653e 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -1092,11 +1092,6 @@ static void rfcomm_tty_hangup(struct tty_struct *tty)
 	}
 }
 
-static int rfcomm_tty_read_proc(char *buf, char **start, off_t offset, int len, int *eof, void *unused)
-{
-	return 0;
-}
-
 static int rfcomm_tty_tiocmget(struct tty_struct *tty, struct file *filp)
 {
 	struct rfcomm_dev *dev = (struct rfcomm_dev *) tty->driver_data;
@@ -1155,7 +1150,6 @@ static const struct tty_operations rfcomm_ops = {
 	.send_xchar		= rfcomm_tty_send_xchar,
 	.hangup			= rfcomm_tty_hangup,
 	.wait_until_sent	= rfcomm_tty_wait_until_sent,
-	.read_proc		= rfcomm_tty_read_proc,
 	.tiocmget		= rfcomm_tty_tiocmget,
 	.tiocmset		= rfcomm_tty_tiocmset,
 };
-- 
1.5.6.5

