Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbZKAV5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbZKAV5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 16:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbZKAV5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 16:57:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453AbZKAV5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 16:57:41 -0500
Date: Sun, 1 Nov 2009 15:57:20 -0600
From: Clark Williams <williams@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] modify perf routines to use new debugfs routines
Message-ID: <20091101155720.624cc87e@torg>
In-Reply-To: <20091101155500.7dd22f19@torg>
References: <20091101155500.7dd22f19@torg>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.nCyROvw6UJi_oAz2IbkVGQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.nCyROvw6UJi_oAz2IbkVGQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


modified perf.c get_debugfs_mntpnt() to use the util/debugfs.c
debugfs_find_mountpoint()
modified util/parse-events.c to use debugfs_valid_mountpoint().

Signed-off-by: Clark Williams <williams@redhat.com>
---
 tools/perf/perf.c              |   45
++++++--------------------------------- tools/perf/util/parse-events.c
|   17 +++----------- 2 files changed, 11 insertions(+), 51 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 9cafe54..940cbf6 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -14,6 +14,7 @@
 #include "util/run-command.h"
 #include "util/parse-events.h"
 #include "util/string.h"
+#include "util/debugfs.h"
=20
 const char perf_usage_string[] =3D
 	"perf [--version] [--help] COMMAND [ARGS]";
@@ -296,6 +297,7 @@ static void handle_internal_command(int argc, const
char **argv) { "trace", cmd_trace, 0 },
 		{ "sched", cmd_sched, 0 },
 		{ "probe", cmd_probe, 0 },
+		{ "latency", cmd_latency, 0},
 	};
 	unsigned int i;
 	static const char ext[] =3D STRIP_EXTENSION;
@@ -383,45 +385,12 @@ static int run_argv(int *argcp, const char
***argv) /* mini /proc/mounts parser: searching for "^blah /mount/point
debugfs" */ static void get_debugfs_mntpt(void)
 {
-	FILE *file;
-	char fs_type[100];
-	char debugfs[MAXPATHLEN];
+	const char *path =3D debugfs_find_mountpoint();
=20
-	/*
-	 * try the standard location
-	 */
-	if (valid_debugfs_mount("/sys/kernel/debug/") =3D=3D 0) {
-		strcpy(debugfs_mntpt, "/sys/kernel/debug/");
-		return;
-	}
-
-	/*
-	 * try the sane location
-	 */
-	if (valid_debugfs_mount("/debug/") =3D=3D 0) {
-		strcpy(debugfs_mntpt, "/debug/");
-		return;
-	}
-
-	/*
-	 * give up and parse /proc/mounts
-	 */
-	file =3D fopen("/proc/mounts", "r");
-	if (file =3D=3D NULL)
-		return;
-
-	while (fscanf(file, "%*s %"
-		      STR(MAXPATHLEN)
-		      "s %99s %*s %*d %*d\n",
-		      debugfs, fs_type) =3D=3D 2) {
-		if (strcmp(fs_type, "debugfs") =3D=3D 0)
-			break;
-	}
-	fclose(file);
-	if (strcmp(fs_type, "debugfs") =3D=3D 0) {
-		strncpy(debugfs_mntpt, debugfs, MAXPATHLEN);
-		debugfs_mntpt[MAXPATHLEN - 1] =3D '\0';
-	}
+	if (path)
+		strncpy(debugfs_mntpt, path, sizeof(debugfs_mntpt));
+	else
+		debugfs_mntpt[0] =3D '\0';
 }
=20
 int main(int argc, const char **argv)
diff --git a/tools/perf/util/parse-events.c
b/tools/perf/util/parse-events.c index 31baa5a..097938a 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -7,6 +7,7 @@
 #include "string.h"
 #include "cache.h"
 #include "header.h"
+#include "debugfs.h"
=20
 int				nr_counters;
=20
@@ -149,16 +150,6 @@ static int tp_event_has_id(struct dirent *sys_dir,
struct dirent *evt_dir)=20
 #define MAX_EVENT_LENGTH 512
=20
-int valid_debugfs_mount(const char *debugfs)
-{
-	struct statfs st_fs;
-
-	if (statfs(debugfs, &st_fs) < 0)
-		return -ENOENT;
-	else if (st_fs.f_type !=3D (long) DEBUGFS_MAGIC)
-		return -ENOENT;
-	return 0;
-}
=20
 struct tracepoint_path *tracepoint_id_to_path(u64 config)
 {
@@ -171,7 +162,7 @@ struct tracepoint_path *tracepoint_id_to_path(u64
config) char evt_path[MAXPATHLEN];
 	char dir_path[MAXPATHLEN];
=20
-	if (valid_debugfs_mount(debugfs_path))
+	if (debugfs_valid_mountpoint(debugfs_path))
 		return NULL;
=20
 	sys_dir =3D opendir(debugfs_path);
@@ -510,7 +501,7 @@ static enum event_result
parse_tracepoint_event(const char **strp, char
sys_name[MAX_EVENT_LENGTH]; unsigned int sys_length, evt_length;
=20
-	if (valid_debugfs_mount(debugfs_path))
+	if (debugfs_valid_mountpoint(debugfs_path))
 		return 0;
=20
 	evt_name =3D strchr(*strp, ':');
@@ -788,7 +779,7 @@ static void print_tracepoint_events(void)
 	char evt_path[MAXPATHLEN];
 	char dir_path[MAXPATHLEN];
=20
-	if (valid_debugfs_mount(debugfs_path))
+	if (debugfs_valid_mountpoint(debugfs_path))
 		return;
=20
 	sys_dir =3D opendir(debugfs_path);
--=20
1.6.2.5


--Sig_/.nCyROvw6UJi_oAz2IbkVGQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAkruBEQACgkQHyuj/+TTEp2AaQCgz7CQHyrrM7SdovrmzQcjXLK6
xcUAoKRJOjHLKSr5bFXurQThoLEHVTsz
=tZvn
-----END PGP SIGNATURE-----

--Sig_/.nCyROvw6UJi_oAz2IbkVGQ--
