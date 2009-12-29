Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbZL2TTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbZL2TTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 14:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbZL2TTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 14:19:08 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:37000 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbZL2TTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 14:19:04 -0500
Message-ID: <4B3A5620.6050005@us.ibm.com>
Date: Tue, 29 Dec 2009 11:18:56 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       "lkml, " <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace-cmd: add getopt support to gui tools for input 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From b3acaddbe845dd3296374a32951b29616519da86 Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhltc@us.ibm.com>
Date: Tue, 29 Dec 2009 11:17:37 -0800
Subject: [PATCH] trace-cmd: add getopt support to gui tools for input file

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---
  kernel-shark.c     |   28 +++++++++++++++++++++++++++-
  trace-graph-main.c |   28 +++++++++++++++++++++++++++-
  trace-view-main.c  |   29 ++++++++++++++++++++++++++++-
  3 files changed, 82 insertions(+), 3 deletions(-)

diff --git a/kernel-shark.c b/kernel-shark.c
index 158b9ac..0d72459 100644
--- a/kernel-shark.c
+++ b/kernel-shark.c
@@ -18,12 +18,15 @@
   *
   * 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   */
+#define _GNU_SOURCE
  #include <stdio.h>
  #include <string.h>
  #include <stdarg.h>
  #include <fcntl.h>
  #include <unistd.h>
  #include <gtk/gtk.h>
+#include <getopt.h>
+#include <string.h>

  #include "trace-compat.h"
  #include "trace-cmd.h"
@@ -34,7 +37,15 @@
  #define TRACE_WIDTH	800
  #define TRACE_HEIGHT	600

-#define input_file "trace.dat"
+#define default_input_file "trace.dat"
+static char *input_file = default_input_file;
+
+void usage(char *prog)
+{
+	printf("Usage: %s\n", prog);
+	printf("  -h	Display this help message\n");
+	printf("  -i	input_file, default is %s\n", default_input_file);
+}

  /* graph callbacks */

@@ -161,6 +172,21 @@ void kernel_shark(int argc, char **argv)
  	GtkWidget *draw;
  	GtkWidget *label;
  	GtkWidget *spin;
+	int c;
+
+	while ((c = getopt(argc, argv, "hi:")) != -1) {
+		switch(c) {
+		case 'h':
+			usage(basename(argv[0]));
+			return;
+		case 'i':
+			input_file = optarg;
+			break;
+		default:
+			/* assume the other options are for gtk */
+			break;
+		}
+	}

  	info = g_new0(typeof(*info), 1);
  	if (!info)
diff --git a/trace-graph-main.c b/trace-graph-main.c
index 4eb257f..54194e1 100644
--- a/trace-graph-main.c
+++ b/trace-graph-main.c
@@ -1,4 +1,7 @@
+#define _GNU_SOURCE
  #include <gtk/gtk.h>
+#include <getopt.h>
+#include <string.h>

  #include "trace-cmd.h"
  #include "trace-graph.h"
@@ -7,10 +10,18 @@

  #define TRACE_WIDTH	800
  #define TRACE_HEIGHT	600
-#define input_file "trace.dat"

+#define default_input_file "trace.dat"
+static char *input_file = default_input_file;
  static struct graph_info *ginfo;

+void usage(char *prog)
+{
+	printf("Usage: %s\n", prog);
+	printf("  -h	Display this help message\n");
+	printf("  -i	input_file, default is %s\n", default_input_file);
+}
+
  /* Callback for the clicked signal of the Exit button */
  static void
  exit_clicked (GtkWidget *widget, gpointer data)
@@ -42,6 +53,21 @@ void trace_graph(int argc, char **argv)
  	GtkWidget *sub_item;
  	GtkWidget *scrollwin;
  	GtkWidget *draw;
+	int c;
+
+	while ((c = getopt(argc, argv, "hi:")) != -1) {
+		switch(c) {
+		case 'h':
+			usage(basename(argv[0]));
+			return;
+		case 'i':
+			input_file = optarg;
+			break;
+		default:
+			/* assume the other options are for gtk */
+			break;
+		}
+	}

  	handle = tracecmd_open(input_file);

diff --git a/trace-view-main.c b/trace-view-main.c
index c0eb716..5b6eb7b 100644
--- a/trace-view-main.c
+++ b/trace-view-main.c
@@ -1,4 +1,7 @@
+#define _GNU_SOURCE
  #include <gtk/gtk.h>
+#include <getopt.h>
+#include <string.h>

  #include "trace-cmd.h"
  #include "trace-view.h"
@@ -7,11 +10,20 @@

  #define TRACE_WIDTH	800
  #define TRACE_HEIGHT	600
-#define input_file "trace.dat"
+
+#define default_input_file "trace.dat"
+static char *input_file = default_input_file;

  GtkWidget *trace_tree;
  static struct tracecmd_input *handle;

+void usage(char *prog)
+{
+	printf("Usage: %s\n", prog);
+	printf("  -h	Display this help message\n");
+	printf("  -i	input_file, default is %s\n", default_input_file);
+}
+
  /* Callback for the clicked signal of the Exit button */
  static void
  exit_clicked (GtkWidget *widget, gpointer data)
@@ -76,6 +88,21 @@ void trace_view(int argc, char **argv)
  	GtkWidget *scrollwin;
  	GtkWidget *label;
  	GtkWidget *spin;
+	int c;
+
+	while ((c = getopt(argc, argv, "hi:")) != -1) {
+		switch(c) {
+		case 'h':
+			usage(basename(argv[0]));
+			return;
+		case 'i':
+			input_file = optarg;
+			break;
+		default:
+			/* assume the other options are for gtk */
+			break;
+		}
+	}

  	handle = tracecmd_open(input_file);

-- 
1.6.3.3
-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
