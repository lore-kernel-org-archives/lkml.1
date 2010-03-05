Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab0CETor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 14:44:47 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58177 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525Ab0CETog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 14:44:36 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: zippel@linux-m68k.org, mingo@elte.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, geert@linux-m68k.org, elendil@planet.nl,
       cloos@jhcloos.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/2] kconfig: place localversion string in .config output
Date: Fri,  5 Mar 2010 11:44:30 -0800
Message-Id: <1267818271-23154-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100305194305.GA23009@linux.vnet.ibm.com>
References: <20100305194305.GA23009@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch appends the localversion string to the Linux kernel version.
For example, in a git tree with uncommitted changes, the .config file
might start as follows (but with leading hash marks):

	Automatically generated make config: don't edit
	Linux kernel version: 2.6.33-01836-g90a6501-dirty
	Mon Mar  1 17:05:59 2010

The "-01836-g90a6501-dirty" string is added by this patch.

The KBUILD_CONFIG_NO_CHECK_DIRTY environment variable controls the
git "-dirty" check.  If this variable is either empty or undefined,
then a "-dirty" check is performed (the default), otherwise, this
check is omitted.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Suggested-by: Frans Pop <elendil@planet.nl>
Suggested-by: James Cloos <cloos@jhcloos.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Frans Pop <elendil@planet.nl>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 scripts/kconfig/confdata.c |   68 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index c4dec80..99d16b4 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -3,6 +3,7 @@
  * Released under the terms of the GNU GPL v2.0.
  */
 
+#include <sys/types.h>
 #include <sys/stat.h>
 #include <ctype.h>
 #include <fcntl.h>
@@ -11,10 +12,13 @@
 #include <string.h>
 #include <time.h>
 #include <unistd.h>
+#include <sys/wait.h>
 
 #define LKC_DIRECT_LINK
 #include "lkc.h"
 
+extern char **environ;
+
 static void conf_warning(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2)));
 
@@ -399,15 +403,20 @@ int conf_read(const char *name)
 int conf_write(const char *name)
 {
 	FILE *out;
+	FILE *slv;
 	struct symbol *sym;
 	struct menu *menu;
 	const char *basename;
-	char dirname[128], tmpname[128], newname[128];
+	char dirname[128], tmpname[128], newname[128], localversion[128];
+	char cmdline[PATH_MAX * 2 + 128];
 	int type, l;
 	const char *str;
 	time_t now;
 	int use_timestamp = 1;
+	int pipefd[2];
 	char *env;
+	char *path;
+	pid_t pid;
 
 	dirname[0] = 0;
 	if (name && name[0]) {
@@ -450,12 +459,67 @@ int conf_write(const char *name)
 	if (env && *env)
 		use_timestamp = 0;
 
+	sprintf(localversion, "-error: %s:%d", __FILE__, __LINE__);
+	path = getenv(SRCTREE);
+	if (path && *path) {
+		sprintf(localversion, "-error: %s:%d", __FILE__, __LINE__);
+		if (pipe(pipefd) != 0) {
+			fprintf(stderr, "%s:%d error: pipe() failed\n",
+				__FILE__, __LINE__);
+			goto nolocalversion;
+		}
+		sprintf(cmdline, "%s/scripts/setlocalversion", path);
+		sprintf(localversion, "-error: %s:%d", __FILE__, __LINE__);
+		fflush(stderr);
+		pid = fork();
+		if (pid < 0) {
+			fprintf(stderr, "%s:%d error: fork() failed\n",
+				__FILE__, __LINE__);
+			goto nolocalversion;
+		}
+		if (pid == 0) { /* child */
+			char *newargv[] = { cmdline, path, NULL };
+
+			close(1); /* stdout */
+			if (dup2(pipefd[1], 1) < 0) {
+				fprintf(stderr, "%s:%d error: dup2() failed\n",
+					__FILE__, __LINE__);
+				fflush(stderr);
+				_exit(1);
+			}
+			execve(cmdline, newargv, environ);
+			fprintf(stderr, "%s:%d error: execve() failed\n",
+				__FILE__, __LINE__);
+			fflush(stderr);
+			_exit(2);
+		} else { /* parent */
+			int chldstatus = 0;
+
+			localversion[0] = '\0';
+			slv = fdopen(pipefd[0], "r");
+			if (slv != NULL) {
+				close(pipefd[1]);
+				fscanf(slv, " %127s ", localversion);
+				/* can have EOF if no SCM. */
+				if (wait(&chldstatus) < 0 || chldstatus != 0) {
+					fprintf(stderr,
+						"%s:%d error: child failed\n",
+						__FILE__, __LINE__);
+					sprintf(localversion, "-error: %s:%d",
+						__FILE__, __LINE__);
+				}
+			}
+		}
+	}
+nolocalversion:
+
 	fprintf(out, _("#\n"
 		       "# Automatically generated make config: don't edit\n"
-		       "# Linux kernel version: %s\n"
+		       "# Linux kernel version: %s%s\n"
 		       "%s%s"
 		       "#\n"),
 		     sym_get_string_value(sym),
+		     localversion,
 		     use_timestamp ? "# " : "",
 		     use_timestamp ? ctime(&now) : "");
 
-- 
1.6.6

