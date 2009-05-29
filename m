Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbZE2Qtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbZE2Qtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 12:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbZE2Qt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 12:49:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59685 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbZE2Qt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 12:49:26 -0400
Date: Fri, 29 May 2009 13:48:59 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 1/1] perf_counter tools: Shorten the DSO names using cwd
Message-ID: <20090529164859.GN4747@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit c33188d6cca8616c5bb9e1bbf95bc88cc3c1fa9c
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Fri May 29 13:43:08 2009 -0300

    perf_counter tools: Shorten the DSO names using cwd
    
    [acme@emilia linux-2.6-tip]$ pwd
    /home/acme/git/linux-2.6-tip
    
    Before (still available using -P/--full-paths)
    
    [acme@emilia linux-2.6-tip]$ perf report -P | head -10
        11.48%             perf: 7454 [kernel]: clear_page_c
         4.89%             perf: 7454 [kernel]: vsnprintf
         4.61%             perf: 7454 /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: dso__find_symbol
         4.09%             perf: 7454 [kernel]: number
         4.06%             perf: 7454 /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: dso__fprintf
         4.00%             perf: 7454 /home/acme/git/linux-2.6-tip/Documentation/perf_counter/perf: symbol_filter
    
    New default:
    
    [acme@emilia linux-2.6-tip]$ perf report | head -10
        11.48%             perf: 7454 [kernel]: clear_page_c
         4.89%             perf: 7454 [kernel]: vsnprintf
         4.61%             perf: 7454 ./Documentation/perf_counter/perf: dso__find_symbol
         4.09%             perf: 7454 [kernel]: number
         4.06%             perf: 7454 ./Documentation/perf_counter/perf: dso__fprintf
         4.00%             perf: 7454 ./Documentation/perf_counter/perf: symbol_filter
    
    Suggested-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 412d524..4705679 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -23,6 +23,7 @@ static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
 static int		dump_trace = 0;
 static int		verbose;
+static int		full_paths;
 
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
@@ -134,6 +135,16 @@ static int load_kernel(void)
 	return err;
 }
 
+static int strcommon(const char *pathname, const char *cwd, int cwdlen)
+{
+	int n = 0;
+
+	while (pathname[n] == cwd[n] && n < cwdlen)
+		++n;
+
+	return n;
+}
+
 struct map {
 	struct list_head node;
 	uint64_t	 start;
@@ -142,16 +153,28 @@ struct map {
 	struct dso	 *dso;
 };
 
-static struct map *map__new(struct mmap_event *event)
+static struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen)
 {
 	struct map *self = malloc(sizeof(*self));
 
 	if (self != NULL) {
+		const char *filename = event->filename;
+		char newfilename[PATH_MAX];
+
+		if (cwd) {
+			int n = strcommon(filename, cwd, cwdlen);
+			if (n == cwdlen) {
+				snprintf(newfilename, sizeof(newfilename),
+					 ".%s", filename + n);
+				filename = newfilename;
+			}
+		}
+
 		self->start = event->start;
 		self->end   = event->start + event->len;
 		self->pgoff = event->pgoff;
 
-		self->dso = dsos__findnew(event->filename);
+		self->dso = dsos__findnew(filename);
 		if (self->dso == NULL)
 			goto out_delete;
 	}
@@ -598,6 +621,8 @@ static int __cmd_report(void)
 	int ret, rc = EXIT_FAILURE;
 	uint32_t size;
 	unsigned long total = 0, total_mmap = 0, total_comm = 0, total_unknown = 0;
+	char cwd[PATH_MAX], *cwdp = cwd;
+	int cwdlen;
 
 	input = open(input_name, O_RDONLY);
 	if (input < 0) {
@@ -621,6 +646,14 @@ static int __cmd_report(void)
 		return EXIT_FAILURE;
 	}
 
+	if (!full_paths) {
+		if (getcwd(cwd, sizeof(cwd)) == NULL) {
+			perror("failed to get the current directory");
+			return EXIT_FAILURE;
+		}
+		cwdlen = strlen(cwd);
+	} else
+		cwdp = NULL;
 remap:
 	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
 			   MAP_SHARED, input, offset);
@@ -710,7 +743,7 @@ more:
 	} else switch (event->header.type) {
 	case PERF_EVENT_MMAP: {
 		struct thread *thread = threads__findnew(event->mmap.pid);
-		struct map *map = map__new(&event->mmap);
+		struct map *map = map__new(&event->mmap, cwdp, cwdlen);
 
 		if (dump_trace) {
 			fprintf(stderr, "%p [%p]: PERF_EVENT_MMAP: [%p(%p) @ %p]: %s\n",
@@ -809,6 +842,8 @@ static const struct option options[] = {
 	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol. Default: pid,symbol"),
+	OPT_BOOLEAN('P', "full-paths", &full_paths,
+		    "Don't shorten the pathnames taking into account the cwd"),
 	OPT_END()
 };
 
