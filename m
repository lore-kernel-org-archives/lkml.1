Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbXDJX31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbXDJX31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 19:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbXDJX31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 19:29:27 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:41321 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753435AbXDJX3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 19:29:25 -0400
Date: Tue, 10 Apr 2007 19:29:24 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] markers-module.c-doc-flags
Message-ID: <20070410232924.GI7092@Krystal>
References: <20070410231126.GC7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070410231126.GC7092@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 19:27:30 up 67 days, 13:34,  6 users,  load average: 1.15, 1.36, 1.74
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation to the module.c marker functions. Update them to
follow the flags modifications.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -303,24 +303,36 @@ static struct module *find_module(const char *name)
 }
 
 #ifdef CONFIG_MARKERS
-void __mark_empty_function(const char *fmt, ...)
+
+/* Empty callback provided as a probe to the markers. By providing this to a
+ * disabled marker, we makes sure the  execution flow is always valid even
+ * though the function pointer change and the marker enabling are two distinct
+ * operations that modifies the execution flow of preemptible code. */
+void __mark_empty_function(const struct __mark_marker_data *mdata,
+	const char *fmt, ...)
 {
 }
 EXPORT_SYMBOL_GPL(__mark_empty_function);
 
+/* Set the enable bit of the marker, choosing the generic or architecture
+ * specific functions depending on the marker's flags.
+ */
 static int marker_set_enable(void *address, char enable, int flags)
 {
-	if (flags & _MF_OPTIMIZED)
+	if (flags & MF_OPTIMIZED)
 		return marker_optimized_set_enable(address, enable);
 	else
 		return marker_generic_set_enable(address, enable);
 }
 
-/* enable and function address are set out of order, and it's ok :
- * the state is always coherent. */
+/* Sets the probe callback and enables the markers corresponding to a range of
+ * markers. The enable bit and function address are set out of order, and it's
+ * ok : the state is always coherent because of the empty callback we provide.
+ */
 static int _marker_set_probe_range(int flags, const char *name,
 	const char *format,
 	marker_probe_func *probe,
+	void *pdata,
 	const struct __mark_marker *begin,
 	const struct __mark_marker *end)
 {
@@ -328,27 +340,27 @@ static int _marker_set_probe_range(int flags, const char *name,
 	int found = 0;
 
 	for (iter = begin; iter < end; iter++) {
-		if (strcmp(name, iter->cmark->name) == 0) {
+		if (strcmp(name, iter->mdata->name) == 0) {
 			if (format
-				&& strcmp(format, iter->cmark->format) != 0) {
+				&& strcmp(format, iter->mdata->format) != 0) {
 				printk(KERN_NOTICE
 					"Format mismatch for probe %s "
 					"(%s), marker (%s)\n",
 					name,
 					format,
-					iter->cmark->format);
+					iter->mdata->format);
 				continue;
 			}
-			if (flags & _MF_LOCKDEP
-				&& !(iter->cmark->flags & _MF_LOCKDEP)) {
+			if (flags & MF_LOCKDEP
+				&& !(iter->mdata->flags & MF_LOCKDEP)) {
 					printk(KERN_NOTICE
 					"Incompatible lockdep flags for "
 					"probe %s\n",
 					name);
 					continue;
 			}
-			if (flags & _MF_PRINTK
-				&& !(iter->cmark->flags & _MF_PRINTK)) {
+			if (flags & MF_PRINTK
+				&& !(iter->mdata->flags & MF_PRINTK)) {
 					printk(KERN_NOTICE
 					"Incompatible printk flags for "
 					"probe %s\n",
@@ -356,32 +368,33 @@ static int _marker_set_probe_range(int flags, const char *name,
 					continue;
 			}
 			if (probe == __mark_empty_function) {
-				if (*iter->cmark->call
+				if (iter->mdata->call
 					!= __mark_empty_function) {
-					*iter->cmark->call =
+					iter->mdata->call =
 						__mark_empty_function;
 				}
 				marker_set_enable(iter->enable, 0,
-					iter->cmark->flags);
+					iter->mdata->flags);
 			} else {
-				if (*iter->cmark->call
+				if (iter->mdata->call
 					!= __mark_empty_function) {
-					if (*iter->cmark->call != probe) {
+					if (iter->mdata->call != probe) {
 						printk(KERN_NOTICE
 							"Marker %s busy, "
 							"probe %p already "
 							"installed\n",
 							name,
-							*iter->cmark->call);
+							iter->mdata->call);
 						continue;
 					}
 				} else {
 					found++;
-					*iter->cmark->call = probe;
+					iter->mdata->call = probe;
 				}
-				/* Can have many enables for one function */
+				iter->mdata->pdata = pdata;
+				smp_wmb();
 				marker_set_enable(iter->enable, 1,
-					iter->cmark->flags);
+					iter->mdata->flags);
 			}
 			found++;
 		}
@@ -389,7 +402,9 @@ static int _marker_set_probe_range(int flags, const char *name,
 	return found;
 }
 
-static int marker_remove_probe_range(marker_probe_func *probe,
+/* Sets a range of markers to a disabled state : unset the enable bit and
+ * provide the empty callback. */
+static int marker_remove_probe_range(const char *name,
 	const struct __mark_marker *begin,
 	const struct __mark_marker *end)
 {
@@ -397,16 +412,19 @@ static int marker_remove_probe_range(marker_probe_func *probe,
 	int found = 0;
 
 	for (iter = begin; iter < end; iter++) {
-		if (*iter->cmark->call == probe) {
+		if (strcmp(name, iter->mdata->name) == 0) {
 			marker_set_enable(iter->enable, 0,
-				iter->cmark->flags);
-			*iter->cmark->call = __mark_empty_function;
+				iter->mdata->flags);
+			iter->mdata->call = __mark_empty_function;
 			found++;
 		}
 	}
 	return found;
 }
 
+/* Provides a listing of the markers present in the kernel with their type
+ * (optimized or generic), state (enabled or disabled), callback and format
+ * string. */
 static int marker_list_probe_range(marker_probe_func *probe,
 	const struct __mark_marker *begin,
 	const struct __mark_marker *end)
@@ -416,23 +434,26 @@ static int marker_list_probe_range(marker_probe_func *probe,
 
 	for (iter = begin; iter < end; iter++) {
 		if (probe)
-			if (probe != *iter->cmark->call) continue;
-		printk("name %s \n", iter->cmark->name);
-		if (iter->cmark->flags & _MF_OPTIMIZED)
+			if (probe != iter->mdata->call) continue;
+		printk("name %s \n", iter->mdata->name);
+		if (iter->mdata->flags & MF_OPTIMIZED)
 			printk("  enable %u optimized ",
 				MARK_OPTIMIZED_ENABLE(iter->enable));
 		else
 			printk("  enable %u generic ",
 				MARK_GENERIC_ENABLE(iter->enable));
 		printk("  func 0x%p format \"%s\"\n",
-			*iter->cmark->call, iter->cmark->format);
+			iter->mdata->call, iter->mdata->format);
 		found++;
 	}
 	return found;
 }
-/* markers use the modlist_lock to to synchronise */
+
+/* Calls _marker_set_probe_range for the core markers and modules markers.
+ * Marker enabling/disabling use the modlist_lock to synchronise. */
 int _marker_set_probe(int flags, const char *name, const char *format,
-				marker_probe_func *probe)
+				marker_probe_func *probe,
+				void *pdata)
 {
 	struct module *mod;
 	int found = 0;
@@ -440,31 +461,35 @@ int _marker_set_probe(int flags, const char *name, const char *format,
 	mutex_lock(&module_mutex);
 	/* Core kernel markers */
 	found += _marker_set_probe_range(flags, name, format, probe,
+			pdata,
 			__start___markers, __stop___markers);
 	/* Markers in modules. */
 	list_for_each_entry(mod, &modules, list) {
 		if (!mod->taints)
 			found += _marker_set_probe_range(flags, name, format,
-			probe, mod->markers, mod->markers+mod->num_markers);
+			probe, pdata,
+			mod->markers, mod->markers+mod->num_markers);
 	}
 	mutex_unlock(&module_mutex);
 	return found;
 }
 EXPORT_SYMBOL_GPL(_marker_set_probe);
 
-int marker_remove_probe(marker_probe_func *probe)
+/* Calls _marker_remove_probe_range for the core markers and modules markers.
+ * Marker enabling/disabling use the modlist_lock to synchronise. */
+int marker_remove_probe(const char *name)
 {
 	struct module *mod;
 	int found = 0;
 
 	mutex_lock(&module_mutex);
 	/* Core kernel markers */
-	found += marker_remove_probe_range(probe,
+	found += marker_remove_probe_range(name,
 			__start___markers, __stop___markers);
 	/* Markers in modules. */
 	list_for_each_entry(mod, &modules, list) {
 		if (!mod->taints)
-			found += marker_remove_probe_range(probe,
+			found += marker_remove_probe_range(name,
 				mod->markers, mod->markers+mod->num_markers);
 	}
 	mutex_unlock(&module_mutex);
@@ -472,6 +497,9 @@ int marker_remove_probe(marker_probe_func *probe)
 }
 EXPORT_SYMBOL_GPL(marker_remove_probe);
 
+/* Calls _marker_list_probe_range for the core markers and modules markers.
+ * Marker listing uses the modlist_lock to synchronise.
+ * TODO : should output this listing to a procfs file. */
 int marker_list_probe(marker_probe_func *probe)
 {
 	struct module *mod;
@@ -1856,6 +1886,8 @@ static struct module *load_module(void __user *umod,
 	unsigned int unusedgplindex;
 	unsigned int unusedgplcrcindex;
 	unsigned int markersindex;
+	unsigned int markersdataindex;
+	unsigned int markersstringsindex;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -1952,7 +1984,10 @@ static struct module *load_module(void __user *umod,
 #ifdef ARCH_UNWIND_SECTION_NAME
 	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
 #endif
-	markersindex = find_sec(hdr, sechdrs, secstrings, ".markers");
+	markersindex = find_sec(hdr, sechdrs, secstrings, "__markers");
+	markersdataindex = find_sec(hdr, sechdrs, secstrings, "__markers_data");
+	markersstringsindex = find_sec(hdr, sechdrs, secstrings,
+				"__markers_strings");
 
 	/* Don't keep modinfo section */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -1966,9 +2001,18 @@ static struct module *load_module(void __user *umod,
 #ifdef CONFIG_MARKERS
 	if (markersindex)
 		sechdrs[markersindex].sh_flags |= SHF_ALLOC;
+	if (markersdataindex)
+		sechdrs[markersdataindex].sh_flags |= SHF_ALLOC;
+	if (markersstringsindex)
+		sechdrs[markersstringsindex].sh_flags |= SHF_ALLOC;
 #else
 	if (markersindex)
 		sechdrs[markersindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
+	if (markersdataindex)
+		sechdrs[markersdataindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
+	if (markersstringsindex)
+		sechdrs[markersstringsindex].sh_flags
+					&= ~(unsigned long)SHF_ALLOC;
 #endif
 
 	/* Check module struct version now, before we try to use module. */
@@ -2622,7 +2668,7 @@ void list_modules(void)
 #ifdef CONFIG_MODULE_UNLOAD
 		refcount = local_read(&mod->ref[0].count);
 #endif //CONFIG_MODULE_UNLOAD
-		MARK(list_modules, "%s %d[enum module_state] %lu",
+		MARK(list_module, "%s %d %lu",
 				mod->name, mod->state, refcount);
 	}
 	mutex_unlock(&module_mutex);
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
