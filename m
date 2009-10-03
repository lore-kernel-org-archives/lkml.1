Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbZJCJMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbZJCJMm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 05:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbZJCJMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 05:12:42 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:50251 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbZJCJMl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 05:12:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NIL2M4E+ooxBO9xFBhzGJRlzj7J9URoLumnBeknmCRWSh0jMF8jHHGv5OOYhdKz7eq
         /zrtSbk7tsfr1WOYtDnacLZPQGKflnA79x4kK3k81/ei4LRVweqqtOUb4zqKAkrVRG1x
         /j0RgtdVU5SIrAeg3+yMCya1b55xGJqB7MANo=
MIME-Version: 1.0
In-Reply-To: <1254560434.17052.14.camel@marge.simson.net>
References: <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain>
	 <20091002172554.GJ31616@kernel.dk> <20091002172842.GA4884@elte.hu>
	 <20091002173732.GK31616@kernel.dk>
	 <1254507215.8667.7.camel@marge.simson.net>
	 <20091002181903.GN31616@kernel.dk>
	 <1254548931.8299.18.camel@marge.simson.net>
	 <1254549378.8299.21.camel@marge.simson.net>
	 <20091003072401.GV31616@kernel.dk>
	 <1254560434.17052.14.camel@marge.simson.net>
Date: Sat, 3 Oct 2009 11:12:45 +0200
Message-ID: <4e5e476b0910030212y50f97d97nc2e17c35d855cc63@mail.gmail.com>
Subject: Re: IO scheduler based IO controller V10
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       riel@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Sat, Oct 3, 2009 at 11:00 AM, Mike Galbraith <efault@gmx.de> wrote:
> On Sat, 2009-10-03 at 09:24 +0200, Jens Axboe wrote:
>
>> After shutting down the computer yesterday, I was thinking a bit about
>> this issue and how to solve it without incurring too much delay. If we
>> add a stricter control of the depth, that may help. So instead of
>> allowing up to max_quantum (or larger) depths, only allow gradual build
>> up of that the farther we get away from a dispatch from the sync IO
>> queues. For example, when switching to an async or seeky sync queue,
>> initially allow just 1 in flight. For the next round, if there still
>> hasn't been sync activity, allow 2, then 4, etc. If we see sync IO queue
>> again, immediately drop to 1.
>>

I would limit just async I/O. Seeky sync queues are automatically
throttled by being sync, and have already high latency, so we
shouldn't increase it artificially. I think, instead, that we should
send multiple seeky requests (possibly coming from different queues)
at once. They will help especially with raid devices, where the seeks
for requests going to different disks will happen in parallel.

>> It could tie in with (or partly replace) the overload feature. The key
>> to good latency and decent throughput is knowing when to allow queue
>> build up and when not to.
>
> Hm.  Starting at 1 sounds a bit thin (like IDLE), multiple iterations to
> build/unleash any sizable IO, but that's just my gut talking.
>
On the other hand, sending 1 write first and then waiting it to
complete before submitting new ones, will help performing more merges,
so the subsequent requests will be bigger and thus more efficient.

Corrado

>        -Mike
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
