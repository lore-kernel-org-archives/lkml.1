Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbYFNGaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbYFNGaF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 02:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbYFNG3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 02:29:55 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:62786 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbYFNG3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 02:29:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=lOi+SiUS6rZAN4jD/upZmeAuh3n/bL6oBN7i1GWHMSr/vKulKXXE/f+xOeFfshg6aw
         p4XkN0GCAX9VuZiJdTrA0++mw7WGNBQUMBYmb/do6kLrU2AL+wpGj2aDECi4FkwUublW
         SGs0/alny6je8+rBI9/meXi8wssRpxZQRVV6Y=
Message-ID: <48536553.8020601@gmail.com>
Date: Sat, 14 Jun 2008 11:59:39 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: fix "notrace" filtering priority
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

This is a fix to give notrace filter rules priority over "set_ftrace_filter"
rules. This way functions set to be filtered and also in the notrace list will
not get traced.

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
---

This fix ensures that functions which are set to be filetered and are
concurrently marked as "notrace" don't get recorded. As of now, if
a record is marked as FTRACE_FL_FILTER and is enabled, then the notrace
flag is not checked. Tested on x86-32.

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0118979..b532e4a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -355,20 +355,26 @@ __ftrace_replace_code(struct dyn_ftrace *rec,
 		 * If this record is set not to trace then
 		 * do nothing.
 		 *
+		 * If this record is set not to trace and
+		 * it is enabled then disable it.
+		 *
 		 * If this record is not set to be filtered and
 		 * it is enabled, disable it.
 		 */
-		fl = rec->flags & (FTRACE_FL_FILTER | FTRACE_FL_ENABLED);
+
+		fl = rec->flags & (FTRACE_FL_FILTER | FTRACE_FL_NOTRACE |
+				   FTRACE_FL_ENABLED);
 
 		if ((fl ==  (FTRACE_FL_FILTER | FTRACE_FL_ENABLED)) ||
-		    (fl == 0) || (rec->flags & FTRACE_FL_NOTRACE))
+		    (fl ==  (FTRACE_FL_FILTER | FTRACE_FL_NOTRACE)) ||
+		    !fl || (fl == FTRACE_FL_NOTRACE))
 			return 0;
 
 		/*
 		 * If it is enabled disable it,
 		 * otherwise enable it!
 		 */
-		if (fl == FTRACE_FL_ENABLED) {
+		if (fl & FTRACE_FL_ENABLED) {
 			/* swap new and old */
 			new = old;
 			old = ftrace_call_replace(ip, FTRACE_ADDR);
