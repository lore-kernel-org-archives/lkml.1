Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbZIRJ7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbZIRJ7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 05:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbZIRJ66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 05:58:58 -0400
Received: from mail-pz0-f179.google.com ([209.85.222.179]:56549 "EHLO
	mail-pz0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbZIRJ66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 05:58:58 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0909180809290.2882@sister.anvils>
References: <1253227412-24342-1-git-send-email-ngupta@vflare.org>
	 <1253227412-24342-3-git-send-email-ngupta@vflare.org>
	 <1253256805.4959.8.camel@penberg-laptop>
	 <Pine.LNX.4.64.0909180809290.2882@sister.anvils>
Date: Fri, 18 Sep 2009 15:29:01 +0530
Message-ID: <d760cf2d0909180259s34c15062led687940ff7e0c42@mail.gmail.com>
Subject: Re: [PATCH 2/4] send callback when swap slot is freed
From: Nitin Gupta <ngupta@vflare.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, linux-mm-cc <linux-mm-cc@laptop.org>,
       kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 12:47 PM, Hugh Dickins
<hugh.dickins@tiscali.co.uk> wrote:
> On Fri, 18 Sep 2009, Pekka Enberg wrote:
>> On Fri, 2009-09-18 at 04:13 +0530, Nitin Gupta wrote:
>> > +EXPORT_SYMBOL_GPL(set_swap_free_notify);
>> > +
>> >  static int swap_entry_free(struct swap_info_struct *p,
>> >                        swp_entry_t ent, int cache)
>> >  {
>> > @@ -585,6 +617,8 @@ static int swap_entry_free(struct swap_info_struct *p,
>> >                     swap_list.next = p - swap_info;
>> >             nr_swap_pages++;
>> >             p->inuse_pages--;
>> > +           if (p->swap_free_notify_fn)
>> > +                   p->swap_free_notify_fn(p->bdev, offset);
>> >     }
>> >     if (!swap_count(count))
>> >             mem_cgroup_uncharge_swap(ent);
>>
>> OK, this hits core kernel code so we need to CC some more mm/swapfile.c
>> people. The set_swap_free_notify() API looks strange to me. Hugh, I
>> think you mentioned that you're okay with an explicit hook. Any
>> suggestions how to do this cleanly?
>
> No, no better suggestion.  I quite see Nitin's point that ramzswap
> would benefit significantly from a callback here, though it's not a
> place (holding swap_lock) where we'd like to offer a callback at all.
>
> I think I would prefer the naming to make it absolutely clear that
> it's a special for ramzswap or compcache, rather than dressing it
> up in the grand generality of a swap_free_notify_fn: giving our
> hacks fancy names doesn't really make them better.
>

Yes, makes sense... Since we cannot afford to have a chain of callbacks
within a spin lock, we have to keep it ramzswap specific (and rename
functions/variables to reflect this).

set_ramzswap_free_notify_fn() -> set_ramzswap_free_notify_fn()
and
swap_free_notify_fn -> ramzswap_free_notify_fn

Now, this renaming exposes ugliness of this hack in its true sense. Currently,
I don't have a cleaner solution but few points to consider:

 - If we really have to do this within the lock then there cannot be
multiple callbacks.
It has to then remain ramzswap specific. In that case, current patch
looks looks like
the simplest solution.

 - Do we really have to have a callback within a spin lock? Things become
very complex in ramzswap driver if we try to do this outside the lock
(I attempted
this but couldn't get it working). Still, we should think about it.

 - If it can be done outside lock, we can afford to be chain of
callbacks attached
to this event. A nice generic solution. But if this means delaying
callback for too long,
then it may be unacceptable for ramzswap (we come back to problem with discard
approach).


> (Does the bdev matching work out if there are any regular swapfiles
> around? I've not checked, might or might not need refinement there.)
>

Yes.

Thanks,
Nitin
