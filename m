Return-Path: <linux-kernel-owner+w=401wt.eu-S1764728AbYDOLvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764728AbYDOLvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 07:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763628AbYDOLvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 07:51:23 -0400
Received: from saeurebad.de ([85.214.36.134]:54456 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763049AbYDOLvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 07:51:21 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, "Andi Kleen" <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [patch 2/2] bootmem: Node-setup agnostic free_bootmem()
References: <20080412223319.372887160@symbol.fehenstaub.lan>
	<20080412225850.704752615@symbol.fehenstaub.lan>
	<87lk3hwv52.fsf@basil.nowhere.org>
	<20080414232308.ffa4e269.akpm@linux-foundation.org>
	<86802c440804150004w1c94b2dci520e0ffb8b60632f@mail.gmail.com>
	<20080415001512.60cb784d.akpm@linux-foundation.org>
	<86802c440804150028t33fabd7fn40d3d47d0482bfc1@mail.gmail.com>
	<20080415003647.922a9a05.akpm@linux-foundation.org>
Date: Tue, 15 Apr 2008 13:51:08 +0200
In-Reply-To: <20080415003647.922a9a05.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 15 Apr 2008 00:36:47 -0700")
Message-ID: <87wsmzibf7.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrew Morton <akpm@linux-foundation.org> writes:

> On Tue, 15 Apr 2008 00:28:34 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>
>> On Tue, Apr 15, 2008 at 12:15 AM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>> >
>> > On Tue, 15 Apr 2008 00:04:03 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>> >
>> >  > On Mon, Apr 14, 2008 at 11:23 PM, Andrew Morton
>> >  > <akpm@linux-foundation.org> wrote:
>> >  > >
>> >  > > On Sun, 13 Apr 2008 18:56:57 +0200 Andi Kleen <andi@firstfloor.org> wrote:
>> >  > >
>> >  > >  > Johannes Weiner <hannes@saeurebad.de> writes:
>> >  > >  >
>> >  > >  > > Make free_bootmem() look up the node holding the specified address
>> >  > >  > > range which lets it work transparently on single-node and multi-node
>> >  > >  > > configurations.
>> >  > >  >
>> >  > >  > Acked-by: Andi Kleen <andi@firstfloor.org>
>> >  > >  >
>> >  > >  > This is far better than the original change it replaces and which
>> >  > >  > I also objected to in review.
>> >  > >  >
>> >  > >
>> >  > >  So...  do we think these two patches are sufficiently safe and important for
>> >  > >  2.6.25?
>> >  >
>> >  > the patch is wrong
>> >  >
>> >
>> >  The last I saw was this:
>> >
>> >
>> >  On Sun, 13 Apr 2008 12:57:22 +0200 Johannes Weiner <hannes@saeurebad.de> wrote:
>> >
>> >  > Hi,
>> >  >
>> >  > "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>> >  >
>> >  > > On Sat, Apr 12, 2008 at 3:33 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
>> >  > > ...
>> >
>> > > >
>> >  > > could have chance that bootmem with reserved_early that is crossing
>> >  > > the nodes.
>> >  >
>> >  > Upstream reserve_bootmem_core() would BUG() on a caller trying to cross
>> >  > nodes, so I don't see where this chance could come from.
>> >
>> >  Is that what you're referring to?
>> >
>> >  Was Johannes observation incorrect?  If so, why?
>> 
>> my patch with free_bootmem will make sure free_bootmem_core only free
>> bootmem in the bdata scope.
>> so free_bootmem can handle the cross_node bootmem that is done by
>> reserve_early ( done in another patch, is dropped by you because took
>> Jonannes).
>> 
>> in setup_arch for x86_64 there is one free_bootmem that is used when
>> ramdisk is falled out of ram map. that could be crossed by bootloader
>> and kexec, and kernel or second kernel is memmap=NN@SS to execlue some
>> memory.
>> 
>> anyway that is extrem case, but my patch could handle that.

Has this case ever occured?  If this could become real, I have no
objections to implement a way to handle it (why would I?), but until now
you just said that in some time in the future, this could be useful.

>> 
>> I wonder if any regression caused by my previous patch? maybe on other platform?
>> 
>
> Not that I'm aware of.

It papers over buggy usage of free_bootmem().  If its arguments are
bogus, it will just return again where it BUG()ed out before.  The pages
might be never marked free and therefor never reach the buddy allocator.

> I restored mm-make-reserve_bootmem-can-crossed-the-nodes.patch.  Johannes,
> can you please check 2.6.28-rc8-mm2, see if it looks OK?

I object to the way it is implemented.  If it is really needed, that
should be done properly:

	- remove the double loop over the area on the likely succeeding
          path and unroll the reserving on the unlikely path as it was
          done before.  Better to punish exceptional branches than
	  the working paths.
	- make reserve_bootmem_core be strict with its arguments.  If
	  you want to iterate over the bdata list, you should not just
	  throw every item at the _core functions and let them work it
	  out for themselves.  The correct parameters should be
          calculated in advance and then passed to a strict
          _bootmem_core() function that BUG()s on failure.

But still, Yinghai, you never brought in practical reasons for this
whole thing.  You talked about extreme and theoretical cases and I don't
think that this justifies breaking API or pessimizing code at all.

	Hannes
