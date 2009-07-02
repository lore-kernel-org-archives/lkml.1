Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbZGBS66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbZGBS66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 14:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbZGBS6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 14:58:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:35791 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108AbZGBS6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 14:58:43 -0400
Date: Thu, 2 Jul 2009 18:58:11 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, anton@samba.org,
       paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, anton@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1246550301-8954-2-git-send-email-fweisbec@gmail.com>
References: <1246550301-8954-2-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/urgent] perf_counter tools: Add new OPT_CALLBACK_DEFAULT option
Message-ID: <tip-5a4b181721375700124513cdd9f97056e1c66675@git.kernel.org>
Git-Commit-ID: 5a4b181721375700124513cdd9f97056e1c66675
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Jul 2009 18:58:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a4b181721375700124513cdd9f97056e1c66675
Gitweb:     http://git.kernel.org/tip/5a4b181721375700124513cdd9f97056e1c66675
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 2 Jul 2009 17:58:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 2 Jul 2009 20:47:14 +0200

perf_counter tools: Add new OPT_CALLBACK_DEFAULT option

There is no predefined macro to create an option that can have
a custom value or a default one if none is given.

This patch provides a new helper OPT_CALLBACK_DEFAULT() which
defines such kind of option.

For example, considering an option -c, we want to get the
default value in the following cases:

    perf command -c -d
    perf command -d -c

And the foo value when it's given:

    perf command -c foo -d
    perf command -d -c foo

That's also why PARSE_OPT_LASTARG_DEFAULT is extended here to
support default values whatever the position of the option, not
only in the end.

Should it now be renamed to PARSE_OPT_ARG_DEFAULT ?

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: git@vger.kernel.org
LKML-Reference: <1246550301-8954-2-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/parse-options.c |    3 ++-
 tools/perf/util/parse-options.h |    2 ++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index 9a897b7..1bf6719 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -20,7 +20,8 @@ static int get_arg(struct parse_opt_ctx_t *p, const struct option *opt,
 	if (p->opt) {
 		*arg = p->opt;
 		p->opt = NULL;
-	} else if (p->argc == 1 && (opt->flags & PARSE_OPT_LASTARG_DEFAULT)) {
+	} else if ((opt->flags & PARSE_OPT_LASTARG_DEFAULT) && (p->argc == 1 ||
+		    **(p->argv + 1) == '-')) {
 		*arg = (const char *)opt->defval;
 	} else if (p->argc > 1) {
 		p->argc--;
diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index 15c8aba..8aa3464 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -104,6 +104,8 @@ struct option {
 	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), .argh = "time", .help = (h), .callback = parse_opt_approxidate_cb }
 #define OPT_CALLBACK(s, l, v, a, h, f) \
 	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f) }
+#define OPT_CALLBACK_DEFAULT(s, l, v, a, h, f, d) \
+	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f), .defval = (intptr_t)d, .flags = PARSE_OPT_LASTARG_DEFAULT }
 
 /* parse_options() will filter out the processed options and leave the
  * non-option argments in argv[].
