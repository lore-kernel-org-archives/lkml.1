Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbYEETtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbYEETtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbYEETs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:48:56 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38774 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbYEETsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:48:55 -0400
Date: Mon, 5 May 2008 21:49:29 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sergio Luis <sergio@uece.br>, Parag Warudkar <parag.warudkar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "akpm@osdl.org" <akpm@osdl.org>, Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Dave Jones <davej@redhat.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [PATCH] kconfig: add support for stdin (make K=- ...)
Message-ID: <20080505194929.GA8868@uranus.ravnborg.org>
References: <82e4877d0805031742o464dd581wd93173d79705ce0d@mail.gmail.com> <20080504092417.GA3425@elte.hu> <82e4877d0805050814j721ae522k84384df48c9f4336@mail.gmail.com> <20080505171501.GA22332@elte.hu> <20080505182427.GA2025@uranus.ravnborg.org> <ce0170d90805051136w2f016c15p575623d33c220ddf@mail.gmail.com> <20080505184538.GE22332@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505184538.GE22332@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 08:45:38PM +0200, Ingo Molnar wrote:
> 
> * Sergio Luis <sergio@uece.br> wrote:
> 
> > >  In latest kbuild.git I've added a new feature.
> > >
> > >         make K=.config alldefconfig
> > >
> > >  would give you eaxtly what you request here.
> > >  K= is used to say where to locate the base-configuration.
> 
> > Can I specify /proc/config.gz (gzipped) in the K parameter?
> > -sergio
> 
> i think the 'natural' script behavior would be for this to do the right 
> thing:
> 
>    zcat /proc/config.gz | make K=- alldefconfig
> 
> or something like that - so that it can be scripted in a pipe.

I like this ;-)
So I implemented support for stdin - see attached.
It is also in kbuild.git.

	Sam

commit 95ee7b97051dcc4b61d1dbf626e9b32266cb402d
Author: Sam Ravnborg <sam@ravnborg.org>
Date:   Mon May 5 21:44:21 2008 +0200

    kconfig: add support for stdin (make K=- ...)
    
    With support for stdin we can now say:
    
       zcat /proc/config.gz | make K=- alldefconfig
    
    Which will give us a configuration based on the
    running kernel with all new values set to default.
    
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

diff --git a/scripts/kconfig/aconf.c b/scripts/kconfig/aconf.c
index cf05861..54ffd72 100644
--- a/scripts/kconfig/aconf.c
+++ b/scripts/kconfig/aconf.c
@@ -248,6 +248,7 @@ static void usage(void)
 
 int main(int ac, char **av)
 {
+	char *config_filename;
 	char *config_file = NULL;
 	char *kconfig_file = NULL;
 	struct stat tmpstat;
@@ -287,19 +288,26 @@ int main(int ac, char **av)
 	}
 	conf_parse(kconfig_file);
 	/* debug: zconfdump(stdout); */
-	if (config_file && stat(config_file, &tmpstat)) {
-		fprintf(stderr, _("%s: failed to open %s\n"),
-		        av[0], config_file);
-		exit(1);
+	if (strcmp(config_file, "-")) {
+		if (config_file && stat(config_file, &tmpstat)) {
+			fprintf(stderr, _("%s: failed to open %s\n"),
+			        av[0], config_file);
+			exit(1);
+		}
+		config_filename = config_file;
+	} else {
+		config_filename = "stdin";
 	}
+
 	if (config_file && conf_read_simple(config_file, S_DEF_USER)) {
 		fprintf(stderr, _("%s: failed to read %s\n"),
-		        av[0], config_file);
+		        av[0], config_filename);
 		exit(1);
 	}
 	if (config_file) {
 		printf("#\n");
-		printf(_("# configuration is based on '%s'\n"), config_file);
+		printf(_("# configuration is based on '%s'\n"),
+		       config_filename);
 	}
 	/* generate the config */
 	do {
diff --git a/scripts/kconfig/lex.zconf.c_shipped b/scripts/kconfig/lex.zconf.c_shipped
index 6a61cee..7bd00d3 100644
--- a/scripts/kconfig/lex.zconf.c_shipped
+++ b/scripts/kconfig/lex.zconf.c_shipped
@@ -2268,13 +2268,17 @@ FILE *zconf_fopen(const char *name)
 	char *env, fullname[PATH_MAX+1];
 	FILE *f;
 
-	f = fopen(name, "r");
-	if (!f && name != NULL && name[0] != '/') {
-		env = getenv(SRCTREE);
-		if (env) {
-			sprintf(fullname, "%s/%s", env, name);
-			f = fopen(fullname, "r");
+	if (strcmp(name, "-")) {
+		f = fopen(name, "r");
+		if (!f && name != NULL && name[0] != '/') {
+			env = getenv(SRCTREE);
+			if (env) {
+				sprintf(fullname, "%s/%s", env, name);
+				f = fopen(fullname, "r");
+			}
 		}
+	} else {
+		f = stdin;
 	}
 	return f;
 }
diff --git a/scripts/kconfig/zconf.l b/scripts/kconfig/zconf.l
index 4cea5c8..a268d88 100644
--- a/scripts/kconfig/zconf.l
+++ b/scripts/kconfig/zconf.l
@@ -269,13 +269,17 @@ FILE *zconf_fopen(const char *name)
 	char *env, fullname[PATH_MAX+1];
 	FILE *f;
 
-	f = fopen(name, "r");
-	if (!f && name != NULL && name[0] != '/') {
-		env = getenv(SRCTREE);
-		if (env) {
-			sprintf(fullname, "%s/%s", env, name);
-			f = fopen(fullname, "r");
+	if (strcmp(name, "-")) {
+		f = fopen(name, "r");
+		if (!f && name != NULL && name[0] != '/') {
+			env = getenv(SRCTREE);
+			if (env) {
+				sprintf(fullname, "%s/%s", env, name);
+				f = fopen(fullname, "r");
+			}
 		}
+	} else {
+		f = stdin;
 	}
 	return f;
 }
