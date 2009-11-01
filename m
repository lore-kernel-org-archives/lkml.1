Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbZKAV53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbZKAV53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 16:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbZKAV51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 16:57:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbZKAV50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 16:57:26 -0500
Date: Sun, 1 Nov 2009 15:56:21 -0600
From: Clark Williams <williams@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] debugfs utility routines for perf
Message-ID: <20091101155621.2b3503ee@torg>
In-Reply-To: <20091101155500.7dd22f19@torg>
References: <20091101155500.7dd22f19@torg>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/d_rj5llm=oUhzh_LTc.8WYQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/d_rj5llm=oUhzh_LTc.8WYQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Add routines to locate the debugfs mount point and to manage the
mounting and unmountin of the debugfs.

Signed-off-by: Clark Williams <williams@redhat.com>
---
 tools/perf/util/debugfs.c |  241 +++++++++++++++++++++++++++++++++++++++++=
++++
 tools/perf/util/debugfs.h |   22 ++++
 2 files changed, 263 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/util/debugfs.c
 create mode 100644 tools/perf/util/debugfs.h

diff --git a/tools/perf/util/debugfs.c b/tools/perf/util/debugfs.c
new file mode 100644
index 0000000..34f7983
--- /dev/null
+++ b/tools/perf/util/debugfs.c
@@ -0,0 +1,241 @@
+#include "util.h"
+#include "debugfs.h"
+#include "cache.h"
+
+static int debugfs_premounted =3D 0;
+static char debugfs_mountpoint[MAX_PATH+1];
+
+static const char *debugfs_known_mountpoints[] =3D {
+	"/sys/kernel/debug/",
+	"/debug/",
+	0,
+};
+
+/* use this to force a umount */
+void debugfs_force_cleanup(void)
+{
+	debugfs_find_mountpoint();
+	debugfs_premounted =3D 0;
+	debugfs_umount();
+}
+
+/* construct a full path to a debugfs element */
+int debugfs_make_path(const char *element, char *buffer, int size)
+{
+	int len;
+
+	if (strlen(debugfs_mountpoint) =3D=3D 0) {
+		buffer[0] =3D '\0';
+		return -1;
+	}
+=09
+	len =3D strlen(debugfs_mountpoint) + strlen(element) + 1;
+	if (len >=3D size)=20
+		return len+1;
+
+	snprintf(buffer, size-1, "%s/%s", debugfs_mountpoint, element);
+	return 0;
+}
+
+/* find the path to the mounted debugfs */
+const char *
+debugfs_find_mountpoint(void)
+{
+	static int debugfs_found =3D 0;
+	char type[100];
+	FILE *fp;
+	const char **ptr;
+
+	if (debugfs_found)
+		return (const char *) debugfs_mountpoint;
+
+	ptr =3D debugfs_known_mountpoints;
+	while(*ptr) {
+		if (debugfs_valid_mountpoint(*ptr) =3D=3D 0) {
+			debugfs_found =3D 1;
+			strcpy(debugfs_mountpoint, *ptr);
+			return debugfs_mountpoint;
+		}
+		ptr++;
+	}
+
+	/* give up and parse /proc/mounts */
+	if ((fp =3D fopen("/proc/mounts","r")) =3D=3D NULL)
+		die("Can't open /proc/mounts for read");
+
+	while (fscanf(fp, "%*s %"
+		      STR(MAX_PATH)
+		      "s %99s %*s %*d %*d\n",
+		      debugfs_mountpoint, type) =3D=3D 2) {
+		if (strcmp(type, "debugfs") =3D=3D 0)
+			break;
+	}
+	fclose(fp);
+
+	if (strcmp(type, "debugfs") !=3D 0)
+		return NULL;
+
+	debugfs_found =3D 1;
+
+	return debugfs_mountpoint;
+}
+
+/* verify that a mountpoint is actually a debugfs instance */
+
+int=20
+debugfs_valid_mountpoint(const char *debugfs)
+{
+	struct statfs st_fs;
+
+	if (statfs(debugfs, &st_fs) < 0)
+		return -ENOENT;
+	else if (st_fs.f_type !=3D (long) DEBUGFS_MAGIC)
+		return -ENOENT;
+	return 0;
+}
+
+
+int=20
+debugfs_valid_entry(const char *path)
+{
+	struct stat st;
+
+	if (stat(path, &st))
+		return -errno;
+	return 0;
+}
+
+/* mount the debugfs somewhere */
+
+int
+debugfs_mount(const char *mountpoint)
+{
+	char mountcmd[128];
+
+	/* see if it's already mounted */
+	if (debugfs_find_mountpoint()) {
+		debugfs_premounted =3D 1;
+		return 0;
+	}
+
+	/* if not mounted and no argument */
+	if (mountpoint =3D=3D NULL) {
+		/* see if environment variable set */
+		mountpoint =3D getenv(PERF_DEBUGFS_ENVIRONMENT);
+		/* if no environment variable, use default */
+		if (mountpoint =3D=3D NULL)
+			mountpoint =3D "/sys/kernel/debug";
+	}
+
+	/* save the mountpoint */
+	strncpy(debugfs_mountpoint, mountpoint, sizeof(debugfs_mountpoint));
+
+	/* mount it */
+	snprintf(mountcmd, sizeof(mountcmd),=20
+		 "/bin/mount -t debugfs debugfs %s", mountpoint);
+	return system(mountcmd);
+}
+
+/* umount the debugfs */
+
+int
+debugfs_umount(void)
+{
+	int ret;
+	char umountcmd[128];
+
+	/* if it was already mounted, leave it */
+	if (debugfs_premounted)
+		return 0;
+
+	/* make sure it's a valid mount point */
+	if ((ret =3D debugfs_valid_mountpoint(debugfs_mountpoint)))
+		return ret;
+
+	snprintf(umountcmd, sizeof(umountcmd),
+		 "/bin/umount %s", debugfs_mountpoint);
+	return system(umountcmd);
+}
+
+
+int
+debugfs_write(const char *entry, const char *value)
+{
+	int ret, count;
+	int fd;
+	char path[MAX_PATH+1];
+
+	/* construct the path */
+	snprintf(path, sizeof(path), "%s/%s", debugfs_mountpoint, entry);
+=09
+	/* verify that it exists */
+	if ((ret =3D debugfs_valid_entry(path)))
+		return ret;
+
+	/* get how many chars we're going to write */
+	count =3D strlen(value);
+
+	/* open the debugfs entry */
+	if ((fd =3D open(path, O_RDWR)) < 0)
+		return -errno;
+
+	while (count > 0) {
+		/* write it */
+		ret =3D write(fd, value, count);
+		if (ret <=3D 0) {
+			if (ret =3D=3D EAGAIN)
+				continue;
+			close(fd);
+			return -errno;
+		}
+		count -=3D ret;
+	}
+
+	/* close it */
+	close(fd);
+
+	/* return success */
+	return 0;
+}
+
+/*=20
+ * read a debugfs entry
+ * returns the number of chars read or a negative errno
+ */
+
+int
+debugfs_read(const char *entry, char *buffer, size_t size)
+{
+	int ret;
+	int fd;
+	char path[MAX_PATH+1];
+=09
+	/* construct the path */
+	snprintf(path, sizeof(path), "%s/%s", debugfs_mountpoint, entry);
+=09
+	/* verify that it exists */
+	if ((ret =3D debugfs_valid_entry(path)))
+		return ret;
+
+	/* open the debugfs entry */
+	if ((fd =3D open(path, O_RDONLY)) < 0)
+		return -errno;
+
+	do {
+		/* read it */
+		ret =3D read(fd, buffer, size);
+		if (ret =3D=3D 0) {
+			close(fd);
+			return EOF;
+		}
+	} while (ret < 0 && errno =3D=3D EAGAIN);
+
+	/* close it */
+	close(fd);
+
+	/* make *sure* there's a null character at the end */
+	buffer[ret] =3D '\0';
+
+	/* return the number of chars read */
+	return ret;
+}
diff --git a/tools/perf/util/debugfs.h b/tools/perf/util/debugfs.h
new file mode 100644
index 0000000..df14c2a
--- /dev/null
+++ b/tools/perf/util/debugfs.h
@@ -0,0 +1,22 @@
+#ifndef __DEBUGFS_H__
+#define __DEBUGFS_H__
+#include <sys/mount.h>
+#ifndef MAX_PATH
+#define MAX_PATH 256
+#endif
+
+#ifndef STR
+#define _STR(x) #x
+#define STR(x) _STR(x)
+#endif
+
+extern const char * debugfs_find_mountpoint(void);
+extern int debugfs_valid_mountpoint(const char *debugfs);
+extern int debugfs_valid_entry(const char *path);
+extern int debugfs_mount(const char *mountpoint);
+extern int debugfs_umount(void);
+extern int debugfs_write(const char *entry, const char *value);
+extern int debugfs_read(const char *entry, char *buffer, size_t size);
+extern void debugfs_force_cleanup(void);
+extern int debugfs_make_path(const char *element, char *buffer, int size);
+#endif
--=20
1.6.2.5



--Sig_/d_rj5llm=oUhzh_LTc.8WYQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAkruBAkACgkQHyuj/+TTEp0RTACfSb7f74idloCDejJI/rsKMK83
9JAAnRdruFwyS8/4X5jF4jOY9ycigWiD
=+E9c
-----END PGP SIGNATURE-----

--Sig_/d_rj5llm=oUhzh_LTc.8WYQ--
