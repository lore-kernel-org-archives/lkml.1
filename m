Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbZGGFxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbZGGFxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 01:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZGGFxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 01:53:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63634 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754919AbZGGFxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 01:53:15 -0400
Message-ID: <4A52E2CE.6080409@cn.fujitsu.com>
Date: Tue, 07 Jul 2009 13:53:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/8] ksym_tracer: Fix validation of access type
References: <4A52E291.1020408@cn.fujitsu.com>
In-Reply-To: <4A52E291.1020408@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 # echo 'pid_max:rw-' > ksym_trace_filter
 # cat ksym_trace_filter
 pid_max:rw-
 # echo 'pid_max:ww-' > ksym_trace_filter
 (should return -EINVAL)
 # cat ksym_trace_filter
 (but it ended up removing filter entry)

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
-- 
1.5.4.rc3
