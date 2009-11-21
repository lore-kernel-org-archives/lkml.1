Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbZKUNey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbZKUNey (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbZKUNex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:34:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:41587 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377AbZKUNew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:34:52 -0500
Date: Sat, 21 Nov 2009 13:34:20 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stern@rowland.harvard.edu, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
In-Reply-To: <4A52E2CE.6080409@cn.fujitsu.com>
References: <4A52E2CE.6080409@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ksym_tracer: Fix validation of access type
Message-ID: <tip-f088e5471297cc78d7465e1fd997cb1a91a48019@git.kernel.org>
Git-Commit-ID: f088e5471297cc78d7465e1fd997cb1a91a48019
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f088e5471297cc78d7465e1fd997cb1a91a48019
Gitweb:     http://git.kernel.org/tip/f088e5471297cc78d7465e1fd997cb1a91a48019
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 7 Jul 2009 13:53:18 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 11:59:41 +0200

ksym_tracer: Fix validation of access type

# echo 'pid_max:rw-' > ksym_trace_filter
 # cat ksym_trace_filter
 pid_max:rw-
 # echo 'pid_max:ww-' > ksym_trace_filter
 (should return -EINVAL)
 # cat ksym_trace_filter
 (but it ended up removing filter entry)

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4A52E2CE.6080409@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_ksym.c |   32 ++++++++++++++------------------
 1 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index b6710d3..9556009 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -114,24 +114,22 @@ void ksym_hbp_handler(struct hw_breakpoint *hbp, struct pt_regs *regs)
  * --x : Set Execution Break points (Not available yet)
  *
  */
-static int ksym_trace_get_access_type(char *access_str)
+static int ksym_trace_get_access_type(char *str)
 {
-	int pos, access = 0;
+	int access = 0;
 
-	for (pos = 0; pos < KSYM_TRACER_OP_LEN; pos++) {
-		switch (access_str[pos]) {
-		case 'r':
-			access += (pos == 0) ? 4 : -1;
-			break;
-		case 'w':
-			access += (pos == 1) ? 2 : -1;
-			break;
-		case '-':
-			break;
-		default:
-			return -EINVAL;
-		}
-	}
+	if (str[0] == 'r')
+		access += 4;
+	else if (str[0] != '-')
+		return -EINVAL;
+
+	if (str[1] == 'w')
+		access += 2;
+	else if (str[1] != '-')
+		return -EINVAL;
+
+	if (str[2] != '-')
+		return -EINVAL;
 
 	switch (access) {
 	case 6:
@@ -140,8 +138,6 @@ static int ksym_trace_get_access_type(char *access_str)
 	case 2:
 		access = HW_BREAKPOINT_WRITE;
 		break;
-	case 0:
-		access = 0;
 	}
 
 	return access;
