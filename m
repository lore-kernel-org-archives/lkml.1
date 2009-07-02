Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZGBQGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZGBQGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 12:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbZGBQGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 12:06:30 -0400
Received: from mail-ew0-f215.google.com ([209.85.219.215]:40507 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbZGBQG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 12:06:28 -0400
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jul 2009 12:05:48 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=d3m6FmG02NesTZ8HWeg3mDIiDTyuryh89XiJ8RgUOOd4qfoEcwlCPoMDj/YK0tld6w
         KoJimnRxbIsxIPybKfD7LQPlcPdx14gveuYeRhaJXJNSYtwSSyXoR3P1sLDL+fVLR4+g
         LrPsiVD+uI6E9tQlyRYYHZTiOd9FFXNo7hY5w=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/3] perfcounter: bring new OPT_CALLBACK_DEFAULT option
Date: Thu,  2 Jul 2009 17:58:20 +0200
Message-Id: <1246550301-8954-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1246550301-8954-1-git-send-email-fweisbec@gmail.com>
References: <1246550301-8954-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no predefined macro to create an option that can
have a custom value or a default one if none is given.

This patch provides a new helper OPT_CALLBACK_DEFAULT() which
defines such kind of option.

For example, considering an option -c, we want to get the default
value in the following cases:

./perf command -c -d
./perf command -d -c

And the foo value when it's given:

./perf command -c foo -d
./perf command -d -c foo

That's also why PARSE_OPT_LASTARG_DEFAULT is extended here
to support default values whatever the position of the option, not
only in the end.

Should it now be renamed to PARSE_OPT_ARG_DEFAULT ?

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
-- 
1.6.2.3

