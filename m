Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbZLaBPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbZLaBPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 20:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbZLaBPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 20:15:51 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48611 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbZLaBPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 20:15:50 -0500
Message-ID: <4B3BFB43.8020304@us.ibm.com>
Date: Wed, 30 Dec 2009 17:15:47 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       "lkml, " <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] trace-view: Self-adjusting fixed width trace-view
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven,

Please pull the latest for-rostedt/trace-view git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/dvhart/trace-cmd.git for-rostedt/trace-view


>From 358e0e5121098fac9eda8637def53233b5c7a905 Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhltc@us.ibm.com>
Date: Wed, 30 Dec 2009 11:09:53 -0800
Subject: [PATCH] trace-view: Self-adjusting fixed width trace-view

By using fixed width columns and fixed height rows, the view can now
render over 400k events without any noticable lag. This makes it so
large traces can now be viewed in one "page" of the trace-view-model.

The new trace-view-data-func() is called when the view wants to render
cell (which it only has to do when it's visible now that we use fixed
sizings). Here we check the string width in pixels and resize the column
if necessary. By tracking the max character width of each column, we can
avoid doing the expensive Pango pixel width test as often. By adding a
little extra padding, we anticipate one more character, further reducing
the overhead. The first full scroll down and up shows no noticable lag
due to these calculations once the optimizations were implemented.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---
 trace-view-store.h |    2 +-
 trace-view.c       |  149 ++++++++++++++++++++++++++++++++-------------------
 2 files changed, 94 insertions(+), 57 deletions(-)

diff --git a/trace-view-store.h b/trace-view-store.h
index db755d5..35f1193 100644
--- a/trace-view-store.h
+++ b/trace-view-store.h
@@ -128,7 +128,7 @@ GType		trace_view_store_get_type (void);
 
 TraceViewStore	*trace_view_store_new (struct tracecmd_input *handle);
 
-#define TRACE_VIEW_DEFAULT_MAX_ROWS 1000
+#define TRACE_VIEW_DEFAULT_MAX_ROWS 1000000
 
 #if 0
 void		trace_view_store_append_record (TraceViewStore   *trace_view_store,
diff --git a/trace-view.c b/trace-view.c
index dadf35c..2fffc21 100644
--- a/trace-view.c
+++ b/trace-view.c
@@ -22,6 +22,7 @@
 #include <string.h>
 #include <stdarg.h>
 #include <gtk/gtk.h>
+#include <glib-object.h>
 
 #include "trace-cmd.h"
 #include "trace-local.h"
@@ -39,6 +40,29 @@ enum {
 	NUM_COLS
 };
 
+static char* col_labels[] = {
+	"#",
+	"CPU",
+	"Time Stamp",
+	"Task",
+	"PID",
+	"Latency",
+	"Event",
+	"Info",
+	NULL
+};
+static int col_chars[] = {
+	0,	/* INDEX */
+	0,	/* CPU */
+	0,	/* TS */
+	0,	/* COMM */
+	0,	/* PID */
+	0,	/* LAT */
+	0,	/* EVENT */
+	0,	/* INFO */
+	0
+};
+
 static GtkTreeModel *
 create_trace_view_model(struct tracecmd_input *handle)
 {
@@ -75,6 +99,57 @@ spin_changed(gpointer data, GtkWidget *spin)
 	g_object_unref(model);
 }
 
+void trace_view_data_func(GtkTreeViewColumn *column, GtkCellRenderer *renderer,
+			  GtkTreeModel *model, GtkTreeIter *iter,
+			  gpointer data)
+{
+	int str_len, label_len, col_num = (int)data;
+	gchar *text, *str;
+	int new_w, x_pad;
+	GValue val = {0};
+	GtkWidget *view;
+
+	PangoFontDescription *pfd;
+	PangoLayout *playout;
+
+	/* Put the text in the renderer. */
+	gtk_tree_model_get_value(model, iter, col_num, &val);
+	g_object_set_property(G_OBJECT(renderer), "text", &val);
+
+	g_object_get(G_OBJECT(renderer),
+			"text", &text,
+			"font-desc", &pfd, /* apparently don't have to free this */
+			NULL);
+
+	/* Make sure there is enough room to render the column label. */
+	str = text;
+	str_len = strlen(str);
+	label_len = strlen(col_labels[col_num]);
+	if (label_len > str_len) {
+		str = col_labels[col_num];
+		str_len = label_len;
+	}
+
+	/* Don't bother with pango unless we have more chars than the max. */
+	if (str_len > col_chars[col_num]) {
+		col_chars[col_num] = str_len;
+
+		view = GTK_WIDGET(gtk_tree_view_column_get_tree_view(column));
+		playout = gtk_widget_create_pango_layout(GTK_WIDGET(view), str);
+		pango_layout_set_font_description(playout, pfd);
+		pango_layout_get_pixel_size(playout, &new_w, NULL);
+		gtk_cell_renderer_get_padding(renderer, &x_pad, NULL);
+		/* +10 to avoid another adjustment for one char */
+		new_w += 2*x_pad + 10;
+
+		if (new_w > gtk_tree_view_column_get_width(column))
+			gtk_tree_view_column_set_fixed_width(column, new_w);
+	}
+
+	g_value_unset(&val);
+	g_free(text);
+}
+
 void
 trace_view_load(GtkWidget *view, struct tracecmd_input *handle,
 		GtkWidget *spin)
@@ -94,62 +169,24 @@ trace_view_load(GtkWidget *view, struct tracecmd_input *handle,
 		     "family-set", TRUE,
 		     NULL);
 
-	gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
-					     -1,
-					     "#",
-					     renderer,
-					     "text", COL_INDEX,
-					     NULL);
-
-	gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
-					     -1,
-					     "CPU",
-					     renderer,
-					     "text", COL_CPU,
-					     NULL);
-
-	gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
-					     -1,
-					     "Time Stamp",
-					     renderer,
-					     "text", COL_TS,
-					     NULL);
-
-	gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
-					     -1,
-					     "Task",
-					     renderer,
-					     "text", COL_COMM,
-					     NULL);
-
-	gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
-					     -1,
-					     "PID",
-					     renderer,
-					     "text", COL_PID,
-					     NULL);
-
-	gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
-					     -1,
-					     "Latency",
-					     fix_renderer,
-					     "text", COL_LAT,
-					     NULL);
-
-	gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
-					     -1,
-					     "Event",
-					     renderer,
-					     "text", COL_EVENT,
-					     NULL);
-
-	
-	gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
-					     -1,
-					     "Info",
-					     fix_renderer,
-					     "text", COL_INFO,
-					     NULL);
+	/* 
+	 * Set fixed height mode now which will cause all the columns below to
+	 * be created with their sizing property to be set to
+	 * GTK_TREE_VIEW_COLUMN_FIXED.
+	 */
+	gtk_tree_view_set_fixed_height_mode(GTK_TREE_VIEW(view), TRUE);
+
+	for (int c = 0; c < NUM_COLS; c++)
+	{
+		gtk_tree_view_insert_column_with_data_func(GTK_TREE_VIEW(view),
+				-1,
+				col_labels[c],
+				(c == COL_LAT || c == COL_INFO) ? fix_renderer : renderer,
+				trace_view_data_func,
+				(gpointer)c,
+				NULL);
+		GtkTreeViewColumn *col = gtk_tree_view_get_column(GTK_TREE_VIEW(view), c);
+	}
 
 	model = create_trace_view_model(handle);
 
-- 
1.6.3.3
-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
