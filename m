Return-Path: <linux-kernel-owner+w=401wt.eu-S1758118AbZFCOsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118AbZFCOsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbZFCOsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:48:08 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:62747 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbZFCOsH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:48:07 -0400
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Jun 2009 10:48:06 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vEYYIUIi57V/6ZIfakw6u2zCM/eqgBg5P2aPmU7Svvol9mp1yecVHUwD+WsUHxLhBs
         1PJKYluMKeheq6nFYuXkKG9jR3BQ8DFI9OLUvs9KXgAVdg6+LfeTz4zseqLTebL+BK3r
         M2XxtpVH1XZ0u7XvWklIDA78nH920FD7+G+RI=
MIME-Version: 1.0
In-Reply-To: <20090603143559.GL5736@alberich.amd.com>
References: <20090603142727.GI5736@alberich.amd.com>
	 <20090603143559.GL5736@alberich.amd.com>
Date: Wed, 3 Jun 2009 16:48:07 +0200
Message-ID: <36ca99e90906030748l6e6cc2caqb575c924836dc0e@mail.gmail.com>
Subject: Re: [PATCH 3/5] x86: add cpu_node topology detection for AMD 
	Magny-Cours
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 3, 2009 at 16:35, Andreas Herrmann
<andreas.herrmann3@amd.com> wrote:
> This adapts CPU topology detection for AMD Magny-Cours.
>
> Here is example output from two cores on same package but different
> internal cpu_nodes:
>
> /sys/devices/system/cpu/cpu5:
>  physical_package_id        : 0
>  core_id                    : 5
>  thread_siblings            : 00000020
>  thread_siblings_list       : 5
>  cpu_node_id                : 0
>  cpu_node_siblings          : 0000003f
>  cpu_node_siblings_list     : 0-5
>  core_siblings              : 00000fff
>  core_siblings_list         : 0-11
> /sys/devices/system/cpu/cpu6:
>  physical_package_id        : 0
>  core_id                    : 0
>  thread_siblings            : 00000040
>  thread_siblings_list       : 6
>  cpu_node_id                : 1
>  cpu_node_siblings          : 00000fc0
>  cpu_node_siblings_list     : 6-11
>  core_siblings              : 00000fff
>  core_siblings_list         : 0-11
>
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/include/asm/cpufeature.h |    1 +
>  arch/x86/kernel/cpu/amd.c         |   61 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 62 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 728b375..feed057 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -274,7 +328,14 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
>        int node;
>        unsigned apicid = cpu_has_apic ? hard_smp_processor_id() : c->apicid;
>
> +#ifdef CONFIG_MULTI_NODE_CPU
> +       if (cpu_has(c, X86_FEATURE_AMD_DCM))
> +               node = (c->phys_proc_id << 1) + c->cpu_node_id;
> +       else
> +               node = c->phys_proc_id;
> +#else
>        node = c->phys_proc_id;
> +#endif
Stale CONFIG_MULTI_NODE_CPU?

Regards,
Bert

>        if (apicid_to_node[apicid] != NUMA_NO_NODE)
>                node = apicid_to_node[apicid];
>        if (!node_online(node)) {
> --
> 1.6.3.1
>
>
>
>
