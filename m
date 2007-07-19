Return-Path: <linux-kernel-owner+w=401wt.eu-S1761819AbXGSLJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761819AbXGSLJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 07:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbXGSLJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 07:09:22 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:51401 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbXGSLJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 07:09:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WBk/7BWHo3pIO9XcgQKZb/aatBeQ4qgxprR2nHCRhdkA3+oIhKmlE40igk21j+tZt75gICDrsG4URNWKzMiWxP4RylQQG0ISP9I3uW4SjuHiGiVHZvb62AD01c15GjpJaH6QhqRvd0nkY8Vyqia69cCLw/dxKqW1qVcf9r2CK1E=
Message-ID: <a781481a0707190409r73fc0220g835fe818eeb2f6ac@mail.gmail.com>
Date: Thu, 19 Jul 2007 16:39:20 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] [14/58] x86_64: Add on_cpu_single
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070719095458.DB13914E06@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707191154.642492000@suse.de>
	 <20070719095458.DB13914E06@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On 7/19/07, Andi Kleen <ak@suse.de> wrote:
>
> Call a function on a target CPU but do the right thing when
> we're already on that CPU. That's the main difference from
> smp_call_function_single
> which does the wrong thing in this case (erroring out)

I think this is no longer the case, is it? With KVM updates already
merged in latest mainline -git, that modified smp_call_function_single()
behaviour ...

> +#ifdef CONFIG_SMP
> +/* Similar to smp_call_function_single, but DTRT when we're already
> +   on the right CPU. */
> +static inline void on_cpu_single(int cpu, void (*func)(void *), void *info)
> +{
> +       int me = get_cpu();
> +       if (cpu == me) {
> +               func(info);
> +               put_cpu();
> +       } else {
> +               put_cpu();
> +               /* wait is forced on because the me==cpu case above will always wait */
> +               smp_call_function_single(cpu, func, info, 0, 1);

In any case, this is unsafe. smp_call_function_single() -- with the old
semantics, which is what this patch assumes, obviously -- is quite
pointless without its _caller_ disabling preemption around it. So the
put_cpu() must come after the smp_call_function_single, otherwise
you won't even detect the error that might happen, seeing you're
ignoring its return and this wrapper being void-returning.

> +       }
> +}
> +#else
> +static inline void on_cpu_single(int cpu, void (*func)(void *), void *info)
> +{

WARN_ON(irqs_disabled());
local_irq_disable();

> +       func(info);

local_irq_restore();

> +}
> +#endif

... for the sake of API / behaviour consistency.


But probably you should just drop this ... with smp_call_function_single's
new semantics, I don't see this function growing any users.

Satyam
