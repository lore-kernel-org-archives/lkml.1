Return-Path: <linux-kernel-owner+w=401wt.eu-S1754269AbYAIJuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbYAIJuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 04:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYAIJur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 04:50:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbYAIJuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 04:50:46 -0500
Date: Wed, 09 Jan 2008 18:50:36 +0900 (JST)
Message-Id: <20080109.185036.227535061.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ltp-list@lists.sourceforge.net
Subject: [PATCH] checking ADVICE of fadvice64_64 even if get_xip_page is
 given
From: Masatake YAMATO <yamato@redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1.50 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've written some test programs in ltp project.
During writing I met an problem which I cannot solve
in user land. So I wrote a patch for linux kernel.
Please, include this patch if acceptable.


The test program tests the 4th parameter of fadvise64_64:

    long sys_fadvise64_64(int fd, loff_t offset, loff_t len, int advice);


My test case calls fadvise64_64 with invalid advice value and
checks errno is set to EINVAL.
About the advice parameter man page says:

    ...
    Permissible values for advice include:

	   POSIX_FADV_NORMAL
                  ...
	   POSIX_FADV_SEQUENTIAL
                  ...
	   POSIX_FADV_RANDOM
		  ...
	   POSIX_FADV_NOREUSE
                  ...
	   POSIX_FADV_WILLNEED
                  ...
	   POSIX_FADV_DONTNEED
		  ...
    ERRORS
           ...
	   EINVAL An invalid value was specified for advice.

However, I got a bug report that the system call invocations
in my test case returned 0 unexpectedly. 

I've inspected the kernel code:

    asmlinkage long sys_fadvise64_64(int fd, loff_t offset, loff_t len, int advice)
    {
	    struct file *file = fget(fd);
	    struct address_space *mapping;
	    struct backing_dev_info *bdi;
	    loff_t endbyte;			/* inclusive */
	    pgoff_t start_index;
	    pgoff_t end_index;
	    unsigned long nrpages;
	    int ret = 0;

	    if (!file)
		    return -EBADF;

	    if (S_ISFIFO(file->f_path.dentry->d_inode->i_mode)) {
		    ret = -ESPIPE;
		    goto out;
	    }

	    mapping = file->f_mapping;
	    if (!mapping || len < 0) {
		    ret = -EINVAL;
		    goto out;
	    }

	    if (mapping->a_ops->get_xip_page)
		    /* no bad return value, but ignore advice */
		    goto out;
    ...
    out:
	    fput(file);
	    return ret;
    }

I found the advice parameter is just ignored in the case
mapping->a_ops->get_xip_page is given. This behavior is different from
what is written on the man page. Is this o.k.?

get_xip_page is given if CONFIG_EXT2_FS_XIP is true.
Anyway I cannot find the easy way to detect get_xip_page 
field is given or CONFIG_EXT2_FS_XIP is true from the 
user space.

I propose the following patch which checks the advice parameter
even if get_xip_page is given.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>

diff --git a/mm/fadvise.c b/mm/fadvise.c
index 0df4c89..3c0f1e9 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -49,9 +49,21 @@ asmlinkage long sys_fadvise64_64(int fd, loff_t offset, loff_t len, int advice)
 		goto out;
 	}
 
-	if (mapping->a_ops->get_xip_page)
-		/* no bad return value, but ignore advice */
+	if (mapping->a_ops->get_xip_page) {
+		switch (advice) {
+		case POSIX_FADV_NORMAL:
+		case POSIX_FADV_RANDOM:
+		case POSIX_FADV_SEQUENTIAL:
+		case POSIX_FADV_WILLNEED:
+		case POSIX_FADV_NOREUSE:
+		case POSIX_FADV_DONTNEED:
+			/* no bad return value, but ignore advice */
+			break;
+		default:
+			ret = -EINVAL;
+		}
 		goto out;
+	}
 
 	/* Careful about overflows. Len == 0 means "as much as possible" */
 	endbyte = offset + len;
