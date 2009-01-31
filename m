Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZAaMTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZAaMTb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 07:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbZAaMTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 07:19:22 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:60639 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbZAaMTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 07:19:21 -0500
Date: Sat, 31 Jan 2009 12:16:11 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
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
In-Reply-To: <alpine.LFD.2.00.0901301326020.3150@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0901311209140.6763@blonde.anvils>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com> 
 <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain> 
 <1233259410.2315.75.camel@lts-notebook>  <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain>
  <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain> 
 <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com> 
 <alpine.LFD.2.00.0901291806340.3054@localhost.localdomain> 
 <20090130055639.GA30950@suse.de>  <alpine.LFD.2.00.0901300811260.3150@localhost.localdomain>
  <Pine.LNX.4.64.0901301724010.1563@blonde.anvils> 
 <alpine.LFD.2.00.0901300946360.3150@localhost.localdomain>
 <1233345190.908.36.camel@lts-notebook> <alpine.LFD.2.00.0901301159500.3150@localhost.localdomain>
 <Pine.LNX.4.64.0901302048360.18677@blonde.anvils>
 <alpine.LFD.2.00.0901301326020.3150@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009, Linus Torvalds wrote:
> On Fri, 30 Jan 2009, Hugh Dickins wrote:
> > 
> > By the same (used to merge, now won't) argument, one could say
> > VM_INSERTPAGE should be there too; but whereas VM_MIXEDMAP is used
> > in one place only, quite a lot of drivers use vm_insert_page(), so
> > I feel more comfortable with the idea that it's stopping merges -
> > though in that case, shouldn't we add it to VM_SPECIAL?
> 
> But VM_INSERTPAGE - no.
> 
> Why? Because VM_INSERTPAGE implies that mmap() itself quite possibly 
> actually _does_ something (it may have inserted _all_ the pages, and may 
> not even have any ->fault handler at all).
> 
> So we can't just expand a current mapping and forget about it, we need to 
> do the mmap(). So the "only do merges early" fundamentally cannot merge 
> such a vma, even if the old code did.

Good point indeed.  Same as why we test for it in copy_page_range().
Should it be added to VM_SPECIAL?  Not for this particular (need to
call ->mmap) reason, but we probably ought to add it anyway.

Hugh

> 
> Of course, we could look at whether it has a ->fault handler as an 
> indication of whether it's possible to merge or not. We already do that 
> for ->close, and in many ways ->fault would likely be a better indicator 
> of whether something is mergeable or not.
> 
> But there's really no point. VM_INSERTPAGE implies a very special mapping: 
> it's used by things like the SCSI target user space ring map, or the magic 
> network packet mmap thing. If you use those things, you really don't care 
> about merging adjacent VM's anyway, and at least the two I looked at 
> really do the whole "pre-populate at mmap time" thing.
> 
> And at least the packet one really does have a ->close function, and lacks 
> a ->fault function, so it wouldn't have merged before either (and looking 
> at ->fault again seems to be as valid as looking at ->close).
> 
> 			Linus
