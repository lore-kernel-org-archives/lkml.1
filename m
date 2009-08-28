Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbZH1HOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbZH1HOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 03:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZH1HOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 03:14:03 -0400
Received: from mailgw5.ericsson.se ([193.180.251.36]:59942 "EHLO
	mailgw5.ericsson.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbZH1HOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 03:14:02 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Aug 2009 03:14:01 EDT
X-AuditID: c1b4fb24-b7c01ae00000498b-4e-4a9780355f72
Message-ID: <4A978034.6040209@ericsson.com>
Date: Fri, 28 Aug 2009 08:59:00 +0200
From: Nils Carlson <nils.carlson@ericsson.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Goldwyn Rodrigues <rgoldwyn@gmail.com>
CC: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] hpet: hpet driver periodic timer setup bug fixes
References: <20090810220503.GA29239@linux-os.sc.intel.com> <241c7a2b0908271217u178edd5eu1ec45923e527012f@mail.gmail.com>
In-Reply-To: <241c7a2b0908271217u178edd5eu1ec45923e527012f@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 Aug 2009 06:59:00.0769 (UTC) FILETIME=[05726910:01CA27AD]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

Answers below.

Goldwyn Rodrigues wrote:
> Hi,
>
> One comment on this patch.
>
> On Mon, Aug 10, 2009 at 5:05 PM, Pallipadi,
> Venkatesh<venkatesh.pallipadi@intel.com> wrote:
>   
>> From: Nils Carlson <nils.carlson@ericsson.com>
>>
>> The periodic interrupt from drivers/char/hpet.c does not work correctly,
>> both when using the periodic capability of the hardware and while
>> emulating the periodic interrupt (when hardware does not support
>> periodic mode).
>>
>> With timers capable of periodic interrupts, the comparator field is first
>> set with the period value followed by set of hidden accumulator,
>> which has the side effect of overwriting the comparator value. This
>> results in wrong periodicity for the interrupts. For,
>> periodic interrupts to work, following steps are necessary, in that order.
>> * Set config with Tn_VAL_SET_CNF bit
>> * Write to hidden accumulator, the value written is the time when the
>>  first interrupt should be generated
>> * Write compartor with period interval for subsequent interrupts
>> (http://www.intel.com/hardwaredesign/hpetspec_1.pdf )
>>
>> When emulating periodic timer with timers not capable of periodic
>> interrupt, driver is adding the period to counter value instead of
>> comparator value, which causes slow drift when using this emulation.
>>
>> Also, driver seems to add hpetp->hp_delta both while setting up
>> periodic interrupt and while emulating periodic interrupts with timers
>> not capable of doing periodic interrupts. This hp_delta will result in
>> slower than expected interrupt rate and should not be used while setting
>> the interval.
>>
>> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>> Signed-off-by: Nils Carlson <nils.carlson@ericsson.com>
>> ---
>>  drivers/char/hpet.c |   21 ++++++++++++---------
>>  1 files changed, 12 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
>> index 4a9f349..70a770a 100644
>> --- a/drivers/char/hpet.c
>> +++ b/drivers/char/hpet.c
>> @@ -166,9 +166,8 @@ static irqreturn_t hpet_interrupt(int irq, void *data)
>>                unsigned long m, t;
>>
>>                t = devp->hd_ireqfreq;
>> -               m = read_counter(&devp->hd_hpet->hpet_mc);
>> -               write_counter(t + m + devp->hd_hpets->hp_delta,
>> -                             &devp->hd_timer->hpet_compare);
>> +               m = read_counter(&devp->hd_timer->hpet_compare);
>> +               write_counter(t + m, &devp->hd_timer->hpet_compare);
>>        }
>>
>>        if (devp->hd_flags & HPET_SHARED_IRQ)
>> @@ -504,21 +503,25 @@ static int hpet_ioctl_ieon(struct hpet_dev *devp)
>>        g = v | Tn_32MODE_CNF_MASK | Tn_INT_ENB_CNF_MASK;
>>
>>        if (devp->hd_flags & HPET_PERIODIC) {
>> -               write_counter(t, &timer->hpet_compare);
>>                g |= Tn_TYPE_CNF_MASK;
>> -               v |= Tn_TYPE_CNF_MASK;
>> -               writeq(v, &timer->hpet_config);
>> -               v |= Tn_VAL_SET_CNF_MASK;
>> +               v |= Tn_TYPE_CNF_MASK | Tn_VAL_SET_CNF_MASK;
>>                writeq(v, &timer->hpet_config);
>>                local_irq_save(flags);
>>
>> -               /* NOTE:  what we modify here is a hidden accumulator
>> +               /*
>> +                * NOTE: First we modify the hidden accumulator
>>                 * register supported by periodic-capable comparators.
>>                 * We never want to modify the (single) counter; that
>> -                * would affect all the comparators.
>> +                * would affect all the comparators. The value written
>> +                * is the counter value when the first interrupt is due.
>>                 */
>>                m = read_counter(&hpet->hpet_mc);
>>                write_counter(t + m + hpetp->hp_delta, &timer->hpet_compare);
>> +               /*
>> +                * Then we modify the comparator, indicating the period
>> +                * for subsequent interrupt.
>> +                */
>> +               write_counter(t, &timer->hpet_compare);
>>        } else {
>>                local_irq_save(flags);
>>                m = read_counter(&hpet->hpet_mc);
>>     
>
> Shouldn't
> write_counter(t + m + hpetp->hp_delta, &timer->hpet_compare);
> be deleted if we are doing
> write_counter(t, &timer->hpet_compare);
> ?
>
> Regards,
>
>   
The answer is no. The first write of
write_counter(t + m + hpetp->hp_delta, &timer->hpet_compare)
writes directly to the comparator( also reffered to as accumulator),
that is, it is the next trigger value. This happens because of the setting
of Tn_VAL_SET_CNF_MASK .

The second write, write_counter(t, &timer->hpet_compare),
doesn't write to the comparator but instead writes to the adder register,
the value of which is added to the comparator every time the timer triggers.

So the first write sets when the FIRST trigger should occur, the second 
write
defines the FREQUENCY. To quoute the intel documentation regarding
Tn_VAL_SET_CNF_MASK:

"Timer n Value Set: (where n is the timer number: 00 to 31). Software 
uses this
read/write bit only for timers that have been set to periodic mode. By 
writing
this bit to a 1, the software is then allowed to directly set a periodic 
timer’s
accumulator.
Software does NOT have to write this bit back to 0 (it automatically 
clears)."

For some nice diagrams see the intel documentation at
http://www.intel.com/hardwaredesign/hpetspec_1.pdf
pages 19 and 22.

Please feel free to ask more questions, I've spent a lot of time lately 
debugging hpet.

Regards,

Nils

