Return-Path: <linux-kernel-owner+w=401wt.eu-S1753082AbZLMNIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbZLMNIk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 08:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZLMNIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 08:08:34 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53483 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753044AbZLMNIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 08:08:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Z8Qo2iIZ5xwLES2ajmJ4bUeUnaTfJ7vbb/N5jrunlpDvfwaOceLKTuJNHmelUe1iif
         eycxgbiPRBOVzJn/QKFcyNBuFg6swJFD7DZWZy2zL0yux7w9AxxYBaJVGltMiGitwyFB
         YRziGJAsNGoukz5K7f7Gyi2xSdlBR0UtGFvkE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 05/13] ftrace: Call trace_parser_clear() properly
Date: Sun, 13 Dec 2009 14:08:06 +0100
Message-Id: <1260709694-5166-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
References: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

I found a weird behavior:

  # echo 'fuse:*' > set_ftrace_filter
  bash: echo: write error: Invalid argument
  # cat set_ftrace_filter
  fuse_dev_fasync
  fuse_dev_poll
  fuse_copy_do

We should call trace_parser_clear() no matter ftrace_process_regex()
returns 0 or -errno, otherwise we will actually take the unaccepted
records from ftrace_regex_release().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4B1DC4D2.3000406@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/ftrace.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 08a3fb5..ff8aecd 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2208,10 +2208,9 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	    !trace_parser_cont(parser)) {
 		ret = ftrace_process_regex(parser->buffer,
 					   parser->idx, enable);
+		trace_parser_clear(parser);
 		if (ret)
 			goto out_unlock;
-
-		trace_parser_clear(parser);
 	}
 
 	ret = read;
-- 
1.6.2.3

