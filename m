Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbZGGFxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbZGGFxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 01:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbZGGFxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 01:53:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55772 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbZGGFxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 01:53:43 -0400
Message-ID: <4A52E2EB.9070503@cn.fujitsu.com>
Date: Tue, 07 Jul 2009 13:53:47 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/8] ksym_tracer: Fix validation of length of access type
References: <4A52E291.1020408@cn.fujitsu.com>
In-Reply-To: <4A52E291.1020408@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't take newline into account, otherwise:

 # echo 'pid_max:-w-' > ksym_trace_filter
 # echo -n 'pid_max:rw-' > ksym_trace_filter
 bash: echo: write error: Invalid argument

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
 
-- 
1.5.4.rc3
