Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbZKUNgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbZKUNgj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbZKUNgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:36:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:36227 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578AbZKUNga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:36:30 -0500
Date: Sat, 21 Nov 2009 13:34:33 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stern@rowland.harvard.edu, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
In-Reply-To: <4A52E2EB.9070503@cn.fujitsu.com>
References: <4A52E2EB.9070503@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ksym_tracer: Fix validation of length of access type
Message-ID: <tip-92cf9f8f7e89c6bdbb1a724f879b8b18fc0dfe0f@git.kernel.org>
Git-Commit-ID: 92cf9f8f7e89c6bdbb1a724f879b8b18fc0dfe0f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  92cf9f8f7e89c6bdbb1a724f879b8b18fc0dfe0f
Gitweb:     http://git.kernel.org/tip/92cf9f8f7e89c6bdbb1a724f879b8b18fc0dfe0f
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 7 Jul 2009 13:53:47 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 11:59:42 +0200

ksym_tracer: Fix validation of length of access type

Don't take newline into account, otherwise:

 # echo 'pid_max:-w-' > ksym_trace_filter
 # echo -n 'pid_max:rw-' > ksym_trace_filter
 bash: echo: write error: Invalid argument

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4A52E2EB.9070503@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_ksym.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 9556009..72fcb46 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -158,21 +158,21 @@ static int ksym_trace_get_access_type(char *str)
 static int parse_ksym_trace_str(char *input_string, char **ksymname,
 							unsigned long *addr)
 {
-	char *delimiter = ":";
 	int ret;
 
-	ret = -EINVAL;
-	*ksymname = strsep(&input_string, delimiter);
+	strstrip(input_string);
+
+	*ksymname = strsep(&input_string, ":");
 	*addr = kallsyms_lookup_name(*ksymname);
 
 	/* Check for malformed request: (2), (1) and (5) */
 	if ((!input_string) ||
-		(strlen(input_string) != (KSYM_TRACER_OP_LEN + 1)) ||
-			(*addr == 0))
-		goto return_code;
+	    (strlen(input_string) != KSYM_TRACER_OP_LEN) ||
+	    (*addr == 0))
+		return -EINVAL;;
+
 	ret = ksym_trace_get_access_type(input_string);
 
-return_code:
 	return ret;
 }
 
