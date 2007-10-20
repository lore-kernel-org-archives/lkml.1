Return-Path: <linux-kernel-owner+w=401wt.eu-S1764089AbXJTPv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764089AbXJTPv5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 11:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbXJTPvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 11:51:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:55391 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001AbXJTPvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 11:51:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH] compat_ioctl: introduce generic_compat_ioctl helper
Date: Sat, 20 Oct 2007 17:50:57 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Philip Langdale <philipl@overt.org>, Jiri Kosina <jkosina@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>
References: <47100864.2090208@overt.org> <20071013000221.GC8181@ftp.linux.org.uk>
In-Reply-To: <20071013000221.GC8181@ftp.linux.org.uk>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710201750.58521.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+7X5Kd0W2OrslLzWoYpjw+Gh3EM5UJCmfTgWZ
 e/uGYZ28EydI3iAOFKaY0k18wRul2MlXJtVJsq0GwyTvZL9rqi
 NgnFoAm5GvRmQ+0P0oHsw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Many drivers use only compatible ioctl numbers. In order to
avoid having to write a special compat_ioctl handler for each
of them or listing every ioctl number in fs/compat_ioctl.c,
let's introduce a generic handler that simply calls the
driver specific f_op->unlocked_ioctl() or f_op->ioctl() handler.

Signed-off-by: Arnd Bergman <arnd@arndb.de>
---
On Saturday 13 October 2007, Al Viro wrote:
> Just how many instances of that sucker do we need?  It's nothing but
> 
>      struct inode *inode = file->f_path.dentry->d_inode;
>      return file->f_op->ioctl(inode, file, cmd, compat_ptr(arg));

Is this what you had in mind? I've been meaning to do something like
it for some time, but had forgotten about it.

I guess we can kill a significant amount of COMPATIBLE_IOCTL
lines in fs/compat_ioctl.c with this.

Index: linux-2.6/fs/compat_ioctl.c
===================================================================
--- linux-2.6.orig/fs/compat_ioctl.c
+++ linux-2.6/fs/compat_ioctl.c
@@ -1877,6 +1877,30 @@ lp_timeout_trans(unsigned int fd, unsign
 	return sys_ioctl(fd, cmd, (unsigned long)tn);
 }
 
+/*
+ * Helper function for device drivers that only have COMPATIBLE_IOCTL
+ * numbers. This can be used as f_op->compat_ioctl without any #ifdef
+ * and will simply call the native ioctl handler with the argument
+ * pointer.
+ * Don't use for drivers that interpret arg as an unsigned long instead
+ * of a pointer.
+ */
+long generic_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int ret = -ENOTTY;
+	arg = (unsigned long)compat_ptr(arg);
+
+	if (file->f_op->unlocked_ioctl)
+		ret = file->f_op->unlocked_ioctl(file, cmd, arg);
+	else if (file->f_op->ioctl) {
+		lock_kernel();
+		ret = file->f_op->ioctl(file->f_dentry->d_inode, file, cmd, arg);
+		unlock_kernel();
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(generic_compat_ioctl);
 
 typedef int (*ioctl_trans_handler_t)(unsigned int, unsigned int,
 					unsigned long, struct file *);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -1807,6 +1807,12 @@ extern void do_generic_mapping_read(stru
 extern int generic_segment_checks(const struct iovec *iov,
 		unsigned long *nr_segs, size_t *count, int access_flags);
 
+#ifdef CONFIG_COMPAT
+extern long generic_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+#else
+#define generic_compat_ioctl (long (*)(struct file *, unsigned int, unsigned long))NULL
+#endif
+
 /* fs/splice.c */
 extern ssize_t generic_file_splice_read(struct file *, loff_t *,
 		struct pipe_inode_info *, size_t, unsigned int);
