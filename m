Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbZKNKTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbZKNKTP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 05:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbZKNKTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 05:19:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:37637 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898AbZKNKTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 05:19:12 -0500
Date: Sat, 14 Nov 2009 10:18:40 GMT
From: tip-bot for Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, johannes@sipsolutions.net, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johannes@sipsolutions.net, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20091113224009.GB23942@elte.hu>
References: <20091113224009.GB23942@elte.hu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Fix event format export
Message-ID: <tip-811cb50baf63461ce0bdb234927046131fc7fa8b@git.kernel.org>
Git-Commit-ID: 811cb50baf63461ce0bdb234927046131fc7fa8b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  811cb50baf63461ce0bdb234927046131fc7fa8b
Gitweb:     http://git.kernel.org/tip/811cb50baf63461ce0bdb234927046131fc7fa8b
Author:     Johannes Berg <johannes@sipsolutions.net>
AuthorDate: Fri, 13 Nov 2009 23:40:09 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 13 Nov 2009 22:20:34 -0500

tracing: Fix event format export

For some reason the export of the event print format to userspace
uses '#fmt' which breaks if the format string is anything but a plain
string, for example if it is built with macros then the macro names
are exported instead of their contents.

Use
	"\"%s\"", fmt
instead of
	"%s", #fmt
to export the string and not the way it is built.

For example, in net/mac80211/driver-trace.h for the trace event drv_start
there is:

        TP_printk(
                LOCAL_PR_FMT, LOCAL_PR_ARG
        )

Which use to produce:

 print fmt: LOCAL_PR_FMT, REC->wiphy_name

Now produces:

 print fmt: "%s", REC->wiphy_name

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
LKML-Reference: <20091113224009.GB23942@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index cc0d966..dacb8ef 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -159,7 +159,7 @@
 #undef __get_str
 
 #undef TP_printk
-#define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
+#define TP_printk(fmt, args...) "\"%s\", %s\n", fmt, __stringify(args)
 
 #undef TP_fast_assign
 #define TP_fast_assign(args...) args
