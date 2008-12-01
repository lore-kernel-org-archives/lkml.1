Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYLAVfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYLAVfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 16:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbYLAVfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 16:35:03 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53734 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751059AbYLAVfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:35:00 -0500
Date: Mon, 1 Dec 2008 22:34:58 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: linux-man@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ulrich Drepper <drepper@redhat.com>
Subject: man page for robust mutexes
Message-ID: <20081201213458.GA18973@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robust mutexes are available since a few days, so here is a man page for
them. I used pthread_mutexattr_setprotocol.3p as a template and sneaked a
few phrases from there. That's my first man-page however, so some things
might be wrong :)

Sebastian
--- /dev/null
+++ b/man3p/pthread_mutexattr_setrobust_np.3p
@@ -0,0 +1,240 @@
+.\" Copyright (c) 2008 Sebastian Andrzej Siewior
+.TH "ROBUST MUTEXES" P 2008 "" "POSIX Programmer's Manual"
+.\" pthread_mutexattr_setrobust_np
+.SH NAME
+pthread_mutexattr_setrobust_np, pthread_mutexattr_getrobust_np \- set or get
+the robustness of a mutex
+.SH SYNOPSIS
+.LP
+\fB#include <pthread.h>
+.br
+.sp
+#define __USE_GNU
+.sp
+int pthread_mutexattr_getrobust_np(pthread_mutexattr_t *\fP\fIattr\fP\fB, int
+\fP\fIrobustness\fP\fB);
+.br
+int pthread_mutexattr_setrobust_np(pthread_mutexattr_t *\fP\fIattr\fP\fB, int
+\fP\fIrobustness\fP\fB);
+.br
+int pthread_mutex_consistent_np(pthread_mutex_t *\fP\fImutex\fP\fB);
+\fP
+\fB
+.br
+\fP
+.SH DESCRIPTION
+.LP
+The \fIpthread_mutexattr_getrobust_np\fP() and
+\fIpthread_mutexattr_setrobust_np\fP() functions, respectively, shall get and
+set the robustness attribute of a mutex attributes object pointed to by
+\fIattr\fP which was previously created by the function
+\fIpthread_mutexattr_init\fP().
+.LP
+The \fIrobustness\fP attribute defines the robustness to be used in utilizing
+mutexes. The value of \fIrobustness\fP may be one of:
+.LP
+.sp
+PTHREAD_MUTEX_STALLED_NP
+.br
+.sp
+PTHREAD_MUTEX_ROBUST_NP
+.br
+.sp
+.LP
+which are defined in the \fI<pthread.h>\fP header if the GNU extensions are
+used.
+.LP
+The default attribute is PTHREAD_MUTEX_STALLED_NP.
+.LP
+When a mutex is created with PTHREAD_MUTEX_STALLED_NP is locked and the owner
+dies, then the next call to pthread_mutex_lock() will block forever. Also,
+the already waiting waiters will wait for ever.
+.LP
+The behavior is different if the mutex is created with
+PTHREAD_MUTEX_ROBUST_NP. If the owner dies while holding the lock, the
+next call to \fIpthread_mutex_lock\fP() will return EOWNERDEAD and the caller
+will acquire lock. The new owner should call
+\fIpthread_mutex_consistent_np\fP() on the mutex once the internal state of
+the protected variables are consistent again. If this is not done, future
+calls to pthread_mutex_lock() will continue to return EOWNERDEAD (although
+locking will function correctly).
+.SH RETURN VALUE
+.LP
+Upon successful completion, \fIpthread_mutexattr_setrobust_np\fP(),
+\fIpthread_mutexattr_getrobust_np\fP() and
+\fIpthread_mutex_consistent_np\fP()shall return zero; otherwise,
+an error number shall be returned to indicate the error.
+.SH ERRORS
+.LP
+The \fIpthread_mutexattr_destroy\fP() function may fail if:
+.TP 7
+.B EINVAL
+The value specified by \fIrobustness\fP is invalid.
+.LP
+The \fIpthread_mutex_consistent_np\fp() function may fail if:
+.TP 7
+.B EINVAL
+The mutex specified by \fImutex\fP is either not PTHREAD_MUTEX_ROBUST_NP or is
+in consistent state.
+\fIThe following sections are informative.\fP
+.SH EXAMPLES
+.LP
+The robost mutexes could be used to share a common lock accross multiple
+process and avoid IPC communication. Here is an example:
+.sp
+.RS
+.nf
+\fB
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <errno.h>
+
+#define __USE_GNU
+#include <pthread.h>
+
+static const char *lock_name = "/dev/shm/limi_lock";
+static int lock_fd;
+static void *limi_ressource;
+static pthread_mutex_t *limi_mutex;
+
+.sp
+
+static int open_existing_lock(void)
+{
+	int fd;
+	int ret;
+	struct stat buf;
+	int retry = 5;
+
+	fd = open(lock_name, O_RDWR);
+	if (fd < 0)
+		return fd;
+	do {
+
+		ret = fstat(fd, &buf);
+		if (ret < 0)
+			return ret;
+
+		if (buf.st_size == sizeof(*limi_mutex))
+			return fd;
+
+		sleep(1);
+		retry--;
+	} while (retry);
+
+	close(fd);
+	return -1;
+}
+
+.sp
+
+static int create_new_lock(void)
+{
+	int fd;
+	pthread_mutex_t cmutex = PTHREAD_MUTEX_INITIALIZER;
+	pthread_mutexattr_t attr;
+	int ret;
+
+	pthread_mutexattr_init(&attr);
+	pthread_mutexattr_setrobust_np(&attr, PTHREAD_MUTEX_ROBUST_NP);
+	pthread_mutex_init(&cmutex, &attr);
+
+	fd = open(lock_name, O_RDWR | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR |
+			S_IRGRP | S_IWGRP);
+	if (fd < 0)
+		return fd;
+
+	ret = write(fd, &cmutex, sizeof(cmutex));
+	if (ret < 0) {
+		fprintf(stderr, "Write to %s failed: %s\n",
+				lock_name, strerror(errno));
+		exit(1);
+	}
+	return fd;
+}
+
+.sp
+
+void limi_lock_init(void)
+{
+	lock_fd = open_existing_lock();
+	if (lock_fd < 0) {
+		lock_fd = create_new_lock();
+		if (lock_fd < 0) {
+			lock_fd = open_existing_lock();
+			if (lock_fd < 0) {
+				fprintf(stderr, "Can't open %s: %s\n",
+						lock_name, strerror(errno));
+				exit(1);
+			}
+		}
+	}
+
+	limi_lock_mmap = mmap(NULL, sizeof(*limi_mutex),
+			PROT_READ | PROT_WRITE, MAP_SHARED, lock_fd, 0);
+
+	if (limi_lock_mmap == MAP_FAILED) {
+		fprintf(stderr, "failed to mmap limi lock: %s\n",
+				strerror(errno));
+		exit(1);
+	}
+	limi_mutex = limi_lock_mmap;
+}
+
+.sp
+
+void limi_lock(void)
+{
+	int ret;
+
+	ret = pthread_mutex_lock(limi_mutex);
+	if (!ret)
+		return;
+
+	if (ret == EOWNERDEAD) {
+		pthread_mutex_consistent_np(limi_mutex);
+		return;
+	}
+
+	fprintf(stderr, "Can not grab lock: %s\n", strerror(ret));
+	exit(1);
+}
+
+.sp
+
+void limi_unlock(void)
+{
+	int ret;
+
+	ret = pthread_mutex_unlock(limi_mutex);
+	if (!ret)
+		return;
+
+	fprintf(stderr, "Can not unlock: %s\n", strerror(ret));
+	exit(1);
+}
+
+\fP
+.fi
+.RE
+.LP
+The code example shows how to share a lock between two applications without
+classic IPC. If one of the applications dies while holding the lock or the
+system reboots unexpectly, the new owner of lock marks the lock state
+consistent. In this example the lock owner does not need to perform any
+validation of the resource protected by the lock. The lock owner knows if
+the previous owner unlocked successfully or died.
+.f
+.SH SEE ALSO
+.LP
+\fIpthread_mutex_create\fP(), \fIpthread_mutex_destroy\fP(),
+\fIpthread_mutexattr_init\fP(), \fIpthread_mutexattr_destroy\fP(),
+\fIpthread_mutex_lock\fP(), \fIpthread_mutex_unlock\fP(), \fI<pthread.h>\fP
+.SH COPYRIGHT
+This man page was contributed by Sebastian Andrzej Siewior.
