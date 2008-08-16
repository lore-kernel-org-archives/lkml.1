Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbYHPI07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbYHPI07 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 04:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYHPI0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 04:26:50 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:20491 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbYHPI0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 04:26:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=N+VIaGC6vbkPuE8fsdNUcFKfL5vARJQVJdsHX2r0aQPWHy0+NsCSMh5chL+w7Ge6L3
         YLUFN8Dn6pdo8yJhzSB8B0OEsuWO3qvXEe/U2dvElp+D3smoTDnXuNBUX8vhoygTR5eh
         8e2ilaXCJdruR6E9QTae2huB/IMTHKm0uNfwQ=
Message-ID: <86802c440808160126x3ff4b82cjc5dc14a6506e155d@mail.gmail.com>
Date: Sat, 16 Aug 2008 01:26:48 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: io_apic.c, build fix
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080816082258.GA5915@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218843762-14650-1-git-send-email-yhlu.kernel@gmail.com>
	 <1218843762-14650-2-git-send-email-yhlu.kernel@gmail.com>
	 <1218843762-14650-3-git-send-email-yhlu.kernel@gmail.com>
	 <1218843762-14650-4-git-send-email-yhlu.kernel@gmail.com>
	 <1218843762-14650-5-git-send-email-yhlu.kernel@gmail.com>
	 <1218843762-14650-6-git-send-email-yhlu.kernel@gmail.com>
	 <1218843762-14650-7-git-send-email-yhlu.kernel@gmail.com>
	 <20080816080221.GA8415@elte.hu> <20080816082258.GA5915@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 1:22 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> From 306bb46f92d326c5afae3fa04860bdccb879b6b8 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Sat, 16 Aug 2008 10:18:31 +0200
> Subject: [PATCH] x86: io_apic.c, build fix
>
> fix:
>
>  arch/x86/kernel/io_apic.c: In function 'MPBIOS_trigger':
>  arch/x86/kernel/io_apic.c:1105: error: implicit declaration of function 'default_MCA_trigger'
>
> the MCA defines got lost in the unification.
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/io_apic.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
> index 2043cd8..929429f 100644
> --- a/arch/x86/kernel/io_apic.c
> +++ b/arch/x86/kernel/io_apic.c
> @@ -1025,6 +1025,12 @@ static int EISA_ELCR(unsigned int irq)
>  #define default_EISA_trigger(idx)       (EISA_ELCR(mp_irqs[idx].mp_srcbusirq))
>  #define default_EISA_polarity(idx)      default_ISA_polarity(idx)
>
> +/* MCA interrupts are always polarity zero level triggered,
> + * when listed as conforming in the MP table. */
> +
> +#define default_MCA_trigger(idx)       (1)
> +#define default_MCA_polarity(idx)      default_ISA_polarity(idx)
> +
>
>  static int MPBIOS_polarity(int idx)
>  {
>

ah. EISA got too copies

/* ISA interrupts are always polarity zero edge triggered,
 * when listed as conforming in the MP table. */

#define default_ISA_trigger(idx)        (0)
#define default_ISA_polarity(idx)       (0)

/* EISA interrupts are always polarity zero and can be edge or level
 * trigger depending on the ELCR value.  If an interrupt is listed as
 * EISA conforming in the MP table, that means its trigger type must
 * be read in from the ELCR */

#define default_EISA_trigger(idx)       (EISA_ELCR(mp_irqs[idx].mp_srcbusirq))
#define default_EISA_polarity(idx)      default_ISA_polarity(idx)

/* PCI interrupts are always polarity one level triggered,
 * when listed as conforming in the MP table. */

#define default_PCI_trigger(idx)        (1)
#define default_PCI_polarity(idx)       (1)

/* EISA interrupts are always polarity zero and can be edge or level
 * trigger depending on the ELCR value.  If an interrupt is listed as
 * EISA conforming in the MP table, that means its trigger type must
 * be read in from the ELCR */

#define default_EISA_trigger(idx)       (EISA_ELCR(mp_irqs[idx].mp_srcbusirq))
#define default_EISA_polarity(idx)      default_ISA_polarity(idx)


need to remove the  extra one.

YH
