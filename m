Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab0CBBQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 20:16:36 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56676 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab0CBBQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 20:16:34 -0500
Date: Mon, 1 Mar 2010 17:16:33 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frans Pop <elendil@planet.nl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, mingo@elte.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH RFC] kconfig: place git SHA1 in .config output if in
	git tree
Message-ID: <20100302011633.GJ6758@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100301042249.GA12289@linux.vnet.ibm.com> <201003011753.34299.elendil@planet.nl> <20100301181616.GD6758@linux.vnet.ibm.com> <201003012129.36937.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201003012129.36937.elendil@planet.nl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 09:29:35PM +0100, Frans Pop wrote:
> On Monday 01 March 2010, Paul E. McKenney wrote:
> > Hmmm...  In that case, it won't find the scripts/setlocalversion script,
> > either.  Unless you have the git tree on your $PATH, which seems
> > unlikely.  So I can just check for popen() failure and take corrective
> > action.
> 
> It doesn't work for me yet, but I don't see why not. It does work when I do 
> e.g. a 'make defconfig' in the current directory, but not when I set 
> KBUILD_OUTPUT.

Sigh!  Because popen() doesn't fail when the command is bogus, it seems.
I now do stat() to check for it existing, and that seems to handle the
remote-output case.

> It's probably easiest if you try to debug it yourself. It's as simple as:
> $ mkdir /tmp/kbuild
> $ KBUILD_OUTPUT=/tmp/kbuild make defconfig

Thank you!!!

> One other thing. I wonder if this implementation will always reliably 
> result in the *current* SHA1 being included in the .config. AFAICT 
> the .config only actually gets written if there are changes, or if you 
> explicitly do a 'make oldconfig'.
> 
> But if you e.g. pull a stable update and just run 'make', the .config will 
> likely remain unchanged and will thus still contain the SHA1 from a 
> previous build.

Good point.  But the same is true of the Linux kernel version
identifier, right?

Anyway, here is the updated patch.

							Thanx, Paul

------------------------------------------------------------------------

kconfig: place localversion string in .config output

This patch appends the localversion string to the Linux kernel version.
For example, in a git tree with uncommitted changes, the .config file
might start as follows (but with leading hash marks):

	Automatically generated make config: don't edit
	Linux kernel version: 2.6.33-01836-g90a6501-dirty
	Mon Mar  1 17:05:59 2010

This patch uses the scripts/setlocalversion output, so similar output
is also generated for svn and mercurial.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Frans Pop <elendil@planet.nl>
Signed-off-by: Paul E.  McKenney <paulmck@linux.vnet.ibm.com>
---

 confdata.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index c4dec80..6c067ab 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -399,15 +399,18 @@ int conf_read(const char *name)
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
 	char *env;
+	struct stat statbuf;
 
 	dirname[0] = 0;
 	if (name && name[0]) {
@@ -450,12 +453,27 @@ int conf_write(const char *name)
 	if (env && *env)
 		use_timestamp = 0;
 
+	localversion[0] = '\0';
+	strcpy(cmdline, "scripts/setlocalversion 2> /dev/null");
+	if (stat("scripts/setlocalversion", &statbuf) != 0) {
+		env = getenv("KBUILD_SRC");
+		if (env) {
+			sprintf(cmdline, "%s/scripts/setlocalversion %s 2> /dev/null", env, env);
+		}
+	}
+	slv = popen(cmdline, "r");
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
 
