Return-Path: <linux-kernel-owner+w=401wt.eu-S935314AbXGSMRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935314AbXGSMRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbXGSMQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:16:50 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:25935 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758771AbXGSMQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:16:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GF9Gx90UJu91nSp7vTmpXbA5NGId8Pr13Al4/V0Yc/F25agEwDzs6oURl8BaFcM8+RIQKihnn32mWKF5zGM/Z90vV9CTGaEFoqe+6XOD3VWvam3LMX3QzDjMwTiocyXVxEwsWw9dj7mm04xIJYy/szXkFVCllMxVfZy8dKhQfAI=
Message-ID: <a781481a0707190516m651cc7bbs7ac8fc3510d8f5d6@mail.gmail.com>
Date: Thu, 19 Jul 2007 17:46:48 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] [19/58] x86_64: Don't use softirq save locks in smp_call_function
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070719095504.376B614E06@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707191154.642492000@suse.de>
	 <20070719095504.376B614E06@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/19/07, Andi Kleen <ak@suse.de> wrote:
>
> It is not fully softirq safe anyways.

Ack

[ sorry, I remember having promised to send such a patch myself
some time ago, but just forgot about it ... ]

> Can't do a WARN_ON unfortunately because it could trigger in the
> panic case.

But this is not true at all. This function doesn't come anywhere
on the panic codepath.

> +++ linux/arch/x86_64/kernel/smp.c
> @@ -386,9 +386,9 @@ int smp_call_function_single (int cpu, v
>                 return 0;
>         }

So I'd say we do need a:

WARN_ON(irqs_disabled() || in_interrupt());

or something right about here ...

> -       spin_lock_bh(&call_lock);
> +       spin_lock(&call_lock);
>         __smp_call_function_single(cpu, func, info, nonatomic, wait);
> -       spin_unlock_bh(&call_lock);
> +       spin_unlock(&call_lock);
>         put_cpu();
>         return 0;
>  }

And oh, by the way, you can safely go ahead and put that warning
in smp_call_function() *also*.

Note that panic() -> smp_send_stop() -> calls into the lower-level
__smp_call_function() directly.

So neither smp_call_function() nor smp_call_function_single() come
in the panic codepath -- the warnings there would be okay.

Satyam
