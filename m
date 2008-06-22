Return-Path: <linux-kernel-owner+w=401wt.eu-S1752478AbYFVHau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbYFVHau (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 03:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYFVHal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 03:30:41 -0400
Received: from saeurebad.de ([85.214.36.134]:50250 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbYFVHak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 03:30:40 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Philippe Elie <phil.el@wanadoo.fr>,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/oprofile: disable preemption in nmi_shutdown
References: <20080621215518.GA5715@damson.getinternet.no>
Date: Sun, 22 Jun 2008 09:30:28 +0200
In-Reply-To: <20080621215518.GA5715@damson.getinternet.no> (Vegard Nossum's
	message of "Sat, 21 Jun 2008 23:55:18 +0200")
Message-ID: <878wwylyej.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vegard,

Vegard Nossum <vegard.nossum@gmail.com> writes:

> Hi,
>
> Does this look correct? I didn't really play with preemption before, but
> as far as I can tell, this is the right thing to do.
>
> I don't really get why model->shutdown(msrs) is done only for one of the
> CPUs, but my patch assumes that this is correct. (If that had been done
> from inside nmi_shutdown() for each CPU, we wouldn't have had to get the
> cpu var, and not needed to disable preemption.)
>
> Please comment :-)
>
>
> Vegard
>
>
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Sat, 21 Jun 2008 23:44:19 +0200
> Subject: [PATCH] x86/oprofile: disable preemption in nmi_shutdown
>
>     BUG: using smp_processor_id() in preemptible [00000000] code: oprofiled/27301
>     caller is nmi_shutdown+0x11/0x60
>     Pid: 27301, comm: oprofiled Not tainted 2.6.26-rc7 #25
>      [<c028a90d>] debug_smp_processor_id+0xbd/0xc0
>      [<c045fba1>] nmi_shutdown+0x11/0x60
>      [<c045dd4a>] oprofile_shutdown+0x2a/0x60
>
> Note that we don't need this for the other functions, since they are all
> called with on_each_cpu() (which disables preemption for us anyway).
>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  arch/x86/oprofile/nmi_int.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
> index cc48d3f..4a177b4 100644
> --- a/arch/x86/oprofile/nmi_int.c
> +++ b/arch/x86/oprofile/nmi_int.c
> @@ -269,12 +269,16 @@ static void nmi_cpu_shutdown(void *dummy)
>  
>  static void nmi_shutdown(void)
>  {
> -	struct op_msrs *msrs = &__get_cpu_var(cpu_msrs);
> +	struct op_msrs *msrs;
> +
> +	preempt_disable();
> +	msrs = &__get_cpu_var(cpu_msrs);
>  	nmi_enabled = 0;
>  	on_each_cpu(nmi_cpu_shutdown, NULL, 0, 1);
>  	unregister_die_notifier(&profile_exceptions_nb);
>  	model->shutdown(msrs);
>  	free_msrs();
> +	preempt_enable();

Have a look at get_cpu_var() and put_cpu_var(), that is exactly the
pattern.

	Hannes
