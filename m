Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360AbZIXIHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbZIXIHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 04:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbZIXIHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 04:07:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:39985 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752116AbZIXIHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 04:07:09 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+rXPdmmm+rTGwMsqb5N/O19tTthk+ie3z9wV4vnQ
	Id8nz60FEc0sGs
Subject: Re: [patch] Re: [perf] Finding uninstalled modules Was Re: mailing
 list for trace users
From: Mike Galbraith <efault@gmx.de>
To: Avi Kivity <avi@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, rostedt@goodmis.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <4ABA3A37.2070108@redhat.com>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>
	 <4AB89520.2050900@redhat.com> <1253618894.13917.18.camel@marge.simson.net>
	 <4AB8B65F.7030602@redhat.com> <1253620041.13917.24.camel@marge.simson.net>
	 <4AB8BA37.4010305@redhat.com> <20090922201746.GH5216@ghostprotocols.net>
	 <4AB9DCC8.5050603@redhat.com> <1253697658.11461.36.camel@marge.simson.net>
	 <4AB9F08E.1020106@redhat.com> <1253705515.7835.41.camel@marge.simson.net>
	 <4ABA1B75.7040900@redhat.com>  <4ABA1E3B.40800@redhat.com>
	 <1253713800.7816.15.camel@marge.simson.net>  <4ABA2A0B.1010103@redhat.com>
	 <1253714972.7816.23.camel@marge.simson.net>  <4ABA3321.9090503@redhat.com>
	 <1253717548.7816.34.camel@marge.simson.net>  <4ABA3732.3040907@redhat.com>
	 <1253718323.7816.42.camel@marge.simson.net>  <4ABA3A37.2070108@redhat.com>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 10:07:08 +0200
Message-Id: <1253779628.10513.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 18:09 +0300, Avi Kivity wrote:
> On 09/23/2009 06:05 PM, Mike Galbraith wrote:
> >
> > So, I just need to check whether it's full path or not, prepend or take
> > the path as is, and hope there aren't several other ways to get screwed
> > up by modules.dep content.
> >    
> 
> Maybe we should fix that then (though I prefer relative paths myself).

Ok, the below should (knock wood) handle your relative paths.  May look
a little overly paranoid, but it's not... they _are_ out to get me ;-)

perf_counter tools: handle relative paths while loading module symbols.

Inform util/module.c::mod_dso__load_module_paths() that relative paths do exist
in some modules.dep, and make it fail noisily should it encounter a path that it
doesn't understand, or a module it cannot open.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reported-by: Avi Kivity <avi@redhat.com>
LKML-Reference: <new-submission>

---
 tools/perf/util/module.c |  100 +++++++++++++++++++++++++++++++----------------
 1 file changed, 67 insertions(+), 33 deletions(-)

Index: linux-2.6/tools/perf/util/module.c
===================================================================
--- linux-2.6.orig/tools/perf/util/module.c
+++ linux-2.6/tools/perf/util/module.c
@@ -4,6 +4,7 @@
 #include "module.h"
 
 #include <libelf.h>
+#include <libgen.h>
 #include <gelf.h>
 #include <elf.h>
 #include <dirent.h>
@@ -409,35 +410,40 @@ out_failure:
 static int mod_dso__load_module_paths(struct mod_dso *self)
 {
 	struct utsname uts;
-	int count = 0, len;
+	int count = 0, len, err = -1;
 	char *line = NULL;
 	FILE *file;
-	char *path;
+	char *dpath, *dir;
 	size_t n;
 
 	if (uname(&uts) < 0)
-		goto out_failure;
+		return err;
 
 	len = strlen("/lib/modules/");
 	len += strlen(uts.release);
 	len += strlen("/modules.dep");
 
-	path = calloc(1, len);
-	if (path == NULL)
-		goto out_failure;
-
-	strcat(path, "/lib/modules/");
-	strcat(path, uts.release);
-	strcat(path, "/modules.dep");
+	dpath = calloc(1, len);
+	if (dpath == NULL)
+		return err;
+
+	strcat(dpath, "/lib/modules/");
+	strcat(dpath, uts.release);
+	strcat(dpath, "/modules.dep");
 
-	file = fopen(path, "r");
-	free(path);
+	file = fopen(dpath, "r");
 	if (file == NULL)
 		goto out_failure;
 
+	dir = dirname(dpath);
+	if (!dir)
+		goto out_failure;
+	strcat(dir, "/");
+
 	while (!feof(file)) {
-		char *name, *tmp;
 		struct module *module;
+		char *name, *path, *tmp;
+		FILE *modfile;
 		int line_len;
 
 		line_len = getline(&line, &n, file);
@@ -445,44 +451,65 @@ static int mod_dso__load_module_paths(st
 			break;
 
 		if (!line)
-			goto out_failure;
+			break;
 
 		line[--line_len] = '\0'; /* \n */
 
-		path = strtok(line, ":");
+		path = strchr(line, ':');
 		if (!path)
-			goto out_failure;
+			break;
+		*path = '\0';
 
-		name = strdup(path);
-		name = strtok(name, "/");
+		path = strdup(line);
+		if (!path)
+			break;
 
-		tmp = name;
+		if (!strstr(path, dir)) {
+			if (strncmp(path, "kernel/", 7))
+				break;
+
+			free(path);
+			path = calloc(1, strlen(dir) + strlen(line) + 1);
+			if (!path)
+				break;
+			strcat(path, dir);
+			strcat(path, line);
+		}
+
+		modfile = fopen(path, "r");
+		if (modfile == NULL)
+			break;
+		fclose(modfile);
+
+		name = strdup(path);
+		if (!name)
+			break;
+		tmp = name = strtok(name, "/");
 
 		while (tmp) {
 			tmp = strtok(NULL, "/");
 			if (tmp)
 				name = tmp;
 		}
+
 		name = strsep(&name, ".");
+		if (!name)
+			break;
 
-		/* Quirk: replace '-' with '_' in sound modules */
+		/* Quirk: replace '-' with '_' in all modules */
 		for (len = strlen(name); len; len--) {
 			if (*(name+len) == '-')
 				*(name+len) = '_';
 		}
 
 		module = module__new(name, path);
-		if (!module) {
-			fprintf(stderr, "load_module_paths: allocation error\n");
-			goto out_failure;
-		}
+		if (!module)
+			break;
 		mod_dso__insert_module(self, module);
 
 		module->sections = sec_dso__new_dso("sections");
-		if (!module->sections) {
-			fprintf(stderr, "load_module_paths: allocation error\n");
-			goto out_failure;
-		}
+		if (!module->sections)
+			break;
 
 		module->active = mod_dso__load_sections(module);
 
@@ -490,13 +517,20 @@ static int mod_dso__load_module_paths(st
 			count++;
 	}
 
-	free(line);
-	fclose(file);
-
-	return count;
+	if(feof(file))
+		err = count;
+	else
+		fprintf(stderr, "load_module_paths: modules.dep parse failure!\n");
 
 out_failure:
-	return -1;
+	if (dpath)
+		free(dpath);
+	if (file)
+		fclose(file);
+	if (line)
+		free(line);
+
+	return err;
 }
 
 int mod_dso__load_modules(struct mod_dso *dso)


