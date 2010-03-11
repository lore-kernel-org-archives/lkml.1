Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab0CKLg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 06:36:26 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42098 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508Ab0CKLgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 06:36:24 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1003110706340.29854@sister.anvils>
References: <d760cf2d1003050222m6e509ffaqa498645c52f7d98e@mail.gmail.com>
	 <alpine.LSU.2.00.1003110706340.29854@sister.anvils>
Date: Thu, 11 Mar 2010 17:06:22 +0530
Message-ID: <d760cf2d1003110336l60c2536fj82ec541bf99261df@mail.gmail.com>
Subject: Re: [PATCH 0/3] ramzswap: Eliminate stale data in compressed memory
From: Nitin Gupta <ngupta@vflare.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Pekka Enberg <penberg@gmail.com>, andi@firstfloor.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 12:52 PM, Hugh Dickins
<hugh.dickins@tiscali.co.uk> wrote:
> On Fri, 5 Mar 2010, Nitin Gupta wrote:
<snip>
>
>> Adding handler for this callback:
>>       swapon notifier --> set_swap_free_notify(swap_type, fn)
>>
>> Removing handler:
>>       swapoff notifier --> set_swap_free_notify(swap_type, NULL)
>>
>>
>> Alternative approaches:
>> 1) Add callback directly in 'struct block_device_operations' but
>> that is considered too hacky.
>> 2) Use swap discard mechanism: It involves unncessary overhead of
>> allocating 'discard bio' requests and its too slow to serve ramzswap
>> needs.
>>
>>  drivers/staging/ramzswap/ramzswap_drv.c   |   91 +++++++++++++++++++++++++++++
>>  drivers/staging/ramzswap/ramzswap_drv.h   |    1 +
>>  drivers/staging/ramzswap/ramzswap_ioctl.h |    1 +
>>  include/linux/swap.h                      |   16 +++++-
>>  mm/swapfile.c                             |   78 ++++++++++++++++++++++++
>>  5 files changed, 185 insertions(+), 2 deletions(-)
>

> This is one of the various solutions I disliked already, isn't it?
>

This is a kind of hybrid of previous approaches. We now have notifier
for swapon/off events only -- which Linus seems to be okay with (earlier
we had notifier for slot free event also). Handler for swapon is responsible
for setting callback for slot free event  (earlier we were installing it from
"ramzswap_make_request" directly, when first I/O is received).


> To me this is just a more convoluted and obscure variant of the
> block_device_operations swap_slot_free_notify patch you had in mmotm,
> which Linus has rejected.
>

This slot free notification is a sort of black area for which I have
really run out of
ideas. I tried all the approaches I could think of (and all you and
Pekka suggested)
but nothing seems to satisfy everyone. This is so essential for ramzswap but now
I don't know how to get this done.

> I admit, I did not understand at all what Linus was proposing with
> readpage, writepage and address_space_operations: I kept quiet in
> the hope that you'd understand where I didn't!
>

I guess he is suggesting creating a fictional 'address_space' just like
we have 'struct address_space swapper_space'. This way, we can
intercept writepage naturally in pageout() with new mapping->a_ops->writepage().
And then similarly with mapping->a_ops->readpage().

I'm now looking into this approach. This might allow compressing page cache
pages too. However, figuring out all the details can take significant
amount of time
and allowing ramzswap development to happen in parallel should be okay.

Thanks,
Nitin
