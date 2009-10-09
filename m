Return-Path: <linux-kernel-owner+w=401wt.eu-S1761617AbZJIXRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761617AbZJIXRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761600AbZJIXRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:17:16 -0400
Received: from kroah.org ([198.145.64.141]:36844 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761488AbZJIXRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:17:14 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:00 2009
Message-Id: <20091009231000.733529740@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:08:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Olsa <jolsa@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [patch 05/26] tracing: correct module boundaries for ftrace_release
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=tracing-correct-module-boundaries-for-ftrace_release.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: jolsa@redhat.com <jolsa@redhat.com>

commit e7247a15ff3bbdab0a8b402dffa1171e5c05a8e0 upstream.

When the module is about the unload we release its call records.
The ftrace_release function was given wrong values representing
the module core boundaries, thus not releasing its call records.

Plus making ftrace_release function module specific.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
LKML-Reference: <1254934835-363-3-git-send-email-jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/ftrace.h |    2 +-
 kernel/trace/ftrace.c  |   12 ++++--------
 2 files changed, 5 insertions(+), 9 deletions(-)

--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -241,7 +241,7 @@ extern void ftrace_enable_daemon(void);
 # define ftrace_set_filter(buf, len, reset)	do { } while (0)
 # define ftrace_disable_daemon()		do { } while (0)
 # define ftrace_enable_daemon()			do { } while (0)
-static inline void ftrace_release(void *start, unsigned long size) { }
+static inline void ftrace_release_mod(struct module *mod) {}
 static inline int register_ftrace_command(struct ftrace_func_command *cmd)
 {
 	return -EINVAL;
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2801,19 +2801,17 @@ static int ftrace_convert_nops(struct mo
 }
 
 #ifdef CONFIG_MODULES
-void ftrace_release(void *start, void *end)
+void ftrace_release_mod(struct module *mod)
 {
 	struct dyn_ftrace *rec;
 	struct ftrace_page *pg;
-	unsigned long s = (unsigned long)start;
-	unsigned long e = (unsigned long)end;
 
-	if (ftrace_disabled || !start || start == end)
+	if (ftrace_disabled)
 		return;
 
 	mutex_lock(&ftrace_lock);
 	do_for_each_ftrace_rec(pg, rec) {
-		if ((rec->ip >= s) && (rec->ip < e)) {
+		if (within_module_core(rec->ip, mod)) {
 			/*
 			 * rec->ip is changed in ftrace_free_rec()
 			 * It should not between s and e if record was freed.
@@ -2845,9 +2843,7 @@ static int ftrace_module_notify(struct n
 				   mod->num_ftrace_callsites);
 		break;
 	case MODULE_STATE_GOING:
-		ftrace_release(mod->ftrace_callsites,
-			       mod->ftrace_callsites +
-			       mod->num_ftrace_callsites);
+		ftrace_release_mod(mod);
 		break;
 	}
 


