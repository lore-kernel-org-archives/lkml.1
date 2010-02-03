Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab0BCUMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 15:12:51 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:54535 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab0BCUMs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 15:12:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OMNHgSEmBG68o+JMyOOhHAupQQ2Y4qG6mYiHiKuK3VZ9xKZo0A1I4zzh0gv7Hb3mGv
         0B7GX3EFXcAB5mAtyFqHaae6TLmUf0VmkL6JcR+R5cET5T234CZDKK7J65j0jZnS+lVD
         JrtIo68WmEn5Z1THqyZPhtm+bu88oyx53zaeE=
MIME-Version: 1.0
In-Reply-To: <1265227746.24386.15.camel@gandalf.stny.rr.com>
References: <1265226801-6199-1-git-send-email-jkacur@redhat.com>
	 <1265226801-6199-2-git-send-email-jkacur@redhat.com>
	 <1265227746.24386.15.camel@gandalf.stny.rr.com>
Date: Wed, 3 Feb 2010 21:12:46 +0100
X-Google-Sender-Auth: cf84ed0bae56f465
Message-ID: <520f0cf11002031212p4f1497e3he82dce3af668e676@mail.gmail.com>
Subject: Re: [RFC][PATCH] vmscan: balance local_irq_disable() and 
	local_irq_enable()
From: John Kacur <jkacur@redhat.com>
To: rostedt@goodmis.org
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 3, 2010 at 9:09 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> t On Wed, 2010-02-03 at 20:53 +0100, John Kacur wrote:
>> Balance local_irq_disable() and local_irq_enable() as well as
>> spin_lock_irq() and spin_lock_unlock_irq
>>
>> Signed-off-by: John Kacur <jkacur@redhat.com>
>> ---
>>  mm/vmscan.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index c26986c..b895025 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1200,8 +1200,9 @@ static unsigned long shrink_inactive_list(unsigned long max_scan,
>>               if (current_is_kswapd())
>>                       __count_vm_events(KSWAPD_STEAL, nr_freed);
>>               __count_zone_vm_events(PGSTEAL, zone, nr_freed);
>> +             local_irq_enable();
>>
>> -             spin_lock(&zone->lru_lock);
>> +             spin_lock_irq(&zone->lru_lock);
>>               /*
>>                * Put back any unfreeable pages.
>>                */
>
>
> The above looks wrong. I don't know the code, but just by looking at
> where the locking and interrupts are, I can take a guess.
>
> Lets add a little more of the code:
>
>                local_irq_disable();
>                if (current_is_kswapd())
>                        __count_vm_events(KSWAPD_STEAL, nr_freed);
>                __count_zone_vm_events(PGSTEAL, zone, nr_freed);
>
>                spin_lock(&zone->lru_lock);
>                /*
>
> I'm guessing the __count_zone_vm_events and friends need interrupts
> disabled here, probably due to per cpu stuff. But if you enable
> interrupts before the spin_lock() you may let an interrupt come in and
> invalidate what was done above it.
>
> So no, I do not think enabling interrupts here is a good thing.
>

okay, and since we have already done local_irq_disable(), then that is
why we only need the spin_lock() and not the spin_lock_irq() flavour?
