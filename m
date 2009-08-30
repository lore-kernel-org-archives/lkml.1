Return-Path: <linux-kernel-owner+w=401wt.eu-S1752845AbZH3JeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbZH3JeX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 05:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbZH3JeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 05:34:22 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:36870 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbZH3JeV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 05:34:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nEJFq/quhP8tpRAALSUpqOHj9ZpaQT0th3QZcXl8AJo3BflJCd2h5uGHVB3z30fJBM
         Ib4w0sM1SP0JkWoKyrDtoQFWtvAvdtV54rQlWRP/B+zZqzhElmZRZHo92VF1GLaioExe
         xQYDYDFqz39rRSEtl2nfORWfqCx7ZbjVUFgUk=
MIME-Version: 1.0
In-Reply-To: <1251556965.9909.10.camel@desktop>
References: <3efb10970908290047k6f4d5a14of148db7f2b179f18@mail.gmail.com>
	 <1251556965.9909.10.camel@desktop>
Date: Sun, 30 Aug 2009 11:34:21 +0200
X-Google-Sender-Auth: 6002c406723502b2
Message-ID: <3efb10970908300234q60e56418kbab64ef9a1dd23e3@mail.gmail.com>
Subject: Re: System lockup with 2.6.26.8-rt16 on ARM9 [Solved]
From: Remy Bohmer <linux@bohmer.net>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,


2009/8/29 Daniel Walker <dwalker@fifo99.com>:
> On Sat, 2009-08-29 at 09:47 +0200, Remy Bohmer wrote:
>
>> Well, we found the root cause of this problem.
>> It turned out to be caused by sched_clock() that made disjunct time jumps.
>> This caused this check to become true in kernel/sched_rt.c:370:
>>          if (rt_rq->rt_time > runtime) {
>>                 rt_rq->rt_throttled = 1;
>>                 if (rt_rq_throttled(rt_rq)) {
>>                         sched_rt_rq_dequeue(rt_rq);
>>                         return 1;
>>                 }
>>         }
>>
>> The end results is that all realtime tasks got throttled for a long
>> time, and that time got extended every time sched_clock() made such a
>> jump. I would never have expected the scheduler would show this kind
>> of behaviour while CONFIG_RT_GROUP_SCHED is _not_ set...
>>
>> The root-cause of the sched_clock being faulty was a synchronisation
>> issue between 2 clock domains. The CPU clock and the clock domain of
>> the peripheral (GPT) on which the sched_clock() implementation was
>> based. The GPT made jumps backwards which triggered a false wraparound
>> detection in the conversion of 32->64 bit timestamps, causing the time
>> to jump about 356 seconds in the future...
>>
>
> Can you tell us more about what type of board this was? I've never heard
> of a ARM board having an unstable clocksource before ..

It was a Freescale iMX25 based board... (hmm, looking at it, it was a
driver build by Montavista that configured the GPT as clocksource, so
it might be interesting info for you too, notice that the EPIT turns
out to be much more stable in this processor. I also never seen this
problem on iMX35 based boards for which the same driver was used.)

Remy
