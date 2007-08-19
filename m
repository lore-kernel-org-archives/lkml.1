Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbXHSW4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbXHSW4A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 18:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbXHSWzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 18:55:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51855 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbXHSWzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 18:55:51 -0400
Date: Sun, 19 Aug 2007 23:55:46 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] ptrdiff_t is not uintptr_t, damnit
Message-ID: <20070819225546.GV21089@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use of ptrdiff_t in

-                       if (!access_ok(VERIFY_WRITE, u_tmp->rx_buf, u_tmp->len))
+                       if (!access_ok(VERIFY_WRITE, (u8 __user *)
+                                               (ptrdiff_t) u_tmp->rx_buf,
+                                               u_tmp->len))

is wrong; for one thing, it's a bad C (it's what uintptr_t is for; in general
we are not even promised that ptrdiff_t is large enough to hold a pointer,
just enough to hold a difference between two pointers within the same object).
For another, it confuses the fsck out of sparse.

Use unsigned long or uintptr_t instead.  There are several places misusing
ptrdiff_t (one - in a very odd way; WTF did that cast to __user ptrdiff_t 
in ntfs expect to happen, anyway?)   Fixed...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 72b0393..1e6d7a9 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -391,7 +391,7 @@ static int close_getadapter_fib(struct aac_dev * dev, void __user *arg)
 		/*
 		 *	Extract the fibctx from the input parameters
 		 */
-		if (fibctx->unique == (u32)(ptrdiff_t)arg) /* We found a winner */
+		if (fibctx->unique == (u32)(uintptr_t)arg) /* We found a winner */
 			break;
 		entry = entry->next;
 		fibctx = NULL;
@@ -590,7 +590,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				}
 				addr = (u64)upsg->sg[i].addr[0];
 				addr += ((u64)upsg->sg[i].addr[1]) << 32;
-				sg_user[i] = (void __user *)(ptrdiff_t)addr;
+				sg_user[i] = (void __user *)(uintptr_t)addr;
 				sg_list[i] = p; // save so we can clean up later
 				sg_indx = i;
 
@@ -633,7 +633,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 					rcode = -ENOMEM;
 					goto cleanup;
 				}
-				sg_user[i] = (void __user *)(ptrdiff_t)usg->sg[i].addr;
+				sg_user[i] = (void __user *)(uintptr_t)usg->sg[i].addr;
 				sg_list[i] = p; // save so we can clean up later
 				sg_indx = i;
 
@@ -664,7 +664,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		if (actual_fibsize64 == fibsize) {
 			struct user_sgmap64* usg = (struct user_sgmap64 *)upsg;
 			for (i = 0; i < upsg->count; i++) {
-				u64 addr;
+				uintptr_t addr;
 				void* p;
 				/* Does this really need to be GFP_DMA? */
 				p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
@@ -676,7 +676,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				}
 				addr = (u64)usg->sg[i].addr[0];
 				addr += ((u64)usg->sg[i].addr[1]) << 32;
-				sg_user[i] = (void __user *)(ptrdiff_t)addr;
+				sg_user[i] = (void __user *)addr;
 				sg_list[i] = p; // save so we can clean up later
 				sg_indx = i;
 
@@ -704,7 +704,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 					rcode = -ENOMEM;
 					goto cleanup;
 				}
-				sg_user[i] = (void __user *)(ptrdiff_t)upsg->sg[i].addr;
+				sg_user[i] = (void __user *)(uintptr_t)upsg->sg[i].addr;
 				sg_list[i] = p; // save so we can clean up later
 				sg_indx = i;
 
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 3009ad8..8736813 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -110,7 +110,7 @@ static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsigned long co
 	/*
 	 *	Align the beginning of Headers to commalign
 	 */
-	align = (commalign - ((ptrdiff_t)(base) & (commalign - 1)));
+	align = (commalign - ((uintptr_t)(base) & (commalign - 1)));
 	base = base + align;
 	phys = phys + align;
 	/*
diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index fcd25f7..e6032ff 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -254,7 +254,7 @@ unsigned int aac_intr_normal(struct aac_dev * dev, u32 Index)
 			kfree (fib);
 			return 1;
 		}
-		memcpy(hw_fib, (struct hw_fib *)(((ptrdiff_t)(dev->regs.sa)) +
+		memcpy(hw_fib, (struct hw_fib *)(((uintptr_t)(dev->regs.sa)) +
 		  (index & ~0x00000002L)), sizeof(struct hw_fib));
 		INIT_LIST_HEAD(&fib->fiblink);
 		fib->type = FSAFS_NTC_FIB_CONTEXT;
diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index c55459c..b3518ca 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -184,14 +184,14 @@ static int spidev_message(struct spidev_data *spidev,
 		if (u_tmp->rx_buf) {
 			k_tmp->rx_buf = buf;
 			if (!access_ok(VERIFY_WRITE, (u8 __user *)
-						(ptrdiff_t) u_tmp->rx_buf,
+						(uintptr_t) u_tmp->rx_buf,
 						u_tmp->len))
 				goto done;
 		}
 		if (u_tmp->tx_buf) {
 			k_tmp->tx_buf = buf;
 			if (copy_from_user(buf, (const u8 __user *)
-						(ptrdiff_t) u_tmp->tx_buf,
+						(uintptr_t) u_tmp->tx_buf,
 					u_tmp->len))
 				goto done;
 		}
@@ -224,7 +224,7 @@ static int spidev_message(struct spidev_data *spidev,
 	for (n = n_xfers, u_tmp = u_xfers; n; n--, u_tmp++) {
 		if (u_tmp->rx_buf) {
 			if (__copy_to_user((u8 __user *)
-					(ptrdiff_t) u_tmp->rx_buf, buf,
+					(uintptr_t) u_tmp->rx_buf, buf,
 					u_tmp->len)) {
 				status = -EFAULT;
 				goto done;
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index ffcc504..a9103ce 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -362,7 +362,7 @@ static inline void ntfs_fault_in_pages_readable(const char __user *uaddr,
 	volatile char c;
 
 	/* Set @end to the first byte outside the last page we care about. */
-	end = (const char __user*)PAGE_ALIGN((ptrdiff_t __user)uaddr + bytes);
+	end = (const char __user*)PAGE_ALIGN((uintptr_t)uaddr + bytes);
 
 	while (!__get_user(c, uaddr) && (uaddr += PAGE_SIZE, uaddr < end))
 		;
diff --git a/include/linux/types.h b/include/linux/types.h
index 0351bf2..efdec19 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -40,6 +40,8 @@ typedef __kernel_gid32_t	gid_t;
 typedef __kernel_uid16_t        uid16_t;
 typedef __kernel_gid16_t        gid16_t;
 
+typedef unsigned long		uintptr_t;
+
 #ifdef CONFIG_UID16
 /* This is defined by include/asm-{arch}/posix_types.h */
 typedef __kernel_old_uid_t	old_uid_t;
