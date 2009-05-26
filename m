Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346AbZEZPWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbZEZPWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 11:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822AbZEZPV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 11:21:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48467 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063AbZEZPV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 11:21:58 -0400
Date: Tue, 26 May 2009 12:21:34 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
       jkacur@redhat.com, Peter Zijlstra <peterz@infradead.org>, efault@gmx.de,
       mtosatti@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
       cjashfor@linux.vnet.ibm.com
Subject: [PATCH 1/1 tip] perf: Don't assume /proc/kallsyms is ordered
Message-ID: <20090526152134.GF4424@ghostprotocols.net>
References: <tip-59d81029b6804c3d5895d07cad77d7dfddc6b5b2@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-59d81029b6804c3d5895d07cad77d7dfddc6b5b2@git.kernel.org>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please fix the previous fix with this:

commit 64d254523be740b224533e0e4982cda7f25c0348
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Tue May 26 12:08:10 2009 -0300

    perf: Don't assume /proc/kallsyms is ordered
    
    Since we _are_ ordering it by the symbol start, just traverse the
    freshly built rbtree setting the prev->end members to curr->start - 1.
    
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index b19b893..5a385e8 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -360,17 +360,9 @@ static int load_kallsyms(void)
 	char *line = NULL;
 	size_t n;
 
-	if (getline(&line, &n, file) < 0 || !line)
-		goto out_delete_dso;
-
-	unsigned long long previous_start;
-	char c, previous_symbf[4096];
-	if (sscanf(line, "%llx %c %s", &previous_start, &c, previous_symbf) != 3)
-		goto out_delete_line;
-
 	while (!feof(file)) {
 		unsigned long long start;
-		char symbf[4096];
+		char c, symbf[4096];
 
 		if (getline(&line, &n, file) < 0)
 			break;
@@ -379,21 +371,35 @@ static int load_kallsyms(void)
 			goto out_delete_dso;
 
 		if (sscanf(line, "%llx %c %s", &start, &c, symbf) == 3) {
-			if (start > previous_start) {
-				struct symbol *sym = symbol__new(previous_start,
-								 start - previous_start,
-								 previous_symbf);
+			/*
+			 * Well fix up the end later, when we have all sorted.
+			 */
+			struct symbol *sym = symbol__new(start, 0xdead, symbf);
 
-				if (sym == NULL)
-					goto out_delete_dso;
+			if (sym == NULL)
+				goto out_delete_dso;
 
-				dso__insert_symbol(kernel_dso, sym);
-				previous_start = start;
-				strcpy(previous_symbf, symbf);
-			}
+			dso__insert_symbol(kernel_dso, sym);
 		}
 	}
 
+	/*
+	 * Now that we have all sorted out, just set the ->end of all
+	 * symbols
+	 */
+	struct rb_node *nd, *prevnd = rb_first(&kernel_dso->syms);
+
+	if (prevnd == NULL)
+		goto out_delete_line;
+
+	for (nd = rb_next(prevnd); nd; nd = rb_next(nd)) {
+		struct symbol *prev = rb_entry(prevnd, struct symbol, rb_node),
+			      *curr = rb_entry(nd, struct symbol, rb_node);
+		
+		prev->end = curr->start - 1;
+		prevnd = nd;
+	}
+
 	dsos__add(kernel_dso);
 	free(line);
 	fclose(file);
