Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbZCEXeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbZCEXeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756304AbZCEXeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:34:08 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:37010 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756505AbZCEXeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:34:06 -0500
Message-Id: <20090305225516.602698557@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:47:50 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jan Kiszka <jan.kiszka@siemens.com>
Subject: [RFC patch 22/41] LTTng marker control
Content-Disposition: inline; filename=lttng-marker-control.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marker control. Depends on LTT to assign numeric IDs to markers. Used by the
following ltt trace control module which exports these interfaces through
debugfs.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jan Kiszka <jan.kiszka@siemens.com>
---
 ltt/ltt-marker-control.c |  265 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 265 insertions(+)

Index: linux-2.6-lttng/ltt/ltt-marker-control.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/ltt/ltt-marker-control.c	2009-02-06 18:15:14.000000000 -0500
@@ -0,0 +1,265 @@
+/*
+ * Copyright (C) 2007 Mathieu Desnoyers
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/stat.h>
+#include <linux/vmalloc.h>
+#include <linux/marker.h>
+#include <linux/ltt-tracer.h>
+#include <linux/uaccess.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+
+#define DEFAULT_CHANNEL "cpu"
+#define DEFAULT_PROBE "default"
+
+LIST_HEAD(probes_list);
+
+/*
+ * Mutex protecting the probe slab cache.
+ * Nests inside the traces mutex.
+ */
+DEFINE_MUTEX(probes_mutex);
+
+struct ltt_available_probe default_probe = {
+	.name = "default",
+	.format = NULL,
+	.probe_func = ltt_vtrace,
+	.callbacks[0] = ltt_serialize_data,
+};
+
+static struct kmem_cache *markers_loaded_cachep;
+static LIST_HEAD(markers_loaded_list);
+/*
+ * List sorted by name strcmp order.
+ */
+static LIST_HEAD(probes_registered_list);
+
+static struct ltt_available_probe *get_probe_from_name(const char *pname)
+{
+	struct ltt_available_probe *iter;
+	int comparison, found = 0;
+
+	if (!pname)
+		pname = DEFAULT_PROBE;
+	list_for_each_entry(iter, &probes_registered_list, node) {
+		comparison = strcmp(pname, iter->name);
+		if (!comparison)
+			found = 1;
+		if (comparison <= 0)
+			break;
+	}
+	if (found)
+		return iter;
+	else
+		return NULL;
+}
+
+int ltt_probe_register(struct ltt_available_probe *pdata)
+{
+	int ret = 0;
+	int comparison;
+	struct ltt_available_probe *iter;
+
+	mutex_lock(&probes_mutex);
+	list_for_each_entry_reverse(iter, &probes_registered_list, node) {
+		comparison = strcmp(pdata->name, iter->name);
+		if (!comparison) {
+			ret = -EBUSY;
+			goto end;
+		} else if (comparison > 0) {
+			/* We belong to the location right after iter. */
+			list_add(&pdata->node, &iter->node);
+			goto end;
+		}
+	}
+	/* Should be added at the head of the list */
+	list_add(&pdata->node, &probes_registered_list);
+end:
+	mutex_unlock(&probes_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ltt_probe_register);
+
+/*
+ * Called when a probe does not want to be called anymore.
+ */
+int ltt_probe_unregister(struct ltt_available_probe *pdata)
+{
+	int ret = 0;
+	struct ltt_active_marker *amark, *tmp;
+
+	mutex_lock(&probes_mutex);
+	list_for_each_entry_safe(amark, tmp, &markers_loaded_list, node) {
+		if (amark->probe == pdata) {
+			ret = marker_probe_unregister_private_data(
+				pdata->probe_func, amark);
+			if (ret)
+				goto end;
+			list_del(&amark->node);
+			kmem_cache_free(markers_loaded_cachep, amark);
+		}
+	}
+	list_del(&pdata->node);
+end:
+	mutex_unlock(&probes_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ltt_probe_unregister);
+
+/*
+ * Connect marker "mname" to probe "pname".
+ * Only allow _only_ probe instance to be connected to a marker.
+ */
+int ltt_marker_connect(const char *channel, const char *mname,
+		       const char *pname)
+
+{
+	int ret;
+	struct ltt_active_marker *pdata;
+	struct ltt_available_probe *probe;
+
+	ltt_lock_traces();
+	mutex_lock(&probes_mutex);
+	probe = get_probe_from_name(pname);
+	if (!probe) {
+		ret = -ENOENT;
+		goto end;
+	}
+	pdata = marker_get_private_data(channel, mname, probe->probe_func, 0);
+	if (pdata && !IS_ERR(pdata)) {
+		ret = -EEXIST;
+		goto end;
+	}
+	pdata = kmem_cache_zalloc(markers_loaded_cachep, GFP_KERNEL);
+	if (!pdata) {
+		ret = -ENOMEM;
+		goto end;
+	}
+	pdata->probe = probe;
+	/*
+	 * ID has priority over channel in case of conflict.
+	 */
+	ret = marker_probe_register(channel, mname, NULL,
+		probe->probe_func, pdata);
+	if (ret)
+		kmem_cache_free(markers_loaded_cachep, pdata);
+	else
+		list_add(&pdata->node, &markers_loaded_list);
+end:
+	mutex_unlock(&probes_mutex);
+	ltt_unlock_traces();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ltt_marker_connect);
+
+/*
+ * Disconnect marker "mname", probe "pname".
+ */
+int ltt_marker_disconnect(const char *channel, const char *mname,
+			  const char *pname)
+{
+	struct ltt_active_marker *pdata;
+	struct ltt_available_probe *probe;
+	int ret = 0;
+
+	mutex_lock(&probes_mutex);
+	probe = get_probe_from_name(pname);
+	if (!probe) {
+		ret = -ENOENT;
+		goto end;
+	}
+	pdata = marker_get_private_data(channel, mname, probe->probe_func, 0);
+	if (IS_ERR(pdata)) {
+		ret = PTR_ERR(pdata);
+		goto end;
+	} else if (!pdata) {
+		/*
+		 * Not registered by us.
+		 */
+		ret = -EPERM;
+		goto end;
+	}
+	ret = marker_probe_unregister(channel, mname, probe->probe_func, pdata);
+	if (ret)
+		goto end;
+	else {
+		list_del(&pdata->node);
+		kmem_cache_free(markers_loaded_cachep, pdata);
+	}
+end:
+	mutex_unlock(&probes_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ltt_marker_disconnect);
+
+static void disconnect_all_markers(void)
+{
+	struct ltt_active_marker *pdata, *tmp;
+
+	list_for_each_entry_safe(pdata, tmp, &markers_loaded_list, node) {
+		marker_probe_unregister_private_data(pdata->probe->probe_func,
+			pdata);
+		list_del(&pdata->node);
+		kmem_cache_free(markers_loaded_cachep, pdata);
+	}
+}
+
+static int __init marker_control_init(void)
+{
+	int ret;
+
+	markers_loaded_cachep = KMEM_CACHE(ltt_active_marker, 0);
+
+	ret = ltt_probe_register(&default_probe);
+	BUG_ON(ret);
+	ret = ltt_marker_connect("metadata", "core_marker_format",
+				 DEFAULT_PROBE);
+	BUG_ON(ret);
+	ret = ltt_marker_connect("metadata", "core_marker_id", DEFAULT_PROBE);
+	BUG_ON(ret);
+
+	return 0;
+}
+module_init(marker_control_init);
+
+static void __exit marker_control_exit(void)
+{
+	int ret;
+
+	ret = ltt_marker_disconnect("metadata", "core_marker_format",
+				    DEFAULT_PROBE);
+	BUG_ON(ret);
+	ret = ltt_marker_disconnect("metadata", "core_marker_id",
+				    DEFAULT_PROBE);
+	BUG_ON(ret);
+	ret = ltt_probe_unregister(&default_probe);
+	BUG_ON(ret);
+	disconnect_all_markers();
+	kmem_cache_destroy(markers_loaded_cachep);
+	marker_synchronize_unregister();
+}
+module_exit(marker_control_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("Linux Trace Toolkit Marker Control");

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
