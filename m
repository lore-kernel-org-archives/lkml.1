Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbZKWP0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbZKWP0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 10:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbZKWP0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 10:26:23 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:64501 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbZKWP0X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 10:26:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vnrFNGgn3Yf6BArMSgoa7/TGU57jc1LsCd9ikTcwm8AwFV7cw2yBJxvG0ZNb96g1bY
         Y2acVY7oGeKgARd17U8bbXZVwZg+R8nYFj56jVNxn69ynr65ElvsTfcixZb56yrUiIGd
         BLnfQU4aLjdl4/jZg6yuEDKHKUZxCzdduItLc=
MIME-Version: 1.0
In-Reply-To: <20091123140323.GA4495@redhat.com>
References: <cover.1258805412.git.andre.goddard@gmail.com> 
	<0e91f1c4ecc5bc5000f729ccb56e9b6e1fbd4bd3.1258805412.git.andre.goddard@gmail.com> 
	<84144f020911230138v11b18709q28c186f9260f6d66@mail.gmail.com> 
	<20091123140323.GA4495@redhat.com>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Mon, 23 Nov 2009 13:26:09 -0200
Message-ID: <b8bf37780911230726x7ec9b8b4s9adec2202de5fb87@mail.gmail.com>
Subject: Re: [PATCH 1/2] pid: tighten pidmap spinlock critical section by 
	removing kfree()
To: Oleg Nesterov <oleg@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Oleg!

On Mon, Nov 23, 2009 at 12:03 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 11/23, Pekka Enberg wrote:
>> (Adding some CC's.)
>>
>> On Sat, Nov 21, 2009 at 2:16 PM, André Goddard Rosa
>> <andre.goddard@gmail.com> wrote:
>> > Avoid calling kfree() under pidmap spinlock, calling it afterwards.
>> >
>> > Normally kfree() is very fast, but sometimes it can be slow, so avoid
>> > calling it under the spinlock if we can.
>
> kfree() is called when we race with another process which also
> finds map->page == NULL, allocs the new page and takes pidmap_lock
> before us. This is extremely unlikely case, right?

Right, somehow.

>> > @@ -141,11 +141,12 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
>> >                         * installing it:
>> >                         */
>> >                        spin_lock_irq(&pidmap_lock);
>> > -                       if (map->page)
>> > -                               kfree(page);
>> > -                       else
>> > +                       if (!map->page) {
>> >                                map->page = page;
>> > +                               page = NULL;
>> > +                       }
>> >                        spin_unlock_irq(&pidmap_lock);
>> > +                       kfree(page);
>
> And this change pessimizes (a little bit) the likely case, when
> the race doesn't happen. And imho this change doesn't make the
> code more readable.
>
> But this is subjective, and technically the patch is correct
> afaics.

It does not affect the likely case which happens when the pidmap is
already allocated.

In the unlikely case where the pidmap must be allocated, if we think
that we could have
let's say 8 processes contending for that spinlock, while one process
got it first and allocated
the page, having the kfree() out of the spinlock would make those
other 7 processes doing
useful work (performing the release of the page) before, because it
would avoid all of them
spinning around waiting until the all the others also free their
allocated pages.

>> >                        if (unlikely(!map->page))
>> >                         �
>
> Hmm. Off-topic, but why alloc_pidmap() does not do this right
> after kzalloc() ?

Hmm... I would say that it's an optimistic best effort. We avoid
failing right away
hoping that another process (racing) had success allocating the page.
That is unlikely! :)

Thank you,
André
