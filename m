Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbZBHGJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbZBHGJt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 01:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbZBHGJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 01:09:41 -0500
Received: from science.horizon.com ([192.35.100.1]:17613 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750836AbZBHGJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 01:09:40 -0500
Message-ID: <20090208060938.25184.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
Date: Sun, 08 Feb 2009 01:09:38 -0500
To: udovdh@xs4all.nl
Cc: linux-kernel@vger.kernel.org, LinuxPPS@ml.enneenne.com,
       giometti@enneenne.com, linux@horizon.com
Subject: Re: [LinuxPPS] LinuxPPS kernel interface
References: <9dd2f03a0810280213v42811184pb14d80f90529d1d5@mail.gmail.com>
 <20081028111414.19650.qmail@science.horizon.com>
 <20081028144735.GC28518@tekkaman>
 <20081028181335.29352.qmail@science.horizon.com>
 <20081028181546.GM11339@tekkaman>
 <20090206142231.22425.qmail@science.horizon.com>
 <20090206143703.GC7975@enneenne.com>
 <20090206144752.5195.qmail@science.horizon.com>
 <20090206145553.GD7975@enneenne.com>
 <20090206145932.10638.qmail@science.horizon.com>
 <20090206152156.GE7975@enneenne.com>
 <20090206225326.14093.qmail@science.horizon.com>
 <20090208004914.21448.qmail@science.horizon.com>
 <498E712F.7080206@xs4all.nl>
In-Reply-To: <498E712F.7080206@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel <udovdh@xs4all.nl> wrote:
> Interesting ideas, thanks for the input.
>
> I think I must mention  that we also must strive for kernel inclusion.
> Kernel inclusion will broaden our exposure.
> This means we have to get rid of the issues blocking inclusion.
> (see a query like http://marc.info/?l=linux-kernel&w=2&r=1&s=pps&q=b for 
> related posts)
>
> What do you think?

I agree, that's the goal.  But it's also important to get the
interface right, preferably before publishing it to world+dog.

And then there are little things like the fact that an important header
file like timepps.h probably shouldn't live in Documentation/pps...

For example, here's a patch, on top of the previous series, that
gets rid of the timeout argument to PPS_FETCH:

diff --git a/Documentation/pps/timepps.h b/Documentation/pps/timepps.h
index 5006ca5..56746db 100644
--- a/Documentation/pps/timepps.h
+++ b/Documentation/pps/timepps.h
@@ -22,6 +22,7 @@
 #define _SYS_TIMEPPS_H_
 
 #include <errno.h>
+#include <poll.h>
 #include <sys/time.h>
 #include <sys/ioctl.h>
 #include <linux/types.h>
@@ -29,28 +30,44 @@
 
 #define LINUXPPS	1		/* signal we are using LinuxPPS */
 
+/* In case we don't have it */
+int ppoll(struct pollfd *fds, nfds_t nfds,
+          const struct timespec *timeout, const sigset_t *sigmask);
+
 /*
- * New data structures
+ * New data structures.
+ *
+ * The data types are mandated by RFC 2783, and are unfortunately not
+ * 64-bit clean.  (In particular, they use the "long" data type, which
+ * is 32 bits in 32-bit code and 64 bits in 64-bit code.)  Thus, they
+ * are not suitable for passing to the kernel on a machine which runs
+ * both kinds of code.  (Like any modern x86-64 system.)
+ *
+ * So this code does a lot of copying of data structures.
  */
+typedef __u32 pps_seq_t;		/* sequence number */
 
 struct ntp_fp {
 	unsigned int integral;
 	unsigned int fractional;
 };
+typedef struct ntp_fp ntp_fp_t;		/* NTP-compatible time stamp */
 
 union pps_timeu {
 	struct timespec tspec;
 	struct ntp_fp ntpfp;
 	unsigned long longpad[3];
 };
+typedef union pps_timeu pps_timeu_t;	/* generic data type for time stamps */
 
 struct pps_info {
-	unsigned long assert_sequence;	/* seq. num. of assert event */
-	unsigned long clear_sequence;	/* seq. num. of clear event */
+	pps_seq_t assert_sequence;	/* seq. num. of assert event */
+	pps_seq_t clear_sequence;	/* seq. num. of clear event */
 	union pps_timeu assert_tu;	/* time of assert event */
 	union pps_timeu clear_tu;	/* time of clear event */
 	int current_mode;		/* current mode bits */
 };
+typedef struct pps_info pps_info_t;
 
 struct pps_params {
 	int api_version;		/* API version # */
@@ -58,13 +75,9 @@ struct pps_params {
 	union pps_timeu assert_off_tu;	/* offset compensation for assert */
 	union pps_timeu clear_off_tu;	/* offset compensation for clear */
 };
+typedef struct pps_params pps_params_t;
 
 typedef int pps_handle_t;		/* represents a PPS source */
-typedef unsigned long pps_seq_t;	/* sequence number */
-typedef struct ntp_fp ntp_fp_t;		/* NTP-compatible time stamp */
-typedef union pps_timeu pps_timeu_t;	/* generic data type for time stamps */
-typedef struct pps_info pps_info_t;
-typedef struct pps_params pps_params_t;
 
 #define assert_timestamp        assert_tu.tspec
 #define clear_timestamp         clear_tu.tspec
@@ -155,7 +168,8 @@ static __inline int time_pps_fetch(pps_handle_t handle, const int tsformat,
 					pps_info_t *ppsinfobuf,
 					const struct timespec *timeout)
 {
-	struct pps_fdata __fdata;
+	struct pps_kinfo kinfo;
+	struct pollfd pfd = { .fd = handle, .events = POLLIN };
 	int ret;
 
 	/* Sanity checks */
@@ -164,22 +178,23 @@ static __inline int time_pps_fetch(pps_handle_t handle, const int tsformat,
 		return -1;
 	}
 
-	if (timeout) {
-		__fdata.timeout.sec = timeout->tv_sec;
-		__fdata.timeout.nsec = timeout->tv_nsec;
-		__fdata.timeout.flags = ~PPS_TIME_INVALID;
-	} else
-		__fdata.timeout.flags = PPS_TIME_INVALID;
-
-	ret = ioctl(handle, PPS_FETCH, &__fdata);
-
-	ppsinfobuf->assert_sequence = __fdata.info.assert_sequence;
-	ppsinfobuf->clear_sequence = __fdata.info.clear_sequence;
-	ppsinfobuf->assert_tu.tspec.tv_sec = __fdata.info.assert_tu.sec;
-	ppsinfobuf->assert_tu.tspec.tv_nsec = __fdata.info.assert_tu.nsec;
-	ppsinfobuf->clear_tu.tspec.tv_sec = __fdata.info.clear_tu.sec;
-	ppsinfobuf->clear_tu.tspec.tv_nsec = __fdata.info.clear_tu.nsec;
-	ppsinfobuf->current_mode = __fdata.info.current_mode;
+	ret = ppoll(&pfd, 1, timeout, NULL);
+	if (ret < 0)
+		return ret;
+	if (ret == 0) {
+		errno = ETIMEDOUT;	/* Should be EAGAIN! */
+		return -1;
+	}
+		
+	ret = ioctl(handle, PPS_FETCH, &kinfo);
+
+	ppsinfobuf->assert_sequence         = kinfo.assert_sequence;
+	ppsinfobuf->clear_sequence          = kinfo.clear_sequence;
+	ppsinfobuf->assert_tu.tspec.tv_sec  = kinfo.assert_tu.sec;
+	ppsinfobuf->assert_tu.tspec.tv_nsec = kinfo.assert_tu.nsec;
+	ppsinfobuf->clear_tu.tspec.tv_sec   = kinfo.clear_tu.sec;
+	ppsinfobuf->clear_tu.tspec.tv_nsec  = kinfo.clear_tu.nsec;
+	ppsinfobuf->current_mode            = kinfo.current_mode;
 
 	return ret;
 }
diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 7a32920..d3d4c49 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -151,10 +151,9 @@ static long pps_cdev_ioctl(struct file *file,
 						struct pps_device, cdev);
 	struct pps_kinfo *info = file->private_data;
 	void __user *uarg = (void __user *) arg;
-	struct pps_fdata __user *fuarg = uarg;
+	struct pps_kinfo __user *fuarg = uarg;
 	struct pps_kparams params;
-	struct pps_fdata fdata;
-	unsigned long ticks;
+	struct pps_kinfo kinfo;
 	u32 seq1, seq2;
 	int err;
 
@@ -246,59 +245,24 @@ static long pps_cdev_ioctl(struct file *file,
 
 		if (!(file->f_mode & FMODE_READ))
 			return -EBADF;	/* Not open for read */
-		err = copy_from_user(&fdata.timeout, &fuarg->timeout,
-			sizeof fdata.timeout);
-		if (err)
-			return -EFAULT;
-
-		/* Manage the timeout */
-		if (fdata.timeout.flags & PPS_TIME_INVALID)
-			err = wait_event_interruptible(pps->queue,
-						pps_is_ready(pps, info));
-		else {
-			pr_debug("timeout %lld.%09d\n",
-					(long long) fdata.timeout.sec,
-					fdata.timeout.nsec);
-			ticks = fdata.timeout.sec * HZ;
-			ticks += fdata.timeout.nsec / (NSEC_PER_SEC / HZ);
-
-			if (ticks != 0) {
-				err = wait_event_interruptible_timeout(
-						pps->queue,
-						pps_is_ready(pps, info),
-						ticks);
-				/*
-				 * RFC 2783 requires this error, although
-				 * it really should be EAGAIN.
-				 */
-				if (err == 0)
-					return -ETIMEDOUT;
-			}
-		}
-
-		/* Check for pending signals */
-		if (err == -ERESTARTSYS) {
-			pr_debug("pending signal caught\n");
-			return -EINTR;
-		}
 
-		/* Return the fetched timestamp */
-		fdata.info.assert_sequence = info->assert_sequence = seq1 =
+		/* Return the most recent timestamp */
+		kinfo.assert_sequence = info->assert_sequence = seq1 =
 			pps->assert_sequence;
-		fdata.info.clear_sequence = info->clear_sequence = seq2 =
+		kinfo.clear_sequence = info->clear_sequence = seq2 =
 			pps->clear_sequence;
 
 		read_barrier_depends();
 
-		fdata.info.assert_tu = pps->assert_tu[seq1 % 4];
+		kinfo.assert_tu = pps->assert_tu[seq1 % 4];
 		if (info->current_mode & PPS_OFFSETASSERT)
-			pps_add_offset(&fdata.info.assert_tu, &info->assert_tu);
-		fdata.info.clear_tu = pps->clear_tu[seq2 % 4];
+			pps_add_offset(&kinfo.assert_tu, &info->assert_tu);
+		kinfo.clear_tu = pps->clear_tu[seq2 % 4];
 		if (info->current_mode & PPS_OFFSETCLEAR)
-			pps_add_offset(&fdata.info.clear_tu, &info->clear_tu);
-		fdata.info.current_mode = info->current_mode;
+			pps_add_offset(&kinfo.clear_tu, &info->clear_tu);
+		kinfo.current_mode = info->current_mode;
 
-		err = copy_to_user(&fuarg->info, &fdata.info, sizeof fdata.info);
+		err = copy_to_user(fuarg, &kinfo, sizeof kinfo);
 		if (err)
 			return -EFAULT;
 
diff --git a/include/linux/pps.h b/include/linux/pps.h
index deb739c..868d66e 100644
--- a/include/linux/pps.h
+++ b/include/linux/pps.h
@@ -108,18 +108,13 @@ struct pps_kparams {
  * Here begins the implementation-specific part!
  */
 
-struct pps_fdata {
-	struct pps_kinfo info;
-	struct pps_ktime timeout;
-};
-
 #include <linux/ioctl.h>
 
 #define PPS_CHECK		_IO('p', 0xa0)
 #define PPS_GETPARAMS		_IOR('p', 0xa1, struct pps_kparams *)
 #define PPS_SETPARAMS		_IOW('p', 0xa2, struct pps_kparams *)
 #define PPS_GETCAP		_IOR('p', 0xa3, int *)
-#define PPS_FETCH		_IOWR('p', 0xa4, struct pps_fdata *)
+#define PPS_FETCH		_IOWR('p', 0xa4, struct pps_kinfo *)
 
 #ifdef __KERNEL__
 
