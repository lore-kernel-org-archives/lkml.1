Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab0BXUTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:19:37 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55178 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848Ab0BXUTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:19:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qhL6GOwXihkf2PKzviIniWaIbXCmRBsmfgDPApFAi5EzKRoxIpea1Dz5T+n5RI9cB/
         KxqQHe0ueMQntTuDXIbsrWoMPPZ7aQcZNYTb40nEHFCZY9MDo6kqznOmqRllZb2ZpfUB
         8lMLJhLbRx8CgbnudE2Ftx5qXUjp9m330fkws=
MIME-Version: 1.0
In-Reply-To: <20100224102037.2cca4f83.kamezawa.hiroyu@jp.fujitsu.com>
References: <9b2b86521001020703v23152d0cy3ba2c08df88c0a79@mail.gmail.com>
	 <201002222017.55588.rjw@sisk.pl>
	 <9b2b86521002230624g20661564mc35093ee0423ff77@mail.gmail.com>
	 <201002232213.56455.rjw@sisk.pl>
	 <20100224102037.2cca4f83.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 24 Feb 2010 20:19:32 +0000
Message-ID: <9b2b86521002241219v648458c1gad1c18b0c3e7ca83@mail.gmail.com>
Subject: Re: s2disk hang update
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Mel Gorman <mel@csn.ul.ie>,
       hugh.dickins@tiscali.co.uk, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/24/10, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 23 Feb 2010 22:13:56 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
>> Well, it still looks like we're waiting for create_workqueue_thread() to
>> return, which probably is trying to allocate memory for the thread
>> structure.
>>
>> My guess is that the preallocated memory pages freed by
>> free_unnecessary_pages() go into a place from where they cannot be taken
>> for
>> subsequent NOIO allocations.  I have no idea why that happens though.
>>
>> To test that theory you can try to change GFP_IOFS to GFP_KERNEL in the
>> calls to clear_gfp_allowed_mask() in kernel/power/hibernate.c (and in
>> kernel/power/suspend.c for completness).
>>
>
> If allocation of kernel threads for stop_machine_run() is the problem,
>
> What happens when
> 1. use CONIFG_4KSTACK

Interesting question.  4KSTACK doesn't stop it though; it hangs in the
same place.

> or
> 2. make use of stop_machine_create(), stop_machine_destroy().
>    A new interface added by this commit.
>   http://git.kernel.org/?p=linux/kernel/git/torvalds/
> linux-2.6.git;a=commit;h=9ea09af3bd3090e8349ca2899ca2011bd94cda85
>    You can do no-fail stop_machine_run().
>
> Thanks,
> -Kame

Since this is a uni-processor machine that would make it a single 4K
allocation.  AIUI this is supposed to be ok.  The hibernation code
tries to make sure there is over 1000x that much free RAM (ish), in
anticipation of this sort of requirement.

There appear to be some deficiencies in the way this allowance works,
which have recently been exposed.  And unfortunately the allocation
hangs instead of failing, so we're in unclean shutdown territory.

I have three test scenarios at the moment.  I've tested two patches
which appear to fix the common cases, but there's still a third test
scenario to figure out.  (Repeated hibernation attempts with
insufficient swap - encountered during real-world use, believe it or
not).

Alan
