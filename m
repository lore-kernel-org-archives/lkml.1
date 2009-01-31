Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZAaTHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZAaTHB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 14:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZAaTGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 14:06:53 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:42316 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751430AbZAaTGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 14:06:52 -0500
Date: Sat, 31 Jan 2009 22:06:50 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ftrace: On PowerPC we don't need frame pointers for
	CALLER_ADDRs
Message-ID: <20090131190650.GA4284@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to this discussion:

http://lkml.org/lkml/2008/7/25/338
http://lkml.org/lkml/2008/7/26/72

Frame pointers do nothing useful on PowerPC, so lib/Kconfig.debug
makes CONFIG_FRAME_POINTER unselectable on PPC targets. But ftrace.h
requires CONFIG_FRAME_POINTER for CALLER_ADDR macros. Therefore
tracing is completely useless on PowerPC:

[...]
  <idle>-0       0X.h3    2us+:      0:140:R   + [000]  1733:120:S mvtsd
  <idle>-0       0X.h3    9us+: 0 (0)
  <idle>-0       0X..3   72us : 0 (0)
  <idle>-0       0X..3   73us :      0:140:R ==> [000]  1733:120:R mvtsd

On PPC we can safely use __builtin_return_address(1..6) w/o frame
pointers, and with this patch the trace output looks OK:

[...]
  <idle>-0       0X.h3    2us+:      0:140:R   + [000]  1740:120:S mvtsd
  <idle>-0       0X.h3    9us+: hrtimer_wakeup (__run_hrtimer)
  <idle>-0       0X..3   87us : cpu_idle (__got2_end)
  <idle>-0       0X..3   89us :      0:140:R ==> [000]  1740:120:R mvtsd

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---

Btw, on PowerPC tracing is also broken w/o "ring-buffer: fix alignment
problem" patch (currently collecting dust in the -tip tree, commit
082605de5f82eb692cc90f7fda071cc01bb5ac34). Any chance the fix go into
Linus' tree, to not waste other people's time bisecting and debugging
the problem? ;-)

For google: tracing, regression, "ring-buffer: move some metadata
into buffer page", commit abc9b56d66fbd4d93302ef4bf6fa726e1b8255f9,
answer is here.

 include/linux/ftrace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9c5bc6b..13eba02 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -146,7 +146,7 @@ static inline void __ftrace_enabled_restore(int enabled)
 #endif
 }
 
-#ifdef CONFIG_FRAME_POINTER
+#if defined(CONFIG_FRAME_POINTER) || defined(CONFIG_PPC)
 /* TODO: need to fix this for ARM */
 # define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
 # define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
-- 
1.5.6.5
