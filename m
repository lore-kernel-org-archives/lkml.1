Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbZA3VOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbZA3VOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 16:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbZA3VON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 16:14:13 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:44193 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbZA3VON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 16:14:13 -0500
Date: Fri, 30 Jan 2009 21:12:44 +0000 (GMT)
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
In-Reply-To: <alpine.LFD.2.00.0901301159500.3150@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0901302048360.18677@blonde.anvils>
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
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009, Linus Torvalds wrote:
> On Fri, 30 Jan 2009, Lee Schermerhorn wrote:
> > 
> > So happens, I'm mapping with MAP_SHARED, so the VM_ACCOUNT flag gets
> > cleared later in mmap_region().  Comments say that this is for checking
> > memory availability during shmem_file_setup().  Maybe we can move the
> > temporary setting of VM_ACCOUNT until just before the call to
> > shmem_zero_setup()?
> 
> Yeah, that would probably fix it, and looks like the right thing to do. 

I do need to refresh my memory on that in a moment...

> 
> It all looks pretty confused wrong to set the whole VM_ACCOUNT flag for a 
> file-backed file AT ALL in the first place, but the code knows that it 
> won't matter for a shared file, and will be cleared again later.
> 
> So it plays these temporary games with vm_flags, and it didn't matter 
> because of how we used to call "vma_merge()" either early only for the 
> anonymous memory case (that had VM_ACCOUNT stable and didn't have that 
> temporary case at all) or much later (after having undone the temporary 
> flag setting) for files.

I'm to blame for those games, and now they've given trouble,
the right thing may be to put an end to them.

> 
> Why do we pass in that "accountable" flag, btw? It's only ever set to 0 by 
> a MAP_PRIVATE mapping that hits is_file_hugepages() (see do_mmap_pgoff), 
> and we could just do that decision all inside mmap_region(). So the flag 
> doesn't really seem to have any real meaning, and is just passed around 
> for some odd historical reason?

It looks like the "accountable" flag dates from before Miklos separated
mmap_region() out from do_mmap_pgoff(): so he just passed it on down to
mmap_region() as an additional argument, preferring to leave the more
complex MAP_PRIVATE/is_file_hugepages test behind in do_mmap_pgoff().

It seemed rather a random refactoring to me.  Looking at it again,
I wonder if we should be getting do_brk() to use mmap_region() too;
but my appetite for cleanups is low at present, bugs we have enough.

By the way, there's an argument to say that you should add
VM_MIXEDMAP to VM_CAN_NONLINEAR in VM_MERGEABLE_FLAGS: I don't
really care whether we merge the odd filemap_xip vma or not,
but it used to do so and now won't.

By the same (used to merge, now won't) argument, one could say
VM_INSERTPAGE should be there too; but whereas VM_MIXEDMAP is used
in one place only, quite a lot of drivers use vm_insert_page(), so
I feel more comfortable with the idea that it's stopping merges -
though in that case, shouldn't we add it to VM_SPECIAL?

But I'm caring more about that VM_ACCOUNT...

Hugh
