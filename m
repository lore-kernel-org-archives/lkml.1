Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbYHZTsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbYHZTsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYHZTsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:48:14 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40573 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYHZTsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:48:12 -0400
Date: Tue, 26 Aug 2008 14:47:57 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: SELinux <selinux@tycho.nsa.gov>, Stephen Smalley <sds@epoch.ncsc.mil>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Daniel J Walsh <dwalsh@redhat.com>
Subject: [PATCH 1/1] selinux: add support for installing a dummy policy (v2)
Message-ID: <20080826194757.GA3612@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend taking into account feedback from the last posting.
The Documentation/SELinux.txt file should as Stephen pointed out, have
general SELinux info.  I'm hoping someone will send a patch adding that,
perhaps in the form of a set of links to the latest and greatest online
docs.

=======================================================================

In August 2006 I posted a patch generating a minimal SELinux policy.  This
week, David P. Quigley posted an updated version of that as a patch against
the kernel.  It also had nice logic for auto-installing the policy.

Following is David's original patch intro (preserved especially
bc it has stats on the generated policies):

se interested in the changes there were only two significant
changes. The first is that the iteration through the list of classes
used NULL as a sentinel value. The problem with this is that the
class_to_string array actually has NULL entries in its table as place
holders for the user space object classes.

The second change was that it would seem at some point the initial sids
table was NULL terminated. This is no longer the case so that iteration
has to be done on array length instead of looking for NULL.

Some statistics on the policy that it generates:

The policy consists of 523 lines which contain no blank lines. Of those
523 lines 453 of them are class, permission, and initial sid
definitions. These lines are usually little to no concern to the policy
developer since they will not be adding object classes or permissions.
Of the remaining 70 lines there is one type, one role, and one user
statement. The remaining lines are broken into three portions. The first
group are TE allow rules which make up 29 of the remaining lines, the
second is assignment of labels to the initial sids which consist of 27
lines, and file system labeling statements which are the remaining 11.

In addition to the policy.conf generated there is a single file_contexts
file containing two lines which labels the entire system with base_t.

This policy generates a policy.23 binary that is 7920 bytes.

(then a few versions later...):

The new policy is 587 lines (stripped of blank lines) with 476 of those
lines being the boilerplate that I mentioned last time. The remaining
111 lines have the 3 lines for type, user, and role, 70 lines for the
allow rules (one for each object class including user space object
classes), 27 lines to assign types to the initial sids, and 11 lines for
file system labeling. The policy binary is 9194 bytes.

Changelog:

	Aug 26: Added Documentation/SELinux.txt
	Aug 26: Incorporated a set of comments by Stephen Smalley:
		1. auto-setup SELINUXTYPE=dummy
		2. don't auto-install if selinux is enabled with
			non-dummy policy
		3. don't re-compute policy version
		4. /sbin/setfiles not /usr/sbin/setfiles
	Aug 22: As per JMorris comments, made sure make distclean
		cleans up the mdp directory.
		Removed a check for file_contexts which is now
		created in the same file as the check, making it
		superfluous.

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: David Quigley <dpquigl@tycho.nsa.gov>
---
 Documentation/SELinux.txt         |   27 ++++
 scripts/Makefile                  |    3 +-
 scripts/selinux/Makefile          |    2 +
 scripts/selinux/README            |    2 +
 scripts/selinux/install_policy.sh |   69 +++++++++++
 scripts/selinux/mdp/Makefile      |    5 +
 scripts/selinux/mdp/dbus_contexts |    6 +
 scripts/selinux/mdp/mdp.c         |  242 +++++++++++++++++++++++++++++++++++++
 8 files changed, 355 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/SELinux.txt
 create mode 100644 scripts/selinux/Makefile
 create mode 100644 scripts/selinux/README
 create mode 100644 scripts/selinux/install_policy.sh
 create mode 100644 scripts/selinux/mdp/Makefile
 create mode 100644 scripts/selinux/mdp/dbus_contexts
 create mode 100644 scripts/selinux/mdp/mdp.c

diff --git a/Documentation/SELinux.txt b/Documentation/SELinux.txt
new file mode 100644
index 0000000..07eae00
--- /dev/null
+++ b/Documentation/SELinux.txt
@@ -0,0 +1,27 @@
+If you want to use SELinux, chances are you will want
+to use the distro-provided policies, or install the
+latest reference policy release from
+	http://oss.tresys.com/projects/refpolicy
+
+However, if you want to install a dummy policy for
+testing, you can do using 'mdp' provided under
+scripts/selinux.  Note that this requires the selinux
+userspace to be installed - in particular you will
+need checkpolicy to compile a kernel, and setfiles and
+fixfiles to label the filesystem.
+
+	1. Compile the kernel with selinux enabled.
+	2. Type 'make' to compile mdp.
+	3. Make sure that you are not running with
+	   SELinux enabled and a real policy.  If
+	   you are, reboot with selinux disabled
+	   before continuing.
+	4. Run install_policy.sh:
+		cd scripts/selinux
+		sh install_policy.sh
+
+Step 4 will create a new dummy policy valid for your
+kernel, with a single selinux user, role, and type.
+It will compile the policy, will set your SELINUXTYPE to
+dummy in /etc/selinux/config, install the compiled policy
+as 'dummy', and relabel your filesystem.
diff --git a/scripts/Makefile b/scripts/Makefile
index 1c73c5a..aafdf06 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -20,6 +20,7 @@ hostprogs-y += unifdef
 
 subdir-$(CONFIG_MODVERSIONS) += genksyms
 subdir-y                     += mod
+subdir-$(CONFIG_SECURITY_SELINUX) += selinux
 
 # Let clean descend into subdirs
-subdir-	+= basic kconfig package
+subdir-	+= basic kconfig package selinux
diff --git a/scripts/selinux/Makefile b/scripts/selinux/Makefile
new file mode 100644
index 0000000..ca4b1ec
--- /dev/null
+++ b/scripts/selinux/Makefile
@@ -0,0 +1,2 @@
+subdir-y := mdp
+subdir-	+= mdp
diff --git a/scripts/selinux/README b/scripts/selinux/README
new file mode 100644
index 0000000..a936315
--- /dev/null
+++ b/scripts/selinux/README
@@ -0,0 +1,2 @@
+Please see Documentation/SELinux.txt for information on
+installing a dummy SELinux policy.
diff --git a/scripts/selinux/install_policy.sh b/scripts/selinux/install_policy.sh
new file mode 100644
index 0000000..7b9ccf6
--- /dev/null
+++ b/scripts/selinux/install_policy.sh
@@ -0,0 +1,69 @@
+#!/bin/sh
+if [ `id -u` -ne 0 ]; then
+	echo "$0: must be root to install the selinux policy"
+	exit 1
+fi
+SF=`which setfiles`
+if [ $? -eq 1 ]; then
+	if [ -f /sbin/setfiles ]; then
+		SF="/usr/setfiles"
+	else
+		echo "no selinux tools installed: setfiles"
+		exit 1
+	fi
+fi
+
+cd mdp
+
+CP=`which checkpolicy`
+VERS=`$CP -V | awk '{print $1}'`
+
+./mdp policy.conf file_contexts
+$CP -o policy.$VERS policy.conf
+
+mkdir -p /etc/selinux/dummy/policy
+mkdir -p /etc/selinux/dummy/contexts/files
+
+cp file_contexts /etc/selinux/dummy/contexts/files
+cp dbus_contexts /etc/selinux/dummy/contexts
+cp policy.$VERS /etc/selinux/dummy/policy
+FC_FILE=/etc/selinux/dummy/contexts/files/file_contexts
+
+if [ ! -d /etc/selinux ]; then
+	mkdir -p /etc/selinux
+fi
+if [ ! -f /etc/selinux/config ]; then
+	cat > /etc/selinux/config << EOF
+SELINUX=enforcing
+SELINUXTYPE=dummy
+EOF
+else
+	TYPE=`cat /etc/selinux/config | grep "^SELINUXTYPE" | tail -1 | awk -F= '{ print $2 '}`
+	if [ "eq$TYPE" != "eqdummy" ]; then
+		selinuxenabled
+		if [ $? -eq 0 ]; then
+			echo "SELinux already enabled with a non-dummy policy."
+			echo "Exiting.  Please install policy by hand if that"
+			echo "is what you REALLY want."
+			exit 1
+		fi
+		mv /etc/selinux/config /etc/selinux/config.mdpbak
+		grep -v "^SELINUXTYPE" /etc/selinux/config.mdpbak >> /etc/selinux/config
+		echo "SELINUXTYPE=dummy" >> /etc/selinux/config
+	fi
+fi
+
+cd /etc/selinux/dummy/contexts/files
+$SF file_contexts /
+
+mounts=`cat /proc/$$/mounts | egrep "ext2|ext3|xfs|jfs|ext4|ext4dev|gfs2" | awk '{ print $2 '}`
+$SF file_contexts $mounts
+
+
+dodev=`cat /proc/$$/mounts | grep "/dev "`
+if [ "eq$dodev" != "eq" ]; then
+	mount --move /dev /mnt
+	$SF file_contexts /dev
+	mount --move /mnt /dev
+fi
+
diff --git a/scripts/selinux/mdp/Makefile b/scripts/selinux/mdp/Makefile
new file mode 100644
index 0000000..eb365b3
--- /dev/null
+++ b/scripts/selinux/mdp/Makefile
@@ -0,0 +1,5 @@
+hostprogs-y	:= mdp
+HOST_EXTRACFLAGS += -Isecurity/selinux/include
+
+always		:= $(hostprogs-y)
+clean-files	:= $(hostprogs-y) policy.* file_contexts
diff --git a/scripts/selinux/mdp/dbus_contexts b/scripts/selinux/mdp/dbus_contexts
new file mode 100644
index 0000000..116e684
--- /dev/null
+++ b/scripts/selinux/mdp/dbus_contexts
@@ -0,0 +1,6 @@
+<!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
+ "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
+<busconfig>
+  <selinux>
+  </selinux>
+</busconfig>
diff --git a/scripts/selinux/mdp/mdp.c b/scripts/selinux/mdp/mdp.c
new file mode 100644
index 0000000..e2a73c9
--- /dev/null
+++ b/scripts/selinux/mdp/mdp.c
@@ -0,0 +1,242 @@
+/*
+ *
+ * mdp - make dummy policy
+ *
+ * When pointed at a kernel tree, builds a dummy policy for that kernel
+ * with exactly one type with full rights to itself.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2006
+ *
+ * Authors: Serge E. Hallyn <serue@us.ibm.com>
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+
+#include "flask.h"
+
+void usage(char *name)
+{
+	printf("usage: %s [-m] policy_file context_file\n", name);
+	exit(1);
+}
+
+void find_common_name(char *cname, char *dest, int len)
+{
+	char *start, *end;
+	
+	start = strchr(cname, '_')+1;
+	end = strchr(start, '_');
+	if (!start || !end || start-cname > len || end-start > len) {
+		printf("Error with commons defines\n");
+		exit(1);
+	}
+	strncpy(dest, start, end-start);
+	dest[end-start] = '\0';
+}
+
+#define S_(x) x,
+static char *classlist[] = {
+#include "class_to_string.h"
+	NULL
+};
+#undef S_
+
+#include "initial_sid_to_string.h"
+
+#define TB_(x) char *x[] = {
+#define TE_(x) NULL };
+#define S_(x) x,
+#include "common_perm_to_string.h"
+#undef TB_
+#undef TE_
+#undef S_
+
+struct common {
+	char *cname;
+	char **perms;
+};
+struct common common[] = {
+#define TB_(x) { #x, x },
+#define S_(x) 
+#define TE_(x)
+#include "common_perm_to_string.h"
+#undef TB_
+#undef TE_
+#undef S_
+};
+
+#define S_(x, y, z) {x, #y},
+struct av_inherit {
+	int class;
+	char *common;
+};
+struct av_inherit av_inherit[] = {
+#include "av_inherit.h"
+};
+#undef S_
+
+#include "av_permissions.h"
+#define S_(x, y, z) {x, y, z},
+struct av_perms {
+	int class;
+	int perm_i;
+	char *perm_s;
+};
+struct av_perms av_perms[] = {
+#include "av_perm_to_string.h"
+};
+#undef S_
+
+int main(int argc, char *argv[])
+{
+	int i, j, mls = 0;
+	char **arg, *polout, *ctxout;
+	int classlist_len, initial_sid_to_string_len;
+	FILE *fout;
+
+	if (argc < 3)
+		usage(argv[0]);
+	arg = argv+1;
+	if (argc==4 && strcmp(argv[1], "-m") == 0) {
+		mls = 1;
+		arg++;
+	}
+	polout = *arg++;
+	ctxout = *arg;
+
+	fout = fopen(polout, "w");
+	if (!fout) {
+		printf("Could not open %s for writing\n", polout);
+		usage(argv[0]);
+	}
+
+	classlist_len = sizeof(classlist) / sizeof(char *);
+	/* print out the classes */
+	for (i=1; i < classlist_len; i++) {
+		if(classlist[i])
+			fprintf(fout, "class %s\n", classlist[i]);
+		else
+			fprintf(fout, "class user%d\n", i);
+	}
+	fprintf(fout, "\n");
+
+	initial_sid_to_string_len = sizeof(initial_sid_to_string) / sizeof (char *);
+	/* print out the sids */
+	for (i=1; i < initial_sid_to_string_len; i++) 
+		fprintf(fout, "sid %s\n", initial_sid_to_string[i]);
+	fprintf(fout, "\n");
+
+	/* print out the commons */
+	for (i=0; i< sizeof(common)/sizeof(struct common); i++) {
+		char cname[101];
+		find_common_name(common[i].cname, cname, 100);
+		cname[100] = '\0';
+		fprintf(fout, "common %s\n{\n", cname);
+		for (j=0; common[i].perms[j]; j++)
+			fprintf(fout, "\t%s\n", common[i].perms[j]);
+		fprintf(fout, "}\n\n");
+	}
+	fprintf(fout, "\n");
+
+	/* print out the class permissions */
+	for (i=1; i < classlist_len; i++) {
+		if (classlist[i]) {
+			int firstperm = -1, numperms = 0;
+
+			fprintf(fout, "class %s\n", classlist[i]);
+			/* does it inherit from a common? */
+			for (j=0; j < sizeof(av_inherit)/sizeof(struct av_inherit); j++)
+				if (av_inherit[j].class == i)
+					fprintf(fout, "inherits %s\n", av_inherit[j].common);
+
+			for (j=0; j < sizeof(av_perms)/sizeof(struct av_perms); j++) {
+				if (av_perms[j].class == i) {
+					if (firstperm == -1)
+						firstperm = j;
+					numperms++;
+				}
+			}
+			if (!numperms) {
+				fprintf(fout, "\n");
+				continue;
+			}
+
+			fprintf(fout, "{\n");
+			/* print out the av_perms */
+			for (j=0; j < numperms; j++) {
+				fprintf(fout, "\t%s\n", av_perms[firstperm+j].perm_s);
+			}
+			fprintf(fout, "}\n\n");
+		}
+	}
+	fprintf(fout, "\n");
+
+	/* NOW PRINT OUT MLS STUFF */
+	if (mls) {
+		printf("MLS not yet implemented\n");
+		exit(1);
+	}
+
+	/* types, roles, and allows */
+	fprintf(fout, "type base_t;\n");
+	fprintf(fout, "role base_r types { base_t };\n");
+	for (i=1; i < classlist_len; i++) {
+		if (classlist[i])
+			fprintf(fout, "allow base_t base_t:%s *;\n", classlist[i]);
+		else
+			fprintf(fout, "allow base_t base_t:user%d *;\n", i);
+	}
+	fprintf(fout, "user user_u roles { base_r };\n");
+	fprintf(fout, "\n");
+
+	/* default sids */
+	for (i=1; i < initial_sid_to_string_len; i++)
+		fprintf(fout, "sid %s user_u:base_r:base_t\n", initial_sid_to_string[i]);
+	fprintf(fout, "\n");
+
+
+	fprintf(fout, "fs_use_xattr ext2 user_u:base_r:base_t;\n");
+	fprintf(fout, "fs_use_xattr ext3 user_u:base_r:base_t;\n");
+	fprintf(fout, "fs_use_xattr jfs user_u:base_r:base_t;\n");
+	fprintf(fout, "fs_use_xattr xfs user_u:base_r:base_t;\n");
+	fprintf(fout, "fs_use_xattr reiserfs user_u:base_r:base_t;\n");
+
+	fprintf(fout, "fs_use_task pipefs user_u:base_r:base_t;\n");
+	fprintf(fout, "fs_use_task sockfs user_u:base_r:base_t;\n");
+
+	fprintf(fout, "fs_use_trans devpts user_u:base_r:base_t;\n");
+	fprintf(fout, "fs_use_trans tmpfs user_u:base_r:base_t;\n");
+	fprintf(fout, "fs_use_trans shm user_u:base_r:base_t;\n");
+
+	fprintf(fout, "genfscon proc / user_u:base_r:base_t\n");
+
+	fclose(fout);
+
+	fout = fopen(ctxout, "w");
+	if (!fout) {
+		printf("Wrote policy, but cannot open %s for writing\n", ctxout);
+		usage(argv[0]);
+	}
+	fprintf(fout, "/ user_u:base_r:base_t\n");
+	fprintf(fout, "/.* user_u:base_r:base_t\n");
+	fclose(fout);
+
+	return 0;
+}
-- 
1.5.4.3

