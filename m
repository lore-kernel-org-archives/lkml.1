Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbYLEHNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbYLEHNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 02:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbYLEHNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 02:13:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:55779 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbYLEHNX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 02:13:23 -0500
Subject: Re: Page alloc failures under network/disk IO load
From: Peter Zijlstra <peterz@infradead.org>
To: Dan =?ISO-8859-1?Q?No=E9?= <dpn@isomerica.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081204135443.7c24234a@rockhopper.limebrokerage.com>
References: <20081203222750.391e8890@tuna> <1228378983.5092.7.camel@twins>
	 <1228380128.5092.15.camel@twins>
	 <20081204135443.7c24234a@rockhopper.limebrokerage.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 05 Dec 2008 08:13:22 +0100
Message-Id: <1228461202.18899.11.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-04 at 13:54 -0500, Dan Noé wrote:
> On Thu, 04 Dec 2008 09:42:08 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Thu, 2008-12-04 at 09:23 +0100, Peter Zijlstra wrote:
> > > On Wed, 2008-12-03 at 22:27 -0500, Dan Noé wrote:
> > > > This is on Linux 2.6.28-rc7, on a Core 2 Duo.  The system has
> > > > plenty of memory:
> > > > 
> > > >              total       used       free     shared    buffers
> > > > cached
> > > > Mem:          1893       1822         70          0          0
> > > 
> > > filled to the brim with data
> > > 
> > > > 1573
> > > > -/+ buffers/cache:        249       1644
> > > > Swap:         1906         37       1868
> > > > 
> > > > I am using rsync to transfer data onto this system.  The
> > > > filesystem is XFS, and the target drive is a 1TB Western Digital
> > > > on ata_piix.  The system files are on a RAID 1 (Linux md, also on
> > > > ata_piix).
> > > > 
> > > > Periodically I get page allocation failures, from
> > > > __netdev_alloc_skb. I suppose this causes the driver to drop
> > > > packets and thus hurts performance.
> > > 
> > > There isn't much we can do about that, memory is filled and your
> > > network card tries to allocate memory in a mode that doesn't allow
> > > freeing some.
> > > 
> > > Looking at the timestamps its not very frequent, so it doesn't hurt
> > > performance much if anything. If you're really bothered with this,
> > > you could quiet it by sticking in a __GFP_NOWARN in
> > > __netdev_alloc_skb() or something..
> > 
> > Another thing you can do is increase /proc/sys/vm/min_free_kbytes
> 
> I'm a bit confused because on another system (2.6.26.3) I never see
> messages like this despite having the same amount of physical RAM in
> each.  The 2.6.26.3 system is also under more active use, and has more
> userspace memory usage.  On that system:
> 
>              total       used       free     shared    buffers
> cached Mem:          2017       1681        335          0
> 99        603 -/+ buffers/cache:        979       1037
> Swap:          972        137        835
> 
> dpn@colobus:~$ cat /proc/sys/vm/min_free_kbytes
> 3816
> 
> Yet on the system where I saw the allocation failures:
> 
> dpn@trout:~/kernels/linux-2.6$ cat /proc/sys/vm/min_free_kbytes
> 5711
> 
> If I understand it correctly the issue is that __netdev_alloc_skb must
> make a GFP_ATOMIC allocation, which fails because the page cache must
> evict pages before there is sufficient memory.  And
> min_free_kbytes allows tuning of the point where try_to_free_pages is
> called and thus the "reserve" memory available.  Is that correct?

yes

> Wouldn't a higher min_free_kbytes mean less likelihood of GFP_ATOMIC
> allocations failing?  Or are these allocations failing on my 2.6.26.3
> system and I don't know it because of different config options?
> 
> Why am I seeing this on the system with the *higher* min_free_kbytes?

Higher burst rate? For the reserve pool to dry out, you need a high rate
of incoming packets. If one machine has a steady workload and the other
a bursty one, that could be the full difference.

