Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbZKAV6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbZKAV6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 16:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbZKAV6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 16:58:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548AbZKAV6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 16:58:21 -0500
Date: Sun, 1 Nov 2009 15:58:09 -0600
From: Clark Williams <williams@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] perf latency builtin command
Message-ID: <20091101155809.191a7ed6@torg>
In-Reply-To: <20091101155500.7dd22f19@torg>
References: <20091101155500.7dd22f19@torg>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qPNXmJs/NFcyY9nHBcSlDOj"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qPNXmJs/NFcyY9nHBcSlDOj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


This is the first cut at a 'perf latency' command to manage the
hwlat_detector kernel module, used to detect hardware induced
latencies (e.g. SMIs).

Signed-off-by: Clark Williams <williams@redhat.com>
---
 tools/perf/Documentation/perf-latency.txt |   64 +++++
 tools/perf/Documentation/perf.txt         |    2 +-
 tools/perf/Makefile                       |    3 +
 tools/perf/builtin-latency.c              |  383
+++++++++++++++++++++++++++++ tools/perf/builtin.h
|    2 +- tools/perf/command-list.txt               |    1 +
 6 files changed, 453 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-latency.txt
 create mode 100644 tools/perf/builtin-latency.c

diff --git a/tools/perf/Documentation/perf-latency.txt
b/tools/perf/Documentation/perf-latency.txt new file mode 100644
index 0000000..f615d08
--- /dev/null
+++ b/tools/perf/Documentation/perf-latency.txt
@@ -0,0 +1,64 @@
+perf-latency(1)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+perf-latency - check for hardware latencies
+
+SYNOPSIS
+--------
+[verse]
+'per latency' [OPTIONS]
+
+DESCRIPTION
+-----------
+This command manages the hwlat_detector kernel module, which is used
+to test the system for hardware induced latencies. The command runs
+for a specified amount of time (default: 60 seconds) and samples the
+system Time Stamp Counter (TSC) register, looking for gaps which
+exceed a threshold. If a gap exceeding the threshold is seen, a
+timestamp and the gap (in microseconds) is printed to the standard
+output.
+
+OPTIONS
+-------
+--duration=3D<n>{s,m,h,d,w}::
+	The length of time the test should run. (default: 60 seconds)
+
+--window=3D<n>{us,ms,s,m}::
+	The sample period for the test. (default 1 second)
+
+--width=3D=3D<n>{us,ms,s,m}::
+	The test time within the sample window. (default 500
+	milliseconds)
+
+--threshold=3D=3D<n>{us,ms,s}::
+	Threshold above which is considered a latency. (default
50 microseconds) +
+--cleanup::
+	Force unload of hwlat_detector module and umount of debugfs.
+
+--debug::
+	Turn on lots of debugging prints
+
+
+Time values are specified as a decimal integer value with an optional
+unit suffix
+
+        us - microseconds
+	ms - milliseconds
+	s - seconds
+	m - minutes
+	h - hours
+	d - days
+	w - weeks
+
+EXAMPLES
+--------
+
+$ perf latency --duration=3D1h --width=3D750ms --threshold=3D10us
+
+This invocation runs the latency detector for 1 hour, using the
+default window size of 1 second, a width of 750 milliseconds and a
+threshold of 10 microseconds. Any gap larger than 10 microseconds
+detected during sampling will be printed to the screen.
diff --git a/tools/perf/Documentation/perf.txt
b/tools/perf/Documentation/perf.txt index 69c8325..358856e 100644
--- a/tools/perf/Documentation/perf.txt
+++ b/tools/perf/Documentation/perf.txt
@@ -21,4 +21,4 @@ SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-top[1],
 linkperf:perf-record[1], linkperf:perf-report[1],
-linkperf:perf-list[1]
+linkperf:perf-list[1], linkperf:perf-latency[1]
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 800783d..68f210a 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -374,6 +374,7 @@ LIB_H +=3D util/sort.h
 LIB_H +=3D util/hist.h
 LIB_H +=3D util/thread.h
 LIB_H +=3D util/data_map.h
+LIB_H +=3D util/debugfs.h
=20
 LIB_OBJS +=3D util/abspath.o
 LIB_OBJS +=3D util/alias.o
@@ -415,6 +416,7 @@ LIB_OBJS +=3D util/svghelper.o
 LIB_OBJS +=3D util/sort.o
 LIB_OBJS +=3D util/hist.o
 LIB_OBJS +=3D util/data_map.o
+LIB_OBJS +=3D util/debugfs.o
=20
 BUILTIN_OBJS +=3D builtin-annotate.o
 BUILTIN_OBJS +=3D builtin-help.o
@@ -427,6 +429,7 @@ BUILTIN_OBJS +=3D builtin-timechart.o
 BUILTIN_OBJS +=3D builtin-top.o
 BUILTIN_OBJS +=3D builtin-trace.o
 BUILTIN_OBJS +=3D builtin-probe.o
+BUILTIN_OBJS +=3D builtin-latency.o
=20
 PERFLIBS =3D $(LIB_FILE)
=20
diff --git a/tools/perf/builtin-latency.c b/tools/perf/builtin-latency.c
new file mode 100644
index 0000000..7a33f71
--- /dev/null
+++ b/tools/perf/builtin-latency.c
@@ -0,0 +1,383 @@
+#include "builtin.h"
+#include "perf.h"
+
+#include "util/util.h"
+#include "util/parse-options.h"
+#include "util/debugfs.h"
+
+static struct latency_params {
+	long duration;
+	long threshold;
+	long window;
+	long width;
+	int cleanup;
+	int debugging;
+} parameters =3D {
+	.duration =3D 0,
+	.threshold =3D -1,
+	.window =3D -1,
+	.width =3D -1,
+	.cleanup =3D 0,
+	.debugging =3D 0,
+};
+
+/* strings for argument processing */
+#define DEFAULT_DURATION  "60s"  /* 60 seconds */
+
+static char *duration_str  =3D (char*)DEFAULT_DURATION;
+static char *threshold_str =3D (char*)"-1";
+static char *window_str    =3D (char*)"-1";
+static char *width_str     =3D (char*)"-1";
+
+#define SAMPLE_POLL_INTERVAL  1  /* poll for sample every second */
+#define ENABLE_RETRIES 100       /* how many times to retry
enable/disable */ +
+static int hwlat_preloaded;
+
+static void debug(const char *fmt, ...)
+{
+	if (parameters.debugging) {
+		va_list ap;
+		fputs("PERF DEBUG: ", stderr);
+		va_start(ap, fmt);
+		vfprintf(stderr, fmt, ap);
+		va_end(ap);
+	}
+}
+
+static int check_module_loaded(const char *modname)
+{
+	char line[256], module[64];
+	FILE *fp =3D fopen("/proc/modules", "r");
+	int len;
+
+	if (fp =3D=3D NULL)
+		return -errno;
+	len =3D strlen(modname);
+	while (fgets(line, sizeof(line) - 1, fp)) {
+		if (sscanf(line, "%s", module) =3D=3D EOF)
+			continue;
+		if (strncmp(module, modname, len) =3D=3D 0) {
+			fclose(fp);
+			return 0;
+		}
+	}
+	fclose(fp);
+	return -1;
+}
+
+static int
+hwlat_load_module(void)
+{
+	if (hwlat_preloaded)
+		return 0;
+	debug("loading hwlat_detector module\n");
+	if (check_module_loaded("hwlat_detector") =3D=3D 0) {
+		debug("hwlat_detector already loaded\n");
+		hwlat_preloaded =3D 1;
+		return 0;
+	}
+	return system("/sbin/modprobe hwlat_detector");
+}
+
+static int
+hwlat_unload_module(void)
+{
+	if (hwlat_preloaded)
+		return 0;
+	if (check_module_loaded("hwlat_detector"))
+		return 0;
+	return system("/sbin/modprobe -r hwlat_detector");
+}
+
+static int
+hwlat_get_value(const char *entry)
+{
+	char hwlat_entry[128];
+	char buffer[256];
+	int nread, val;
+
+	snprintf(hwlat_entry, sizeof(hwlat_entry),
"hwlat_detector/%s", entry);
+	nread =3D debugfs_read(hwlat_entry, buffer, sizeof(buffer));
+	if (nread < 0)
+		return nread;
+	val =3D strtol(buffer, NULL, 10);
+	debug("read %d from %s\n", val, hwlat_entry);
+	return val;
+}=09
+
+static int
+hwlat_put_value(const char *entry, int value)
+{
+	char hwlat_entry[128];
+	char buffer[256];
+
+	snprintf(hwlat_entry, sizeof(hwlat_entry),
"hwlat_detector/%s", entry);
+	snprintf(buffer, sizeof(buffer), "%d", value);
+	debug("writing %s to %s\n", buffer, hwlat_entry);
+	return debugfs_write(hwlat_entry, buffer);
+}
+
+/*=20
+ * read the sample file and if we get something return it
+ * the file is opened non-blocking so handle EAGAIN
+ */
+static int
+hwlat_read_sample(int fd, char *buffer, size_t size)
+{
+	int ret;
+	ret =3D read(fd, buffer, size);
+	if (ret >=3D 0)
+		buffer[ret] =3D '\0';
+	/* don't error if there's nothing to read */
+	if (ret < 0 && errno =3D=3D EAGAIN)
+		return 0;
+	return ret;
+}
+
+static int
+hwlat_enable(void)
+{
+	int retries =3D ENABLE_RETRIES;
+	int val;
+	do {
+		hwlat_put_value("enable", 1);
+	=09
+	} while ((val =3D hwlat_get_value("enable")) !=3D 1 && --retries >
0);
+	if (val !=3D 1)
+		return -1;
+	return 0;
+}
+
+static int
+hwlat_disable(void)
+{
+	int val;
+	int retries =3D ENABLE_RETRIES;
+
+	do {
+		hwlat_put_value("enable", 0);
+	} while ((val =3D hwlat_get_value("enable")) !=3D 0 && --retries >
0);
+	if (val !=3D 0)
+		return -1;
+	return 0;
+}
+
+/* perf latency options */
+
+static const char * const latency_usage[] =3D {
+	"perf latency [<options>]",
+	NULL
+};
+
+static const struct option options[] =3D {
+	OPT_STRING('d', "duration", &duration_str, "n{s,m,h,d,w}",
+		    "total time to test for hardware latencies:
<N>{smhd}"),
+	OPT_STRING('t', "threshold", &threshold_str, "n{ms,s,m,h}",
+		    "microsecond value above which is considered a
hardware latency"),
+	OPT_STRING('w', "window", &window_str, "n{ms,s,m,h}",
+		   "sample window duration"),
+	OPT_STRING('W', "width", &width_str, "n{ms,s,m,h}",
+		   "actual measurment time period (must be <=3D
window)"),
+	OPT_BOOLEAN('c', "cleanup", &parameters.cleanup,=20
+		    "force unload of module and umount of debugfs"),
+	OPT_BOOLEAN('D', "debug", &parameters.debugging, "turn on
debugging prints"),
+	OPT_END()
+};
+
+static int
+ts_less_than(const struct timespec t1, const struct timespec t2)
+{
+	long long diff;
+	diff =3D NSEC_PER_SEC * (long long)((int) t1.tv_sec - (int)
t2.tv_sec);
+	diff +=3D ((int) t1.tv_nsec - (int) t2.tv_nsec);
+	/*debug("diff: %ld\n", diff);*/
+	if (diff < 0)
+		return 1;
+	return 0;
+}
+
+static long
+str_to_us(const char *str)
+{
+	char *ptr;
+	int val =3D strtol(str, &ptr, 10);
+	if (ptr) {
+		/* check for milliseconds, seconds, minutes and hours
*/
+		/* ignore anything else */
+		if (strcmp(ptr, "ms") =3D=3D 0)
+			val *=3D 1000;
+		else if (strcmp(ptr, "s") =3D=3D 0)
+			val *=3D 1000000;
+		else if (strcmp(ptr, "m") =3D=3D 0)
+			val *=3D 60000000;   /* 1000000 * 60 */
+		else if (strcmp(ptr, "h") =3D=3D 0)
+			val *=3D 3600000000; /* 1000000 * 60 * 60 */
+	}
+	return val;
+}
+
+static long
+str_to_sec(const char *str)
+{
+	char *ptr;
+	int val =3D strtol(str, &ptr, 10);
+
+	if (ptr) {
+		/* check for minutes, hours, days, and weeks */
+		if (strcmp(ptr, "m") =3D=3D 0)
+			val *=3D 60;
+		else if (strcmp(ptr, "h") =3D=3D 0)
+			val *=3D 360; /* 60 * 60 */
+		else if (strcmp(ptr, "d") =3D=3D 0)
+			val *=3D 86400; /* 60 * 60 * 24 */
+		else if (strcmp(ptr, "w") =3D=3D 0)
+			val *=3D 604800; /* 60 * 60 * 24 * 7 */
+	}
+	return val;
+}
+
+
+/* main function for hwlat_detector operation */
+static void
+detect (struct latency_params *params)
+{
+	int ret;
+	int fd;
+	char buffer[128];
+	char sample_path[256];
+	struct timespec start, stop, now;
+
+	/* set the parameters */
+	debug("setting window to %d\n", params->window);
+	if ((ret =3D hwlat_put_value("window", params->window)))
+		die("error writing hwlat_detector 'window' parameter
(%ld): %s",
+		    params->window, strerror(errno));
+
+	debug("setting width to %d\n", params->width);
+	if ((ret =3D hwlat_put_value("width", params->width)))
+		die("error writing hwlat_detector 'width' parameter
(%ld): %s",
+		    params->width, strerror(errno));
+
+	debug("setting threshold to %d\n", params->threshold);
+	if ((ret =3D hwlat_put_value("threshold", params->threshold)))
+		die("error writing hwlat_detector 'threshold'
parameter (%ld): %s",
+		    params->threshold, strerror(errno));
+
+	/* open the sample entry */
+	if (debugfs_make_path("hwlat_detector/sample", sample_path,
sizeof(sample_path)))
+		die ("can't get path to sample element: %s\n",
strerror(errno)); +
+	if ((fd =3D open(sample_path, O_RDONLY|O_NDELAY)) =3D=3D -1)
+		die("can't open %s: %s\n", sample_path,
strerror(errno)); +
+	/* get our start time */
+	if ((ret =3D clock_gettime(CLOCK_MONOTONIC, &start)))
+		die ("error getting start time: %s\n", strerror(-ret));
+
+	/* setup stop time */
+	stop =3D start;
+	stop.tv_sec +=3D params->duration;
+
+	/* start the kmod sampling */
+	if (hwlat_enable())
+		die ("can't enable the hwlat_detector!\n");
+
+	/* read samples until duration is done */
+	if ((ret =3D clock_gettime(CLOCK_MONOTONIC, &now)))
+		die ("error getting initial time: %s\n",
strerror(-errno)); +
+	while(ts_less_than(now, stop)) {
+		struct timespec ts;
+		debug("checking for sample\n");
+		if ((ret =3D hwlat_read_sample(fd, buffer,
sizeof(buffer))) < 0)
+			die("error reading sample: %s (%d)",
strerror(errno), errno);
+		/* for now, just print it */
+		if (ret) {
+			buffer[ret-1] =3D '\0'; /* nuke the newline */
+			puts(buffer);
+		}
+		ts.tv_sec =3D SAMPLE_POLL_INTERVAL;
+		ts.tv_nsec =3D 0;
+		clock_nanosleep(CLOCK_MONOTONIC, 0, &ts, NULL);
+		if ((ret =3D clock_gettime(CLOCK_MONOTONIC, &now)))
+			die("error getting current time: %s\n",
strerror(-errno));
+	}
+
+	/* stop the kmod sampling */
+	if (hwlat_disable())
+		die ("can't stop the hwlat_detector!\n");
+
+	/* close the sample entry */
+	close(fd);
+}
+
+static void
+sig_cleanup(int signo __used)
+{
+	hwlat_disable();
+	hwlat_unload_module();
+	debugfs_umount();
+}
+
+int
+cmd_latency(int argc, const char **argv, const char *prefix __used)
+{
+	argc =3D parse_options(argc, argv, options, latency_usage, 0);
+	if (argc)
+		usage_with_options(latency_usage, options);
+
+	if (parameters.cleanup) {
+		printf("cleaning up\n");
+		debugfs_force_cleanup();
+		hwlat_unload_module();
+		return 0;
+	}	=09
+
+	/* setup parameters */
+	parameters.duration  =3D str_to_sec(duration_str);
+	parameters.threshold =3D str_to_us(threshold_str);
+	parameters.window    =3D str_to_us(window_str);
+	parameters.width     =3D str_to_us(width_str);
+
+	/* mount the debugfs */
+	if (debugfs_mount(NULL))
+		die ("error mounting debugfs: %s\n", strerror(errno));
+
+	/* load the hwlat_detector module */
+	if (hwlat_load_module())
+		die("error loading hwlat_detector kernel module:
%s\n",strerror(errno)); +
+	/* get defaults if not specified on cmdline */
+	if (parameters.window =3D=3D -1)
+		parameters.window =3D hwlat_get_value("window");
+	if (parameters.width =3D=3D -1)
+		parameters.width =3D hwlat_get_value("width");
+	if (parameters.threshold =3D=3D -1)
+		parameters.threshold =3D hwlat_get_value("threshold");
+
+	/* sanity check */
+	if (parameters.width > parameters.window)
+		die ("invalid values for window/width (%ld/%ld)
(window must be larger)\n",
+		     parameters.window, parameters.width);
+
+	debug("window:    %dus\n", parameters.window);
+	debug("width:     %dus\n", parameters.width);
+	debug("threshold: %dus\n", parameters.threshold);
+	debug("duration:  %ds\n", parameters.duration);
+	debug("cleanup:   %s\n", parameters.cleanup ? "true" :
"false");
+	debug("debug:     %s\n", parameters.debugging ? "true" :
"false"); +
+	signal(SIGINT,  sig_cleanup);
+	signal(SIGABRT, sig_cleanup);
+
+	/* do detection */
+	detect(&parameters);
+=09
+	/* clean up */
+	hwlat_unload_module();
+	debugfs_umount();
+
+	return 0;
+}
+
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index ad5f0f4..6d6c2f1 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -26,5 +26,5 @@ extern int cmd_top(int argc, const char **argv, const
char *prefix); extern int cmd_trace(int argc, const char **argv, const
char *prefix); extern int cmd_version(int argc, const char **argv,
const char *prefix); extern int cmd_probe(int argc, const char **argv,
const char *prefix); -
+extern int cmd_latency(int argc, const char **argv, const char
*prefix); #endif
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 6475db4..2063e37 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -12,3 +12,4 @@ perf-timechart			mainporcelain
common perf-top			mainporcelain common
 perf-trace			mainporcelain common
 perf-probe			mainporcelain common
+perf-latency			mainporcelain common
--=20
1.6.2.5


--Sig_/qPNXmJs/NFcyY9nHBcSlDOj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAkruBHQACgkQHyuj/+TTEp1AawCgphckPPnHCQoiUxDZQnh+NE8d
8/AAn0LHMYIV/u2c/QBDeZmf7gKk4vj2
=EuQ/
-----END PGP SIGNATURE-----

--Sig_/qPNXmJs/NFcyY9nHBcSlDOj--
