Return-Path: <linux-kernel-owner+w=401wt.eu-S1767554AbXEDAxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767554AbXEDAxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 20:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767561AbXEDAxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 20:53:17 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767554AbXEDAxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 20:53:16 -0400
Date: Thu, 3 May 2007 17:53:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Fulghum <paulkf@microgate.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] synclink_gt add compat_ioctl
Message-Id: <20070503175305.e46ed8b7.akpm@linux-foundation.org>
In-Reply-To: <1178215277.4369.6.camel@amdx2.microgate.com>
References: <1178215277.4369.6.camel@amdx2.microgate.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 May 2007 13:01:17 -0500
Paul Fulghum <paulkf@microgate.com> wrote:

> Add compat_ioctl handler to synclink_gt driver.
> 
> The one case requiring a separate 32 bit handler could be
> removed by redefining the associated structure in
> a way compatible with both 32 and 64 bit systems. But that
> approach would break existing native 64 bit user applications.


A made a few changes here...


From: Andrew Morton <akpm@linux-foundation.org>

- Fix i386 build:

In file included from drivers/char/synclink_gt.c:85:
include/linux/synclink.h:175: error: expected specifier-qualifier-list before 'compat_ulong_t'

- We might as well do the same ifdef-avoidery trick around compat_ioctl()
  too.  That required that it be renamed.

- It is fishy that apart from one outlier in kexec.h, synclink.h is the
  only header file which uses compat_ulong_t.  Are we doing this right?

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink_gt.c |   16 +++++++++-------
 include/linux/synclink.h   |    5 +++--
 2 files changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/char/synclink_gt.c~synclink_gt-add-compat_ioctl-fix drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink_gt-add-compat_ioctl-fix
+++ a/drivers/char/synclink_gt.c
@@ -1176,15 +1176,16 @@ static int ioctl(struct tty_struct *tty,
 }
 
 #ifdef CONFIG_COMPAT
-static long compat_ioctl(struct tty_struct *tty, struct file *file,
+static long synclink_compat_ioctl(struct tty_struct *tty, struct file *file,
 			 unsigned int cmd, unsigned long arg)
 {
 	struct slgt_info *info = tty->driver_data;
 	int rc = -ENOIOCTLCMD;
 
-	if (sanity_check(info, tty->name, "compat_ioctl"))
+	if (sanity_check(info, tty->name, "synclink_compat_ioctl"))
 		return -ENODEV;
-	DBGINFO(("%s compat_ioctl() cmd=%08X\n", info->device_name, cmd));
+	DBGINFO(("%s synclink_compat_ioctl() cmd=%08X\n",
+		info->device_name, cmd));
 
 	switch (cmd) {
 
@@ -1219,9 +1220,12 @@ static long compat_ioctl(struct tty_stru
 		break;
 	}
 
-	DBGINFO(("%s compat_ioctl() cmd=%08X rc=%d\n", info->device_name, cmd, rc));
+	DBGINFO(("%s synclink_compat_ioctl() cmd=%08X rc=%d\n",
+		info->device_name, cmd, rc));
 	return rc;
 }
+#else
+#define synclink_compat_ioctl NULL
 #endif
 
 /*
@@ -3554,9 +3558,7 @@ static const struct tty_operations ops =
 	.chars_in_buffer = chars_in_buffer,
 	.flush_buffer = flush_buffer,
 	.ioctl = ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl = compat_ioctl,
-#endif
+	.compat_ioctl = synclink_compat_ioctl,
 	.throttle = throttle,
 	.unthrottle = unthrottle,
 	.send_xchar = send_xchar,
diff -puN include/linux/synclink.h~synclink_gt-add-compat_ioctl-fix include/linux/synclink.h
--- a/include/linux/synclink.h~synclink_gt-add-compat_ioctl-fix
+++ a/include/linux/synclink.h
@@ -169,9 +169,9 @@ typedef struct _MGSL_PARAMS
 
 } MGSL_PARAMS, *PMGSL_PARAMS;
 
+#ifdef CONFIG_COMPAT
 /* provide 32 bit ioctl compatibility on 64 bit systems */
-struct MGSL_PARAMS32
-{
+struct MGSL_PARAMS32 {
 	compat_ulong_t	mode;
 	unsigned char	loopback;
 	unsigned short	flags;
@@ -186,6 +186,7 @@ struct MGSL_PARAMS32
 	unsigned char	stop_bits;
 	unsigned char	parity;
 };
+#endif
 
 #define MICROGATE_VENDOR_ID 0x13c0
 #define SYNCLINK_DEVICE_ID 0x0010
_

