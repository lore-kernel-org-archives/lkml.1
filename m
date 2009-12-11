Return-Path: <linux-kernel-owner+w=401wt.eu-S1762059AbZLKBZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762059AbZLKBZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:25:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933326AbZLKBZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:25:03 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:57335 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933324AbZLKBY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:24:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CoR1ONU/iDP6yozF+vWumTLokVItTwKmbUXsM0WQcmxO1Hrjm4SeDKEpCMcKHYPRL3
         9gxJzB+NpOe9+5S6QKwYwnJgOtDFNVGed4lwBo1nFUM9hVC4tVCwnGYYq1jqw5dsasbv
         BjqlC34mctlk4fIEpT8QA/cfsZg8lEOtcQVWU=
MIME-Version: 1.0
In-Reply-To: <20091211095159.6472a009.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
	 <20091210163448.338a0bd2.kamezawa.hiroyu@jp.fujitsu.com>
	 <28c262360912101640y4b90db76w61a7a5dab5f8e796@mail.gmail.com>
	 <20091211095159.6472a009.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 11 Dec 2009 10:25:03 +0900
Message-ID: <28c262360912101725ydb0a0d9i12a91c1d4fe57672@mail.gmail.com>
Subject: Re: [RFC mm][PATCH 2/5] percpu cached mm counter
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 9:51 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 11 Dec 2009 09:40:07 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>> > static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
>> >  {
>> > -       return (unsigned long)atomic_long_read(&(mm)->counters[member]);
>> > +       long ret;
>> > +       /*
>> > +        * Because this counter is loosely synchronized with percpu cached
>> > +        * information, it's possible that value gets to be minus. For user's
>> > +        * convenience/sanity, avoid returning minus.
>> > +        */
>> > +       ret = atomic_long_read(&(mm)->counters[member]);
>> > +       if (unlikely(ret < 0))
>> > +               return 0;
>> > +       return (unsigned long)ret;
>> >  }
>>
>> Now, your sync point is only task switching time.
>> So we can't show exact number if many counting of mm happens
>> in short time.(ie, before context switching).
>> It isn't matter?
>>
> I think it's not a matter from 2 reasons.
>
> 1. Now, considering servers which requires continuous memory usage monitoring
> as ps/top, when there are 2000 processes, "ps -elf" takes 0.8sec.
> Because system admins know that gathering process information consumes
> some amount of cpu resource, they will not do that so frequently.(I hope)
>
> 2. When chains of page faults occur continously in a period, the monitor
> of memory usage just see a snapshot of current numbers and "snapshot of what
> moment" is at random, always. No one can get precise number in that kind of situation.
>

Yes. I understand that.

But we did rss updating as batch until now.
It was also stale. Just only your patch make stale period longer.
Hmm. I hope people don't expect mm count is precise.

I saw the many people believed sanpshot of mm counting is real in
embedded system.
They want to know the exact memory usage in system.
Maybe embedded system doesn't use SPLIT_LOCK so that there is no regression.

At least, I would like to add comment "It's not precise value." on
statm's Documentation.
Of course, It's off topic.  :)

Thanks for commenting. Kame.
-- 
Kind regards,
Minchan Kim
