Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499Ab0AEGDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab0AEGDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 01:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068Ab0AEGDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 01:03:52 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34126 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763Ab0AEGDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 01:03:51 -0500
From: Darren Hart <dvhltc@us.ibm.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: dvhltc@us.ibm.com
Subject: [PATCH] trace-view: consolidate the trace-view-store row access
Date: Mon,  4 Jan 2010 22:03:38 -0800
Message-Id: <1262671418-26446-1-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than provide an accessor function for each field of the row
record in the trace-view-store, simply return the row record and allow
the caller to access the fields directly.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---
 kernel-shark.c     |   10 ++++++----
 trace-view-store.c |   29 ++++-------------------------
 trace-view-store.h |    4 ----
 trace-view.c       |    7 +++++--
 4 files changed, 15 insertions(+), 35 deletions(-)

diff --git a/kernel-shark.c b/kernel-shark.c
index fbc5a5f..a55fc8a 100644
--- a/kernel-shark.c
+++ b/kernel-shark.c
@@ -137,6 +137,7 @@ static void row_double_clicked(GtkTreeView        *treeview,
 			       gpointer            data)
 {
 	struct shark_info *info = data;
+	TraceViewRecord *rec;
 	GtkTreeModel *model;
 	gchar *spath;
 	guint64 time;
@@ -151,7 +152,8 @@ static void row_double_clicked(GtkTreeView        *treeview,
 	row = atoi(spath);
 	g_free(spath);
 
-	time = trace_view_store_get_time_from_row(TRACE_VIEW_STORE(model), row);
+	rec = trace_view_store_get_row(TRACE_VIEW_STORE(model), row);
+	time = rec->timestamp;
 	trace_graph_select_by_time(info->ginfo, time);
 }
 
@@ -220,7 +222,7 @@ do_tree_popup(GtkWidget *widget, GdkEventButton *event, gpointer data)
 	static GtkWidget *menu_filter_add_task;
 	static GtkWidget *menu_filter_clear_tasks;
 	struct record *record;
-	TraceViewStore *store;
+	TraceViewRecord *vrec;
 	GtkTreeSelection *selection;
 	GtkTreeModel *model;
 	GtkTreePath *path;
@@ -281,8 +283,8 @@ do_tree_popup(GtkWidget *widget, GdkEventButton *event, gpointer data)
 		g_free(spath);
 
 		model = gtk_tree_view_get_model(GTK_TREE_VIEW(info->treeview));
-		store = TRACE_VIEW_STORE(model);
-		offset = trace_view_store_get_offset_from_row(store, row);
+		vrec = trace_view_store_get_row(TRACE_VIEW_STORE(model), row);
+		offset = vrec->offset;
 
 		record = tracecmd_read_at(info->handle, offset, &cpu);
 
diff --git a/trace-view-store.c b/trace-view-store.c
index 03664c8..be86662 100644
--- a/trace-view-store.c
+++ b/trace-view-store.c
@@ -1039,37 +1039,16 @@ gint trace_view_store_get_timestamp_page(TraceViewStore *store, guint64 ts)
 	return rec->pos / store->rows_per_page + 1;
 }
 
-guint64 trace_view_store_get_time_from_row(TraceViewStore *store, gint row)
-{
-	g_return_val_if_fail (TRACE_VIEW_IS_LIST (store), 0);
-
-	row += store->start_row;
-
-	g_return_val_if_fail (row >= 0 && row < store->visible_rows, 0);
-
-	return store->rows[row]->timestamp;
-}
-
-guint64 trace_view_store_get_offset_from_row(TraceViewStore *store, gint row)
-{
-	g_return_val_if_fail (TRACE_VIEW_IS_LIST (store), 0);
-
-	row += store->start_row;
-
-	g_return_val_if_fail (row >= 0 && row < store->visible_rows, 0);
-
-	return store->rows[row]->offset;
-}
-
 TraceViewRecord *
 trace_view_store_get_row(TraceViewStore *store, gint row)
 {
 	TraceViewRecord *record;
+	g_return_val_if_fail(TRACE_VIEW_IS_LIST(store), NULL);
 
-	if (row >= store->num_rows || row < 0)
-		return NULL;
+	row += store->start_row;
+	g_return_val_if_fail(row >= store->start_row && row < store->visible_rows, NULL);
 
-	record = store->rows[store->start_row + row];
+	record = store->rows[row];
 	g_assert(record != NULL);
 	g_assert((record->pos - store->start_row) == row);
 	return record;
diff --git a/trace-view-store.h b/trace-view-store.h
index bfa19d9..08caf3f 100644
--- a/trace-view-store.h
+++ b/trace-view-store.h
@@ -117,10 +117,6 @@ gint trace_view_store_get_timestamp_page(TraceViewStore *store, guint64 ts);
 
 gint trace_view_store_get_timestamp_visible_row(TraceViewStore *store, guint64 ts);
 
-guint64 trace_view_store_get_time_from_row(TraceViewStore *store, gint row);
-
-guint64 trace_view_store_get_offset_from_row(TraceViewStore *store, gint row);
-
 void trace_view_store_filter_tasks(TraceViewStore *store, struct filter_task *filter);
 
 TraceViewRecord *trace_view_store_get_row(TraceViewStore *store, gint row);
diff --git a/trace-view.c b/trace-view.c
index 3c023e5..899b3b3 100644
--- a/trace-view.c
+++ b/trace-view.c
@@ -271,6 +271,7 @@ void trace_view_make_selection_visible(GtkWidget *treeview)
 void trace_view_update_task_filter(GtkWidget *treeview, struct filter_task *filter)
 {
 	GtkTreeView *tree = GTK_TREE_VIEW(treeview);
+	TraceViewRecord *vrec;
 	GtkTreeModel *model;
 	guint64 time;
 	gint row;
@@ -281,8 +282,10 @@ void trace_view_update_task_filter(GtkWidget *treeview, struct filter_task *filt
 
 	/* Keep track of the currently selected row */
 	row = trace_view_get_selected_row(treeview);
-	if (row >= 0)
-		time = trace_view_store_get_time_from_row(TRACE_VIEW_STORE(model), row);
+	if (row >= 0) {
+		vrec = trace_view_store_get_row(TRACE_VIEW_STORE(model), row);
+		time = vrec->timestamp;
+	}
 
 	g_object_ref(model);
 	gtk_tree_view_set_model(tree, NULL);
-- 
1.6.3.3

