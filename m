Return-Path: <linux-kernel-owner+w=401wt.eu-S1761901AbYDKROm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761901AbYDKROm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 13:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761102AbYDKROJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 13:14:09 -0400
Received: from keg.few.vu.nl ([130.37.24.4]:46264 "EHLO keg.few.vu.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761048AbYDKROG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 13:14:06 -0400
Date: Fri, 11 Apr 2008 18:57:22 +0200 (CEST)
From: Erik Bosman <ebn310@few.vu.nl>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Add tests for prctl PR_GET_TSC and PR_SET_TSC
Message-ID: <Pine.GSO.4.56.0804111856370.16676@keg.few.vu.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


    This patch adds three tests that test whether the PR_GET_TSC and
    PR_SET_TSC commands have the desirable effect.

    The tests check whether the control register is updated correctly
    at context switches and try to discover bugs while enabling/disabling
    the timestamp counter.

	Signed-off-by: Erik Bosman <ejbosman@cs.vu.nl>
---
 .../prctl/disable-tsc-ctxt-sw-stress-test.c        |   96 ++++++++++++++++++++
 .../prctl/disable-tsc-on-off-stress-test.c         |   95 +++++++++++++++++++
 Documentation/prctl/disable-tsc-test.c             |   94 +++++++++++++++++++
 3 files changed, 285 insertions(+), 0 deletions(-)

diff --git a/Documentation/prctl/disable-tsc-ctxt-sw-stress-test.c b/Documentation/prctl/disable-tsc-ctxt-sw-stress-test.c
new file mode 100644
index 0000000..83f4564
--- /dev/null
+++ b/Documentation/prctl/disable-tsc-ctxt-sw-stress-test.c
@@ -0,0 +1,96 @@
+/*
+ * Tests for prctl(PR_GET_TSC, ...) / prctl(PR_SET_TSC, ...)
+ *
+ * Tests if the control register is updated correctly
+ * at context switches
+ *
+ * Warning: this test will cause a very high load for a few seconds
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <signal.h>
+#include <inttypes.h>
+#include <wait.h>
+
+
+#include <sys/prctl.h>
+#include <linux/prctl.h>
+
+/* Get/set the process' ability to use the timestamp counter instruction */
+#ifndef PR_GET_TSC
+#define PR_GET_TSC 25
+#define PR_SET_TSC 26
+# define PR_TSC_ENABLE		1   /* allow the use of the timestamp counter */
+# define PR_TSC_SIGSEGV		2   /* throw a SIGSEGV instead of reading the TSC */
+#endif
+
+uint64_t rdtsc() {
+uint32_t lo, hi;
+/* We cannot use "=A", since this would use %rax on x86_64 */
+__asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
+return (uint64_t)hi << 32 | lo;
+}
+
+void sigsegv_expect(int sig)
+{
+	/* */
+}
+
+void segvtask(void)
+{
+	if (prctl(PR_SET_TSC, PR_TSC_SIGSEGV) < 0)
+	{
+		perror("prctl");
+		exit(0);
+	}
+	signal(SIGSEGV, sigsegv_expect);
+	alarm(10);
+	rdtsc();
+	fprintf(stderr, "FATAL ERROR, rdtsc() succeeded while disabled\n");
+	exit(0);
+}
+
+
+void sigsegv_fail(int sig)
+{
+	fprintf(stderr, "FATAL ERROR, rdtsc() failed while enabled\n");
+	exit(0);
+}
+
+void rdtsctask(void)
+{
+	if (prctl(PR_SET_TSC, PR_TSC_ENABLE) < 0)
+	{
+		perror("prctl");
+		exit(0);
+	}
+	signal(SIGSEGV, sigsegv_fail);
+	alarm(10);
+	for(;;) rdtsc();
+}
+
+
+int main(int argc, char **argv)
+{
+	int n_tasks = 100, i;
+
+	fprintf(stderr, "[No further output means we're allright]\n");
+
+	for (i=0; i<n_tasks; i++)
+		if (fork() == 0)
+		{
+			if (i & 1)
+				segvtask();
+			else
+				rdtsctask();
+		}
+
+	for (i=0; i<n_tasks; i++)
+		wait(NULL);
+
+	exit(0);
+}
+
diff --git a/Documentation/prctl/disable-tsc-on-off-stress-test.c b/Documentation/prctl/disable-tsc-on-off-stress-test.c
new file mode 100644
index 0000000..5d1d055
--- /dev/null
+++ b/Documentation/prctl/disable-tsc-on-off-stress-test.c
@@ -0,0 +1,95 @@
+/*
+ * Tests for prctl(PR_GET_TSC, ...) / prctl(PR_SET_TSC, ...)
+ *
+ * Tests if the control register is updated correctly
+ * when set with prctl()
+ *
+ * Warning: this test will cause a very high load for a few seconds
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <signal.h>
+#include <inttypes.h>
+#include <wait.h>
+
+
+#include <sys/prctl.h>
+#include <linux/prctl.h>
+
+/* Get/set the process' ability to use the timestamp counter instruction */
+#ifndef PR_GET_TSC
+#define PR_GET_TSC 25
+#define PR_SET_TSC 26
+# define PR_TSC_ENABLE		1   /* allow the use of the timestamp counter */
+# define PR_TSC_SIGSEGV		2   /* throw a SIGSEGV instead of reading the TSC */
+#endif
+
+/* snippet from wikipedia :-) */
+
+uint64_t rdtsc() {
+uint32_t lo, hi;
+/* We cannot use "=A", since this would use %rax on x86_64 */
+__asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
+return (uint64_t)hi << 32 | lo;
+}
+
+int should_segv = 0;
+
+void sigsegv_cb(int sig)
+{
+	if (!should_segv)
+	{
+		fprintf(stderr, "FATAL ERROR, rdtsc() failed while enabled\n");
+		exit(0);
+	}
+	if (prctl(PR_SET_TSC, PR_TSC_ENABLE) < 0)
+	{
+		perror("prctl");
+		exit(0);
+	}
+	should_segv = 0;
+
+	rdtsc();
+}
+
+void task(void)
+{
+	signal(SIGSEGV, sigsegv_cb);
+	alarm(10);
+	for(;;)
+	{
+		rdtsc();
+		if (should_segv)
+		{
+			fprintf(stderr, "FATAL ERROR, rdtsc() succeeded while disabled\n");
+			exit(0);
+		}
+		if (prctl(PR_SET_TSC, PR_TSC_SIGSEGV) < 0)
+		{
+			perror("prctl");
+			exit(0);
+		}
+		should_segv = 1;
+	}
+}
+
+
+int main(int argc, char **argv)
+{
+	int n_tasks = 100, i;
+
+	fprintf(stderr, "[No further output means we're allright]\n");
+
+	for (i=0; i<n_tasks; i++)
+		if (fork() == 0)
+			task();
+
+	for (i=0; i<n_tasks; i++)
+		wait(NULL);
+
+	exit(0);
+}
+
diff --git a/Documentation/prctl/disable-tsc-test.c b/Documentation/prctl/disable-tsc-test.c
new file mode 100644
index 0000000..843c81e
--- /dev/null
+++ b/Documentation/prctl/disable-tsc-test.c
@@ -0,0 +1,94 @@
+/*
+ * Tests for prctl(PR_GET_TSC, ...) / prctl(PR_SET_TSC, ...)
+ *
+ * Basic test to test behaviour of PR_GET_TSC and PR_SET_TSC
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <signal.h>
+#include <inttypes.h>
+
+
+#include <sys/prctl.h>
+#include <linux/prctl.h>
+
+/* Get/set the process' ability to use the timestamp counter instruction */
+#ifndef PR_GET_TSC
+#define PR_GET_TSC 25
+#define PR_SET_TSC 26
+# define PR_TSC_ENABLE		1   /* allow the use of the timestamp counter */
+# define PR_TSC_SIGSEGV		2   /* throw a SIGSEGV instead of reading the TSC */
+#endif
+
+const char *tsc_names[] =
+{
+	[0] = "[not set]",
+	[PR_TSC_ENABLE] = "PR_TSC_ENABLE",
+	[PR_TSC_SIGSEGV] = "PR_TSC_SIGSEGV",
+};
+
+uint64_t rdtsc() {
+uint32_t lo, hi;
+/* We cannot use "=A", since this would use %rax on x86_64 */
+__asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
+return (uint64_t)hi << 32 | lo;
+}
+
+void sigsegv_cb(int sig)
+{
+	int tsc_val = 0;
+
+	printf("[ SIG_SEGV ]\n");
+	printf("prctl(PR_GET_TSC, &tsc_val); ");
+	fflush(stdout);
+
+	if ( prctl(PR_GET_TSC, &tsc_val) == -1)
+		perror("prctl");
+
+	printf("tsc_val == %s\n", tsc_names[tsc_val]);
+	printf("prctl(PR_SET_TSC, PR_TSC_ENABLE)\n");
+	fflush(stdout);
+	if ( prctl(PR_SET_TSC, PR_TSC_ENABLE) == -1)
+		perror("prctl");
+
+	printf("rdtsc() == ");
+}
+
+int main(int argc, char **argv)
+{
+	int tsc_val = 0;
+
+	signal(SIGSEGV, sigsegv_cb);
+
+	printf("rdtsc() == %llu\n", (unsigned long long)rdtsc());
+	printf("prctl(PR_GET_TSC, &tsc_val); ");
+	fflush(stdout);
+
+	if ( prctl(PR_GET_TSC, &tsc_val) == -1)
+		perror("prctl");
+
+	printf("tsc_val == %s\n", tsc_names[tsc_val]);
+	printf("rdtsc() == %llu\n", (unsigned long long)rdtsc());
+	printf("prctl(PR_SET_TSC, PR_TSC_ENABLE)\n");
+	fflush(stdout);
+
+	if ( prctl(PR_SET_TSC, PR_TSC_ENABLE) == -1)
+		perror("prctl");
+
+	printf("rdtsc() == %llu\n", (unsigned long long)rdtsc());
+	printf("prctl(PR_SET_TSC, PR_TSC_SIGSEGV)\n");
+	fflush(stdout);
+
+	if ( prctl(PR_SET_TSC, PR_TSC_SIGSEGV) == -1)
+		perror("prctl");
+
+	printf("rdtsc() == ");
+	fflush(stdout);
+	printf("%llu\n", (unsigned long long)rdtsc());
+	fflush(stdout);
+
+	exit(EXIT_SUCCESS);
+}
+
