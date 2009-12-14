Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbZLNEUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbZLNEUG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 23:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbZLNEUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 23:20:03 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:60809 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbZLNET7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 23:19:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SvvDgryNpS6jpaMZd889MljfYxqlq0q58wWrQxG1CHS07PIGhh6ysMmxbEcHHiu7gH
         E5/9hyBwBYTJ1yv3S0L9tJt5M9+GXpSqQx/u+XUFHA0lXssboMwHW6I2Ez5B9sF3XGq0
         nOAcnrdze1XRdcMHROUciQmPiJGcGRxKXLeIc=
MIME-Version: 1.0
In-Reply-To: <4B25BA6E.5010002@redhat.com>
References: <20091211164651.036f5340@annuminas.surriel.com>
	 <28c262360912131614h62d8e0f7qf6ea9ab882f446d4@mail.gmail.com>
	 <4B25BA6E.5010002@redhat.com>
Date: Mon, 14 Dec 2009 13:19:58 +0900
Message-ID: <28c262360912132019u7c0b8efpf89b11a6cbe512b3@mail.gmail.com>
Subject: Re: [PATCH v2] vmscan: limit concurrent reclaimers in shrink_zone
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: lwoodman@redhat.com, akpm@linux-foundation.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 1:09 PM, Rik van Riel <riel@redhat.com> wrote:
> On 12/13/2009 07:14 PM, Minchan Kim wrote:
>
>> On Sat, Dec 12, 2009 at 6:46 AM, Rik van Riel<riel@redhat.com>  wrote:
>
>>> If too many processes are active doing page reclaim in one zone,
>>> simply go to sleep in shrink_zone().
>
>> I am worried about one.
>>
>> Now, we can put too many processes reclaim_wait with NR_UNINTERRUBTIBLE
>> state.
>> If OOM happens, OOM will kill many innocent processes since
>> uninterruptible task
>> can't handle kill signal until the processes free from reclaim_wait list.
>>
>> I think reclaim_wait list staying time might be long if VM pressure is
>> heavy.
>> Is this a exaggeration?
>>
>> If it is serious problem, how about this?
>>
>> We add new PF_RECLAIM_BLOCK flag and don't pick the process
>> in select_bad_process.
>
> A simpler solution may be to use sleep_on_interruptible, and
> simply have the process continue into shrink_zone() if it
> gets a signal.

I thought it but I was not sure.
Okay. If it is possible, It' more simple.
Could you repost patch with that?


Sorry but I have one requesting.


===

        +The default value is 8.
        +
        +=============================================================


    I like this. but why do you select default value as constant 8?
    Do you have any reason?

    I think it would be better to select the number proportional to NR_CPU.
    ex) NR_CPU * 2 or something.

    Otherwise looks good to me.


Pessimistically, I assume that the pageout code spends maybe
10% of its time on locking (we have seen far, far worse than
this with thousands of processes in the pageout code).  That
means if we have more than 10 threads in the pageout code,
we could end up spending more time on locking and less doing
real work - slowing everybody down.

I rounded it down to the closest power of 2 to come up with
an arbitrary number that looked safe :)
===

We discussed above.
I want to add your desciption into changelog.
That's because after long time, We don't know why we select '8' as
default value.
Your desciption in changelog will explain it to follow-up people. :)

Sorry for bothering you.


> --
> All rights reversed.
>



-- 
Kind regards,
Minchan Kim
