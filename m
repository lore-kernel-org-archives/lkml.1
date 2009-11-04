Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbZKDMth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbZKDMth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 07:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbZKDMtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 07:49:36 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:63642 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbZKDMtg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 07:49:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oraAixED23A++iA1akBzZhCnLc4MikdNRXUTbMQvkucJIqk0PmpRW2d87FEyhm7M2r
         hqaAdvKkqTS2jlNUoJq135EbnFl3/4CZ0KF7lgZmbL5uouYTSHsFZbeAB0ndHVWTTO2C
         x0+w+uz6lb0RPiL9WbnaK9+9FpRbD1SJF2Wyw=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0911041016070.12138@localhost.localdomain>
References: <20091103134342.24414.82986.sendpatchset@prarit.bos.redhat.com>
	 <2674af740911030658m76b702cfxb67723984286c4bb@mail.gmail.com>
	 <alpine.LFD.2.00.0911041016070.12138@localhost.localdomain>
Date: Wed, 4 Nov 2009 20:49:41 +0800
Message-ID: <2674af740911040449h14eaac35y2ec3016862479bc6@mail.gmail.com>
Subject: Re: [PATCH]: use spin_lock_irqsave in try_one_irq()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 5:18 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 3 Nov 2009, Yong Zhang wrote:
>
>> > This happens because the &desc->lock is taken with spin_lock_irqsave and
>> > just a spin_lock.  In the try_one_irq(), this lock really should be a
>> > spin_lock_irqsave().
>> >

>> So I think the following patch is also workable to you.
>
> Yes, that's sufficient.
>
>> diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
>> index 114e704..11affbc 100644
>> --- a/kernel/irq/spurious.c
>> +++ b/kernel/irq/spurious.c
>> @@ -111,6 +111,7 @@ static void poll_all_shared_irqs(void)
>>
>>       for_each_irq_desc(i, desc) {
>>               unsigned int status;
>> +             unsigned long flags;
>>
>>               if (!i)
>>                        continue;
>> @@ -121,7 +122,9 @@ static void poll_all_shared_irqs(void)
>>               if (!(status & IRQ_SPURIOUS_DISABLED))
>>                       continue;
>>
>> +             local_irq_save(flags);
>>               try_one_irq(i, desc);
>> +             local_irq_restore(flags);
>
>  You can even use local_irq_en/disable() here.

Yup, I will resend the patch later.

Thanks,
Yong

>
> Thanks,
>
>        tglx
