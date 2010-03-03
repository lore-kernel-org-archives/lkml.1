Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab0CCBTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 20:19:00 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39399 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402Ab0CCBS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 20:18:59 -0500
Date: Tue, 2 Mar 2010 17:18:58 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: zippel@linux-m68k.org, mingo@elte.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, geert@linux-m68k.org, elendil@planet.nl,
       cloos@jhcloos.com
Subject: [PATCH] kconfig: place git SHA1 in .config output if in SCM
Message-ID: <20100303011858.GA17651@linux.vnet.ibm.com>
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

This version of the patch incorporates feedback from Geert Uytterhoeven,
Linus Torvalds, Frans Pop, and James Cloos:

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
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Frans Pop <elendil@planet.nl>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 confdata.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index c4dec80..ea7e750 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -399,10 +399,12 @@ int conf_read(const char *name)
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
@@ -450,12 +452,28 @@ int conf_write(const char *name)
 	if (env && *env)
 		use_timestamp = 0;
 
+	localversion[0] = '\0';
+	if (getenv("KBUILD_CONFIG_LOCALVERSION")) {
+		env = getenv(SRCTREE);
+		if (env) {
+			sprintf(cmdline,
+				"%s/scripts/setlocalversion %s 2> /dev/null",
+				env, env);
+			slv = popen(cmdline, "r");
+			if (slv != NULL) {
+				fscanf(slv, " %127s ", localversion);
+				pclose(slv);
+			}
+		}
+	}
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
 
