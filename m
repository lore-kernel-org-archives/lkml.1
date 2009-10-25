Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbZJYPSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbZJYPSW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 11:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbZJYPSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 11:18:18 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:52969 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbZJYPSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 11:18:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bpmddossNrOj77TAAFlGveuUHExkzNRVnh6j6LfwtNnCTVLnAHvONZxTXLsiFxmOai
         Zot0rJGIrNVZj9N8d0KLgBzzWuZlex8An81+axxAa1Bc22dpMFMsxvZPLLHWcQc6vnET
         ii5DP/0LECIpm5eFrrGhpOnUvsrHBFQyiJu6Y=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, rostedt@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
Subject: [PATCH -v5 08/11] tracing: not trace mips_timecounter_init() in MIPS
Date: Sun, 25 Oct 2009 23:16:59 +0800
Message-Id: <49b3c441a57f4db423732f81432a3450ccb3240e.1256483735.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <6140dd8f4e1783e5ac30977cf008bb98e4698322.1256483735.git.wuzhangjin@gmail.com>
References: <cover.1256482555.git.wuzhangjin@gmail.com>
 <028867b99ec532b84963a35e7d552becc783cafc.1256483735.git.wuzhangjin@gmail.com>
 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256483735.git.wuzhangjin@gmail.com>
 <3e0c2d7d8b8f196a8153beb41ea7f3cbf42b3d84.1256483735.git.wuzhangjin@gmail.com>
 <54c417629e91f40b2bbb4e08cda2a4e6527824c0.1256483735.git.wuzhangjin@gmail.com>
 <29bccff04932e993ecd9f516d8b6dcf84e2ceecf.1256483735.git.wuzhangjin@gmail.com>
 <72f2270f7b6e01ca7a4cdf4ac8c21778e5d9652f.1256483735.git.wuzhangjin@gmail.com>
 <6140dd8f4e1783e5ac30977cf008bb98e4698322.1256483735.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1256483735.git.wuzhangjin@gmail.com>
References: <cover.1256483735.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use mips_timecounter_init() to get the timestamp in MIPS, so, it's
better to not trace it, otherwise, it will goto recursion(hang) when
using function graph tracer.

but this patch have touched the common part in kernel/time/clocksource.c
and include/linux/clocksource.h, so it is not good, perhaps the better
solution is moving the whole mips_timecounter_init() implementation into
arch/mips, but that will introduce source code duplication. any other
solution?

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/include/asm/time.h |    2 +-
 arch/mips/kernel/csrc-r4k.c  |    4 ++--
 include/linux/clocksource.h  |    2 +-
 kernel/time/clocksource.c    |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/mips/include/asm/time.h b/arch/mips/include/asm/time.h
index b8af7fa..e1c660f 100644
--- a/arch/mips/include/asm/time.h
+++ b/arch/mips/include/asm/time.h
@@ -77,7 +77,7 @@ extern int init_r4k_timecounter(void);
 extern u64 r4k_timecounter_read(void);
 #endif
 
-static inline u64 mips_timecounter_read(void)
+static inline u64 notrace mips_timecounter_read(void)
 {
 #ifdef CONFIG_CSRC_R4K
 	return r4k_timecounter_read();
diff --git a/arch/mips/kernel/csrc-r4k.c b/arch/mips/kernel/csrc-r4k.c
index 4e7705f..0690bea 100644
--- a/arch/mips/kernel/csrc-r4k.c
+++ b/arch/mips/kernel/csrc-r4k.c
@@ -42,7 +42,7 @@ static struct timecounter r4k_tc = {
 	.cc = NULL,
 };
 
-static cycle_t r4k_cc_read(const struct cyclecounter *cc)
+static cycle_t notrace r4k_cc_read(const struct cyclecounter *cc)
 {
 	return read_c0_count();
 }
@@ -66,7 +66,7 @@ int __init init_r4k_timecounter(void)
 	return 0;
 }
 
-u64 r4k_timecounter_read(void)
+u64 notrace r4k_timecounter_read(void)
 {
 	u64 clock;
 
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 83d2fbd..2a02992 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -73,7 +73,7 @@ struct timecounter {
  * XXX - This could use some mult_lxl_ll() asm optimization. Same code
  * as in cyc2ns, but with unsigned result.
  */
-static inline u64 cyclecounter_cyc2ns(const struct cyclecounter *cc,
+static inline u64 notrace cyclecounter_cyc2ns(const struct cyclecounter *cc,
 				      cycle_t cycles)
 {
 	u64 ret = (u64)cycles;
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 5e18c6a..9ce9d02 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -52,7 +52,7 @@ EXPORT_SYMBOL(timecounter_init);
  * The first call to this function for a new time counter initializes
  * the time tracking and returns an undefined result.
  */
-static u64 timecounter_read_delta(struct timecounter *tc)
+static u64 notrace timecounter_read_delta(struct timecounter *tc)
 {
 	cycle_t cycle_now, cycle_delta;
 	u64 ns_offset;
@@ -72,7 +72,7 @@ static u64 timecounter_read_delta(struct timecounter *tc)
 	return ns_offset;
 }
 
-u64 timecounter_read(struct timecounter *tc)
+u64 notrace timecounter_read(struct timecounter *tc)
 {
 	u64 nsec;
 
-- 
1.6.2.1

