Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbYKOVsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbYKOVsr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 16:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbYKOVsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 16:48:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49365 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbYKOVsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 16:48:00 -0500
Message-Id: <20081115214758.332811011@goodmis.org>
References: <20081115214705.363808961@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 15 Nov 2008 16:47:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/5] ftrace: allow NULL pointers in mcount_loc
Content-Disposition: inline; filename=0003-ftrace-allow-NULL-pointers-in-mcount_loc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: let archs insert NULL pointers in mcount_loc section

Due to the way different architecture linkers combine the data sections
of the mcount_loc (the section that lists all the locations that
call mcount), there may be zeros added in that section. This is usually
due to strange alignments that the linker performs, that pads in zeros.

This patch makes the conversion code to nops skip any pointer in
the mcount_loc section that is NULL.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6adad23..2384a9c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1305,6 +1305,14 @@ static int ftrace_convert_nops(struct module *mod,
 	p = start;
 	while (p < end) {
 		addr = ftrace_call_adjust(*p++);
+		/*
+		 * Some architecture linkers will pad between
+		 * the different mcount_loc sections of different
+		 * object files to satisfy alignments.
+		 * Skip any NULL pointers.
+		 */
+		if (!addr)
+			continue;
 		ftrace_record_ip(addr);
 	}
 
-- 
1.5.6.5

-- 
