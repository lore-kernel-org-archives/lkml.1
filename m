Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbYHTXra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbYHTXra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 19:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbYHTXrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 19:47:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:62146 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbYHTXrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 19:47:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uk7MiONZsz5MpBYm0HXV36A3SCPRHdVyPm8lzlKZOfoD966mmyvZuEc0L4svoerzWa
         +PMQVh2W1BiL1F/LKzX0Z32SmNO7RSABoENQ2TQNIlCMv1YO0owMMfDba9w3HuKIiZ5o
         97WojOC+oK3NEdppXv6gq16foWWjfyfZN8x+s=
Message-ID: <86802c440808201647w70cbc286u7b02ae5da5806f49@mail.gmail.com>
Date: Wed, 20 Aug 2008 16:47:19 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Alex Nixon" <alex.nixon@citrix.com>
Subject: Re: [PATCH] X86: Change the default value of nr_irqs from 32 to NR_IRQs
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Jeremy Fitzhardinge" <Jeremy.Fitzhardinge@citrix.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48ACA785.6030607@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AAFAE4.7070409@citrix.com>
	 <86802c440808191044h74871ba1u62330dae18599436@mail.gmail.com>
	 <0E902970173AF84089673FA54B7FE78A2CA11D@lonpexch01.citrite.net>
	 <86802c440808191124v39ce2aa9rb548d3bdd75ca25c@mail.gmail.com>
	 <48AB11A3.4060102@citrix.com>
	 <86802c440808191200u364ffd86h49af661e58d20ea3@mail.gmail.com>
	 <48AB241A.4030706@citrix.com>
	 <86802c440808191352g75c99737kcb8c9c20d59c8f7b@mail.gmail.com>
	 <48AB551D.6010708@citrix.com> <48ACA785.6030607@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 4:23 PM, Alex Nixon <alex.nixon@citrix.com> wrote:
> Alex Nixon wrote:
>>
>> Yinghai Lu wrote:
>>>
>>> when !CONFIG_HAVE_SPARSE_IRQ, with dyn_array, could allocate irq_desc
>>> and etc as less as possible.
>>> when CONFIG_HAVE_SPARESE_IRQ, no actually meaning for nr_irqs.
>>>
>>> YH
>>
>> So I believe the only case this affects is !CONFIG_HAVE_SPARSE_IRQ
>>
>> The worry is that with CONFIG_HAVE_DYN_ARRAY we may waste memory by
>> pre-allocating more irq_descs than may be necessary (NR_IRQs vs 32)?
>>
>> With !CONFIG_HAVE_DYN_ARRAY however, a static array of size NR_IRQS is
>> allocated instead - so doesn't defaulting nr_irqs back to NR_IRQS just
>> revert to the old behaviour (with the exception of the irq_descs being
>> allocated in pre_alloc_dyn_array instead)?
>>
>> - Alex
>>
>
> Sorry to pester you Yinghai, but I'd like to get a patch for this out one
> way or another as Xen is _completely_ unusable with 5 or more VCPUs.
>
> Can you explain more clearly what the problem with the patch is?

small real system doesn't have MSI ioapic will have nr_irqs == 32.
your patch will increase that to 224 again.

sth like ?

#ifdef CONFIG_XEN
int __init probe_nr_irqs(void)
{
        int idx;
        int nr = 0;

        for (idx = 0; idx < nr_ioapics; idx++)
                nr += io_apic_get_redir_entries(idx);

        /* double it for hotplug and msi and nmi */
        nr <<= 1;

        /* something wrong ? */
        if (nr < 32)
                nr = 32;

        return nr;
}
#else
int __init probe_nr_irqs(void)
{
       return NR_IRQS;
}
#endif
