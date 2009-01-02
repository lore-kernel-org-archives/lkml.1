Return-Path: <linux-kernel-owner+w=401wt.eu-S1757660AbZABKyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbZABKyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756765AbZABKyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:54:37 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:64848 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbZABKyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:54:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=W7qhmmX3C6Q4h6bpgY6tmv6Jx5NH284wXF1fiS0EeVMQf/MILn5uW3i/cPP9E0weK+
         P4HIJUG0WW2iJnvV7+QZmZ+W+2ZjjVS4qiUQfgAXapnznPF4pUKxfG/8YjZDkgKitUgy
         438EqhJcFfNb9QWkAKTnV+FzSqlUKyG3lSp4w=
Message-ID: <2f11576a0901020254h13d43d2difa340aa1c40a0dbf@mail.gmail.com>
Date: Fri, 2 Jan 2009 19:54:34 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "MinChan Kim" <minchan.kim@gmail.com>
Subject: Re: [PATCH] mm: stop kswapd's infinite loop at high order allocation take2
Cc: "Mel Gorman" <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>,
       "wassim dagash" <wassim.dagash@gmail.com>
In-Reply-To: <28c262360901020229k55d47445yc9a6c9c7aa3e9c66@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081231115332.GB20534@csn.ul.ie>
	 <20081231215934.1296.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20090101021240.A057.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <28c262360901020155l3a9260b5h3c79d4b23a213825@mail.gmail.com>
	 <2f11576a0901020200t3a6dadf5qa944432cd9fd8873@mail.gmail.com>
	 <28c262360901020229k55d47445yc9a6c9c7aa3e9c66@mail.gmail.com>
X-Google-Sender-Auth: 3f9f92f5fe9ebebd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> So I want to balance zone's proportional free page.
>>> How about following ?
>>>
>>> if (nr_reclaimed < SWAP_CLUSTER_MAX) {
>>>   if (order != 0) {
>>>     order -=1;
>>>     sc.order -=1;
>>>   }
>>> }
>>>
>>> It prevents infinite loop and do best effort to make zone's
>>> proportional free page per order size good.
>>>
>>> It's just my opinion within my knowledge.
>>> If it have a problem, pz, explain me :)
>>
>> Please read Nick's expalin. it explain very kindly :)
>
> Hm. I read Nick's explain.
> I understand his point.
>
> Nick said,
> "A higher kswapd reclaim order shouldn't weaken kswapd
> postcondition for order-0 memory."
>
> My patch don't prevent order-0 memory reclaim. After all, it will do it.
> It also can do best effort to reclaim other order size.
>
> In this case, others order size reclaim is needless  ?

Yes, needless.

wakeup_kswapd() function mean
  - please make free memory until pages_high
  - and, I want to "order argument" conteniously pages.

then, shorter conteniously pages than "order argumet" pages aren't needed
by caller.

Unfortunately, your patch has more bad side effect.
high order shrink_zone() cause lumpy reclaim.
lumpy reclaim cause reclaim neighbor pages although it is active page.

needlessly active page reclaiming decrease system performance.
