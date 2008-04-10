Return-Path: <linux-kernel-owner+w=401wt.eu-S1759229AbYDJSXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229AbYDJSXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 14:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757471AbYDJSWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 14:22:45 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:50009 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344AbYDJSWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 14:22:43 -0400
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rodolfo Giometti <giometti@linux.it>
Date: Thu, 10 Apr 2008 20:22:26 +0200
Message-Id: <1207851751-25703-3-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1207851751-25703-2-git-send-email-giometti@linux.it>
References: <20080410160630.GA24885@enneenne.com>
 <1207851751-25703-1-git-send-email-giometti@linux.it>
 <1207851751-25703-2-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 2/7] PPS: userland header file for PPS API.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds into the PPS's documentation directory a possible
implementation of the PPS API (RFC 2783) by using the LinuxPPS's char
devices.

This file is not just an example but it can be used into real
systems. :)

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 Documentation/pps/timepps.h |  195 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 195 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/pps/timepps.h

diff --git a/Documentation/pps/timepps.h b/Documentation/pps/timepps.h
new file mode 100644
index 0000000..2372949
--- /dev/null
+++ b/Documentation/pps/timepps.h
@@ -0,0 +1,195 @@
+/*
+ * timepps.h -- PPS API main header
+ *
+ * Copyright (C) 2005-2007   Rodolfo Giometti <giometti@linux.it>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _SYS_TIMEPPS_H_
+#define _SYS_TIMEPPS_H_
+
+#include <sys/syscall.h>
+#include <unistd.h>
+#include <errno.h>
+#include <linux/pps.h>
+
+#define LINUXPPS	1		/* signal we are using LinuxPPS */
+
+/*
+ * New data structures
+ */
+
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
+typedef int pps_handle_t;		/* represents a PPS source */
+typedef unsigned long pps_seq_t;	/* sequence number */
+typedef struct ntp_fp ntp_fp_t;		/* NTP-compatible time stamp */
+typedef union pps_timeu pps_timeu_t;	/* generic data type for time stamps */
+typedef struct pps_info pps_info_t;
+typedef struct pps_params pps_params_t;
+
+#define assert_timestamp        assert_tu.tspec
+#define clear_timestamp         clear_tu.tspec
+
+#define assert_timestamp_ntpfp  assert_tu.ntpfp
+#define clear_timestamp_ntpfp   clear_tu.ntpfp
+
+#define assert_offset		assert_off_tu.tspec
+#define clear_offset		clear_off_tu.tspec
+
+#define assert_offset_ntpfp     assert_off_tu.ntpfp
+#define clear_offset_ntpfp      clear_off_tu.ntpfp
+
+/*
+ * The PPS API
+ */
+
+static __inline int time_pps_create(int source, pps_handle_t *handle)
+{
+	int ret;
+
+	if (!handle) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	/* First we check if current device is a PPS valid PPS one...
+	 */
+	ret = ioctl(source, PPS_CHECK);
+	if (ret) {
+		errno = EOPNOTSUPP;
+		return -1;
+	}
+
+	/* ... then since in LinuxPPS there are no differences between a
+	 * "PPS source" and a "PPS handle", we simply return the same value.
+	 */
+	*handle = source;
+
+	return 0;
+}
+
+static __inline int time_pps_destroy(pps_handle_t handle)
+{
+	return close(handle);
+}
+
+static __inline int time_pps_getparams(pps_handle_t handle,
+					pps_params_t *ppsparams)
+{
+	int ret;
+	struct pps_kparams __ppsparams;
+
+	ret = ioctl(handle, PPS_GETPARAMS, &__ppsparams);
+
+	ppsparams->api_version = __ppsparams.api_version;
+	ppsparams->mode = __ppsparams.mode;
+	ppsparams->assert_off_tu.tspec.tv_sec = __ppsparams.assert_off_tu.sec;
+	ppsparams->assert_off_tu.tspec.tv_nsec = __ppsparams.assert_off_tu.nsec;
+	ppsparams->clear_off_tu.tspec.tv_sec = __ppsparams.clear_off_tu.sec;
+	ppsparams->clear_off_tu.tspec.tv_nsec = __ppsparams.clear_off_tu.nsec;
+
+	return ret;
+}
+
+static __inline int time_pps_setparams(pps_handle_t handle,
+					const pps_params_t *ppsparams)
+{
+	struct pps_kparams __ppsparams;
+
+	__ppsparams.api_version = ppsparams->api_version;
+	__ppsparams.mode = ppsparams->mode;
+	__ppsparams.assert_off_tu.sec = ppsparams->assert_off_tu.tspec.tv_sec;
+	__ppsparams.assert_off_tu.nsec = ppsparams->assert_off_tu.tspec.tv_nsec;
+	__ppsparams.clear_off_tu.sec = ppsparams->clear_off_tu.tspec.tv_sec;
+	__ppsparams.clear_off_tu.nsec = ppsparams->clear_off_tu.tspec.tv_nsec;
+
+	return ioctl(handle, PPS_SETPARAMS, &__ppsparams);
+}
+
+/* Get capabilities for handle */
+static __inline int time_pps_getcap(pps_handle_t handle, int *mode)
+{
+	return ioctl(handle, PPS_GETCAP, mode);
+}
+
+static __inline int time_pps_fetch(pps_handle_t handle, const int tsformat,
+					pps_info_t *ppsinfobuf,
+					const struct timespec *timeout)
+{
+	struct pps_fdata __fdata;
+	int ret;
+
+	/* Sanity checks */
+	if (tsformat != PPS_TSFMT_TSPEC) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	if (timeout) {
+		__fdata.timeout.sec = timeout->tv_sec;
+		__fdata.timeout.nsec = timeout->tv_nsec;
+		__fdata.timeout.flags = ~PPS_TIME_INVALID;
+	} else
+		__fdata.timeout.flags = PPS_TIME_INVALID;
+
+	ret = ioctl(handle, PPS_FETCH, &__fdata);
+
+	ppsinfobuf->assert_sequence = __fdata.info.assert_sequence;
+	ppsinfobuf->clear_sequence = __fdata.info.clear_sequence;
+	ppsinfobuf->assert_tu.tspec.tv_sec = __fdata.info.assert_tu.sec;
+	ppsinfobuf->assert_tu.tspec.tv_nsec = __fdata.info.assert_tu.nsec;
+	ppsinfobuf->clear_tu.tspec.tv_sec = __fdata.info.clear_tu.sec;
+	ppsinfobuf->clear_tu.tspec.tv_nsec = __fdata.info.clear_tu.nsec;
+	ppsinfobuf->current_mode = __fdata.info.current_mode;
+
+	return ret;
+}
+
+static __inline int time_pps_kcbind(pps_handle_t handle,
+					const int kernel_consumer,
+					const int edge, const int tsformat)
+{
+	/* LinuxPPS doesn't implement kernel consumer feature */
+	errno = EOPNOTSUPP;
+	return -1;
+}
+
+#endif				/* _SYS_TIMEPPS_H_ */
-- 
1.5.4.3

