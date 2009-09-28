Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbZI1Vk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbZI1Vk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 17:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbZI1Vk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 17:40:58 -0400
Received: from 139-142-54-143.atc.vaillant.ca ([139.142.54.143]:37142 "EHLO
	quartz.edm.orcorp.ca" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752578AbZI1Vk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 17:40:57 -0400
Date: Mon, 28 Sep 2009 15:40:57 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Roland Dreier <rdreier@cisco.com>, linux-rdma@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Message-ID: <20090928214057.GX19540@obsidianresearch.com>
References: <aday6omhz9d.fsf@cisco.com> <20090915113434.GF1328@ucw.cz> <ada7hw0gsqz.fsf@cisco.com> <20090928204923.GA1960@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090928204923.GA1960@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 10:49:23PM +0200, Pavel Machek wrote:

> >  > I don't remember seeing discussion of this on lkml. Yes it  is in
> >  > -next...
> > 
> > eg http://lkml.org/lkml/2009/7/31/197 and followups, or search for v2
> > and earlier patches.
 
> Well... it seems little overspecialized. Just modifying libc to
> provide hooks you want looks like better solution.

That is what MPI people are doing today and their feedback is that it
doesn't work - there are a lot of ways to mess with memory and no good
choices to hook the raw syscalls and keep sensible performance.

The main focus of this is high performance MPI apps, so lower overhead
on critical paths like memory allocation is part of the point. It is
ment to go hand-in-hand with the specialized RDMA memory pinning
interfaces..

> >  > Basically it allows app to 'trace itself'? ...with interesting mmap()
> >  > interface, exporting int to userspace, hoping it behaves atomically...? 
> > 
> > Yes, it allows app to trace what the kernel does to memory mappings.  I
> > don't believe there's any real issue to atomicity of mmap'ed memory,
> > since userspace really just tests whether read value is == to old read
> > value or not.
> 
> That still needs memory barriers etc.. to ensure reliable operation,
> no?

No, I don't think so..

The application is expected to provide sequencing of some sort between
the memory call (mmap/munmap/brk/etc) and the int check - usually just
by running in the same thread, or through some kind of locking scheme.

As long as the mmu notifiers run immediately in the same context as
the mmap/etc then it should be fine.

For example, the most common problem to solve looks like this:

   x = mmap(...)
   do RDMA with x
   [..]
   mmunmap(x);

   [..]
   y = mmap(..);
   do RDMA with y
     if by chance x == y things explode.

So this API puts the int test directly before 'do RDMA with'.

Due to the above kind of argument the net requirement is either to
completely synchronously (and with low overhead) hook every
mmap/munmap/brk/etc call into the kernel and do the accounting work,
or have a very low over head check every time the memory region is
about to be used.

Jason
