Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbZCCBUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbZCCBUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 20:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbZCCBUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 20:20:09 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:42257 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbZCCBUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 20:20:08 -0500
Message-ID: <49AC85C1.7060600@ct.jp.nec.com>
Date: Mon, 02 Mar 2009 17:20:01 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: x86-tip: xine bustage bisection fingers commit	97286a2b64725aac2d584ddd1f94871f9991d5a1
References: <1235984665.6195.12.camel@marge.simson.net> <20090302093319.GB20897@elte.hu>
In-Reply-To: <20090302093319.GB20897@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
>> Greetings and Salutations,
>>
>> $subject, box is Q6600 X86_64 running v2.6.29-rc6-2261-g0fdaeee
>>
>> marge:/root # xine
>> This is xine (X11 gui) - a free video player v0.99.6cvs.
>> (c) 2000-2007 The xine Team.
>> Floating point exception
>>
>> [pid  6230] 06:59:50.524473 set_robust_list(0x40e239f0, 0x18 <unfinished ...>
>> [pid  6230] 06:59:50.524553 <... set_robust_list resumed> ) = 0 <0.000027>
>> [pid  6230] 06:59:50.524648 select(0, NULL, NULL, NULL, {0, 500000} <unfinished ...>
>> [pid  6230] 06:59:50.763988 <... select resumed> ) = ? ERESTARTNOHAND (To be restarted) <0.239321>
>> [pid  6230] 06:59:50.764012 --- SIGRT_1 (Unknown signal 33) @ 0 (0) ---
>> [pid  6230] 06:59:50.764074 setuid(0)   = 0 <0.000014>
>> [pid  6230] 06:59:50.764151 futex(0x7fff2745e7a0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
>> [pid  6230] 06:59:50.764213 <... futex resumed> ) = 0 <0.000051>
>> [pid  6230] 06:59:50.764255 futex(0x40e23d2c, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
>> [pid  6230] 06:59:50.764298 <... futex resumed> ) = 0 <0.000028>
>> [pid  6230] 06:59:50.764346 rt_sigreturn(0x40e23d2c <unfinished ...>
>> [pid  6230] 06:59:50.778497 <... rt_sigreturn resumed> ) = 0 <0.014136>
>> [pid  6230] 06:59:50.778524 --- SIGSEGV (Segmentation fault) @ 0 (0) ---
>>
>> [ 1303.345419] xine[6230] bad frame in rt_sigreturn frame:0000000040e22c28 ip:7f051ca28622 sp:40e23070 orax:ffffffffffffffff in libc-2.8.so[7f051c95c000+14f000]
>> ﻿
>> 97286a2b64725aac2d584ddd1f94871f9991d5a1 is first bad commit
>> commit 97286a2b64725aac2d584ddd1f94871f9991d5a1
>> Author: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>> Date:   Fri Feb 27 10:28:48 2009 -0800
>>
>>     x86: signal: intrroduce get_sigframe() and replace get_sigstack()
>>     
>>     Impact: cleanup
> 
> ok, that's the same area Jaswinder Singh Rajput bisected a 
> breakage back to. I've excluded these commits from tip:master 
> for now and pushed out an updated tip:master tree.
> 
> Hiroshi-san, mind having a look at this problem?

Hi Ingo,

I made a patch to fix this issue.
This patch is against tip/x86/signal.

I've tried tip/x86/signal and seen bad frame with firefox.
After applied this patch, it looks fine.

Thanks,
Hiroshi
========
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: [PATCH] x86: signal: fix get_sigframe() on 64-bit

Impact: fix bad frame in rt_sigreturn on 64-bit

After commit 97286a2b64725aac2d584ddd1f94871f9991d5a1 some applications fail
to return from signal handler.

[  145.150133] firefox[3250] bad frame in rt_sigreturn frame:00007f902b44eb28 ip:352e80b307 sp:7f902b44ef70 orax:ffffffffffffffff in libpthread-2.9.so[352e800000+17000]
[  665.519017] firefox[5420] bad frame in rt_sigreturn frame:00007faa8deaeb28 ip:352e80b307 sp:7faa8deaef70 orax:ffffffffffffffff in libpthread-2.9.so[352e800000+17000]

The root cause is forgetting to keep 64 byte aligned value of fpstate for next
stack pointer calculation.

Reported-by: Jaswinder Singh Rajput <jaswinder@kernel.org>
Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index dde3f2a..d2cc642 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -240,11 +240,10 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 
 	if (used_math()) {
 		sp -= sig_xstate_size;
-#ifdef CONFIG_X86_32
-		*fpstate = (void __user *) sp;
-#else /* !CONFIG_X86_32 */
-		*fpstate = (void __user *)round_down(sp, 64);
-#endif /* CONFIG_X86_32 */
+#ifdef CONFIG_X86_64
+		sp = round_down(sp, 64);
+#endif /* CONFIG_X86_64 */
+		*fpstate = (void __user *)sp;
 
 		if (save_i387_xstate(*fpstate) < 0)
 			return (void __user *)-1L;
-- 
1.6.1.2


