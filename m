Return-Path: <linux-kernel-owner+w=401wt.eu-S934938AbZLKIjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934938AbZLKIjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 03:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933386AbZLKIj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 03:39:27 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:47630 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762254AbZLKIj0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 03:39:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=AsXEH+33ZN5U4AQTl+QLp5F7dUqKJhz6OV3lKAFrAirDx/FexELjV0+zIfxJ3i8Hrz
         xFNTbTQlRUDt8Djw5UojKLONaCF2sCtMbeHFfkKzdZDLI9/iGjX4tRf+J1yR9PHttXUy
         0FJhcBzap4Wu9Mt35LbJpYKmN4wSuLuAUhU4w=
MIME-Version: 1.0
In-Reply-To: <tip-125580380f418000b1a06d9a54700f1191b6e561@git.kernel.org>
References: <20091210165634.GF5086@lenovo>
	 <tip-125580380f418000b1a06d9a54700f1191b6e561@git.kernel.org>
Date: Fri, 11 Dec 2009 09:39:32 +0100
Message-ID: <ffd8902a0912110039y518788eep4a000e16777401be@mail.gmail.com>
Subject: Re: [tip:perf/urgent] x86, perf events: Check if we have APIC enabled
From: Christian Hartmann <cornogle@googlemail.com>
To: linux-kernel@vger.kernel.org, Ralf.Hildebrandt@charite.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

wow, I reported this bug also "PROBLEM: WARNING: at
arch/x86/kernel/apic/apic.c:249 native_apic_write_dummy+0x32/0x3e()
(git 2.6.32-rc5)" on 22.october 09, this a delay of 1,5 month ;)
But anyway, good to know, that they comes now a hint from the kernel
by this patch... :)





2009/12/10 tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>:
> Commit-ID:  125580380f418000b1a06d9a54700f1191b6e561
> Gitweb:     http://git.kernel.org/tip/125580380f418000b1a06d9a54700f1191b6e561
> Author:     Cyrill Gorcunov <gorcunov@openvz.org>
> AuthorDate: Thu, 10 Dec 2009 19:56:34 +0300
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 10 Dec 2009 18:00:30 +0100
>
> x86, perf events: Check if we have APIC enabled
>
> Ralf Hildebrandt reported this boot warning:
>
> | Running a vanilla 2.6.32 as Xen DomU, I'm getting:
> |
> | [    0.000999] CPU: Physical Processor ID: 0
> | [    0.000999] CPU: Processor Core ID: 1
> | [    0.000999] Performance Events: AMD PMU driver.
> | [    0.000999] ------------[ cut here ]------------
> | [    0.000999] WARNING: at arch/x86/kernel/apic/apic.c:249 native_apic_write_dummy
>
> So we need to check if APIC functionality is available, and
> not just in the P6 driver but elsewhere as well.
>
> Reported-by: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> LKML-Reference: <20091210165634.GF5086@lenovo>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/cpu/perf_event.c |   18 ++++++++++++------
>  1 files changed, 12 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 1342f23..18f05ec 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -2066,12 +2066,6 @@ static __init int p6_pmu_init(void)
>
>        x86_pmu = p6_pmu;
>
> -       if (!cpu_has_apic) {
> -               pr_info("no APIC, boot with the \"lapic\" boot parameter to force-enable it.\n");
> -               pr_info("no hardware sampling interrupt available.\n");
> -               x86_pmu.apic = 0;
> -       }
> -
>        return 0;
>  }
>
> @@ -2163,6 +2157,16 @@ static __init int amd_pmu_init(void)
>        return 0;
>  }
>
> +static void __init pmu_check_apic(void)
> +{
> +       if (cpu_has_apic)
> +               return;
> +
> +       x86_pmu.apic = 0;
> +       pr_info("no APIC, boot with the \"lapic\" boot parameter to force-enable it.\n");
> +       pr_info("no hardware sampling interrupt available.\n");
> +}
> +
>  void __init init_hw_perf_events(void)
>  {
>        int err;
> @@ -2184,6 +2188,8 @@ void __init init_hw_perf_events(void)
>                return;
>        }
>
> +       pmu_check_apic();
> +
>        pr_cont("%s PMU driver.\n", x86_pmu.name);
>
>        if (x86_pmu.num_events > X86_PMC_MAX_GENERIC) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
-- 
......oooO..............
.....(....).....Oooo...
......)../.....(....)....
.....(_/.......)../.....
...............(_/.......
... I WAS ..............
.......... HERE...... ;)
