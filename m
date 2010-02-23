Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab0BWQEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 11:04:07 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45429 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab0BWQEF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 11:04:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lL6XK/F5Z9FiwRVSlqiU6xiA28YsbcP2fM7pgwRFhTDvjAdqiCDl1IFZYfJGLZYVn9
         ad2shzeoCUpRMGf1BE6glQbuLGLfvwOSRqqDpcI7JTp5TCF5smK5TIKAnpZkCp86wMIk
         LGA62jImYizsmwbOm63bu3lScSwP2gJk0hRgs=
MIME-Version: 1.0
In-Reply-To: <20100223154016.GC29762@cmpxchg.org>
References: <1266868150-25984-1-git-send-email-hannes@cmpxchg.org>
	 <1266868150-25984-2-git-send-email-hannes@cmpxchg.org>
	 <1266932303.2723.13.camel@barrios-desktop>
	 <20100223142158.GA29762@cmpxchg.org>
	 <1266936254.2723.33.camel@barrios-desktop>
	 <20100223154016.GC29762@cmpxchg.org>
Date: Wed, 24 Feb 2010 01:04:02 +0900
Message-ID: <28c262361002230804h53574e2aje619aeff558efa77@mail.gmail.com>
Subject: Re: [patch 1/3] vmscan: factor out page reference checks
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 12:40 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> Hello Minchan,
>
> On Tue, Feb 23, 2010 at 11:44:14PM +0900, Minchan Kim wrote:
>> On Tue, 2010-02-23 at 15:21 +0100, Johannes Weiner wrote:
>> > Hello Minchan,
>> >
>> > On Tue, Feb 23, 2010 at 10:38:23PM +0900, Minchan Kim wrote:
>>
>> <snip>
>>
>> > > >
>> > > >                 if (PageDirty(page)) {
>> > > > -                       if (sc->order <= PAGE_ALLOC_COSTLY_ORDER && referenced)
>> > > > +                       if (references == PAGEREF_RECLAIM_CLEAN)
>> > >
>> > > How equal PAGEREF_RECLAIM_CLEAN and sc->order <= PAGE_ALLOC_COSTLY_ORDER
>> > > && referenced by semantic?
>> >
>> > It is encoded in page_check_references().  When
>> >     sc->order <= PAGE_ALLOC_COSTLY_ORDER && referenced
>> > it returns PAGEREF_RECLAIM_CLEAN.
>> >
>> > So
>> >
>> >     - PageDirty() && order < COSTLY && referenced
>> >     + PageDirty() && references == PAGEREF_RECLAIM_CLEAN
>> >
>> > is an equivalent transformation.  Does this answer your question?
>>
>> Hmm. I knew it. My point was PAGEREF_RECLAIM_CLEAN seems to be a little
>> awkward. I thought PAGEREF_RECLAIM_CLEAN means if the page was clean, it
>> can be reclaimed.
>
> But you were thinking right, it is exactly what it means!  If
> the state is PAGEREF_RECLAIM_CLEAN, reclaim the page if it is clean:
>
>        if (PageDirty(page)) {
>                if (references == PAGEREF_RECLAIM_CLEAN)
>                        goto keep_locked;       /* do not reclaim */
>                ...
>        }
>
>> I think it would be better to rename it with represent "Although it's
>> referenced page recently, we can reclaim it if VM try to reclaim high
>> order page".
>
> I changed it to PAGEREF_RECLAIM_LUMPY and PAGEREF_RECLAIM, but I felt
> it made it worse.  It's awkward that we have to communicate that state
> at all, maybe it would be better to do
>
>        if (PageDirty(page) && referenced_page)
>                return PAGEREF_KEEP;
>
> in page_check_references()?  But doing PageDirty() twice is also kinda
> lame.
>
> I don't know.  Can we leave it like that for now?

I hope as it is if we don't have any better idea and you don't feel it strong.
But let's listen to other's opinion. maybe they have a good idea.

Thanks, Hannes.



-- 
Kind regards,
Minchan Kim
