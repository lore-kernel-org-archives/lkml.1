Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbZA3Ueq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbZA3Ueq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 15:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbZA3Uei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 15:34:38 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:35091 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbZA3Uei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 15:34:38 -0500
Date: Fri, 30 Jan 2009 20:33:46 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
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
Message-ID: <Pine.LNX.4.64.0901302026530.13686@blonde.anvils>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com> 
 <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain> 
 <1233259410.2315.75.camel@lts-notebook>  <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain>
  <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain> 
 <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com> 
 <alpine.LFD.2.00.0901291806340.3054@localhost.localdomain> 
 <20090130055639.GA30950@suse.de>  <alpine.LFD.2.00.0901300811260.3150@localhost.localdomain>
  <Pine.LNX.4.64.0901301724010.1563@blonde.anvils> 
 <alpine.LFD.2.00.0901300946360.3150@localhost.localdomain>
 <1233345190.908.36.camel@lts-notebook>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009, Lee Schermerhorn wrote:
> 
> I tried this patch atop 29-rc3 + your patch from yesterday with my
> simple test program at http://free.linux/hp.com/~lts/Tests/mmap_lock.c. 
> 
> The test program shows the /proc/<pid>/maps before and after the mmap
> and attempted merge.  It's not merging:
> 
> 7fd20a668000-7fd20a66a000 rw-p 7fd20a668000 00:00 0 
> 7fd20a68a000-7fd20a68b000 r--s 00000000 68:23 6608852                    /tmp/tmpfVx1SFL (deleted)
> 7fd20a68b000-7fd20a68c000 r--s 00001000 68:23 6608852                    /tmp/tmpfVx1SFL (deleted)
> 7fd20a68c000-7fd20a690000 rw-p 7fd20a68c000 00:00 0 

Some testing - now that's a great idea!  Good spotting.

> 
> Ad hoc instrumentation shows that it's the VM_ACCOUNT flag that is
> different between the existing file segment and the one attempting the
> merge:
> 
> is_mergeable_vma: !mergable: vma flags:  0x80020f9:0x1020f9
>                                            |         |-VM_ACCOUNT
>                                            +-----------VM_CAN_NONLINEAR

Sorry, I should have noticed that: VM_ACCOUNT was certainly on my
mind as a flag that gives trouble when merging vmas, but I'd
misconvinced myself that it wasn't a problem in this case.

> 
> So happens, I'm mapping with MAP_SHARED, so the VM_ACCOUNT flag gets
> cleared later in mmap_region().  Comments say that this is for checking
> memory availability during shmem_file_setup().  Maybe we can move the
> temporary setting of VM_ACCOUNT until just before the call to
> shmem_zero_setup()?

Please let me think on that - we can live with the status quo for
the moment.  I need to remind myself why I used that peculiar way
of conveying info from mmap.c to shmem.c: the right answer may be
just to pass another arg to shmem_zero_setup and shmem_file_setup.

Hugh
