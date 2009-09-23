Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZIWJVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZIWJVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 05:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbZIWJVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 05:21:02 -0400
Received: from mail.gmx.net ([213.165.64.20]:50514 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753215AbZIWJU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 05:20:58 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX186RMQ6QFQ6CL6zpJIxL9JqC0TIvDTqAfcKvvkXYV
	F1TJhJB4IoPq8g
Subject: [patch] Re: [perf] Finding uninstalled modules Was Re: mailing
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
In-Reply-To: <4AB9DCC8.5050603@redhat.com>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>
	 <4AB89520.2050900@redhat.com> <1253618894.13917.18.camel@marge.simson.net>
	 <4AB8B65F.7030602@redhat.com> <1253620041.13917.24.camel@marge.simson.net>
	 <4AB8BA37.4010305@redhat.com> <20090922201746.GH5216@ghostprotocols.net>
	 <4AB9DCC8.5050603@redhat.com>
Content-Type: text/plain
Date: Wed, 23 Sep 2009 11:20:58 +0200
Message-Id: <1253697658.11461.36.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 11:31 +0300, Avi Kivity wrote:
> On 09/22/2009 11:17 PM, Arnaldo Carvalho de Melo wrote:
> >
> >> $ perf annotate -v -v -k ~avi/kvm/linux-2.6/vmlinux -m vmx_vcpu_run  |
> >>      
> > Here is the problem, he is passing a vmlinux, that way we don't parse
> > /proc/kallsyms, so no module symbols, he uses -m to load the modules
> > symbols but mod_dso__load_module_paths only looks at /lib/modules/, i.e.
> > installed modules.
> >
> > I guess Avi hasn't installed modules, right? So the right fix for this
> > case is to figure out where modules are from the path given to -k, i.e.
> > we first use ~avi/kvm/linux-2.6/ as the modules path prefix and then
> > fallback to /lib/modules if we can't find modules there, right?
> >    
> 
> Modules were installed (I always load them with modprobe).  It's 
> possible that the installed modules were a later version than the loaded 
> modules, but Mike's reply leads me to believe there was a real bug there.

Yup, brown baggie variety.  Oh darn.

perf_counter tools: fix brown baggie module symbol loading bug.

If there are no modules currently loaded, or the last module scanned is not
loaded, dso__load_modules() steps on the value from dso__load_vmlinux(), so
we happily load the kallsyms symbols on top of what we've already loaded.

Fix that such that the total count of symbols loaded is returned.  Should
module symbol load fail after parsing of vmlinux, is's a hard failure, so
do not silently fall-back to kallsyms.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

 tools/perf/util/symbol.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index fd3d9c8..559fb06 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -833,7 +833,7 @@ int dso__load_modules(struct dso *self, symbol_filter_t filter, int v)
 	struct mod_dso *mods = mod_dso__new_dso("modules");
 	struct module *pos;
 	struct rb_node *next;
-	int err;
+	int err, count = 0;
 
 	err = mod_dso__load_modules(mods);
 
@@ -852,14 +852,16 @@ int dso__load_modules(struct dso *self, symbol_filter_t filter, int v)
 			break;
 
 		next = rb_next(&pos->rb_node);
+		count += err;
 	}
 
 	if (err < 0) {
 		mod_dso__delete_modules(mods);
 		mod_dso__delete_self(mods);
+		return err;
 	}
 
-	return err;
+	return count;
 }
 
 static inline void dso__fill_symbol_holes(struct dso *self)
@@ -913,8 +915,15 @@ int dso__load_kernel(struct dso *self, const char *vmlinux,
 
 	if (vmlinux) {
 		err = dso__load_vmlinux(self, vmlinux, filter, v);
-		if (err > 0 && use_modules)
-			err = dso__load_modules(self, filter, v);
+		if (err > 0 && use_modules) {
+			int syms = dso__load_modules(self, filter, v);
+
+			if (syms < 0) {
+				fprintf(stderr, "dso__load_modules failed!\n");
+				return syms;
+			}
+			err += syms;
+		}
 	}
 
 	if (err <= 0)


