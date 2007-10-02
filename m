Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbXJBJ1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbXJBJ1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 05:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbXJBJ1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 05:27:05 -0400
Received: from brick.kernel.dk ([87.55.233.238]:13279 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbXJBJ1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 05:27:02 -0400
Date: Tue, 2 Oct 2007 11:28:56 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, abhishekrai@google.com,
       Linus Torvalds <torvalds@linux-foundation.org>, davem@davemloft.net
Subject: Re: [PATCH] Fix blktrace setup 32-bit ioctl on 64-bit kernels
Message-ID: <20071002092856.GG5236@kernel.dk>
References: <20071002073943.GC5236@kernel.dk> <200710021015.33203.arnd@arndb.de> <20071002083758.GD5236@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002083758.GD5236@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Updated patch below. I kept the code in compat_ioctl.c, to me it seems
like the cleanest approach. I need the BLKTRACESETUP32 define both in
compat_ioctl.c and blktrace.c if I move it, and I need to hard-core the
struct size or define it in both places. And guard the code in
blktrace.c with an ifdef for CONFIG_COMPAT. Not pretty, imho.

I haven't tested this one yet, but at least it compiles and the sizing
seems right. The u16 padding was an artifact of the
__attribute__((packed)) so that could be removed.

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 5a5b711..54162e5 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -2052,6 +2052,44 @@ static int raw_ioctl(unsigned fd, unsigned cmd, unsigned long arg)
         }
         return ret;
 }
+
+struct blk_user_trace_setup32 {
+	char name[32];
+	u16 act_mask;
+	u32 buf_size;
+	u32 buf_nr;
+	compat_u64 start_lba;
+	compat_u64 end_lba;
+	u32 pid;
+};
+
+#define BLKTRACESETUP32 _IOWR(0x12,115,struct blk_user_trace_setup32)
+
+static int blktrace32_setup(int fd, unsigned cmd, unsigned long arg)
+{
+	struct blk_user_trace_setup __user *buts = compat_alloc_user_space(sizeof(*buts));
+	struct blk_user_trace_setup32 __user *buts32 = compat_ptr(arg);
+	int err;
+
+	if (copy_in_user(&buts->name, &buts32->name, 32) ||
+	    get_user(buts->act_mask, &buts32->act_mask) ||
+	    get_user(buts->buf_size, &buts32->buf_size) ||
+	    get_user(buts->buf_nr, &buts32->buf_nr) ||
+	    get_user(buts->start_lba, &buts32->start_lba) ||
+	    get_user(buts->end_lba, &buts32->end_lba) ||
+	    get_user(buts->pid, &buts32->pid))
+		return -EFAULT;
+
+	err = sys_ioctl(fd, cmd, (unsigned long) buts);
+	if (err)
+		return err;
+
+	if (copy_to_user(&buts32->name, &buts->name, 32))
+		return -EFAULT;
+
+	return err;
+}
+
 #endif /* CONFIG_BLOCK */
 
 struct serial_struct32 {
@@ -2555,7 +2593,7 @@ COMPATIBLE_IOCTL(BLKSECTSET)
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

