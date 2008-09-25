Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYIYLNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYIYLNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbYIYLNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:13:25 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:63506 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbYIYLNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:13:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=RNO+VOrDng6WskK6wDaFCxLDL/SV/EOM396sQxtVCGyHPwdDmDQrhAwXjE9lsQQXI1
         ZJ2dlrIMLY8HEwEiUoqgYMlQclAF94FQTQyWPjbCKuqtXeAcRdH3r7o4sQrmTW0rzBXN
         DnjXVoYq2S0tFXMsk3wDTcAlP2HTxLQTezFxA=
Message-ID: <48DB81BA.2050204@gmail.com>
Date: Thu, 25 Sep 2008 13:19:06 +0100
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Pekka Paalanen <pq@iki.fi>
Subject: [Patch -tip 1/3] Tracing/ftrace: Relay unhandled entry output
Content-Type: multipart/mixed;
 boundary="------------050602000100030304010207"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050602000100030304010207
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

I tried to figure out the origin of the bug reported by Pekka Paalanen
about the broken pipe:
http://kerneltrap.org/mailarchive/linux-kernel/2008/9/15/3305224

When I add a trace_mark with the boot tracer, I had this same problem
but this time it was easy to reproduce.

When it calls a tracer's print_line callback, the print_trace_line function 
in trace.c returns whithout verifying if it could handle the entry properly.
And actually the seq could be empty.

For example the boot_tracer don't handle TRACE_PRINT. Nevertheless it
wants them to be printed as a default way.

So print_trace_line function should relay on the other functions which could handle
an output if one of them fail.

Reported-by: Pekka Paalanen <pq@iki.fi>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---

--------------050602000100030304010207
Content-Type: text/plain;
 name="1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="1.diff"

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 6ada059..50ac334 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1904,20 +1904,27 @@ static int trace_empty(struct trace_iterator *iter)
 
 static int print_trace_line(struct trace_iterator *iter)
 {
+	int ret;
+
 	if (iter->trace && iter->trace->print_line)
-		return iter->trace->print_line(iter);
+		if ((ret = iter->trace->print_line(iter)))
+			return ret;
 
 	if (trace_flags & TRACE_ITER_BIN)
-		return print_bin_fmt(iter);
+		if ((ret = print_bin_fmt(iter)))
+			return ret;
 
 	if (trace_flags & TRACE_ITER_HEX)
-		return print_hex_fmt(iter);
+		if ((ret = print_hex_fmt(iter)))
+			return ret;
 
 	if (trace_flags & TRACE_ITER_RAW)
-		return print_raw_fmt(iter);
+		if ((ret = print_raw_fmt(iter)))
+			return ret;
 
 	if (iter->iter_flags & TRACE_FILE_LAT_FMT)
-		return print_lat_fmt(iter, iter->idx, iter->cpu);
+		if ((ret = print_lat_fmt(iter, iter->idx, iter->cpu)))
+			return ret;
 
 	return print_trace_fmt(iter);
 }

--------------050602000100030304010207--
