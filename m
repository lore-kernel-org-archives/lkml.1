Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbZA3Viv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbZA3Viv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 16:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbZA3Vin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 16:38:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752511AbZA3Vim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 16:38:42 -0500
Date: Fri, 30 Jan 2009 13:37:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Hugh Dickins <hugh@veritas.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Greg KH <gregkh@suse.de>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mikos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED
 file segments
In-Reply-To: <Pine.LNX.4.64.0901302048360.18677@blonde.anvils>
Message-ID: <alpine.LFD.2.00.0901301326020.3150@localhost.localdomain>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com>  <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain>  <1233259410.2315.75.camel@lts-notebook>  <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain> 
 <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain>  <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com>  <alpine.LFD.2.00.0901291806340.3054@localhost.localdomain>  <20090130055639.GA30950@suse.de>  <alpine.LFD.2.00.0901300811260.3150@localhost.localdomain>
  <Pine.LNX.4.64.0901301724010.1563@blonde.anvils>  <alpine.LFD.2.00.0901300946360.3150@localhost.localdomain> <1233345190.908.36.camel@lts-notebook> <alpine.LFD.2.00.0901301159500.3150@localhost.localdomain>
 <Pine.LNX.4.64.0901302048360.18677@blonde.anvils>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 Jan 2009, Hugh Dickins wrote:
> 
> By the way, there's an argument to say that you should add
> VM_MIXEDMAP to VM_CAN_NONLINEAR in VM_MERGEABLE_FLAGS: I don't
> really care whether we merge the odd filemap_xip vma or not,
> but it used to do so and now won't.
> 
> By the same (used to merge, now won't) argument, one could say
> VM_INSERTPAGE should be there too; but whereas VM_MIXEDMAP is used
> in one place only, quite a lot of drivers use vm_insert_page(), so
> I feel more comfortable with the idea that it's stopping merges -
> though in that case, shouldn't we add it to VM_SPECIAL?

VM_MIXEDMAP, yes. It's a special case.

But VM_INSERTPAGE - no.

Why? Because VM_INSERTPAGE implies that mmap() itself quite possibly 
actually _does_ something (it may have inserted _all_ the pages, and may 
not even have any ->fault handler at all).

So we can't just expand a current mapping and forget about it, we need to 
do the mmap(). So the "only do merges early" fundamentally cannot merge 
such a vma, even if the old code did.

Of course, we could look at whether it has a ->fault handler as an 
indication of whether it's possible to merge or not. We already do that 
for ->close, and in many ways ->fault would likely be a better indicator 
of whether something is mergeable or not.

But there's really no point. VM_INSERTPAGE implies a very special mapping: 
it's used by things like the SCSI target user space ring map, or the magic 
network packet mmap thing. If you use those things, you really don't care 
about merging adjacent VM's anyway, and at least the two I looked at 
really do the whole "pre-populate at mmap time" thing.

And at least the packet one really does have a ->close function, and lacks 
a ->fault function, so it wouldn't have merged before either (and looking 
at ->fault again seems to be as valid as looking at ->close).

			Linus
