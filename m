Return-Path: <linux-kernel-owner+w=401wt.eu-S1758677AbZJGHO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbZJGHO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 03:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758258AbZJGHO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 03:14:28 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:54377 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715AbZJGHO1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 03:14:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=M+g/Xz45G9LmynU/HZSk2YuomwQ4zF3u9WlGJ3CedKahAoVsZWYH7X3u1YJaQZ5hD3
         iFU+r/hRJrq/vd1eLUQse5HLZunmYGz7U4v5CDgznXSm0euuqGp2OiO9TuYNLBnjO/wA
         DK+dhrSF5QfyhOHzwq/pg6LC70vIMYzIQMPc0=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0910062202590.5950@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0908212319370.1769@localhost.localdomain>
	 <alpine.LFD.2.00.0908261910460.2888@localhost.localdomain>
	 <alpine.LFD.2.00.0908282326460.19335@localhost.localdomain>
	 <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain>
	 <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain>
	 <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain>
	 <3efb10970910061123k2b6826bci11f0f42509173b26@mail.gmail.com>
	 <alpine.LFD.2.00.0910062122230.5950@localhost.localdomain>
	 <alpine.LFD.2.00.0910062202590.5950@localhost.localdomain>
Date: Wed, 7 Oct 2009 09:13:51 +0200
X-Google-Sender-Auth: 0587aceb2d118994
Message-ID: <3efb10970910070013p447fdd99o22699967a9e51070@mail.gmail.com>
Subject: Re: [ANNOUNCE] 2.6.31.2-rt13
From: Remy Bohmer <linux@bohmer.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

> 2009/10/6 Thomas Gleixner <tglx@linutronix.de>:
> On Tue, 6 Oct 2009, Thomas Gleixner wrote:
>
>> On Tue, 6 Oct 2009, Remy Bohmer wrote:
>> > But I was wondering if you missed this one:
>> > http://patchwork.kernel.org/patch/50044/
>>
>> Yup, slipped through. Queued for the next release.
>
> Correction. I dropped the patch as it is just a sloppy work around.
> Why creating the thread in the first place ? Real fix below.

Yeah, I thought about that too.

>
> Thanks,
>
>        tglx
> ---
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index aae8d45..3526976 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -1161,6 +1161,8 @@ static int __cpuinit cpu_callback(struct notifier_block *nfb,
>                        per_cpu(ksoftirqd, hotcpu)[i].tsk = NULL;
>                }
>                for (i = 0; i < NR_SOFTIRQS; i++) {
> +                       if (!softirq_names[i])
> +                               continue;

But I did not do this because I thought this was sloppy as well, I
guessed you would never accept a patch that only looks at defining the
name, how wrong could I be... ;-)
So, going for the cleaner solution, I was going for not defining the
HRTIMER_SOFTIRQ in the enum in include/linux/interrupt.h in the first
place, but that would touch even more code, and at least that makes
clear how much the code is strangled.

The loop 'for (i = 0; i < NR_SOFTIRQS; i++)' is used at many more
places, would this 'if (!softirq_names[i])' not be required at other
places as well?

Remy
