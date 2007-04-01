Return-Path: <linux-kernel-owner+w=401wt.eu-S932129AbXDAHfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbXDAHfv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 03:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932140AbXDAHfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 03:35:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:57890 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129AbXDAHfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 03:35:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=tC1Zdfld1IG4sPvxDEwBQta+dVKRd/NPXrkfJVeqoM5kGIxTsPqP6pOXoLrrQe9EwM5e5QHfOyoetF4rk01t9rt2tXtZarR6jG3KC41+z7Fvj+N5SP5x0tuzrgMIifErQTBUMPfgQ5YxOQN/9nAxrTFy6eBPh0pXgphywqRasqM=
Date: Sun, 1 Apr 2007 13:06:46 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       parisc-linux@lists.parisc-linux.org, grundler@parisc-linux.org,
       kyle@mcmartin.ca, willy@debian.org
Subject: [KJ][PATCH] ROUND_UP macro cleanup in arch/parisc
Message-ID: <20070401073646.GA11444@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ROUND_UP macro cleanup, use ALIGN where ever appropriate

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

---
 hpux/fs.c             |    5 ++---
 kernel/sys_parisc32.c |    3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)



diff --git a/arch/parisc/hpux/fs.c b/arch/parisc/hpux/fs.c
index 4204cd1..7ff5546 100644
--- a/arch/parisc/hpux/fs.c
+++ b/arch/parisc/hpux/fs.c
@@ -21,6 +21,7 @@
  *    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/file.h>
@@ -70,7 +71,6 @@ struct getdents_callback {
 };
 
 #define NAME_OFFSET(de) ((int) ((de)->d_name - (char *) (de)))
-#define ROUND_UP(x) (((x)+sizeof(long)-1) & ~(sizeof(long)-1))
 
 static int filldir(void * __buf, const char * name, int namlen, loff_t offset,
 		u64 ino, unsigned d_type)
@@ -78,7 +78,7 @@ static int filldir(void * __buf, const char * name, int namlen, loff_t offset,
 	struct hpux_dirent * dirent;
 	struct getdents_callback * buf = (struct getdents_callback *) __buf;
 	ino_t d_ino;
-	int reclen = ROUND_UP(NAME_OFFSET(dirent) + namlen + 1);
+	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 1,sizeof(long));
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
@@ -103,7 +103,6 @@ static int filldir(void * __buf, const char * name, int namlen, loff_t offset,
 }
 
 #undef NAME_OFFSET
-#undef ROUND_UP
 
 int hpux_getdents(unsigned int fd, struct hpux_dirent *dirent, unsigned int count)
 {
diff --git a/arch/parisc/kernel/sys_parisc32.c b/arch/parisc/kernel/sys_parisc32.c
index ce3245f..e590880 100644
--- a/arch/parisc/kernel/sys_parisc32.c
+++ b/arch/parisc/kernel/sys_parisc32.c
@@ -311,14 +311,13 @@ struct readdir32_callback {
 	int count;
 };
 
-#define ROUND_UP(x,a)	((__typeof__(x))(((unsigned long)(x) + ((a) - 1)) & ~((a) - 1)))
 #define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
 static int filldir32 (void *__buf, const char *name, int namlen,
 			loff_t offset, u64 ino, unsigned int d_type)
 {
 	struct linux32_dirent __user * dirent;
 	struct getdents32_callback * buf = (struct getdents32_callback *) __buf;
-	int reclen = ROUND_UP(NAME_OFFSET(dirent) + namlen + 1, 4);
+	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 1, 4);
 	u32 d_ino;
 
 	buf->error = -EINVAL;	/* only used if we fail.. */

-- 
Milind Arun Choudhary
