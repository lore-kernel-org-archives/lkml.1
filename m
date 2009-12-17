Return-Path: <linux-kernel-owner+w=401wt.eu-S936118AbZLQETy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936118AbZLQETy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936432AbZLQETl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:19:41 -0500
Received: from kroah.org ([198.145.64.141]:55878 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935691AbZLQEFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:15 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:58 2009
Message-Id: <20091217035658.016283887@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johannes Berg <johannes@sipsolutions.net>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Subject: [116/151] tracing: Fix event format export
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes@sipsolutions.net>

commit 811cb50baf63461ce0bdb234927046131fc7fa8b upstream.

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
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/trace/ftrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -159,7 +159,7 @@
 #undef __get_str
 
 #undef TP_printk
-#define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
+#define TP_printk(fmt, args...) "\"%s\", %s\n", fmt, __stringify(args)
 
 #undef TP_fast_assign
 #define TP_fast_assign(args...) args


