Return-Path: <linux-kernel-owner+w=401wt.eu-S1758211AbZBEQE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211AbZBEQE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbZBEQES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:04:18 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:38326 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbZBEQER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:04:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Xm4a+AQuyGHPWDCiN0dacmud2CXnF7YXtw58Zvd7UrACUw7StgPDmkHOoq5RMisyf8
         K/Z69/RzFBv4q4354j3cKsSnUM1ldqfoUS+oJvPMFaX9trMOoMsyeBzfhK5wE3L6aROQ
         GUrIaMetRjE0gqMJR5daqnKFSsp699CMP/DmA=
MIME-Version: 1.0
In-Reply-To: <498AB837.1040404@openvz.org>
References: <C5B07536.B77D%dev@parallels.com> <498AB837.1040404@openvz.org>
Date: Thu, 5 Feb 2009 08:04:15 -0800
X-Google-Sender-Auth: 681ea0a70d98703d
Message-ID: <2c0942db0902050804w2e1adc12hbeae29582e5f7193@mail.gmail.com>
Subject: Re: [git pull] timer fix
From: Ray Lee <ray-lk@madrabbit.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Kirill Korotaev <dev@parallels.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kirill Korotaev <dev@openvz.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 1:58 AM, Pavel Emelyanov <xemul@openvz.org> wrote:
> Kirill Korotaev wrote:
>> ACK, it works. Why not save another 4 bytes of .bss then by changing
>> hept_t1_cmp to u32? ;-)
>
> Hm... .bss you say? :) The bloat-o-meter results would be:
>
> For the original fix with casting hpet_t1_cmp to u32 inside the loop
> add/remove: 0/0 grow/shrink: 1/0 up/down: 2/0 (2)
> function                                     old     new   delta
> hpet_rtc_interrupt                           741     743      +2
>
> For the fix with casting the substitution result to s32
> add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-2 (-2)
> function                                     old     new   delta
> hpet_rtc_interrupt                           741     739      -2
>
> For the proposed by Kirill type change of the hpet_t1_cmp
> add/remove: 0/0 grow/shrink: 0/3 up/down: 0/-6 (-6)
> function                                     old     new   delta
> hpet_rtc_timer_init                          186     185      -1
> hpet_rtc_interrupt                           741     740      -1
> hpet_t1_cmp                                    8       4      -4
>
> That's the fix:
>
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index 64d5ad0..dfbbb94 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -897,7 +897,7 @@ static unsigned long hpet_rtc_flags;
>  static int hpet_prev_update_sec;
>  static struct rtc_time hpet_alarm_time;
>  static unsigned long hpet_pie_count;
> -static unsigned long hpet_t1_cmp;
> +static u32 hpet_t1_cmp;
>  static unsigned long hpet_default_delta;
>  static unsigned long hpet_pie_delta;
>  static unsigned long hpet_pie_limit;
>
> Reported-by: Kirill Korotaev <dev@openvz.org>
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
>
> This one also works. Should I re-send this patch in a proper way?

Ugh. This version seems too subtle for a new reader coming into this
code. I'd prefer the fix be kept in the comparison site, where people
already expect wraparound issues.

If you don't have time to add the helper, I'd really rather see the
version with the explicit cast acting as documentation, rather than a
test that magically works due to type issues.

Dunno, maybe it's just me.
