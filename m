Return-Path: <linux-kernel-owner+w=401wt.eu-S1030401AbXDZKHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030401AbXDZKHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 06:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030367AbXDZKHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 06:07:19 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:40841
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030459AbXDZKHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 06:07:14 -0400
Date: Thu, 26 Apr 2007 12:10:08 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] use mutex instead of semaphore in virtual console driver
Message-ID: <20070426101008.GC6468@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the virtual console driver uses a semaphore as mutex. use the mutex
API instead of the (binary) semaphore

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--
diff --git a/drivers/char/vc_screen.c b/drivers/char/vc_screen.c
index 7919303..032d4f1 100644
--- a/drivers/char/vc_screen.c
+++ b/drivers/char/vc_screen.c
@@ -70,11 +70,11 @@ static loff_t vcs_lseek(struct file *file, loff_t offset, int orig)
 {
 	int size;
 
-	down(&con_buf_sem);
+	mutex_lock(&con_buf_mtx);
 	size = vcs_size(file->f_path.dentry->d_inode);
 	switch (orig) {
 		default:
-			up(&con_buf_sem);
+			mutex_unlock(&con_buf_mtx);
 			return -EINVAL;
 		case 2:
 			offset += size;
@@ -85,11 +85,11 @@ static loff_t vcs_lseek(struct file *file, loff_t offset, int orig)
 			break;
 	}
 	if (offset < 0 || offset > size) {
-		up(&con_buf_sem);
+		mutex_unlock(&con_buf_mtx);
 		return -EINVAL;
 	}
 	file->f_pos = offset;
-	up(&con_buf_sem);
+	mutex_unlock(&con_buf_mtx);
 	return file->f_pos;
 }
 
@@ -106,7 +106,7 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	unsigned short *org = NULL;
 	ssize_t ret;
 
-	down(&con_buf_sem);
+	mutex_lock(&con_buf_mtx);
 
 	pos = *ppos;
 
@@ -263,7 +263,7 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		ret = read;
 unlock_out:
 	release_console_sem();
-	up(&con_buf_sem);
+	mutex_unlock(&con_buf_mtx);
 	return ret;
 }
 
@@ -280,7 +280,7 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	u16 *org0 = NULL, *org = NULL;
 	size_t ret;
 
-	down(&con_buf_sem);
+	mutex_lock(&con_buf_mtx);
 
 	pos = *ppos;
 
@@ -450,7 +450,7 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 unlock_out:
 	release_console_sem();
 
-	up(&con_buf_sem);
+	mutex_unlock(&con_buf_mtx);
 
 	return ret;
 }
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 1bbb45b..497d24c 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -1930,7 +1930,7 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
  * kernel memory allocation is available.
  */
 char con_buf[CON_BUF_SIZE];
-DECLARE_MUTEX(con_buf_sem);
+DEFINE_MUTEX(con_buf_mtx);
 
 /* acquires console_sem */
 static int do_con_write(struct tty_struct *tty, const unsigned char *buf, int count)
@@ -1983,7 +1983,7 @@ static int do_con_write(struct tty_struct *tty, const unsigned char *buf, int co
 
 	/* At this point 'buf' is guaranteed to be a kernel buffer
 	 * and therefore no access to userspace (and therefore sleeping)
-	 * will be needed.  The con_buf_sem serializes all tty based
+	 * will be needed.  The con_buf_mtx serializes all tty based
 	 * console rendering and vcs write/read operations.  We hold
 	 * the console spinlock during the entire write.
 	 */
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index e0db669..146dbca 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -82,7 +82,7 @@ void reset_vc(struct vc_data *vc);
 
 #define CON_BUF_SIZE (CONFIG_BASE_SMALL ? 256 : PAGE_SIZE)
 extern char con_buf[CON_BUF_SIZE];
-extern struct semaphore con_buf_sem;
+extern struct mutex con_buf_mtx;
 extern char vt_dont_switch;
 
 struct vt_spawn_console {

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

    Ma patrie est où je suis, où personne ne me dérange, où personne
    ne me demande que je suis, d'où je viens et ce que je fais
                              (B. Traven)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
