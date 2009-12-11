Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbZLKNl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbZLKNl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757320AbZLKNlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:41:23 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:43306 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183AbZLKNlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:41:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=sYWxKriBixeQQHSDwFTuSHiSHLpBycwsaQbYjPPCq//QzV5vK+oHcrG0+ZOk4AGa6n
         IurKQSX0NLoxfloI+4sq9vj0ys6fjDQgwpe46NF0bOIaaITcmq1Hj9AK81JXSCPtvfPs
         E8FizNRMeM9eTP1D+HQwMRa7A2UYu+wfJYNZM=
MIME-Version: 1.0
In-Reply-To: <4B2235F0.4080606@redhat.com>
References: <20091210185626.26f9828a@cuia.bos.redhat.com>
	 <28c262360912101803i7b43db78se8cf9ec61d92ee0f@mail.gmail.com>
	 <4B2235F0.4080606@redhat.com>
Date: Fri, 11 Dec 2009 22:41:27 +0900
Message-ID: <28c262360912110541m2839e151hc9d49b0c251e1b67@mail.gmail.com>
Subject: Re: [PATCH] vmscan: limit concurrent reclaimers in shrink_zone
From: Minchan Kim <minchan.kim@gmail.com>
To: lwoodman@redhat.com
Cc: Rik van Riel <riel@redhat.com>, kosaki.motohiro@jp.fujitsu.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, aarcange@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Larry.

On Fri, Dec 11, 2009 at 9:07 PM, Larry Woodman <lwoodman@redhat.com> wrote:
> Minchan Kim wrote:
>>
>> I like this. but why do you select default value as constant 8?
>> Do you have any reason?
>>
>> I think it would be better to select the number proportional to NR_CPU.
>> ex) NR_CPU * 2 or something.
>>
>> Otherwise looks good to me.
>>
>> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
>>
>>
>
> This is a per-zone count so perhaps a reasonable default is the number of
> CPUs on the
> NUMA node that the zone resides on ?

For example, It assume one CPU per node.
It means your default value is 1.
On the CPU, process A try to reclaim HIGH zone.
Process B want to reclaim NORMAL zone.
But Process B can't enter reclaim path sincev throttle default value is 1
Even kswap can't reclaim.

I think it's really agressive throttle approach although it would
solve your problem.

I have another idea.

We make default value rather big and we provide latency vaule as knob.
So first many processes can enter reclaim path. When shrinking time exceeds
our konb(ex, some HZ), we can decrease default value of number of concurrent
reclaim process. If shrink time is still long alghouth we do it, we
can decrease
default vaule again. When shrink time is fast, we can allow to enter
reclaim path of another processes as increase the number.

It's like old pdflush mechanism. but it's more complex than Rik's one.
If Rik's approach solve this problem well, my approach is rather
overkill, I think.

I am looking forward to Rik's approach work well.

>
>



-- 
Kind regards,
Minchan Kim
