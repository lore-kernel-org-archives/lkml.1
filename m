Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbZDTTEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbZDTTEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 15:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZDTTEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 15:04:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46757 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbZDTTEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 15:04:25 -0400
Date: Mon, 20 Apr 2009 15:04:22 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, mingo@goodmis.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [RFC] Stupid tracepoint ideas
Message-ID: <alpine.DEB.2.00.0904201456470.26147@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mathieu,

You may have tried this in your creation of tracepoints, but I figured I 
would ask before wasting too much time on it.

I'm looking at ways to make tracepoints even lighter weight when disabled. 
And I thought of doing section code. I'm playing with the following idea 
(see below patch) but I'm afraid gcc is allowed to think that the code it 
produces will not move to different sections.

Any thoughts on how we could do something similar to this.

Note, this patch is purely proof-of-concept. I'm fully aware that it is an 
x86 solution only.

-- Steve

[ no Signed-off-by: because this patch is crap ]

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 4353f3f..6953f78 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -65,9 +65,18 @@ struct tracepoint {
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
-		if (unlikely(__tracepoint_##name.state))		\
+		if (unlikely(__tracepoint_##name.state)) {		\
+			asm volatile ("jmp 43f\n"			\
+				      "42:\n"				\
+				      ".section .unlikely,\"ax\"\n"	\
+				      "43:\n"				\
+				      ::: "memory");			\
 			__DO_TRACE(&__tracepoint_##name,		\
-				TP_PROTO(proto), TP_ARGS(args));	\
+				   TP_PROTO(proto), TP_ARGS(args));	\
+			asm volatile ("jmp 42b\n"			\
+			     ".previous\n"				\
+			     ::: "memory");				\
+		}							\
 	}								\
 	static inline int register_trace_##name(void (*probe)(proto))	\
 	{								\
