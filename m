Return-Path: <linux-kernel-owner+w=401wt.eu-S1757027AbZBEHvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbZBEHvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 02:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbZBEHvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 02:51:42 -0500
Received: from relay.parallels.com ([195.214.232.42]:46484 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZBEHvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 02:51:41 -0500
From: Kirill Korotaev <dev@parallels.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Kirill Korotaev <dev@openvz.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 5 Feb 2009 10:51:34 +0300
Subject: Re: [git pull] timer fix
Thread-Topic: [git pull] timer fix
Thread-Index: AcmHHDKCNcHpXGZmTfqZcAI+1DKYBAASl4ly
Message-ID: <C5B07536.B77D%dev@parallels.com>
In-Reply-To: <20090204225848.GA3251@elte.hu>
Accept-Language: en-US, ru-RU
Content-Language: en
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, ru-RU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACK, it works. Why not save another 4 bytes of .bss then by changing
hept_t1_cmp to u32? ;-)

Kirill


On 2/5/09 1:58 AM, "Ingo Molnar" <mingo@elte.hu> wrote:

> 
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>>       } while ((s32)(hpet_readl(HPET_COUNTER) - hpet_t1_cmp) > 0);
> 
> that is also more efficient code by 6 bytes:
> 
> before:
> 
> ffffffff81020856:       ff c3                   inc    %ebx
> ffffffff81020858:       48 05 f0 00 00 00       add    $0xf0,%rax
> ffffffff8102085e:       8b 00                   mov    (%rax),%eax
> ffffffff81020860:       8b 15 2a 79 85 00       mov    0x85792a(%rip),%edx
> # ffffffff81878190 <hpet_t1_cmp>
> ffffffff81020866:       89 c0                   mov    %eax,%eax
> ffffffff81020868:       48 29 d0                sub    %rdx,%rax
> ffffffff8102086b:       48 85 c0                test   %rax,%rax
> ffffffff8102086e:       7f bf                   jg     ffffffff8102082f
> <hpet_rtc_interrupt+0x68>
> ffffffff81020870:       85 db                   test   %ebx,%ebx
> 
> after:
> 
> ffffffff81020856:       ff c3                   inc    %ebx
> ffffffff81020858:       48 05 f0 00 00 00       add    $0xf0,%rax
> ffffffff8102085e:       8b 00                   mov    (%rax),%eax
> ffffffff81020860:       2b 05 2a 79 85 00       sub    0x85792a(%rip),%eax
> # ffffffff81878190 <hpet_t1_cmp>
> ffffffff81020866:       85 c0                   test   %eax,%eax
> ffffffff81020868:       7f c5                   jg     ffffffff8102082f
> <hpet_rtc_interrupt+0x68>
> ffffffff8102086a:       85 db                   test   %ebx,%ebx
> 
> Kirill, Pavel, could you please re-test the updated commit attached below?
> 
>         Ingo
> 
> ---------------->
> From 66a36a1e95fe9de9c6a56f0bcd01f4ba21929f86 Mon Sep 17 00:00:00 2001
> From: Pavel Emelyanov <xemul@openvz.org>
> Date: Wed, 4 Feb 2009 13:40:31 +0300
> Subject: [PATCH] x86: fix hpet timer reinit for x86_64
> 
> There's a small problem with hpet_rtc_reinit function - it checks
> for the:
> 
>         hpet_readl(HPET_COUNTER) - hpet_t1_cmp > 0
> 
> to continue increasing both the HPET_T1_CMP (register) and the
> hpet_t1_cmp (variable).
> 
> But since the HPET_COUNTER is always 32-bit, if the hpet_t1_cmp
> is 64-bit this condition will always be FALSE once the latter hits
> the 32-bit boundary, and we can have a situation, when we don't
> increase the HPET_T1_CMP register high enough.
> 
> The result - timer stops ticking, since HPET_T1_CMP becomes less,
> than the COUNTER and never increased again.
> 
> The solution is (based on Linus's suggestion) to compare 64-bits
> (on 64-bit x86), but to do the comparison on 32-bit signed
> integers.
> 
> Reported-by: Kirill Korotaev <dev@openvz.org>
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/hpet.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index 64d5ad0..c761f91 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -1075,7 +1075,7 @@ static void hpet_rtc_timer_reinit(void)
>                 hpet_t1_cmp += delta;
>                 hpet_writel(hpet_t1_cmp, HPET_T1_CMP);
>                 lost_ints++;
> -       } while ((long)(hpet_readl(HPET_COUNTER) - hpet_t1_cmp) > 0);
> +       } while ((s32)(hpet_readl(HPET_COUNTER) - hpet_t1_cmp) > 0);
> 
>         if (lost_ints) {
>                 if (hpet_rtc_flags & RTC_PIE)

