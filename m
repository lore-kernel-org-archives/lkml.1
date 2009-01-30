Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbZA3Ubp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbZA3Ubp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 15:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbZA3Ubh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 15:31:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752998AbZA3Ubh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 15:31:37 -0500
Date: Fri, 30 Jan 2009 12:31:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Hugh Dickins <hugh@veritas.com>, Greg KH <gregkh@suse.de>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED
 file segments
In-Reply-To: <1233345190.908.36.camel@lts-notebook>
Message-ID: <alpine.LFD.2.00.0901301159500.3150@localhost.localdomain>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com>  <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain>  <1233259410.2315.75.camel@lts-notebook>  <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain> 
 <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain>  <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com>  <alpine.LFD.2.00.0901291806340.3054@localhost.localdomain>  <20090130055639.GA30950@suse.de>  <alpine.LFD.2.00.0901300811260.3150@localhost.localdomain>
  <Pine.LNX.4.64.0901301724010.1563@blonde.anvils>  <alpine.LFD.2.00.0901300946360.3150@localhost.localdomain> <1233345190.908.36.camel@lts-notebook>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 Jan 2009, Lee Schermerhorn wrote:
>
> Ad hoc instrumentation shows that it's the VM_ACCOUNT flag that is
> different between the existing file segment and the one attempting the
> merge:

Gaah. I looked at VM_ACCOUNT, since it looked like a prime example of the 
same VM_CAN_NONLINEAR thing and was thinking that I should just add it to 
the "ok to merge" flags, but decided after a quick look that we do all the 
VM_ACCOUNT handling before we call vma_merge, so I just left it at that. 

But apparently we _do_ do some VM_ACCOUNT stuff afterwards.

> is_mergeable_vma: !mergable: vma flags:  0x80020f9:0x1020f9
>                                            |         |-VM_ACCOUNT
>                                            +-----------VM_CAN_NONLINEAR
> 
> So happens, I'm mapping with MAP_SHARED, so the VM_ACCOUNT flag gets
> cleared later in mmap_region().  Comments say that this is for checking
> memory availability during shmem_file_setup().  Maybe we can move the
> temporary setting of VM_ACCOUNT until just before the call to
> shmem_zero_setup()?

Yeah, that would probably fix it, and looks like the right thing to do. 

It all looks pretty confused wrong to set the whole VM_ACCOUNT flag for a 
file-backed file AT ALL in the first place, but the code knows that it 
won't matter for a shared file, and will be cleared again later.

So it plays these temporary games with vm_flags, and it didn't matter 
because of how we used to call "vma_merge()" either early only for the 
anonymous memory case (that had VM_ACCOUNT stable and didn't have that 
temporary case at all) or much later (after having undone the temporary 
flag setting) for files.

Why do we pass in that "accountable" flag, btw? It's only ever set to 0 by 
a MAP_PRIVATE mapping that hits is_file_hugepages() (see do_mmap_pgoff), 
and we could just do that decision all inside mmap_region(). So the flag 
doesn't really seem to have any real meaning, and is just passed around 
for some odd historical reason?

			Linus
