Return-Path: <linux-kernel-owner+w=401wt.eu-S1760412AbYEOPQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760412AbYEOPQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 11:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbYEOPPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 11:15:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:18721 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbYEOPPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 11:15:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L7u5IpnyjFKrAHD8HwJMf6wG2yG2Fo+/y4C6vBmu4p766onl5nimDitN51d5fpioS9K8skv/NlRbiGtf0gDDfy/Nxz9fgomG7ATtHYx7SU8hrMaUPwTweHNKo0eafitrZgNulP4eGtbMp0sf7PjXMylFCBltdfn7DEEThi+YN3k=
Message-ID: <b647ffbd0805150815t523a6242xd78e85b3f4c5045b@mail.gmail.com>
Date: Thu, 15 May 2008 17:15:50 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: vatsa@linux.vnet.ibm.com
Subject: Re: [PATCH] sched: Improve readability in update_cpu_load() code
Cc: "Gautham R Shenoy" <ego@in.ibm.com>, "Ingo Molnar" <mingo@elte.hu>,
       npiggin@suse.de, linux-kernel@vger.kernel.org,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>
In-Reply-To: <20080515145215.GD14823@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080515130459.GA9650@in.ibm.com>
	 <20080515145215.GD14823@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/15 Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>:
> On Thu, May 15, 2008 at 06:34:59PM +0530, Gautham R Shenoy wrote:
>> Author: Gautham R Shenoy <ego@in.ibm.com>
>> Date:   Thu May 15 17:55:49 2008 +0530
>>
>>     sched: Improve readability in update_cpu_load() code
>>
>>     Currently the cpu_load[i] is calculated as:
>>       this_rq->cpu_load[i] = (old_load*(scale-1) + new_load) >> i;
>>
>>     However, since scale = 2^i, this can be simplified as:
>>       this_rq->cpu_load[i] = old_load + ((new_load - old_load) >> i);
>>
>>     Makes it easier to read.
>>     Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 2d7d8f1..e1a6985 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -2921,7 +2921,7 @@ static void update_cpu_load(struct rq *this_rq)
>>                */
>>               if (new_load > old_load)
>>                       new_load += scale-1;
>> -             this_rq->cpu_load[i] = (old_load*(scale-1) + new_load) >> i;
>> +             this_rq->cpu_load[i] = old_load + ((new_load - old_load) >> i);
>
> This wont work when new_load < old_load ..
>
> For ex: I tried this prog:
>
> #include <stdio.h>
>
> main()
> {
>        unsigned long old_load = 100, new_load = 90, this_load, this_load1;
>        int i = 1, scale = 2 << i;
>
>        this_load = (old_load*(scale-1) + new_load) >> i;
>        this_load1 = old_load + ((new_load - old_load) >> i);

it should be

this_load2 = 2 * old_load + (new_load >> i) - (old_load >> i);

scale == 2 << i == 1 << (i + 1), so scale >> i = 2.

and it may result in (probably) little difefrences due to different rounding.
I think, for me the currently existing version is more easy-to-read.


> --
> Regards,
> vatsa

-- 
Best regards,
Dmitry Adamushko
