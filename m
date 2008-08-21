Return-Path: <linux-kernel-owner+w=401wt.eu-S1761388AbYHUXWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761388AbYHUXWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 19:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758140AbYHUXWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 19:22:05 -0400
Received: from gw.goop.org ([64.81.55.164]:38512 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318AbYHUXWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 19:22:04 -0400
Message-ID: <48ADF895.10001@goop.org>
Date: Thu, 21 Aug 2008 16:21:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Alex Nixon <alex.nixon@citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] X86: Change the default value of nr_irqs from 32 to NR_IRQs
References: <48AAFAE4.7070409@citrix.com>	 <86802c440808191044h74871ba1u62330dae18599436@mail.gmail.com>	 <0E902970173AF84089673FA54B7FE78A2CA11D@lonpexch01.citrite.net>	 <86802c440808191124v39ce2aa9rb548d3bdd75ca25c@mail.gmail.com>	 <48AB11A3.4060102@citrix.com>	 <86802c440808191200u364ffd86h49af661e58d20ea3@mail.gmail.com>	 <48AB241A.4030706@citrix.com>	 <86802c440808191352g75c99737kcb8c9c20d59c8f7b@mail.gmail.com>	 <48AB551D.6010708@citrix.com> <48ACA785.6030607@citrix.com> <86802c440808201647w70cbc286u7b02ae5da5806f49@mail.gmail.com>
In-Reply-To: <86802c440808201647w70cbc286u7b02ae5da5806f49@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Wed, Aug 20, 2008 at 4:23 PM, Alex Nixon <alex.nixon@citrix.com> wrote:
>   
>> Alex Nixon wrote:
>>     
>>> Yinghai Lu wrote:
>>>       
>>>> when !CONFIG_HAVE_SPARSE_IRQ, with dyn_array, could allocate irq_desc
>>>> and etc as less as possible.
>>>> when CONFIG_HAVE_SPARESE_IRQ, no actually meaning for nr_irqs.
>>>>
>>>> YH
>>>>         
>>> So I believe the only case this affects is !CONFIG_HAVE_SPARSE_IRQ
>>>
>>> The worry is that with CONFIG_HAVE_DYN_ARRAY we may waste memory by
>>> pre-allocating more irq_descs than may be necessary (NR_IRQs vs 32)?
>>>
>>> With !CONFIG_HAVE_DYN_ARRAY however, a static array of size NR_IRQS is
>>> allocated instead - so doesn't defaulting nr_irqs back to NR_IRQS just
>>> revert to the old behaviour (with the exception of the irq_descs being
>>> allocated in pre_alloc_dyn_array instead)?
>>>
>>> - Alex
>>>
>>>       
>> Sorry to pester you Yinghai, but I'd like to get a patch for this out one
>> way or another as Xen is _completely_ unusable with 5 or more VCPUs.
>>
>> Can you explain more clearly what the problem with the patch is?
>>     
>
> small real system doesn't have MSI ioapic will have nr_irqs == 32.
> your patch will increase that to 224 again.
>
> sth like ?
>   

No.  A Xen-capable kernel can also run native, so it must do whatever a
normal kernel would do when booting native.

At what point in the boot does nr_irqs need to be set?  Could we just
override it at some point?

> #ifdef CONFIG_XEN
>   

I assume you mean ifndef here?

> int __init probe_nr_irqs(void)
> {
>         int idx;
>         int nr = 0;
>
>         for (idx = 0; idx < nr_ioapics; idx++)
>                 nr += io_apic_get_redir_entries(idx);
>
>         /* double it for hotplug and msi and nmi */
>         nr <<= 1;
>
>         /* something wrong ? */
>         if (nr < 32)
>                 nr = 32;
>
>         return nr;
> }
> #else
> int __init probe_nr_irqs(void)
> {
>        return NR_IRQS;
> }
> #endif
>   

    J
