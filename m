Return-Path: <linux-kernel-owner+w=401wt.eu-S1758421AbZHRANr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421AbZHRANr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 20:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbZHRANq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 20:13:46 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:52058 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbZHRANp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 20:13:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SQA3Ak0Z7iRCOX4Taxxo9swotPoXKBJAdibYOIJFR4KGuHfVzVl1pcgybjgYcvLFM8
         5LoI5QviSMvgjUniLpZKOAWLG3DSRKlJ5W6AQSxlnGaf89ALxQcCzxts01AGY1T7F3UT
         fChN3RX3EdhZ9AS/VgSE4LRhJLloOdl6zjmD0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [GIT PULL] tracing fix for 2.6.31
Date: Tue, 18 Aug 2009 02:13:42 +0200
Message-Id: <1250554422-5316-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the following tracing fix for .31

Thanks,
Frederic.


The following changes since commit df4ecf1524c7793de3121b2d4e5fc6bcc0da3bfb:
  Linus Torvalds (1):
        Merge branch 'upstream' of git://ftp.linux-mips.org/pub/scm/upstream-linus

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
	tracing/urgent

Zhaolei (1):
      ftrace: Unify effect of writing to trace_options and option/*

 kernel/trace/trace.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

---
>From f2d84b65b9778e8a35dd904f7d3993f0a60c9756 Mon Sep 17 00:00:00 2001
From: Zhaolei <zhaolei@cn.fujitsu.com>
Date: Fri, 7 Aug 2009 18:55:48 +0800
Subject: [PATCH] ftrace: Unify effect of writing to trace_options and option/*

"echo noglobal-clock > trace_options" can be used to change trace
clock but "echo 0 > options/global-clock" can't. The flag toggling
will be silently accepted without actually changing the clock callback.

We can fix it by using set_tracer_flags() in
trace_options_core_write().

Changelog:
v1->v2: Simplified switch() after Li Zefan <lizf@cn.fujitsu.com>'s
        suggestion

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c22b40f..8c35839 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3896,17 +3896,9 @@ trace_options_core_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	if (ret < 0)
 		return ret;
 
-	switch (val) {
-	case 0:
-		trace_flags &= ~(1 << index);
-		break;
-	case 1:
-		trace_flags |= 1 << index;
-		break;
-
-	default:
+	if (val != 0 && val != 1)
 		return -EINVAL;
-	}
+	set_tracer_flags(1 << index, val);
 
 	*ppos += cnt;
 
-- 
1.6.2.3

