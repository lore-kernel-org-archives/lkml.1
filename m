Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab0BCTY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:24:59 -0500
Received: from smtp.outflux.net ([198.145.64.163]:55878 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757559Ab0BCTY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:24:57 -0500
Date: Wed, 3 Feb 2010 11:23:28 -0800
From: Kees Cook <kees.cook@canonical.com>
To: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Casey Schaufler <casey@schaufler-ca.com>,
       linux-security-module@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Robin Getz <rgetz@analog.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Paul Moore <paul.moore@hp.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       Etienne Basset <etienne.basset@numericable.fr>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       LKLM <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] syslog: use defined constants instead of raw numbers
Message-ID: <20100203192328.GF19355@outflux.net>
References: <20100202055354.GV19355@outflux.net>
 <4B67C2EA.705@schaufler-ca.com>
 <20100202202054.GW19355@outflux.net>
 <20100202212510.GG32305@us.ibm.com>
 <alpine.LRH.2.00.1002030859220.14592@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1002030859220.14592@tundra.namei.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now the syslog "type" actions are just raw numbers which makes
the source difficult to follow.  This patch replaces the raw numbers
with defined constants for some level of sanity.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 fs/proc/kmsg.c           |   11 ++++++-----
 include/linux/syslog.h   |   23 +++++++++++++++++++++++
 kernel/printk.c          |   45 +++++++++++++++++++--------------------------
 security/commoncap.c     |    5 +++--
 security/selinux/hooks.c |   21 +++++++++++----------
 5 files changed, 62 insertions(+), 43 deletions(-)

diff --git a/fs/proc/kmsg.c b/fs/proc/kmsg.c
index 4a08999..1ac9d2b 100644
--- a/fs/proc/kmsg.c
+++ b/fs/proc/kmsg.c
@@ -21,27 +21,28 @@ extern wait_queue_head_t log_wait;
 
 static int kmsg_open(struct inode * inode, struct file * file)
 {
-	return do_syslog(1, NULL, 0, 1);
+	return do_syslog(SYSLOG_ACTION_OPEN, NULL, 0, 1);
 }
 
 static int kmsg_release(struct inode * inode, struct file * file)
 {
-	(void) do_syslog(0, NULL, 0, 1);
+	(void) do_syslog(SYSLOG_ACTION_CLOSE, NULL, 0, 1);
 	return 0;
 }
 
 static ssize_t kmsg_read(struct file *file, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
-	if ((file->f_flags & O_NONBLOCK) && !do_syslog(9, NULL, 0, 1))
+	if ((file->f_flags & O_NONBLOCK) &&
+	    !do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, 1))
 		return -EAGAIN;
-	return do_syslog(2, buf, count, 1);
+	return do_syslog(SYSLOG_ACTION_READ, buf, count, 1);
 }
 
 static unsigned int kmsg_poll(struct file *file, poll_table *wait)
 {
 	poll_wait(file, &log_wait, wait);
-	if (do_syslog(9, NULL, 0, 1))
+	if (do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, 1))
 		return POLLIN | POLLRDNORM;
 	return 0;
 }
diff --git a/include/linux/syslog.h b/include/linux/syslog.h
index f8c9d94..8c2c422 100644
--- a/include/linux/syslog.h
+++ b/include/linux/syslog.h
@@ -21,6 +21,29 @@
 #ifndef _LINUX_SYSLOG_H
 #define _LINUX_SYSLOG_H
 
+/* Close the log.  Currently a NOP. */
+#define SYSLOG_ACTION_CLOSE          0
+/* Open the log. Currently a NOP. */
+#define SYSLOG_ACTION_OPEN           1
+/* Read from the log. */
+#define SYSLOG_ACTION_READ           2
+/* Read all messages remaining in the ring buffer. */
+#define SYSLOG_ACTION_READ_ALL       3
+/* Read and clear all messages remaining in the ring buffer */
+#define SYSLOG_ACTION_READ_CLEAR     4
+/* Clear ring buffer. */
+#define SYSLOG_ACTION_CLEAR          5
+/* Disable printk's to console */
+#define SYSLOG_ACTION_CONSOLE_OFF    6
+/* Enable printk's to console */
+#define SYSLOG_ACTION_CONSOLE_ON     7
+/* Set level of messages printed to console */
+#define SYSLOG_ACTION_CONSOLE_LEVEL  8
+/* Return number of unread characters in the log buffer */
+#define SYSLOG_ACTION_SIZE_UNREAD    9
+/* Return size of the log buffer */
+#define SYSLOG_ACTION_SIZE_BUFFER   10
+
 int do_syslog(int type, char __user *buf, int count, int from_file);
 
 #endif /* _LINUX_SYSLOG_H */
diff --git a/kernel/printk.c b/kernel/printk.c
index 4bc1412..ca1d970 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -259,21 +259,6 @@ static inline void boot_delay_msec(void)
 }
 #endif
 
-/*
- * Commands to do_syslog:
- *
- * 	0 -- Close the log.  Currently a NOP.
- * 	1 -- Open the log. Currently a NOP.
- * 	2 -- Read from the log.
- * 	3 -- Read all messages remaining in the ring buffer.
- * 	4 -- Read and clear all messages remaining in the ring buffer
- * 	5 -- Clear ring buffer.
- * 	6 -- Disable printk's to console
- * 	7 -- Enable printk's to console
- *	8 -- Set level of messages printed to console
- *	9 -- Return number of unread characters in the log buffer
- *     10 -- Return size of the log buffer
- */
 int do_syslog(int type, char __user *buf, int len, int from_file)
 {
 	unsigned i, j, limit, count;
@@ -286,11 +271,11 @@ int do_syslog(int type, char __user *buf, int len, int from_file)
 		return error;
 
 	switch (type) {
-	case 0:		/* Close log */
+	case SYSLOG_ACTION_CLOSE:	/* Close log */
 		break;
-	case 1:		/* Open log */
+	case SYSLOG_ACTION_OPEN:	/* Open log */
 		break;
-	case 2:		/* Read from log */
+	case SYSLOG_ACTION_READ:	/* Read from log */
 		error = -EINVAL;
 		if (!buf || len < 0)
 			goto out;
@@ -321,10 +306,12 @@ int do_syslog(int type, char __user *buf, int len, int from_file)
 		if (!error)
 			error = i;
 		break;
-	case 4:		/* Read/clear last kernel messages */
+	/* Read/clear last kernel messages */
+	case SYSLOG_ACTION_READ_CLEAR:
 		do_clear = 1;
 		/* FALL THRU */
-	case 3:		/* Read last kernel messages */
+	/* Read last kernel messages */
+	case SYSLOG_ACTION_READ_ALL:
 		error = -EINVAL;
 		if (!buf || len < 0)
 			goto out;
@@ -377,21 +364,25 @@ int do_syslog(int type, char __user *buf, int len, int from_file)
 			}
 		}
 		break;
-	case 5:		/* Clear ring buffer */
+	/* Clear ring buffer */
+	case SYSLOG_ACTION_CLEAR:
 		logged_chars = 0;
 		break;
-	case 6:		/* Disable logging to console */
+	/* Disable logging to console */
+	case SYSLOG_ACTION_CONSOLE_OFF:
 		if (saved_console_loglevel == -1)
 			saved_console_loglevel = console_loglevel;
 		console_loglevel = minimum_console_loglevel;
 		break;
-	case 7:		/* Enable logging to console */
+	/* Enable logging to console */
+	case SYSLOG_ACTION_CONSOLE_ON:
 		if (saved_console_loglevel != -1) {
 			console_loglevel = saved_console_loglevel;
 			saved_console_loglevel = -1;
 		}
 		break;
-	case 8:		/* Set level of messages printed to console */
+	/* Set level of messages printed to console */
+	case SYSLOG_ACTION_CONSOLE_LEVEL:
 		error = -EINVAL;
 		if (len < 1 || len > 8)
 			goto out;
@@ -402,10 +393,12 @@ int do_syslog(int type, char __user *buf, int len, int from_file)
 		saved_console_loglevel = -1;
 		error = 0;
 		break;
-	case 9:		/* Number of chars in the log buffer */
+	/* Number of chars in the log buffer */
+	case SYSLOG_ACTION_SIZE_UNREAD:
 		error = log_end - log_start;
 		break;
-	case 10:	/* Size of the log buffer */
+	/* Size of the log buffer */
+	case SYSLOG_ACTION_SIZE_BUFFER:
 		error = log_buf_len;
 		break;
 	default:
diff --git a/security/commoncap.c b/security/commoncap.c
index aaf123f..0705afe 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -897,9 +897,10 @@ error:
 int cap_syslog(int type, int from_file)
 {
 	/* /proc/kmsg can open be opened by CAP_SYS_ADMIN */
-	if (type != 1 && from_file)
+	if (type != SYSLOG_ACTION_OPEN && from_file)
 		return 0;
-	if ((type != 3 && type != 10) && !capable(CAP_SYS_ADMIN))
+	if ((type != SYSLOG_ACTION_READ_ALL &&
+	     type != SYSLOG_ACTION_SIZE_BUFFER) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	return 0;
 }
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 744785c..d242ab7 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2059,20 +2059,21 @@ static int selinux_syslog(int type, int from_file)
 		return rc;
 
 	switch (type) {
-	case 3:		/* Read last kernel messages */
-	case 10:	/* Return size of the log buffer */
+	case SYSLOG_ACTION_READ_ALL:	/* Read last kernel messages */
+	case SYSLOG_ACTION_SIZE_BUFFER:	/* Return size of the log buffer */
 		rc = task_has_system(current, SYSTEM__SYSLOG_READ);
 		break;
-	case 6:		/* Disable logging to console */
-	case 7:		/* Enable logging to console */
-	case 8:		/* Set level of messages printed to console */
+	case SYSLOG_ACTION_CONSOLE_OFF:	/* Disable logging to console */
+	case SYSLOG_ACTION_CONSOLE_ON:	/* Enable logging to console */
+	/* Set level of messages printed to console */
+	case SYSLOG_ACTION_CONSOLE_LEVEL:
 		rc = task_has_system(current, SYSTEM__SYSLOG_CONSOLE);
 		break;
-	case 0:		/* Close log */
-	case 1:		/* Open log */
-	case 2:		/* Read from log */
-	case 4:		/* Read/clear last kernel messages */
-	case 5:		/* Clear ring buffer */
+	case SYSLOG_ACTION_CLOSE:	/* Close log */
+	case SYSLOG_ACTION_OPEN:	/* Open log */
+	case SYSLOG_ACTION_READ:	/* Read from log */
+	case SYSLOG_ACTION_READ_CLEAR:	/* Read/clear last kernel messages */
+	case SYSLOG_ACTION_CLEAR:	/* Clear ring buffer */
 	default:
 		rc = task_has_system(current, SYSTEM__SYSLOG_MOD);
 		break;
-- 
1.6.5


-- 
Kees Cook
Ubuntu Security Team
