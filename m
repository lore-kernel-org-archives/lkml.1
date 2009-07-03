Return-Path: <linux-kernel-owner+w=401wt.eu-S1757467AbZGCCEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbZGCCEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 22:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbZGCCEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 22:04:45 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:41782 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbZGCCEo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:04:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xtymEBVcVugVe6qrxbbToNZvY0gE6cVlhMDKTAla+lgVHtD4V3UBRz0dFkgq8kdvco
         p5NlnNqoctCai3ei3ZJITC7iqDqEWQUBfTu6XScUePlbw56TyQEWNS4tWkV5iPPZuopY
         3lq2S9W512x0svVV8wJdhaHyJIwEHzaVmIyyE=
MIME-Version: 1.0
In-Reply-To: <1246580583.4534.32443.camel@localhost.localdomain>
References: <3877989d0906282347i311eb14bp80a7c80878219c31@mail.gmail.com>
	 <1246307644.4534.26298.camel@localhost.localdomain>
	 <3877989d0906300001u2f185fb0lcab5614e245efc21@mail.gmail.com>
	 <1246580583.4534.32443.camel@localhost.localdomain>
Date: Fri, 3 Jul 2009 10:04:48 +0800
Message-ID: <3877989d0907021904g1154ad44m7da3888f9c01416@mail.gmail.com>
Subject: Re: [RFC patch] Use IPI_shortcut for lapic timer broadcast
From: Luming Yu <luming.yu@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 3, 2009 at 8:23 AM, Pallipadi,
Venkatesh<venkatesh.pallipadi@intel.com> wrote:
> On Tue, 2009-06-30 at 00:01 -0700, Luming Yu wrote:
>> Thanks for review. How about the following patch?
>>
>> /**The patch is enclosed in text attachment**
>> **Using web client to send the patch**
>> **below is for review, please apply attached  patch*/
>>
>>
>> Signed-off-by: Yu Luming <luming.yu@intel.com>
>>
>>  apic.c         |    5 ++++-
>>  apic_flat_64.c |    7 ++++++-
>>  2 files changed, 10 insertions(+), 2 deletions(-)
>>
>>
>> --- linux-2.6.30-rc6/arch/x86/kernel/apic/apic.c.0    2009-06-29
>> 23:45:05.000000000 -0600
>> +++ linux-2.6.30-rc6/arch/x86/kernel/apic/apic.c      2009-06-30
>> 00:37:56.000000000 -0600
>> @@ -419,7 +419,10 @@
>>  static void lapic_timer_broadcast(const struct cpumask *mask)
>>  {
>>  #ifdef CONFIG_SMP
>> -     apic->send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
>> +     if (unlikely(cpumask_weight(mask) == num_online_cpus() -1))
>> +             apic->send_IPI_all(LOCAL_TIMER_VECTOR);
>> +     else
>> +             apic->send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
>>  #endif
>>  }
>
> I dont think it is a good idea to pay the penalty for cpumask_weight and
> num_online_cpus, for the more common tickless case to fix this problem
> with less common no tickeless case.

In NO_HZ, the lapic_timer_broadcast is rare thing too...

>
> We should be able to add an interface to get tick_nohz_enabled from
> tick-sched.c and use that instead.

If we use send_IPI_all just for NO_HZ is disabled, we will leave a corner case
here that lapic_timer_broadcast could be really really being actively used even
NO_HZ enabled... if this will never happen, I would agree with you..

Thanks,
LUming
