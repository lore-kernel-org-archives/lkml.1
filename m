Return-Path: <linux-kernel-owner+w=401wt.eu-S1759134AbXGCJrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134AbXGCJrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 05:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbXGCJrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 05:47:15 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:39194 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024AbXGCJrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 05:47:14 -0400
Date: Tue, 3 Jul 2007 11:48:31 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070703094831.GA13413@enneenne.com>
References: <20070628084003.GQ13886@enneenne.com> <1183031060.1170.145.camel@pmac.infradead.org> <20070628161450.GD13886@enneenne.com> <1183117082.1170.308.camel@pmac.infradead.org> <20070629150813.GM13886@enneenne.com> <1183132548.1170.360.camel@pmac.infradead.org> <20070629163422.GP13886@enneenne.com> <1183135253.17622.5.camel@shinybook.infradead.org> <20070630171340.GT13886@enneenne.com> <1183291392.2828.17.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <1183291392.2828.17.camel@shinybook.infradead.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 01, 2007 at 01:03:11PM +0100, David Woodhouse wrote:
> 
> Seems reasonable enough in principle -- but whatever you do, don't use
> "long" for it. That would definitely need different behaviour for 32-bit
> vs. 64-bit. Use explicitly sized types such as uint32_t or uint64_t.

Here the patch to convert LinuxPPS data structs into fixed ones.

Please, take a look at it and report possible modifications.

Thanks for your time,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127

--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch

diff --git a/Documentation/pps/timepps.h b/Documentation/pps/timepps.h
index d690aa6..fe8f467 100644
--- a/Documentation/pps/timepps.h
+++ b/Documentation/pps/timepps.h
@@ -28,6 +28,32 @@
 
 /* --- 3.2 New data structures --------------------------------------------- */
 
+struct ntp_fp {
+	unsigned int integral;
+	unsigned int fractional;
+};
+
+union pps_timeu {
+	struct timespec tspec;
+	struct ntp_fp ntpfp;
+	unsigned long longpad[3];
+};
+
+struct pps_info {
+	unsigned long assert_sequence;	/* seq. num. of assert event */
+	unsigned long clear_sequence;	/* seq. num. of clear event */
+	union pps_timeu assert_tu;	/* time of assert event */
+	union pps_timeu clear_tu;	/* time of clear event */
+	int current_mode;		/* current mode bits */
+};
+
+struct pps_params {
+	int api_version;		/* API version # */
+	int mode;			/* mode bits */
+	union pps_timeu assert_off_tu;	/* offset compensation for assert */
+	union pps_timeu clear_off_tu;	/* offset compensation for clear */
+};
+
 typedef int pps_handle_t;		/* represents a PPS source */
 typedef unsigned long pps_seq_t;	/* sequence number */
 typedef struct ntp_fp ntp_fp_t;		/* NTP-compatible time stamp */
@@ -86,7 +112,6 @@ void time_pps_readlink(char *link, int linklen, char *path, int pathlen)
 
 	/* Return the file name where "link" points to */
 	path[i] = '\0';
-	return;
 }
 
 #define PPS_HAVE_FINDPATH	1
@@ -108,8 +133,10 @@ int time_pps_findpath(char *path, int pathlen, char *idstring, int idlen)
 
 int time_pps_create(int source, pps_handle_t *handle)
 {
-	if (!handle)
-		return -EINVAL;
+	if (!handle) {
+		errno = -EINVAL;
+		return -1;
+	}
 
 	/* In LinuxPPS there are no differences between a PPS source and
 	 * a PPS handle so we return the same value. */
@@ -128,12 +155,33 @@ int time_pps_destroy(pps_handle_t handle)
 int time_pps_getparams(pps_handle_t handle,
 				pps_params_t *ppsparams)
 {
-	return syscall(__NR_time_pps_getparams, handle, ppsparams);
+	int ret;
+	struct pps_kparams __ppsparams;
+
+	ret = syscall(__NR_time_pps_getparams, handle, &__ppsparams);
+
+	ppsparams->api_version = __ppsparams.api_version;
+	ppsparams->mode = __ppsparams.mode;
+	ppsparams->assert_off_tu.tspec.tv_sec = __ppsparams.assert_off_tu.sec;
+	ppsparams->assert_off_tu.tspec.tv_nsec = __ppsparams.assert_off_tu.nsec;
+	ppsparams->clear_off_tu.tspec.tv_sec = __ppsparams.clear_off_tu.sec;
+	ppsparams->clear_off_tu.tspec.tv_nsec = __ppsparams.clear_off_tu.nsec;
+
+	return ret;
 }
 
 int time_pps_setparams(pps_handle_t handle,
 				const pps_params_t *ppsparams)
 {
+	struct pps_kparams __ppsparams;
+
+	__ppsparams.api_version = ppsparams->api_version;
+	__ppsparams.mode = ppsparams->mode;
+	__ppsparams.assert_off_tu.sec = ppsparams->assert_off_tu.tspec.tv_sec;
+	__ppsparams.assert_off_tu.nsec = ppsparams->assert_off_tu.tspec.tv_nsec;
+	__ppsparams.clear_off_tu.sec = ppsparams->clear_off_tu.tspec.tv_sec;
+	__ppsparams.clear_off_tu.nsec = ppsparams->clear_off_tu.tspec.tv_nsec;
+
 	return syscall(__NR_time_pps_getparams, handle, ppsparams);
 }
 
@@ -147,15 +195,41 @@ int time_pps_fetch(pps_handle_t handle, const int tsformat,
 				pps_info_t *ppsinfobuf,
 				const struct timespec *timeout)
 {
-	return syscall(__NR_time_pps_fetch, handle,
-				tsformat, ppsinfobuf, timeout);
+	struct pps_kinfo __ppsinfobuf;
+	struct pps_ktime __timeout;
+	int ret;
+
+	/* Sanity checks */
+	if (tsformat != PPS_TSFMT_TSPEC) {
+		errno = -EINVAL;
+		return -1;
+	}
+
+	if (timeout) {
+		__timeout.sec = timeout->tv_sec;
+		__timeout.nsec = timeout->tv_nsec;
+	}
+
+	ret = syscall(__NR_time_pps_fetch, handle, &__ppsinfobuf,
+			timeout ? &__timeout : NULL);
+
+	ppsinfobuf->assert_sequence = __ppsinfobuf.assert_sequence;
+	ppsinfobuf->clear_sequence = __ppsinfobuf.clear_sequence;
+	ppsinfobuf->assert_tu.tspec.tv_sec = __ppsinfobuf.assert_tu.sec;
+	ppsinfobuf->assert_tu.tspec.tv_nsec = __ppsinfobuf.assert_tu.nsec;
+	ppsinfobuf->clear_tu.tspec.tv_sec = __ppsinfobuf.clear_tu.sec;
+	ppsinfobuf->clear_tu.tspec.tv_nsec = __ppsinfobuf.clear_tu.nsec;
+	ppsinfobuf->current_mode = __ppsinfobuf.current_mode;
+
+	return ret;
 }
 
 int time_pps_kcbind(pps_handle_t handle, const int kernel_consumer,
 				const int edge, const int tsformat)
 {
 	/* LinuxPPS doesn't implement kernel consumer feature */
-	return -EOPNOTSUPP;
+	errno = -EOPNOTSUPP;
+	return -1;
 }
 
 #endif   /* _SYS_TIMEPPS_H_ */
diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index dd24c31..b6ad93e 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -31,17 +31,17 @@
  * Local functions
  */
 
-static void pps_add_offset(struct timespec *ts, struct timespec *offset)
+static void pps_add_offset(struct pps_ktime *ts, struct pps_ktime *offset)
 {
-	ts->tv_nsec += offset->tv_nsec;
-	if (ts->tv_nsec >= NSEC_PER_SEC) {
-		ts->tv_nsec -= NSEC_PER_SEC;
-		ts->tv_sec++;
-	} else if (ts->tv_nsec < 0) {
-		ts->tv_nsec += NSEC_PER_SEC;
-		ts->tv_sec--;
+	ts->nsec += offset->nsec;
+	if (ts->nsec >= NSEC_PER_SEC) {
+		ts->nsec -= NSEC_PER_SEC;
+		ts->sec++;
+	} else if (ts->nsec < 0) {
+		ts->nsec += NSEC_PER_SEC;
+		ts->sec--;
 	}
-	ts->tv_sec += offset->tv_sec;
+	ts->sec += offset->sec;
 }
 
 /*
@@ -87,7 +87,7 @@ static int __pps_register_source(struct pps_source_info_s *info,
 	/* Allocate the PPS source.
 	 *
 	 * Note that we should reset all fields BUT "info" one! */
-	memset(&(pps_source[i].params), 0, sizeof(struct pps_params));
+	memset(&(pps_source[i].params), 0, sizeof(struct pps_kparams));
 	pps_source[i].params.api_version = PPS_API_VERS;
 	pps_source[i].params.mode = default_params;
 	pps_source[i].assert_sequence = 0;
@@ -155,10 +155,15 @@ EXPORT_SYMBOL(pps_unregister_source);
 
 void pps_event(int source, int event, void *data)
 {
-	struct timespec ts;
+	struct timespec __ts;
+	struct pps_ktime ts;
 
 	/* First of all we get the time stamp... */
-	getnstimeofday(&ts);
+	getnstimeofday(&__ts);
+
+	/* ... and translate it to PPS time data struct */
+	ts.sec = __ts.tv_sec;
+	ts.nsec = __ts.tv_nsec;
 
 	if ((event & (PPS_CAPTUREASSERT|PPS_CAPTURECLEAR)) == 0 ) {
 		pps_err("unknow event (%x) for source %d", event, source);
@@ -175,24 +180,24 @@ void pps_event(int source, int event, void *data)
 		/* We have to add an offset? */
 		if (pps_source[source].params.mode&PPS_OFFSETASSERT)
 			pps_add_offset(&ts,
-				&pps_source[source].params.assert_off_tu.tspec);
+				&pps_source[source].params.assert_off_tu);
 
 		/* Save the time stamp */
-		pps_source[source].assert_tu.tspec = ts;
+		pps_source[source].assert_tu = ts;
 		pps_source[source].assert_sequence++;
-		pps_dbg("capture assert seq #%lu for source %d", 
+		pps_dbg("capture assert seq #%u for source %d", 
 			pps_source[source].assert_sequence, source);
 	}
 	if (event & PPS_CAPTURECLEAR) {
 		/* We have to add an offset? */
 		if (pps_source[source].params.mode&PPS_OFFSETCLEAR)
 			pps_add_offset(&ts,
-				&pps_source[source].params.clear_off_tu.tspec);
+				&pps_source[source].params.clear_off_tu);
 
 		/* Save the time stamp */
-		pps_source[source].clear_tu.tspec = ts;
+		pps_source[source].clear_tu = ts;
 		pps_source[source].clear_sequence++;
-		pps_dbg("capture clear seq #%lu for source %d", 
+		pps_dbg("capture clear seq #%u for source %d", 
 			pps_source[source].clear_sequence, source);
 	}
 
diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 428c3b7..6f56931 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -168,7 +168,7 @@ sys_time_pps_cmd_exit:
 }
 
 asmlinkage long sys_time_pps_getparams(int source,
-					struct pps_params __user *params)
+					struct pps_kparams __user *params)
 {
 	int ret = 0;
 
@@ -189,7 +189,7 @@ asmlinkage long sys_time_pps_getparams(int source,
 
 	/* Return current parameters */
 	ret = copy_to_user(params, &pps_source[source].params,
-						sizeof(struct pps_params));
+						sizeof(struct pps_kparams));
 	if (ret)
 		ret = -EFAULT;
 
@@ -200,7 +200,7 @@ sys_time_pps_getparams_exit:
 }
 
 asmlinkage long sys_time_pps_setparams(int source,
-					const struct pps_params __user *params)
+					const struct pps_kparams __user *params)
 {
 	int ret;
 
@@ -233,7 +233,7 @@ asmlinkage long sys_time_pps_setparams(int source,
 
 	/* Save the new parameters */
 	ret = copy_from_user(&pps_source[source].params, params,
-						sizeof(struct pps_params));
+						sizeof(struct pps_kparams));
 	if (ret) {
 		ret = -EFAULT;
 		goto sys_time_pps_setparams_exit;
@@ -282,22 +282,16 @@ sys_time_pps_getcap_exit:
 	return ret;
 }
 
-asmlinkage long sys_time_pps_fetch(int source, const int tsformat,
-					struct pps_info __user *info, 
-					const struct timespec __user *timeout)
+asmlinkage long sys_time_pps_fetch(int source, struct pps_kinfo __user *info, 
+					const struct pps_ktime __user *timeout)
 {
 	unsigned long ticks;
-	struct pps_info pi;
-	struct timespec to;
+	struct pps_kinfo pi;
+	struct pps_ktime to;
 	int ret;
 
 	pps_dbg("%s: source %d", __FUNCTION__, source);
 
-	/* Sanity checks */
-	if (tsformat != PPS_TSFMT_TSPEC) {
-		pps_dbg("unsupported time format");
-		return -EINVAL;
- 	}
 	if (!info)
 		return -EINVAL;
 
@@ -314,15 +308,15 @@ asmlinkage long sys_time_pps_fetch(int source, const int tsformat,
 
  	/* Manage the timeout */
 	if (timeout) {
-		ret = copy_from_user(&to, timeout, sizeof(struct timespec));
+		ret = copy_from_user(&to, timeout, sizeof(struct pps_ktime));
 		if (ret) {
 			goto sys_time_pps_fetch_exit;
 			ret = -EFAULT;
 		}
-		if (to.tv_sec != -1) {
-			pps_dbg("timeout %ld.%09ld", to.tv_sec, to.tv_nsec);
-			ticks = to.tv_sec * HZ;
-			ticks += to.tv_nsec / (NSEC_PER_SEC / HZ);
+		if (to.sec != -1) {
+			pps_dbg("timeout %d.%09d", to.sec, to.nsec);
+			ticks = to.sec * HZ;
+			ticks += to.nsec / (NSEC_PER_SEC / HZ);
 
 			if (ticks != 0) {
 				ret = wait_event_interruptible_timeout(
@@ -352,7 +346,7 @@ asmlinkage long sys_time_pps_fetch(int source, const int tsformat,
 	pi.assert_tu = pps_source[source].assert_tu;
 	pi.clear_tu = pps_source[source].clear_tu;
 	pi.current_mode = pps_source[source].current_mode;
-	ret = copy_to_user(info, &pi, sizeof(struct pps_info));
+	ret = copy_to_user(info, &pi, sizeof(struct pps_kinfo));
 	if (ret)
 		ret = -EFAULT;
 
diff --git a/drivers/pps/sysfs.c b/drivers/pps/sysfs.c
index 0dae24b..46d7b7f 100644
--- a/drivers/pps/sysfs.c
+++ b/drivers/pps/sysfs.c
@@ -34,9 +34,8 @@ static ssize_t pps_show_assert(struct class_device *cdev, char *buf)
 {
 	struct pps_s *dev = class_get_devdata(cdev);
 
-	return sprintf(buf, "%ld.%09ld#%ld\n",
-			dev->assert_tu.tspec.tv_sec,
-			dev->assert_tu.tspec.tv_nsec,
+	return sprintf(buf, "%d.%09d#%d\n",
+			dev->assert_tu.sec, dev->assert_tu.nsec,
 			dev->assert_sequence);
 }
 
@@ -44,9 +43,8 @@ static ssize_t pps_show_clear(struct class_device *cdev, char *buf)
 {
 	struct pps_s *dev = class_get_devdata(cdev);
 
-	return sprintf(buf, "%ld.%09ld#%ld\n",
-			dev->clear_tu.tspec.tv_sec,
-			dev->clear_tu.tspec.tv_nsec,
+	return sprintf(buf, "%d.%09d#%d\n",
+			dev->clear_tu.sec, dev->clear_tu.nsec,
 			dev->clear_sequence);
 }
 
diff --git a/include/linux/pps.h b/include/linux/pps.h
index 9e3af51..001b8bf 100644
--- a/include/linux/pps.h
+++ b/include/linux/pps.h
@@ -44,30 +44,24 @@
 
 #define PPS_MAX_NAME_LEN	32
 
-struct ntp_fp {
-	unsigned int integral;
-	unsigned int fractional;
+struct pps_ktime {
+	__u32 sec;
+	__u32 nsec;
 };
 
-union pps_timeu {
-	struct timespec tspec;
-	struct ntp_fp ntpfp;
-	unsigned long longpad[3];
-};
-
-struct pps_info {
-	unsigned long assert_sequence;	/* seq. num. of assert event */
-	unsigned long clear_sequence; 	/* seq. num. of clear event */
-	union pps_timeu assert_tu;	/* time of assert event */
-	union pps_timeu clear_tu;	/* time of clear event */
+struct pps_kinfo {
+	__u32 assert_sequence;		/* seq. num. of assert event */
+	__u32 clear_sequence; 		/* seq. num. of clear event */
+	struct pps_ktime assert_tu;	/* time of assert event */
+	struct pps_ktime clear_tu;	/* time of clear event */
 	int current_mode;		/* current mode bits */
 };
 
-struct pps_params {
+struct pps_kparams {
 	int api_version;		/* API version # */
 	int mode;			/* mode bits */
-	union pps_timeu assert_off_tu;	/* offset compensation for assert */
-	union pps_timeu clear_off_tu;	/* offset compensation for clear */
+	struct pps_ktime assert_off_tu;	/* offset compensation for assert */
+	struct pps_ktime clear_off_tu;	/* offset compensation for clear */
 };
 
 /*
@@ -162,12 +156,12 @@ struct pps_source_info_s {
 struct pps_s {
 	struct pps_source_info_s *info;		/* PSS source info */
 
-	struct pps_params params;		/* PPS's current params */
+	struct pps_kparams params;		/* PPS's current params */
 
-	volatile unsigned long assert_sequence;	/* PPS' assert event seq # */
-	volatile unsigned long clear_sequence;	/* PPS' clear event seq # */
-	volatile union pps_timeu assert_tu;
-	volatile union pps_timeu clear_tu;
+	volatile uint32_t assert_sequence;	/* PPS' assert event seq # */
+	volatile uint32_t clear_sequence;	/* PPS' clear event seq # */
+	volatile struct pps_ktime assert_tu;
+	volatile struct pps_ktime clear_tu;
 	int current_mode;			/* PPS mode at event time */
 
 	int go;					/* PPS event is arrived? */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 853a21e..bfc8899 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -614,13 +614,12 @@ asmlinkage long sys_eventfd(unsigned int count);
 
 asmlinkage long sys_time_pps_cmd(int cmd, void __user *arg);
 asmlinkage long sys_time_pps_getparams(int source,
-					struct pps_params __user *params);
+				       struct pps_kparams __user *params);
 asmlinkage long sys_time_pps_setparams(int source,
-					const struct pps_params __user *params);
+				       const struct pps_kparams __user *params);
 asmlinkage long sys_time_pps_getcap(int source, int __user *mode);
-asmlinkage long sys_time_pps_fetch(int source, const int tsformat,
-					struct pps_info __user *info,
-					const struct timespec __user *timeout);
+asmlinkage long sys_time_pps_fetch(int source, struct pps_kinfo __user *info,
+				       const struct pps_ktime __user *timeout);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 

--ZGiS0Q5IWpPtfppv--
