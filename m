Return-Path: <linux-kernel-owner+w=401wt.eu-S934594AbZLGAc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934594AbZLGAc1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934563AbZLGAcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:32:24 -0500
Received: from kroah.org ([198.145.64.141]:34313 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758390AbZLGAMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:53 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:45 2009
Message-Id: <20091207000645.840002105@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Ankit Jain <me@ankitjain.org>, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [034/119] fs: add missing compat_ptr handling for FS_IOC_RESVSP ioctl
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=fs-add-missing-compat_ptr-handling-for-fs_ioc_resvsp-ioctl.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 7779d7bed950a7fb1af4f540c2f82a6b81b65901 upstream.

For FS_IOC_RESVSP and FS_IOC_RESVSP64 compat_sys_ioctl() uses its
arg argument as a pointer to userspace. However it is missing a
a call to compat_ptr() which will do a proper pointer conversion.

This was introduced with 3e63cbb1 "fs: Add new pre-allocation ioctls
to vfs for compatibility with legacy xfs ioctls".

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ankit Jain <me@ankitjain.org>
Acked-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Arnd Bergmann <arndbergmann@googlemail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/compat_ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1800,7 +1800,7 @@ struct space_resv_32 {
 /* just account for different alignment */
 static int compat_ioctl_preallocate(struct file *file, unsigned long arg)
 {
-	struct space_resv_32	__user *p32 = (void __user *)arg;
+	struct space_resv_32	__user *p32 = compat_ptr(arg);
 	struct space_resv	__user *p = compat_alloc_user_space(sizeof(*p));
 
 	if (copy_in_user(&p->l_type,	&p32->l_type,	sizeof(s16)) ||
@@ -2802,7 +2802,7 @@ asmlinkage long compat_sys_ioctl(unsigne
 #else
 	case FS_IOC_RESVSP:
 	case FS_IOC_RESVSP64:
-		error = ioctl_preallocate(filp, (void __user *)arg);
+		error = ioctl_preallocate(filp, compat_ptr(arg));
 		goto out_fput;
 #endif
 


