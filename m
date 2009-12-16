Return-Path: <linux-kernel-owner+w=401wt.eu-S933486AbZLPG4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933486AbZLPG4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 01:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932810AbZLPG4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 01:56:08 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:41931 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932717AbZLPG4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 01:56:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=evY5lU7RjeFuVhFo0Pgw1EPrR4IYdhB6lYP1Lyx6BTDEY+wpWSNztjqYrYdB2SIWLf
         WsQzXh/gFGq0E4x08mGHH7Vs50CFL9pinbGqxgrCy+6QOAj9PjHo6m6lOq/Z4BmNIMDl
         aYPh5DJ+LNQ5K2FxsK9rvim0FAK2Au93y692E=
MIME-Version: 1.0
In-Reply-To: <4B279370.5050800@in.ibm.com>
References: <4B2224C7.1020908@in.ibm.com> <1260786122.4165.142.camel@twins>
	 <4B261D7A.9040802@in.ibm.com> <1260793182.4165.223.camel@twins>
	 <1260825420.2217.40.camel@pasglop> <4B275A6B.9030200@in.ibm.com>
	 <1260873827.4165.362.camel@twins> <4B279370.5050800@in.ibm.com>
Date: Wed, 16 Dec 2009 14:56:01 +0800
Message-ID: <7b6bb4a50912152256j58cdc8f6u7fc0f38c60281dc8@mail.gmail.com>
Subject: Re: [Next] CPU Hotplug test failures on powerpc
From: Xiaotian Feng <xtfeng@gmail.com>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Linux/PPC Development" <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 9:47 PM, Sachin Sant <sachinp@in.ibm.com> wrote:
> Peter Zijlstra wrote:
>>>
>>> I added some debug statements within the above code. This is a 2 cpu
>>> machine.
>>>
>>> XMON dest_cpu = 1024 . dead_cpu = 1 . nr_cpu_ids = 2
>>> XMON dest_cpu = 1024 XMON dest_cpu = 1024 . dead_cpu = 1
>>> XMON dest_cpu = 1024 . dead_cpu = 1 . nr_cpu_ids = 2
>>> XMON dest_cpu = 1024 XMON dest_cpu = 1024 . dead_cpu = 1
>>> XMON dest_cpu = 1024 . dead_cpu = 1 . nr_cpu_ids = 2
>>> XMON dest_cpu = 1024 XMON dest_cpu = 1024 . dead_cpu = 1
>>>
>>> Seems to me that the control is stuck in an infinite loop and hence the
>>> machine appears to be in hung state. The dest_cpu value is always 1024
>>> and never changes, which result in an infinite loop.
>>>
>>> In working scenario the o/p is something on the following lines
>>>
>>> XMON dest_cpu = 1024 . dead_cpu = 1 . nr_cpu_ids = 2
>>> XMON dest_cpu = 0 XMON dest_cpu = 1024 . dead_cpu = 1 . nr_cpu_ids = 2
>>> XMON dest_cpu = 0 XMON dest_cpu = 1024 . dead_cpu = 1 . nr_cpu_ids = 2
>>> XMON dest_cpu = 0
>>> Let me know if i should try to record any specific value ?
>>>
>>
>> Could you possibly print the two masks themselves? cpumask_scnprintf()
>> and friend come in handy for this.
>>
>> The dest_cpu=1024 thing seem to suggest the intersection between
>> p->cpus_allowed and cpu_active_mask is empty for some reason, even
>> though we forcefully reset p->cpus_allowed to the full set using
>> cpuset_cpus_allowed_locked().
>>
>
> So here is the data related to the two masks.
>
> cpu_active_mask = 00000000,00000000,00000000,00000000,00000000,00000000,
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
> 00000000,00000000
> XMON dest_cpu = 1024
>

How about cpu_online_mask? commit 6ad4c1 switches from cpu_online_mask
to cpu_active_mask.
Is there a mismatch for cpu_online_mask and cpu_active_mask?

> while p->cpus_allowed =  00000000,00000000,00000000,00000000,00000000,
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
> 00000000,00000000,00000001
> XMON dest_cpu = 1024
>
> In working scenario the above data looks like
>
> cpu_active_mask = 00000000,00000000,00000000,00000000,00000000,00000000,
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
> 00000000,00000002
> XMON dest_cpu = 1
>
> while p->cpus_allowed =  00000000,00000000,00000000,00000000,00000000,
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,
> 00000000,00000000,00000002
> XMON dest_cpu = 1
>
>
> hope i got the data correct.
>
> Thanks
> -Sachin
>
>
> --
>
> ---------------------------------
> Sachin Sant
> IBM Linux Technology Center
> India Systems and Technology Labs
> Bangalore, India
> ---------------------------------
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
