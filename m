Return-Path: <linux-kernel-owner+w=401wt.eu-S936584AbZLQSpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936584AbZLQSpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964935AbZLQSpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:45:43 -0500
Received: from claw.goop.org ([74.207.240.146]:57783 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936652AbZLQSpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:45:40 -0500
Message-ID: <4B2A7C50.5080403@goop.org>
Date: Thu, 17 Dec 2009 10:45:36 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Fedora/3.0-3.13.rc2.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Ian Campbell <ian.campbell@citrix.com>
CC: linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] microcode: do not WARN_ON(cpu != 0) during resume
References: <1261058024-32278-1-git-send-email-ian.campbell@citrix.com>
In-Reply-To: <1261058024-32278-1-git-send-email-ian.campbell@citrix.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2009 05:53 AM, Ian Campbell wrote:
> 871b72dd "x86: microcode: use smp_call_function_single instead of
> set_cpus_allowed, cleanup of synchronization logic" included:
>
>   static int mc_sysdev_resume(struct sys_device *dev)
>   {
> [...]
> +       /*
> +        * All non-bootup cpus are still disabled,
> +        * so only CPU 0 will apply ucode here.
> +        *
> +        * Moreover, there can be no concurrent
> +        * updates from any other places at this point.
> +        */
> +       WARN_ON(cpu != 0);
>
> However suspend/resume under Xen doesn't need to hot unplug all the CPUs, so we
> don't; the hypervisor can manage the context save/restore for all CPUs.
>    

Did you see a problem with this in practice, or just by inspection?

The Xen microcode driver will only load in a privileged domain, so I 
don't think this path can ever be exercised.

Regardless, the Xen microcode driver changes aren't upstream yet, so 
there's no need to apply this there yet.

Thanks,
     J

> It would be unnecessary to load microcode.ko in a Xen domU but if it does occur
> (e.g. because a distro installs the tools by default) we would like to avoid
> the warning on resume.
>
> Since the real constraint here is that we are running on the CPU for which we
> would like to load microcode (which in all practical circumstances is CPU0)
> just check for that and return if we are resuming a different CPU.
>
> There is no danger of concurrent updates, even if we ignore the fact that all
> but one CPUs are unplugged on native, because sysdev_resume() is single
> threaded.
>
> Signed-off-by: Ian Campbell<ian.campbell@citrix.com>
> Cc: Jeremy Fitzhardinge<jeremy@goop.org>
> Cc: Dmitry Adamushko<dmitry.adamushko@gmail.com>
> Cc: Hugh Dickins<hugh@veritas.com>
> Cc: Ingo Molnar<mingo@elte.hu>
> ---
>   arch/x86/kernel/microcode_core.c |   11 +----------
>   1 files changed, 1 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
> index 378e9a8..1153062 100644
> --- a/arch/x86/kernel/microcode_core.c
> +++ b/arch/x86/kernel/microcode_core.c
> @@ -438,18 +438,9 @@ static int mc_sysdev_resume(struct sys_device *dev)
>   	int cpu = dev->id;
>   	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
>
> -	if (!cpu_online(cpu))
> +	if (cpu != smp_processor_id())
>   		return 0;
>
> -	/*
> -	 * All non-bootup cpus are still disabled,
> -	 * so only CPU 0 will apply ucode here.
> -	 *
> -	 * Moreover, there can be no concurrent
> -	 * updates from any other places at this point.
> -	 */
> -	WARN_ON(cpu != 0);
> -
>   	if (uci->valid&&  uci->mc)
>   		microcode_ops->apply_microcode(cpu);
>
>    

