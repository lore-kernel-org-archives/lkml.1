Return-Path: <linux-kernel-owner+w=401wt.eu-S934588AbZKYHRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934588AbZKYHRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 02:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933499AbZKYHRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 02:17:32 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:33243 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933522AbZKYHP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 02:15:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=H8BUzSPrnzPxt/rqF2+FnnnoxwYE8O1K1xn7V2967hH+ql4RuP8sbfdnPMRUoa/38p
         N/Xxh3uNWSzMlPu+5bqFwgpCks5TzVV3I4Td4MSwYvjZOKNfkVu/oxQlGfD945ac2nu4
         ivj/x0cOcYNat37x9hDifYZQF0wKfWz+POGDo=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org, anton@samba.org,
       hch@infradead.org
Subject: [RFC][PATCH 1/7] perf trace: Add scripting ops
Date: Wed, 25 Nov 2009 01:15:46 -0600
Message-Id: <1259133352-23685-2-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1259133352-23685-1-git-send-email-tzanussi@gmail.com>
References: <1259133352-23685-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds an interface, scripting_ops, that when implemented for a
particular scripting language enables built-in support for trace
stream processing using that language.

The interface is designed to enable full-fledged language interpreters
to be embedded inside the perf executable and thereby make the full
capabilities of the supported languages available for trace
processing.

See below for details on the interface.

This patch also adds a couple command-line options to 'perf trace':

The -s option option is used to specify the script to be run.  Script
names that can be used with -s take the form:

[language spec:]scriptname[.ext]

Scripting languages register a set of 'language specs' that can be
used to specify scripts for the registered languages.  The specs can
be used either as prefixes or extensions.

If [language spec:] is used, the script is taken as a script of the
matching language regardless of any extension it might have.  If
[language spec:] is not used, [.ext] is used to look up the language
it corresponds to.  Language specs are case insensitive.

e.g. Perl scripts can be specified in the following ways:

Perl:scriptname
pl:scriptname.py # extension ignored
PL:scriptname
scriptname.pl
scriptname.perl

The -g [language spec] option gives users an easy starting point for
writing scripts in the specified language.  Scripting support for a
particular language can implement a generate_script() scripting op
that outputs an empty (or near-empty) set of handlers for all the
events contained in a given perf.data trace file - this option gives
users a direct way to access that.

Adding support for a scripting language
---------------------------------------

The main thing that needs to be done do add support for a new language
is to implement the scripting_ops interface:

It consists of the following four functions:

    start_script()
    stop_script()
    process_event()
    generate_script()

start_script() is called before any events are processed, and is meant
to give the scripting language support an opportunity to set things up
to receive events e.g. create and initialize an instance of a language
interpreter.

stop_script() is called after all events are processed, and is meant
to give the scripting language support an opportunity to clean up
e.g. destroy the interpreter instance, etc.

process_event() is called once for each event and takes as its main
parameter a pointer to the binary trace event record to be processed.
The implementation is responsible for picking out the binary fields
from the event record and sending them to the script handler function
associated with that event e.g. a function derived from the event name
it's meant to handle e.g. 'sched::sched_switch()'.  The 'format'
information for trace events can be used to parse the binary data and
map it into a form usable by a given scripting language; see the Perl
implemention in subsequent patches for one possible way to leverage
the existing trace format parsing code in perf and map that info into
specific scripting language types.

generate_script() should generate a ready-to-run script for the
current set of events in the trace, preferably with bodies that print
out every field for each event.  Again, look at the Perl
implementation for clues as to how that can be done.  This is an
optional, but very useful op.

Support for a given language should also add a language-specific setup
function and call it from setup_scripting().  The language-specific
setup function associates the the scripting ops for that language with
one or more 'language specifiers' (see below) using
script_spec_register().  When a script name is specified on the
command line, the scripting ops associated with the specified language
are used to instantiate and use the appropriate interpreter to process
the trace stream.

In general, it should be relatively easy to add support for a new
language, especially if the language implementation supports an
interface allowing an interpreter to be 'embedded' inside another
program (in this case the containing program will be 'perf trace').
If so, it should be relatively straightforward to translate trace
events into invocations of user-defined script functions where
e.g. the function name corresponds to the event type and the function
parameters correspond to the event fields.  The event and field type
information exported by the event tracing infrastructure (via the
event 'format' files) should be enough to parse and send any piece of
trace data to the user script.  The easiest way to see how this can be
done would be to look at the Perl implementation contained in
perf/util/trace-event-perl.c/.h.

There are a couple of other things that aren't covered by the
scripting_ops or setup interface and are technically optional, but
should be implemented if possible.  One of these is support for 'flag'
and 'symbolic' fields e.g. being able to use more human-readable
values such as 'GFP_KERNEL' or HI/BLOCK_IOPOLL/TASKLET in place of raw
flag values.  See the Perl implementation to see how this can be done.
The other thing is support for 'calling back' into the perf executable
to access e.g. uncommon fields not passed by default into handler
functions, or any metadata the implementation might want to make
available to users via the language interface.  Again, see the Perl
implementation for examples.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-trace.c    |  248 ++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/trace-event.h |   11 ++
 2 files changed, 257 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index d042d65..12122e2 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -13,6 +13,7 @@
 
 #include "util/trace-event.h"
 #include "util/data_map.h"
+#include "util/exec_cmd.h"
 
 static char		const *input_name = "perf.data";
 
@@ -25,6 +26,45 @@ static u64		sample_type;
 static char		*cwd;
 static int		cwdlen;
 
+static char		const *script_name;
+static char		const *generate_script_lang;
+
+static int default_start_script(const char *script __attribute((unused)))
+{
+	return 0;
+}
+
+static int default_stop_script(void)
+{
+	return 0;
+}
+
+static int default_generate_script(const char *outfile __attribute ((unused)))
+{
+	return 0;
+}
+
+static struct scripting_ops default_scripting_ops = {
+	.start_script = default_start_script,
+	.stop_script = default_stop_script,
+	.process_event = print_event,
+	.generate_script = default_generate_script,
+};
+
+static struct scripting_ops *scripting_ops;
+
+static void setup_scripting(void)
+{
+	/* make sure PERF_EXEC_PATH is set for scripts */
+	perf_set_argv_exec_path(perf_exec_path());
+
+	scripting_ops = &default_scripting_ops;
+}
+
+static int cleanup_scripting(void)
+{
+	return scripting_ops->stop_script();
+}
 
 static int
 process_comm_event(event_t *event, unsigned long offset, unsigned long head)
@@ -99,7 +139,8 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		 * field, although it should be the same than this perf
 		 * event pid
 		 */
-		print_event(cpu, raw->data, raw->size, timestamp, thread->comm);
+		scripting_ops->process_event(cpu, raw->data, raw->size,
+					     timestamp, thread->comm);
 	}
 	total += period;
 
@@ -134,6 +175,154 @@ static int __cmd_trace(void)
 	return mmap_dispatch_perf_file(&header, input_name, 0, 0, &cwdlen, &cwd);
 }
 
+struct script_spec {
+	struct list_head node;
+	struct scripting_ops *ops;
+	char spec[0];
+};
+
+LIST_HEAD(script_specs);
+
+static struct script_spec *script_spec__new(const char *spec,
+					    struct scripting_ops *ops)
+{
+	struct script_spec *s = malloc(sizeof(*s) + strlen(spec) + 1);
+
+	if (s != NULL) {
+		strcpy(s->spec, spec);
+		s->ops = ops;
+	}
+
+	return s;
+}
+
+static void script_spec__delete(struct script_spec *s)
+{
+	free(s->spec);
+	free(s);
+}
+
+static void script_spec__add(struct script_spec *s)
+{
+	list_add_tail(&s->node, &script_specs);
+}
+
+static struct script_spec *script_spec__find(const char *spec)
+{
+	struct script_spec *s;
+
+	list_for_each_entry(s, &script_specs, node)
+		if (strcasecmp(s->spec, spec) == 0)
+			return s;
+	return NULL;
+}
+
+static struct script_spec *script_spec__findnew(const char *spec,
+						struct scripting_ops *ops)
+{
+	struct script_spec *s = script_spec__find(spec);
+
+	if (s)
+		return s;
+
+	s = script_spec__new(spec, ops);
+	if (!s)
+		goto out_delete_spec;
+
+	script_spec__add(s);
+
+	return s;
+
+out_delete_spec:
+	script_spec__delete(s);
+
+	return NULL;
+}
+
+int script_spec_register(const char *spec, struct scripting_ops *ops)
+{
+	struct script_spec *s;
+
+	s = script_spec__find(spec);
+	if (s)
+		return -1;
+
+	s = script_spec__findnew(spec, ops);
+	if (!s)
+		return -1;
+
+	return 0;
+}
+
+static struct scripting_ops *script_spec__lookup(const char *spec)
+{
+	struct script_spec *s = script_spec__find(spec);
+	if (!s)
+		return NULL;
+
+	return s->ops;
+}
+
+static void list_available_languages(void)
+{
+	struct script_spec *s;
+
+	fprintf(stderr, "\n");
+	fprintf(stderr, "Scripting language extensions (used in "
+		"perf trace -s [spec:]script.[spec]):\n\n");
+
+	list_for_each_entry(s, &script_specs, node)
+		fprintf(stderr, "  %-42s [%s]\n", s->spec, s->ops->name);
+
+	fprintf(stderr, "\n");
+}
+
+static int parse_scriptname(const struct option *opt __used,
+			    const char *str, int unset __used)
+{
+	char spec[PATH_MAX];
+	const char *script, *ext;
+	int len;
+
+	if (strcmp(str, "list") == 0) {
+		list_available_languages();
+		return 0;
+	}
+
+	script = strchr(str, ':');
+	if (script) {
+		len = script - str;
+		if (len >= PATH_MAX) {
+			fprintf(stderr, "invalid language specifier");
+			return -1;
+		}
+		strncpy(spec, str, len);
+		spec[len] = '\0';
+		scripting_ops = script_spec__lookup(spec);
+		if (!scripting_ops) {
+			fprintf(stderr, "invalid language specifier");
+			return -1;
+		}
+		script++;
+	} else {
+		script = str;
+		ext = strchr(script, '.');
+		if (!ext) {
+			fprintf(stderr, "invalid script extension");
+			return -1;
+		}
+		scripting_ops = script_spec__lookup(++ext);
+		if (!scripting_ops) {
+			fprintf(stderr, "invalid script extension");
+			return -1;
+		}
+	}
+
+	script_name = strdup(script);
+
+	return 0;
+}
+
 static const char * const annotate_usage[] = {
 	"perf trace [<options>] <command>",
 	NULL
@@ -146,13 +335,23 @@ static const struct option options[] = {
 		    "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('l', "latency", &latency_format,
 		    "show latency attributes (irqs/preemption disabled, etc)"),
+	OPT_CALLBACK('s', "script", NULL, "name",
+		     "script file name (lang:script name, script name, or *)",
+		     parse_scriptname),
+	OPT_STRING('g', "gen-script", &generate_script_lang, "lang",
+		   "generate perf-trace.xx script in specified language"),
+
 	OPT_END()
 };
 
 int cmd_trace(int argc, const char **argv, const char *prefix __used)
 {
+	int err;
+
 	symbol__init(0);
 
+	setup_scripting();
+
 	argc = parse_options(argc, argv, options, annotate_usage, 0);
 	if (argc) {
 		/*
@@ -165,5 +364,50 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 
 	setup_pager();
 
-	return __cmd_trace();
+	if (generate_script_lang) {
+		struct stat perf_stat;
+
+		int input = open(input_name, O_RDONLY);
+		if (input < 0) {
+			perror("failed to open file");
+			exit(-1);
+		}
+
+		err = fstat(input, &perf_stat);
+		if (err < 0) {
+			perror("failed to stat file");
+			exit(-1);
+		}
+
+		if (!perf_stat.st_size) {
+			fprintf(stderr, "zero-sized file, nothing to do!\n");
+			exit(0);
+		}
+
+		scripting_ops = script_spec__lookup(generate_script_lang);
+		if (!scripting_ops) {
+			fprintf(stderr, "invalid language specifier");
+			return -1;
+		}
+
+		header = perf_header__new();
+		if (header == NULL)
+			return -1;
+
+		perf_header__read(header, input);
+		err = scripting_ops->generate_script("perf-trace");
+		goto out;
+	}
+
+	if (script_name) {
+		err = scripting_ops->start_script(script_name);
+		if (err)
+			goto out;
+	}
+
+	err = __cmd_trace();
+
+	cleanup_scripting();
+out:
+	return err;
 }
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index dd51c68..e7aaf00 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -259,4 +259,15 @@ enum trace_flag_type {
 	TRACE_FLAG_SOFTIRQ		= 0x10,
 };
 
+struct scripting_ops {
+	const char *name;
+	int (*start_script) (const char *);
+	int (*stop_script) (void);
+	void (*process_event) (int cpu, void *data, int size,
+			       unsigned long long nsecs, char *comm);
+	int (*generate_script) (const char *outfile);
+};
+
+int script_spec_register(const char *spec, struct scripting_ops *ops);
+
 #endif /* __PERF_TRACE_EVENTS_H */
-- 
1.6.4.GIT

