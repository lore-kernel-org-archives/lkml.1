Return-Path: <linux-kernel-owner+w=401wt.eu-S1761162AbXEJTjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761162AbXEJTjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758564AbXEJTjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:39:39 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:34439 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758478AbXEJTji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:39:38 -0400
Date: Thu, 10 May 2007 15:39:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, wfg@ustc.edu
Subject: Re: 2.6.22 -mm merge plans
Message-ID: <20070510193936.GA6320@Krystal>
References: <20070502094707.4197ab7a.akpm@linux-foundation.org> <20070502172934.GA17782@infradead.org> <20070502203627.GA18733@Krystal> <20070502135336.6d6d3569.akpm@linux-foundation.org> <20070502231104.GA26045@Krystal> <20070502162135.f949e371.akpm@linux-foundation.org> <20070503150415.GC26864@Krystal> <20070503151201.GA27281@infradead.org> <20070503171646.GA506@Krystal> <20070503172546.GA13392@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070503172546.GA13392@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 14:40:48 up 97 days,  8:47,  5 users,  load average: 2.14, 2.15, 2.17
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Thu, May 03, 2007 at 01:16:46PM -0400, Mathieu Desnoyers wrote:
> > > kprobes does this kind of synchronization internally, so the marker
> > > wrapper should probabl aswell.
> > > 
> > 
> > The problem appears on heavily loaded systems. Doing 50
> > synchronize_sched() calls in a row can take up to a few seconds on a
> > 4-way machine. This is why I prefer to do it in the module to which
> > the callbacks belong.
> 
> We recently had a discussion on batch unreistration interface for
> kprobes.  I'm not very happy with having so different interfaces for
> different kind of probe registrations.
> 

Ok, I've had a look at the kprobes batch registration mechanisms and..
well, it does not look well suited for the markers. Adding
supplementary data structures such as linked lists of probes does not
look like a good match.

However, I agree with you that providing a similar API is good.

Therefore, here is my proposal :

The goal is to do the synchronize just after we unregister the last
probe handler provided by a given module. Since the unregistration
functions iterate on every marker present in the kernel, we can keep a
count of how many probes provided by the same module are still present.
If we see that we unregistered the last probe pointing to this module,
we issue a synchronize_sched().

It adds no data structure and keeps the same order of complexity as what
is already there, we only have to do 2 passes in the marker structures :
the first one finds the module associated with the callback and the
second disables the callbacks and keep a count of the number of
callbacks associated with the module.

Mathieu

P.S.: here is the code.


Linux Kernel Markers - Architecture Independant code Provide internal
synchronize_sched() in batch.

The goal is to do the synchronize just after we unregister the last
probe handler provided by a given module. Since the unregistration
functions iterate on every marker present in the kernel, we can keep a
count of how many probes provided by the same module are still present.
If we see that we unregistered the last probe pointing to this module,
we issue a synchronize_sched().

It adds no data structure and keeps the same order of complexity as what
is already there, we only have to do 2 passes in the marker structures : 
the first one finds the module associated with the callback and the 
second disables the callbacks and keep a count of the number of
callbacks associated with the module.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 kernel/module.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 52 insertions(+), 10 deletions(-)

Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2007-05-10 14:48:28.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2007-05-10 15:38:27.000000000 -0400
@@ -404,8 +404,12 @@
 }
 
 /* Sets a range of markers to a disabled state : unset the enable bit and
- * provide the empty callback. */
+ * provide the empty callback.
+ * Keep a count of other markers connected to the same module as the one
+ * provided as parameter. */
 static int marker_remove_probe_range(const char *name,
+	struct module *probe_module,
+	int *ref_count,
 	const struct __mark_marker *begin,
 	const struct __mark_marker *end)
 {
@@ -413,12 +417,17 @@
 	int found = 0;
 
 	for (iter = begin; iter < end; iter++) {
-		if (strcmp(name, iter->mdata->name) == 0) {
-			marker_set_enable(iter->enable, 0,
-				iter->mdata->flags);
-			iter->mdata->call = __mark_empty_function;
-			found++;
+		if (strcmp(name, iter->mdata->name) != 0) {
+			if (probe_module)
+				if (__module_text_address(
+					(unsigned long)iter->mdata->call)
+						== probe_module)
+					(*ref_count)++;
+			continue;
 		}
+		marker_set_enable(iter->enable, 0, iter->mdata->flags);
+		iter->mdata->call = __mark_empty_function;
+		found++;
 	}
 	return found;
 }
@@ -450,6 +459,29 @@
 	return found;
 }
 
+/* Get the module to which the probe handler's text belongs.
+ * Called with module_mutex taken.
+ * Returns NULL if the probe handler is not in a module. */
+static struct module *__marker_get_probe_module(const char *name)
+{
+	struct module *mod;
+	const struct __mark_marker *iter;
+
+	list_for_each_entry(mod, &modules, list) {
+		if (mod->taints)
+			continue;
+		for (iter = mod->markers;
+			iter < mod->markers+mod->num_markers; iter++) {
+			if (strcmp(name, iter->mdata->name) != 0)
+				continue;
+			if (iter->mdata->call)
+				return __module_text_address(
+					(unsigned long)iter->mdata->call);
+		}
+	}
+	return NULL;
+}
+
 /* Calls _marker_set_probe_range for the core markers and modules markers.
  * Marker enabling/disabling use the modlist_lock to synchronise. */
 int _marker_set_probe(int flags, const char *name, const char *format,
@@ -477,23 +509,33 @@
 EXPORT_SYMBOL_GPL(_marker_set_probe);
 
 /* Calls _marker_remove_probe_range for the core markers and modules markers.
- * Marker enabling/disabling use the modlist_lock to synchronise. */
+ * Marker enabling/disabling use the modlist_lock to synchronise.
+ * ref_count is the number of markers still connected to the same module
+ * as the one in which sits the probe handler currently removed, excluding the
+ * one currently removed. If the count is 0, we issue a synchronize_sched() to
+ * make sure the module can safely unload. */
 int marker_remove_probe(const char *name)
 {
-	struct module *mod;
+	struct module *mod, *probe_module;
 	int found = 0;
+	int ref_count = 0;
 
 	mutex_lock(&module_mutex);
+	/* In what module is the probe handler ? */
+	probe_module = __marker_get_probe_module(name);
 	/* Core kernel markers */
-	found += marker_remove_probe_range(name,
+	found += marker_remove_probe_range(name, probe_module, &ref_count,
 			__start___markers, __stop___markers);
 	/* Markers in modules. */
 	list_for_each_entry(mod, &modules, list) {
 		if (!mod->taints)
-			found += marker_remove_probe_range(name,
+			found += marker_remove_probe_range(name, probe_module,
+				&ref_count,
 				mod->markers, mod->markers+mod->num_markers);
 	}
 	mutex_unlock(&module_mutex);
+	if (!ref_count)
+		synchronize_sched();
 	return found;
 }
 EXPORT_SYMBOL_GPL(marker_remove_probe);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
