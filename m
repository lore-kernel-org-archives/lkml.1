Return-Path: <linux-kernel-owner+w=401wt.eu-S1752275AbZKCKp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbZKCKp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 05:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbZKCKpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 05:45:55 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:39253 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbZKCKpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 05:45:54 -0500
Date: Tue, 3 Nov 2009 11:45:32 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ankit Jain <me@ankitjain.org>,
       Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] fs: add missing compat_ptr handling for FS_IOC_RESVSP ioctl
Message-ID: <20091103104532.GA19670@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

For FS_IOC_RESVSP and FS_IOC_RESVSP64 compat_sys_ioctl() uses its
arg argument as a pointer to userspace. However it is missing a
a call to compat_ptr() which will do a proper pointer conversion.

This was introduced with 3e63cbb1 "fs: Add new pre-allocation ioctls
to vfs for compatibility with legacy xfs ioctls".

Cc: Ankit Jain <me@ankitjain.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arndbergmann@googlemail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 fs/compat_ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index f91fd51..d84e705 100644
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
@@ -2802,7 +2802,7 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 #else
 	case FS_IOC_RESVSP:
 	case FS_IOC_RESVSP64:
-		error = ioctl_preallocate(filp, (void __user *)arg);
+		error = ioctl_preallocate(filp, compat_ptr(arg));
 		goto out_fput;
 #endif

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

