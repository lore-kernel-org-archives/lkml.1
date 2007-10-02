Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbXJBHiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbXJBHiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 03:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755735AbXJBHhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 03:37:50 -0400
Received: from brick.kernel.dk ([87.55.233.238]:1200 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709AbXJBHht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 03:37:49 -0400
Date: Tue, 2 Oct 2007 09:39:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: abhishekrai@google.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Fix blktrace setup 32-bit ioctl on 64-bit kernels
Message-ID: <20071002073943.GC5236@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The layout of struct blk_user_trace_setup is a bit unfortunate, it gets
padded differently on 32-bit and 64-bit archs. So right now it's not
possible to trace 64-bit kernels with a 32-bit app. This patch fixes
that up by adding a compat ioctl handler for BLKTRACESETUP.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 5a5b711..b18b9cc 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -2052,6 +2052,51 @@ static int raw_ioctl(unsigned fd, unsigned cmd, unsigned long arg)
         }
         return ret;
 }
+
+struct blk_user_trace_setup32 {
+	char name[32];
+	u16 act_mask;
+	u16 pad;
+	u32 buf_size;
+	u32 buf_nr;
+	u64 start_lba;
+	u64 end_lba;
+	u32 pid;
+} __attribute__((packed));
+
+#define BLKTRACESETUP32 _IOWR(0x12,115,struct blk_user_trace_setup32)
+
+static int blktrace32_setup(int fd, unsigned cmd, unsigned long arg)
+{
+	struct blk_user_trace_setup __user *buts = compat_alloc_user_space(sizeof(*buts));
+	struct blk_user_trace_setup32 __user *buts32 = compat_ptr(arg);
+	int err;
+
+	if (copy_in_user(&buts->name, &buts32->name, BDEVNAME_SIZE) ||
+	    get_user(buts->act_mask, &buts32->act_mask) ||
+	    get_user(buts->buf_size, &buts32->buf_size) ||
+	    get_user(buts->buf_nr, &buts32->buf_nr) ||
+	    get_user(buts->start_lba, &buts32->start_lba) ||
+	    get_user(buts->end_lba, &buts32->end_lba) ||
+	    get_user(buts->pid, &buts32->pid))
+		return -EFAULT;
+
+	err = sys_ioctl(fd, BLKTRACESETUP, (unsigned long) buts);
+	if (err)
+		return err;
+
+	if (copy_to_user(&buts32->name, &buts->name, BDEVNAME_SIZE) ||
+	    put_user(buts32->act_mask, &buts->act_mask) ||
+	    put_user(buts32->buf_size, &buts->buf_size) ||
+	    put_user(buts32->buf_nr, &buts->buf_nr) ||
+	    put_user(buts32->start_lba, &buts->start_lba) ||
+	    put_user(buts32->end_lba, &buts->end_lba) ||
+	    put_user(buts32->pid, &buts->pid))
+		return -EFAULT;
+
+	return err;
+}
+
 #endif /* CONFIG_BLOCK */
 
 struct serial_struct32 {
@@ -2555,7 +2600,7 @@ COMPATIBLE_IOCTL(BLKSECTSET)
 COMPATIBLE_IOCTL(BLKSSZGET)
 COMPATIBLE_IOCTL(BLKTRACESTART)
 COMPATIBLE_IOCTL(BLKTRACESTOP)
-COMPATIBLE_IOCTL(BLKTRACESETUP)
+HANDLE_IOCTL(BLKTRACESETUP32, blktrace32_setup)
 COMPATIBLE_IOCTL(BLKTRACETEARDOWN)
 ULONG_IOCTL(BLKRASET)
 ULONG_IOCTL(BLKFRASET)

-- 
Jens Axboe

