Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbZA2RnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbZA2RnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:43:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZA2Rmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:42:51 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:55603 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZA2Rmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:42:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Ji0njVR0vPlknhux3AXICeDgUo/p/2TMnmoLAKhwSHBU4fmuJ0sYJ3Zwq1uXag7Tr8
         4glvYFJM6+gsBNpj/7tNWP7EbbwmcWKwOZzt7YwqIM8qV12kQhyd8H5JWVoJy4EFUlzV
         UJ5E8kD1o+MQmf/DvQl+bY46GV90nNTk9PpHk=
Date: Thu, 29 Jan 2009 20:48:30 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/17] proc tty: add struct tty_operations::proc_fops
Message-ID: <20090129174830.GA21643@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used for gradual switch of TTY drivers from using ->read_proc
which helps with gradual switch from ->read_proc for the whole tree.

As side effect, fix possible race condition when ->data initialized after
PDE is hooked into proc tree.

->proc_fops takes precedence over ->read_proc.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/proc_tty.c         |   19 +++++++++++++------
 include/linux/tty_driver.h |    1 +
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/proc/proc_tty.c b/fs/proc/proc_tty.c
index d153946..2b72dbf 100644
--- a/fs/proc/proc_tty.c
+++ b/fs/proc/proc_tty.c
@@ -144,16 +144,23 @@ void proc_tty_register_driver(struct tty_driver *driver)
 {
 	struct proc_dir_entry *ent;
 		
-	if (!driver->ops->read_proc || !driver->driver_name ||
-	    driver->proc_entry)
+	if (!driver->driver_name || driver->proc_entry)
 		return;
 
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
 
 	driver->proc_entry = ent;
 }
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 08e0883..c9a6957 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -264,6 +264,7 @@ struct tty_operations {
 	int (*poll_get_char)(struct tty_driver *driver, int line);
 	void (*poll_put_char)(struct tty_driver *driver, int line, char ch);
 #endif
+	const struct file_operations *proc_fops;
 };
 
 struct tty_driver {
-- 
1.5.6.5

