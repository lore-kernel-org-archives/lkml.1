Return-Path: <linux-kernel-owner+w=401wt.eu-S1758211AbYFXP5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211AbYFXP5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 11:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbYFXP5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 11:57:09 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:32810 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbYFXP5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 11:57:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dEPHxQ2+j1Oss0EcGzY4PcjKLQzo5i+fo9ccYfQHhNy4XT4QB6yd1Yphv/hsi0/wHY
         6UpfEI+ESBcpeGpwZznjMDxEBtH5o6t2zu2C1kZWuQBQLXJoVcxVGLbKb5MKjLjDM9hu
         L+RvusDYHozj+fAAt/wG0+adOHxChnoDtz0P0=
Message-ID: <48f7fe350806240857l38edb74ame8cef4a7be595bbc@mail.gmail.com>
Date: Tue, 24 Jun 2008 11:57:05 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [BUG] Lockless patches cause hardlock under heavy IO
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Peter Zijlstra" <peterz@infradead.org>, linux-mm@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080624153238.GD7978@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350806181415l4eba61b3i1d206de03147575e@mail.gmail.com>
	 <200806232154.52820.nickpiggin@yahoo.com.au>
	 <20080623130536.GA10595@linux.vnet.ibm.com>
	 <200806241013.45908.nickpiggin@yahoo.com.au>
	 <48f7fe350806240812t5bd411daw122aca4d6b67e932@mail.gmail.com>
	 <20080624153238.GD7978@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can give you a list of patches that should correspond to the thread
name (for the most part):

fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch

fix_munlock-page-table-walk.patch

migration_entry_wait-fix.patch

PATCH collect lru meminfo statistics from correct offset

Mlocked field of /proc/meminfo display silly number.
because trivial mistake exist in meminfo_read_proc().

You can also look in our git repo to see the code that changed with
these patches if you cant track them down in LKML:
http://zen-sources.org/cgi-bin/gitweb.cgi?p=kernel-mm.git;a=shortlog;h=refs/heads/lkml

On Tue, Jun 24, 2008 at 11:32 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Tue, Jun 24, 2008 at 11:12:03AM -0400, Ryan Hope wrote:
>> Well i tried to run pure -mm this weekend, it locked as soon as I got
>> into gnome so I applied a couple of the bug fixes from lkml and -mm
>> seems to be running stable now. I cant seem to get it to hard lock
>> now, at least not doing the simple stuff that was causing it to hard
>> lock on my other patchset, either the lockless patches expose some bug
>> that in -rc6 or lockless requires some other patches further up in the
>> -mm series file.
>
> Cool!!!  Any guess as to which of the bug fixes did the trick?
> Failing that, a list of the bug fixes that you applied?
>
>                                                        Thanx, Paul
>
>> On Mon, Jun 23, 2008 at 8:13 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>> > On Monday 23 June 2008 23:05, Paul E. McKenney wrote:
>> >> On Mon, Jun 23, 2008 at 09:54:52PM +1000, Nick Piggin wrote:
>> >> > On Monday 23 June 2008 13:51, Ryan Hope wrote:
>> >> > > well i get the hardlock on -mm with out using reiser4, i am pretty
>> >> > > sure is swap related
>> >> >
>> >> > The guys seeing hangs don't use PREEMPT_RCU, do they?
>> >> >
>> >> > In my swapping tests, I found -mm3 to be stable with classic RCU, but
>> >> > on a hunch, I tried PREEMPT_RCU and it crashed a couple of times rather
>> >> > quickly. First crash was in find_get_pages so I suspected lockless
>> >> > pagecache doing something subtly wrong with the RCU API, but I just got
>> >> > another crash in __d_lookup:
>> >>
>> >> Could you please send me a repeat-by?  (At least Alexey is no longer
>> >> alone!)
>> >
>> > OK, I had DEBUG_PAGEALLOC in the .config, which I think is probably
>> > important to reproduce it (but the fact that I'm reproducing oopses
>> > with << PAGE_SIZE objects like dentries and radix tree nodes indicates
>> > that there is even more free-before-grace activity going undetected --
>> > if you construct a test case using full pages, it might become even
>> > easier to detect with DEBUG_PAGEALLOC).
>> >
>> > 2 socket, 8 core x86 system.
>> >
>> > I mounted two tmpfs filesystems, one contains a single large file
>> > which is formatted as 1K block size ext3 and mounted loopback, the
>> > other is used directly. Linux kernel source is unpacked on each mount
>> > and concurrent make -j128 on each. This pushes it pretty hard into
>> > swap. Classic RCU survived another 5 hours of this last night.
>> >
>> > But that's a fairly convoluted test for an RCU problem. I expect it
>> > should be easier to trigger with something more targetted...
>> >
>
