Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbYHVSsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbYHVSsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbYHVSrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:47:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:62739 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638AbYHVSrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:47:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QhCSMBTZV9gbjefC4TcNMnN/cE2UhCqPQ9i9DZ5cUk+1gSLzzFK5aIeB+8VvG+tfSm
         LJDP/GYMEtQtbOkplq8ly4iklMCpj4doSYUBJKf0iusKEnhd5ZbZuqjjzK01E3UyN9VK
         X18FUgqc7UN0zIt0XILbDfX1Rlf8jS+vo9WnU=
Message-ID: <86802c440808221147h4fb3c26cw31970678a100e2fc@mail.gmail.com>
Date: Fri, 22 Aug 2008 11:47:45 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Robert Richter" <robert.richter@amd.com>
Subject: Re: [PATCH] x86: fix: do not run code in amd_bus.c on non-AMD CPUs
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Jan Beulich" <jbeulich@novell.com>
In-Reply-To: <1219429418-29023-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD82D5.76E4.0078.0@novell.com>
	 <1219429418-29023-1-git-send-email-robert.richter@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 11:23 AM, Robert Richter <robert.richter@amd.com> wrote:
> On 21.08.08 13:59:33, Jan Beulich wrote:
>> Even worse - this would even try to access the MSR on non-AMD CPUs
>> (currently probably prevented just by the fact that only AMD ones use
>> family values of 0x10 or higher).
>
> This patch adds cpu vendor check to the postcore_initcalls.
>
> Cc: Jan Beulich <jbeulich@novell.com>
> Cc: Yinghai Lu <yhlu.kernel@gmail.com>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/pci/amd_bus.c |   19 ++++++++++++++++---
>  1 files changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
> index dbf5323..4a6f1a6 100644
> --- a/arch/x86/pci/amd_bus.c
> +++ b/arch/x86/pci/amd_bus.c
> @@ -555,9 +555,11 @@ static int __init early_fill_mp_bus_info(void)
>        return 0;
>  }
>
> -postcore_initcall(early_fill_mp_bus_info);
> +#else  /* !CONFIG_X86_64 */
>
> -#endif
> +static int __init early_fill_mp_bus_info(void) { return 0; }
> +
> +#endif /* !CONFIG_X86_64 */
>
>  /* common 32/64 bit code */
>
> @@ -583,4 +585,15 @@ static int __init enable_pci_io_ecs(void)
>        return 0;
>  }
>
> -postcore_initcall(enable_pci_io_ecs);
> +static int __init amd_postcore_init(void)
> +{
> +       if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
> +               return 0;
> +
> +       early_fill_mp_bus_info();
> +       enable_pci_io_ecs();
> +
> +       return 0;
> +}
> +
> +postcore_initcall(amd_postcore_init);

1. early_fill_mp_bus_info has checking with vendor/deviceid in itself.

2. you didn't address: when cpu is hot plug in later,
enable_pci_to_ecs_per_cpu will not be called.
( maxcpus and addtional_cpus)

YH
