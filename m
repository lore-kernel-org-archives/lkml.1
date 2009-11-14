Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbZKNGfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbZKNGfZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 01:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbZKNGfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 01:35:23 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:36800 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbZKNGfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 01:35:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ho2WVi9ORxi+fnUiiDtloQMCUDWf/CyhEcDw4jhxbSzsljLNM13173p+LP2iAZSlQq
         vk0VGROyer2LpZXdPGzGgn9FJ3ydJsmd/eI2GBdNLMkoyh1GnkmfoyVKnNxJx9lVWrKv
         fD2TGJIPnUWrzJdx4kkccXh8RTocAYu0rCqR0=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: rostedt@goodmis.org, Ralf Baechle <ralf@linux-mips.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>,
       "Maciej W . Rozycki" <macro@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, zhangfx@lemote.com, zhouqg@gmail.com
Subject: [PATCH v8 09/16] tracing: define a new __time_notrace annotation flag
Date: Sat, 14 Nov 2009 14:33:24 +0800
Message-Id: <c1fe0d6822e98bc0ffd2dfee7a579fbbe21430e0.1258177321.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <99ebd8fcb19e4cccd702fca966405ffc45f8540b.1258177321.git.wuzhangjin@gmail.com>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1258177321.git.wuzhangjin@gmail.com>
 <b99c08397d9ff92ac5a72bda9131df41b702fc71.1258177321.git.wuzhangjin@gmail.com>
 <8f579e2cece16cd22358a4ec143ef6a8c462639b.1258177321.git.wuzhangjin@gmail.com>
 <ea337742d3ca7eec2825416041a6d4fa917d5cc4.1258177321.git.wuzhangjin@gmail.com>
 <7c7568247ad6cc109ec20387cfc3ca258d1d430f.1258177321.git.wuzhangjin@gmail.com>
 <3fcaffcfb3c8c8cd3015151ed5b7480ccaecde0f.1258177321.git.wuzhangjin@gmail.com>
 <48676d84140dbafd46e530611766121e18abc4ef.1258177321.git.wuzhangjin@gmail.com>
 <99ebd8fcb19e4cccd702fca966405ffc45f8540b.1258177321.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1258177321.git.wuzhangjin@gmail.com>
References: <cover.1258177321.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

Ftrace gets the timestamp via time relative functions, when enabling
function graph tracer, if we also trace these functions, the system will
go into recusion and then hang there. So, we must not trace them. and
there are two existing methods help this job.

The first one is annotating them with notrace, another method is
removing the -pg for the whole file which included them:

CFLAGS_REMOVE_ftrace.o = -pg

But there is a particular situation, that is some archs(i.e MIPS,
Microblaze) need to notrace the common time relative source code, we can
not simply annotate them with the above methods, but need to consider
the archs respectively. this patch does it!

This patch introduce a new annotation flag: __time_notrace, if your
platform need it, define it in your arch specific ftrace.h:

	#define __time_notrace notrace

if only function graph trace need it, wrap it:

	#ifdef CONFIG_FUNCTION_GRAPH_TRACER
	 #define __time_notrace notrace
	#endif

otherwise, ignore it!

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 include/linux/ftrace.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 0b4f97d..c3f2f0f 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -511,4 +511,16 @@ static inline void trace_hw_branch_oops(void) {}
 
 #endif /* CONFIG_HW_BRANCH_TRACER */
 
+/* arch specific notrace for time relative functions, If your arch need it,
+ * define it in the arch specific ftrace.h
+ *
+ *	#define __time_notrace notrace
+ *
+ * otherwise, ignore it!
+ */
+
+#ifndef __time_notrace
+ #define __time_notrace
+#endif
+
 #endif /* _LINUX_FTRACE_H */
-- 
1.6.2.1

