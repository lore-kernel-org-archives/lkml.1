Return-Path: <linux-kernel-owner+w=401wt.eu-S1751089AbZKDFQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751089AbZKDFQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 00:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbZKDFQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 00:16:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57642 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbZKDFQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 00:16:19 -0500
Message-ID: <4AF10DEF.6070605@cn.fujitsu.com>
Date: Wed, 04 Nov 2009 13:15:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] ftrace: Call trace_parser_clear() properly
References: <4AF10DD9.4020902@cn.fujitsu.com>
In-Reply-To: <4AF10DD9.4020902@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found a weird behavior:

  # echo 'fuse:*' > set_ftrace_filter
  bash: echo: write error: Invalid argument
  # cat set_ftrace_filter
  fuse_dev_fasync
  fuse_dev_poll
  fuse_copy_do

We should call trace_parser_clear() no matter ftrace_process_regex()
returns 0 or -errno.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/ftrace.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c7fe869..b1acfb1 100644
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
1.6.3
