Return-Path: <linux-kernel-owner+w=401wt.eu-S1752370AbZI1BTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbZI1BTI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 21:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbZI1BTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 21:19:07 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:46310 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbZI1BTG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 21:19:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AhMEBb41nBOKME27bBkYpU+1EMRfz68wet9VmL3rmsxlZyOJsVDIpLXoaDpB1ffFnw
         YVBTvBB7R3bwwR3qVy6NYLL6xCTDp2qgMIHJW5b4B7w19iit9N0z2ncp6rdMk54QVGh4
         pXsYJa7+1yd5UAhk1yXGrIWr8viUc0iOf8QsI=
MIME-Version: 1.0
In-Reply-To: <20090928010217.GA16863@sgi.com>
References: <20090928010217.GA16863@sgi.com>
Date: Sun, 27 Sep 2009 18:19:09 -0700
Message-ID: <86802c440909271819i303df4ccw9c5df1f4d4455e36@mail.gmail.com>
Subject: Re: [PATCH] x86: limit irq affinity
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 6:02 PM, Dimitri Sivanich <sivanich@sgi.com> wrote:
> This patch allows for restrictions to irq affinity via a new cpumask and
> device node value in the irq_cfg structure.  The node value can then be
> used by specific x86 architectures to determine the cpumask for the
> desired cpu irq affinity domain.
>
> The mask forces IRQ affinity to remain within the specified cpu domain.
> On some UV systems, this domain will be limited to the nodes accessible
> to the given node.  Currently other X86 systems will have all bits in
> the cpumask set, so non-UV systems will remain unaffected at this time.
>
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
>
> ---
>
>  arch/x86/Kconfig                   |    1
>  arch/x86/include/asm/uv/uv_irq.h   |    2
>  arch/x86/include/asm/uv/uv_mmrs.h  |   25 ++++
>  arch/x86/kernel/apic/io_apic.c     |  166 +++++++++++++++++++++++++++------
>  arch/x86/kernel/apic/x2apic_uv_x.c |    2
>  arch/x86/kernel/uv_irq.c           |   68 +++++++++++++
>  6 files changed, 235 insertions(+), 29 deletions(-)
>
> Index: linux/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/apic/io_apic.c   2009-09-26 15:28:04.000000000 -0500
> +++ linux/arch/x86/kernel/apic/io_apic.c        2009-09-26 16:20:04.000000000 -0500
> @@ -62,6 +62,7 @@
>  #include <asm/hw_irq.h>
>  #include <asm/uv/uv_hub.h>
>  #include <asm/uv/uv_irq.h>
> +#include <asm/uv/uv.h>
>
>  #include <asm/apic.h>
>
> @@ -149,6 +150,8 @@ struct irq_cfg {
>        struct irq_pin_list *irq_2_pin;
>        cpumask_var_t domain;
>        cpumask_var_t old_domain;
> +       cpumask_var_t allowed;
> +       int node;
>        unsigned move_cleanup_count;
>        u8 vector;
>        u8 move_in_progress : 1;
> @@ -184,6 +187,18 @@ void __init io_apic_disable_legacy(void)
>        nr_irqs_gsi = 0;
>  }
>

original irq affinity in irq_desc does not work?

YH
