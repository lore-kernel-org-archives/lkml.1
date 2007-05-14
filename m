Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbXENJL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbXENJL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbXENJLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:11:50 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:43720
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755319AbXENJLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:11:49 -0400
Date: Mon, 14 May 2007 11:14:24 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: bzolnier@gmail.com, linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 2/5] Use mutex instead of semaphore in IDE driver
Message-ID: <20070514091424.GH29206@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	bzolnier@gmail.com, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070514090256.GF29206@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514090256.GF29206@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The IDE driver uses a semaphore as mutex. Use the mutex API instead of
the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 7fff773..af67fd2 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -1178,11 +1178,11 @@ static int idedisk_ioctl(struct inode *inode, struct file *file,
 	return generic_ide_ioctl(drive, file, bdev, cmd, arg);
 
 read_val:
-	down(&ide_setting_sem);
+	mutex_lock(&ide_setting_mtx);
 	spin_lock_irqsave(&ide_lock, flags);
 	err = *val;
 	spin_unlock_irqrestore(&ide_lock, flags);
-	up(&ide_setting_sem);
+	mutex_unlock(&ide_setting_mtx);
 	return err >= 0 ? put_user(err, (long __user *)arg) : err;
 
 set_val:
@@ -1192,9 +1192,9 @@ set_val:
 		if (!capable(CAP_SYS_ADMIN))
 			err = -EACCES;
 		else {
-			down(&ide_setting_sem);
+			mutex_lock(&ide_setting_mtx);
 			err = setfunc(drive, arg);
-			up(&ide_setting_sem);
+			mutex_unlock(&ide_setting_mtx);
 		}
 	}
 	return err;
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index d50bd99..33907c6 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -154,7 +154,7 @@ static int __ide_add_setting(ide_drive_t *drive, const char *name, int rw, int d
 {
 	ide_settings_t **p = (ide_settings_t **) &drive->settings, *setting = NULL;
 
-	down(&ide_setting_sem);
+	mutex_lock(&ide_setting_mtx);
 	while ((*p) && strcmp((*p)->name, name) < 0)
 		p = &((*p)->next);
 	if ((setting = kzalloc(sizeof(*setting), GFP_KERNEL)) == NULL)
@@ -175,10 +175,10 @@ static int __ide_add_setting(ide_drive_t *drive, const char *name, int rw, int d
 	if (auto_remove)
 		setting->auto_remove = 1;
 	*p = setting;
-	up(&ide_setting_sem);
+	mutex_unlock(&ide_setting_mtx);
 	return 0;
 abort:
-	up(&ide_setting_sem);
+	mutex_unlock(&ide_setting_mtx);
 	kfree(setting);
 	return -1;
 }
@@ -222,7 +222,7 @@ static void __ide_remove_setting (ide_drive_t *drive, char *name)
  *
  *	Automatically remove all the driver specific settings for this
  *	drive. This function may not be called from IRQ context. The
- *	caller must hold ide_setting_sem.
+ *	caller must hold ide_setting_mtx.
  */
 
 static void auto_remove_settings (ide_drive_t *drive)
@@ -267,7 +267,7 @@ static ide_settings_t *ide_find_setting_by_name(ide_drive_t *drive, char *name)
  *	@setting: drive setting
  *
  *	Read a drive setting and return the value. The caller
- *	must hold the ide_setting_sem when making this call.
+ *	must hold the ide_setting_mtx when making this call.
  *
  *	BUGS: the data return and error are the same return value
  *	so an error -EINVAL and true return of the same value cannot
@@ -304,7 +304,7 @@ static int ide_read_setting(ide_drive_t *drive, ide_settings_t *setting)
  *	@val: value
  *
  *	Write a drive setting if it is possible. The caller
- *	must hold the ide_setting_sem when making this call.
+ *	must hold the ide_setting_mtx when making this call.
  *
  *	BUGS: the data return and error are the same return value
  *	so an error -EINVAL and true return of the same value cannot
@@ -365,7 +365,7 @@ static int set_xfer_rate (ide_drive_t *drive, int arg)
  *	@drive: drive being configured
  *
  *	Add the generic parts of the system settings to the /proc files.
- *	The caller must not be holding the ide_setting_sem.
+ *	The caller must not be holding the ide_setting_mtx.
  */
 
 void ide_add_generic_settings (ide_drive_t *drive)
@@ -406,7 +406,7 @@ static int proc_ide_read_settings
 
 	proc_ide_settings_warn();
 
-	down(&ide_setting_sem);
+	mutex_lock(&ide_setting_mtx);
 	out += sprintf(out, "name\t\t\tvalue\t\tmin\t\tmax\t\tmode\n");
 	out += sprintf(out, "----\t\t\t-----\t\t---\t\t---\t\t----\n");
 	while(setting) {
@@ -426,7 +426,7 @@ static int proc_ide_read_settings
 		setting = setting->next;
 	}
 	len = out - page;
-	up(&ide_setting_sem);
+	mutex_unlock(&ide_setting_mtx);
 	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
 }
 
@@ -506,16 +506,16 @@ static int proc_ide_write_settings(struct file *file, const char __user *buffer,
 				++p;
 			}
 
-			down(&ide_setting_sem);
+			mutex_lock(&ide_setting_mtx);
 			setting = ide_find_setting_by_name(drive, name);
 			if (!setting)
 			{
-				up(&ide_setting_sem);
+				mutex_unlock(&ide_setting_mtx);
 				goto parse_error;
 			}
 			if (for_real)
 				ide_write_setting(drive, setting, val * setting->div_factor / setting->mul_factor);
-			up(&ide_setting_sem);
+			mutex_unlock(&ide_setting_mtx);
 		}
 	} while (!for_real++);
 	free_page((unsigned long)buf);
@@ -703,7 +703,7 @@ EXPORT_SYMBOL(ide_proc_register_driver);
  *	Clean up the driver specific /proc files and IDE settings
  *	for a given drive.
  *
- *	Takes ide_setting_sem and ide_lock.
+ *	Takes ide_setting_mtx and ide_lock.
  *	Caller must hold none of the locks.
  */
 
@@ -713,10 +713,10 @@ void ide_proc_unregister_driver(ide_drive_t *drive, ide_driver_t *driver)
 
 	ide_remove_proc_entries(drive->proc, driver->proc);
 
-	down(&ide_setting_sem);
+	mutex_lock(&ide_setting_mtx);
 	spin_lock_irqsave(&ide_lock, flags);
 	/*
-	 * ide_setting_sem protects the settings list
+	 * ide_setting_mtx protects the settings list
 	 * ide_lock protects the use of settings
 	 *
 	 * so we need to hold both, ide_settings_sem because we want to
@@ -724,11 +724,11 @@ void ide_proc_unregister_driver(ide_drive_t *drive, ide_driver_t *driver)
 	 * a setting out that is being used.
 	 *
 	 * OTOH both ide_{read,write}_setting are only ever used under
-	 * ide_setting_sem.
+	 * ide_setting_mtx.
 	 */
 	auto_remove_settings(drive);
 	spin_unlock_irqrestore(&ide_lock, flags);
-	up(&ide_setting_sem);
+	mutex_unlock(&ide_setting_mtx);
 }
 
 EXPORT_SYMBOL(ide_proc_unregister_driver);
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index f2b547f..4811c61 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -817,9 +817,9 @@ EXPORT_SYMBOL(ide_register_hw);
  *	Locks for IDE setting functionality
  */
 
-DECLARE_MUTEX(ide_setting_sem);
+DEFINE_MUTEX(ide_setting_mtx);
 
-EXPORT_SYMBOL_GPL(ide_setting_sem);
+EXPORT_SYMBOL_GPL(ide_setting_mtx);
 
 /**
  *	ide_spin_wait_hwgroup	-	wait for group
@@ -1181,11 +1181,11 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
 	}
 
 read_val:
-	down(&ide_setting_sem);
+	mutex_lock(&ide_setting_mtx);
 	spin_lock_irqsave(&ide_lock, flags);
 	err = *val;
 	spin_unlock_irqrestore(&ide_lock, flags);
-	up(&ide_setting_sem);
+	mutex_unlock(&ide_setting_mtx);
 	return err >= 0 ? put_user(err, (long __user *)arg) : err;
 
 set_val:
@@ -1195,9 +1195,9 @@ set_val:
 		if (!capable(CAP_SYS_ADMIN))
 			err = -EACCES;
 		else {
-			down(&ide_setting_sem);
+			mutex_lock(&ide_setting_mtx);
 			err = setfunc(drive, arg);
-			up(&ide_setting_sem);
+			mutex_unlock(&ide_setting_mtx);
 		}
 	}
 	return err;
diff --git a/include/linux/ide.h b/include/linux/ide.h
index df4e6a5..3773a5b 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -25,6 +25,7 @@
 #include <asm/system.h>
 #include <asm/io.h>
 #include <asm/semaphore.h>
+#include <asm/mutex.h>
 
 /******************************************************************************
  * IDE driver configuration options (play with these as desired):
@@ -863,7 +864,7 @@ typedef struct hwgroup_s {
 
 typedef struct ide_driver_s ide_driver_t;
 
-extern struct semaphore ide_setting_sem;
+extern struct mutex ide_setting_mtx;
 
 int set_io_32bit(ide_drive_t *, int);
 int set_pio_mode(ide_drive_t *, int);

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona


   Usually when people are sad, they don't do anything. They just cry over
     their condition. But when they get angry, they bring about a change
                              (Malcolm X)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
