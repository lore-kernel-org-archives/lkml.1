Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab0CECyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 21:54:39 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52389 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab0CECyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 21:54:37 -0500
Date: Thu, 4 Mar 2010 18:54:35 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: zippel@linux-m68k.org, mingo@elte.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, geert@linux-m68k.org, elendil@planet.nl,
       cloos@jhcloos.com
Subject: [PATCH] v3 kconfig: place git SHA1 in .config output if in SCM
Message-ID: <20100305025435.GA6836@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
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

Differences from v2:

o	Replace popen() with the equivalent fork-exec series
	to prevent security vulnerabilities due to shell metacharacter
	interpretation.

o	Added the KBUILD_CONFIG_NO_CHECK_DIRTY environment variable,
	and modified scripts/setlocalversion to check it, as suggested
	by James Cloos.

Differences from v1:

o	Incorporates feedback from Geert Uytterhoeven, Linus Torvalds,
	Frans Pop, and James Cloos.

o	Fixed to work correctly with the "O=" Makefile argument and
	the KBUILD_OUTPUT environment variable, so that .config files
	created in directories outside of the source tree are tagged
	correctly.

o	Uses scripts/setlocalversion, which handles not only git, but
	also mercurial and svn.

o	Make the new behavior default-off, as scripts/setlocalversion
	has significant latency.  A new environment variable named
	"KBUILD_CONFIG_LOCALVERSION" must be set to enable the
	"-01836-g90a6501-dirty" style of string.

	This is intended to address James Cloos's concern that this
	feature will slow down casual kernel builds.

It has been suggested that this string be output at boot and oops time.
If there is general agreement, this will be the subject of a separate
patch.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Suggested-by: Frans Pop <elendil@planet.nl>
Suggested-by: James Cloos <cloos@jhcloos.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Frans Pop <elendil@planet.nl>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 kconfig/confdata.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++--
 setlocalversion    |   17 ++++++++++-------
 2 files changed, 59 insertions(+), 9 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index c4dec80..e896b81 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -15,6 +15,8 @@
 #define LKC_DIRECT_LINK
 #include "lkc.h"
 
+extern char **environ;
+
 static void conf_warning(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2)));
 
@@ -399,15 +401,20 @@ int conf_read(const char *name)
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
@@ -450,12 +457,52 @@ int conf_write(const char *name)
 	if (env && *env)
 		use_timestamp = 0;
 
+	strcpy(localversion, "-?-nopath");
+	path = getenv(SRCTREE);
+	if (path && *path) {
+		strcpy(localversion, "-?-pipe()-failed");
+		if (pipe(pipefd) != 0)
+			goto nolocalversion;
+		env = getenv("KBUILD_CONFIG_NO_CHECK_DIRTY");
+		sprintf(cmdline, "%s/scripts/setlocalversion", path);
+		strcpy(localversion, "-?-fork()-failed");
+		pid = fork();
+		if (pid < 0)
+			goto nolocalversion;
+		if (pid == 0) { /* child */
+			int fd_new_stderr;
+			char *newargv[] = { cmdline, path, NULL };
+
+			close(1); /* stdout */
+			close(2); /* stderr */
+			fd_new_stderr = open("/dev/null", O_RDONLY);
+			if (dup2(pipefd[1], 1) < 0)
+				_exit(1);
+			if (fd_new_stderr != 2)
+				if (dup2(fd_new_stderr, 1) < 0) {
+					_exit(2);
+			}
+			execve(cmdline, newargv, environ);
+			_exit(3);
+		} else { /* parent */
+			strcpy(localversion, "-?-fscanf()-failed");
+			slv = fdopen(pipefd[0], "r");
+			if (slv != NULL) {
+				close(pipefd[1]);
+				fscanf(slv, " %127s ", localversion);
+				fclose(slv);
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
+		     localversion[0] != '\0' ? localversion : "",
 		     use_timestamp ? "# " : "",
 		     use_timestamp ? ctime(&now) : "");
 
diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 46989b8..3d4ff84 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -39,13 +39,16 @@ if head=`git rev-parse --verify --short HEAD 2>/dev/null`; then
 	        printf -- '-svn%s' "`git svn find-rev $head`"
 	fi
 
-	# Update index only on r/w media
-	[ -w . ] && git update-index --refresh --unmerged > /dev/null
-
-	# Check for uncommitted changes
-	if git diff-index --name-only HEAD | grep -v "^scripts/package" \
-	    | read dummy; then
-		printf '%s' -dirty
+	if [ -z "$KBUILD_CONFIG_NO_CHECK_DIRTY" ]; then
+		# Update index only on r/w media
+		[ -w . ] && git update-index --refresh --unmerged > /dev/null
+
+		# Check for uncommitted changes
+		if git diff-index --name-only HEAD \
+		    | grep -v "^scripts/package" \
+		    | read dummy; then
+			printf '%s' -dirty
+		fi
 	fi
 
 	# All done with git
