Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab0CASQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:16:21 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54090 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab0CASQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:16:19 -0500
Date: Mon, 1 Mar 2010 10:16:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frans Pop <elendil@planet.nl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, mingo@elte.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH RFC] kconfig: place git SHA1 in .config output if in
	git tree
Message-ID: <20100301181616.GD6758@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100301042249.GA12289@linux.vnet.ibm.com> <10f740e81003010210k3de9851fuf9f67f55b08af4f1@mail.gmail.com> <20100301162733.GB6758@linux.vnet.ibm.com> <201003011753.34299.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003011753.34299.elendil@planet.nl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 05:53:32PM +0100, Frans Pop wrote:
> On Monday 01 March 2010, Paul E. McKenney wrote:
> > Here is the updated patch.  Thoughts?
> 
> AFAICT that still won't work with KBUILD_OUTPUT as you're not passing the 
> source tree directory to the script. So it will default to "." and when 
> KBUILD_OUTPUT is used that is not the source tree but the target tree (and 
> thus not under git).

Hmmm...  In that case, it won't find the scripts/setlocalversion script,
either.  Unless you have the git tree on your $PATH, which seems
unlikely.  So I can just check for popen() failure and take corrective
action.

Taking a look at conf_get_default_confname(), it looks like one approach
would be to prepend getenv(SRCTREE) to the name of the script and also
pass this to the script.  Will that work for your setup?  If so, please
see below for the updated patch.

							Thanx, Paul

------------------------------------------------------------------------

[PATCH RFC] kconfig: place localversion string in .config output

This patch appends the localversion string to the Linux kernel version.
For example, in a git tree with uncommitted changes, the .config file
might start as follows:

# Automatically generated make config: don't edit
# Linux kernel version: 2.6.33-01836-g90a6501-dirty
# Mon Mar  1 08:21:49 2010

This patch uses the scripts/setlocalversion output, so similar output
is also generated for svn and mercurial.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Frans Pop <elendil@planet.nl>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 confdata.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index c4dec80..4c28ea5 100644
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
@@ -450,12 +452,27 @@ int conf_write(const char *name)
 	if (env && *env)
 		use_timestamp = 0;
 
+	localversion[0] = '\0';
+	slv = popen("scripts/setlocalversion 2> /dev/null", "r");
+	if (slv == NULL) {
+		env = getenv(SRCTREE);
+		if (env) {
+			sprintf(cmdline, "%s/scripts/setlocalversion %s 2> /dev/null", env, env);
+			slv = popen(cmdline, "r");
+		}
+	}
+	if (slv != NULL) {
+		fscanf(slv, " %127s ", localversion);
+		pclose(slv);
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
 
