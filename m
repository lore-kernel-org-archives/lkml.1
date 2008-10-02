Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbYJBQTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbYJBQTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 12:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbYJBQTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 12:19:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:50757 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbYJBQTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 12:19:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Z3U2tYYbkw0fFLn4xcaB5D5ASyjMTmtpXnWdOXfp4BxIL3wfMPO+TjMkpOh5LA5DYH
         JBmfuFrWoeQo+9PEM0LFBK5bNuULWR6IWkXg+tnV0MAn+fWQeneeqa/+0Hs6igfnja80
         61XdvyHvIqVX3jlMIhpaDo3Ls371FVai5BgD8=
Message-ID: <86802c440810020919p4391cbebva0eaa5591e7915be@mail.gmail.com>
Date: Thu, 2 Oct 2008 09:19:04 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Dean Nelson" <dcn@sgi.com>
Subject: Re: [PATCH] x86, UV: add uv_setup_irq() and uv_teardown_irq() functions
Cc: "Ingo Molnar" <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Alan Mayer" <ajm@sgi.com>, jeremy@goop.org, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Yinghai Lu" <Yinghai.lu@amd.com>
In-Reply-To: <20081001114415.GA3281@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081001114415.GA3281@sgi.com>
X-Google-Sender-Auth: 05c362d560e7ea9e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2008 at 4:44 AM, Dean Nelson <dcn@sgi.com> wrote:
> Provide a means for UV interrupt MMRs to be setup with the message to be sent
> when an MSI is raised.
>
> Signed-off-by: Dean Nelson <dcn@sgi.com>
>
> ---
>
> This functionality is needed by drivers/misc/sgi-xp. And a patch will be
> submitted shortly.
>
>  arch/x86/kernel/Makefile    |    2
>  arch/x86/kernel/io_apic.c   |   95 ++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/uv_irq.c    |   50 +++++++++++++++++++++
>  include/asm-x86/uv/uv_irq.h |   34 ++++++++++++++
>  kernel/irq/chip.c           |    1
>  5 files changed, 181 insertions(+), 1 deletion(-)
>
> Index: linux/arch/x86/kernel/io_apic.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/io_apic.c        2008-09-30 09:07:42.000000000 -0500
> +++ linux/arch/x86/kernel/io_apic.c     2008-09-30 12:54:12.000000000 -0500
> @@ -58,6 +58,8 @@
>  #include <asm/setup.h>
>  #include <asm/irq_remapping.h>
>  #include <asm/hpet.h>
> +#include <asm/uv/uv_hub.h>
> +#include <asm/uv/uv_irq.h>
>
>  #include <mach_ipi.h>
>  #include <mach_apic.h>
> @@ -3694,6 +3696,99 @@ int arch_setup_ht_irq(unsigned int irq,
>  }
>  #endif /* CONFIG_HT_IRQ */
>
> +#ifdef CONFIG_X86_64
> +static void noop(unsigned int irq)
> +{
> +}
> +
> +static unsigned int noop_ret(unsigned int irq)
> +{
> +       return 0;
> +}
> +
> +static void ack_apic(unsigned int irq)
> +{
> +       ack_APIC_irq();
> +}
> +
> +static struct irq_chip uv_irq_chip = {
> +       .name           = "UV_MSI",

anything to do with MSI?

YH
