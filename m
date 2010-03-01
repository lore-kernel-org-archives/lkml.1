Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0CAEWr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 23:22:47 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41321 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab0CAEWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 23:22:46 -0500
Date: Sun, 28 Feb 2010 20:22:49 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: zippel@linux-m68k.org, mingo@elte.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: [PATCH RFC] kconfig: place git SHA1 in .config output if in git
	tree
Message-ID: <20100301042249.GA12289@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch appends the SHA1 hash of the current git tree to the
kernel version line, or "[Not git tree]" if run from a non-git tree.
Uses "git log" to print the hash.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 confdata.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index c4dec80..4bd7842 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -399,10 +399,11 @@ int conf_read(const char *name)
 int conf_write(const char *name)
 {
 	FILE *out;
+	FILE *git;
 	struct symbol *sym;
 	struct menu *menu;
 	const char *basename;
-	char dirname[128], tmpname[128], newname[128];
+	char dirname[128], tmpname[128], newname[128], gitsha[128];
 	int type, l;
 	const char *str;
 	time_t now;
@@ -450,12 +451,20 @@ int conf_write(const char *name)
 	if (env && *env)
 		use_timestamp = 0;
 
+	gitsha[0] = '\0';
+	git = popen("git log --pretty=format:%h -1 2> /dev/null", "r");
+	if (git != NULL) {
+		fscanf(git, " %127s ", gitsha);
+		pclose(git);
+	}
+
 	fprintf(out, _("#\n"
 		       "# Automatically generated make config: don't edit\n"
-		       "# Linux kernel version: %s\n"
+		       "# Linux kernel version: %s %s\n"
 		       "%s%s"
 		       "#\n"),
 		     sym_get_string_value(sym),
+		     gitsha[0] == '\0' ? "[Not git tree]" : gitsha,
 		     use_timestamp ? "# " : "",
 		     use_timestamp ? ctime(&now) : "");
 
