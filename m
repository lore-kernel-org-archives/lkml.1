Return-Path: <linux-kernel-owner+w=401wt.eu-S1760888AbYFXPMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760888AbYFXPMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 11:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758728AbYFXPMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 11:12:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:57251 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757644AbYFXPMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 11:12:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MfyHcrOdGaY/xQlNcnLWdRSjBxvYhb1gR3/x33573L5qXJhK9WGRc1DcSOywKUM8Iy
         kKDre+257o0E92ocpQ8L0nrUnm/62yWLnyg4Q8sbFnl9SJu+egcPh+zG9UswA2+wjnTE
         PLuL7MZf67ds4ruHB0V9mUPZxuJTk3p8tpKds=
Message-ID: <48f7fe350806240812t5bd411daw122aca4d6b67e932@mail.gmail.com>
Date: Tue, 24 Jun 2008 11:12:03 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [BUG] Lockless patches cause hardlock under heavy IO
Cc: paulmck@linux.vnet.ibm.com, "Peter Zijlstra" <peterz@infradead.org>,
       linux-mm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200806241013.45908.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350806181415l4eba61b3i1d206de03147575e@mail.gmail.com>
	 <200806232154.52820.nickpiggin@yahoo.com.au>
	 <20080623130536.GA10595@linux.vnet.ibm.com>
	 <200806241013.45908.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well i tried to run pure -mm this weekend, it locked as soon as I got
into gnome so I applied a couple of the bug fixes from lkml and -mm
seems to be running stable now. I cant seem to get it to hard lock
now, at least not doing the simple stuff that was causing it to hard
lock on my other patchset, either the lockless patches expose some bug
that in -rc6 or lockless requires some other patches further up in the
-mm series file.

On Mon, Jun 23, 2008 at 8:13 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> On Monday 23 June 2008 23:05, Paul E. McKenney wrote:
>> On Mon, Jun 23, 2008 at 09:54:52PM +1000, Nick Piggin wrote:
>> > On Monday 23 June 2008 13:51, Ryan Hope wrote:
>> > > well i get the hardlock on -mm with out using reiser4, i am pretty
>> > > sure is swap related
>> >
>> > The guys seeing hangs don't use PREEMPT_RCU, do they?
>> >
>> > In my swapping tests, I found -mm3 to be stable with classic RCU, but
>> > on a hunch, I tried PREEMPT_RCU and it crashed a couple of times rather
>> > quickly. First crash was in find_get_pages so I suspected lockless
>> > pagecache doing something subtly wrong with the RCU API, but I just got
>> > another crash in __d_lookup:
>>
>> Could you please send me a repeat-by?  (At least Alexey is no longer
>> alone!)
>
> OK, I had DEBUG_PAGEALLOC in the .config, which I think is probably
> important to reproduce it (but the fact that I'm reproducing oopses
> with << PAGE_SIZE objects like dentries and radix tree nodes indicates
> that there is even more free-before-grace activity going undetected --
> if you construct a test case using full pages, it might become even
> easier to detect with DEBUG_PAGEALLOC).
>
> 2 socket, 8 core x86 system.
>
> I mounted two tmpfs filesystems, one contains a single large file
> which is formatted as 1K block size ext3 and mounted loopback, the
> other is used directly. Linux kernel source is unpacked on each mount
> and concurrent make -j128 on each. This pushes it pretty hard into
> swap. Classic RCU survived another 5 hours of this last night.
>
> But that's a fairly convoluted test for an RCU problem. I expect it
> should be easier to trigger with something more targetted...
>
