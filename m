Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbZBEKAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbZBEKAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 05:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbZBEJ75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 04:59:57 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:49097 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628AbZBEJ74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 04:59:56 -0500
Message-ID: <498AB837.1040404@openvz.org>
Date: Thu, 05 Feb 2009 12:58:15 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Kirill Korotaev <dev@parallels.com>, Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Kirill Korotaev <dev@openvz.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] timer fix
References: <C5B07536.B77D%dev@parallels.com>
In-Reply-To: <C5B07536.B77D%dev@parallels.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill Korotaev wrote:
> ACK, it works. Why not save another 4 bytes of .bss then by changing
> hept_t1_cmp to u32? ;-)

Hm... .bss you say? :) The bloat-o-meter results would be:

For the original fix with casting hpet_t1_cmp to u32 inside the loop
add/remove: 0/0 grow/shrink: 1/0 up/down: 2/0 (2)
function                                     old     new   delta
hpet_rtc_interrupt                           741     743      +2

For the fix with casting the substitution result to s32
add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-2 (-2)
function                                     old     new   delta
hpet_rtc_interrupt                           741     739      -2

For the proposed by Kirill type change of the hpet_t1_cmp
add/remove: 0/0 grow/shrink: 0/3 up/down: 0/-6 (-6)
function                                     old     new   delta
hpet_rtc_timer_init                          186     185      -1
hpet_rtc_interrupt                           741     740      -1
hpet_t1_cmp                                    8       4      -4

That's the fix:

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 64d5ad0..dfbbb94 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -897,7 +897,7 @@ static unsigned long hpet_rtc_flags;
 static int hpet_prev_update_sec;
 static struct rtc_time hpet_alarm_time;
 static unsigned long hpet_pie_count;
-static unsigned long hpet_t1_cmp;
+static u32 hpet_t1_cmp;
 static unsigned long hpet_default_delta;
 static unsigned long hpet_pie_delta;
 static unsigned long hpet_pie_limit;

Reported-by: Kirill Korotaev <dev@openvz.org>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

This one also works. Should I re-send this patch in a proper way?

> Kirill
> 
> 
> On 2/5/09 1:58 AM, "Ingo Molnar" <mingo@elte.hu> wrote:
> 
>>
>> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>>>       } while ((s32)(hpet_readl(HPET_COUNTER) - hpet_t1_cmp) > 0);
>> that is also more efficient code by 6 bytes:
>>
>> before:
>>
>> ffffffff81020856:       ff c3                   inc    %ebx
>> ffffffff81020858:       48 05 f0 00 00 00       add    $0xf0,%rax
>> ffffffff8102085e:       8b 00                   mov    (%rax),%eax
>> ffffffff81020860:       8b 15 2a 79 85 00       mov    0x85792a(%rip),%edx
>> # ffffffff81878190 <hpet_t1_cmp>
>> ffffffff81020866:       89 c0                   mov    %eax,%eax
>> ffffffff81020868:       48 29 d0                sub    %rdx,%rax
>> ffffffff8102086b:       48 85 c0                test   %rax,%rax
>> ffffffff8102086e:       7f bf                   jg     ffffffff8102082f
>> <hpet_rtc_interrupt+0x68>
>> ffffffff81020870:       85 db                   test   %ebx,%ebx
>>
>> after:
>>
>> ffffffff81020856:       ff c3                   inc    %ebx
>> ffffffff81020858:       48 05 f0 00 00 00       add    $0xf0,%rax
>> ffffffff8102085e:       8b 00                   mov    (%rax),%eax
>> ffffffff81020860:       2b 05 2a 79 85 00       sub    0x85792a(%rip),%eax
>> # ffffffff81878190 <hpet_t1_cmp>
>> ffffffff81020866:       85 c0                   test   %eax,%eax
>> ffffffff81020868:       7f c5                   jg     ffffffff8102082f
>> <hpet_rtc_interrupt+0x68>
>> ffffffff8102086a:       85 db                   test   %ebx,%ebx
>>
>> Kirill, Pavel, could you please re-test the updated commit attached below?
>>
>>         Ingo
>>
>> ---------------->
>> From 66a36a1e95fe9de9c6a56f0bcd01f4ba21929f86 Mon Sep 17 00:00:00 2001
>> From: Pavel Emelyanov <xemul@openvz.org>
>> Date: Wed, 4 Feb 2009 13:40:31 +0300
>> Subject: [PATCH] x86: fix hpet timer reinit for x86_64
>>
>> There's a small problem with hpet_rtc_reinit function - it checks
>> for the:
>>
>>         hpet_readl(HPET_COUNTER) - hpet_t1_cmp > 0
>>
>> to continue increasing both the HPET_T1_CMP (register) and the
>> hpet_t1_cmp (variable).
>>
>> But since the HPET_COUNTER is always 32-bit, if the hpet_t1_cmp
>> is 64-bit this condition will always be FALSE once the latter hits
>> the 32-bit boundary, and we can have a situation, when we don't
>> increase the HPET_T1_CMP register high enough.
>>
>> The result - timer stops ticking, since HPET_T1_CMP becomes less,
>> than the COUNTER and never increased again.
>>
>> The solution is (based on Linus's suggestion) to compare 64-bits
>> (on 64-bit x86), but to do the comparison on 32-bit signed
>> integers.
>>
>> Reported-by: Kirill Korotaev <dev@openvz.org>
>> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> ---
>>  arch/x86/kernel/hpet.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
>> index 64d5ad0..c761f91 100644
>> --- a/arch/x86/kernel/hpet.c
>> +++ b/arch/x86/kernel/hpet.c
>> @@ -1075,7 +1075,7 @@ static void hpet_rtc_timer_reinit(void)
>>                 hpet_t1_cmp += delta;
>>                 hpet_writel(hpet_t1_cmp, HPET_T1_CMP);
>>                 lost_ints++;
>> -       } while ((long)(hpet_readl(HPET_COUNTER) - hpet_t1_cmp) > 0);
>> +       } while ((s32)(hpet_readl(HPET_COUNTER) - hpet_t1_cmp) > 0);
>>
>>         if (lost_ints) {
>>                 if (hpet_rtc_flags & RTC_PIE)
> 
> 
> 

