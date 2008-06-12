Return-Path: <linux-kernel-owner+w=401wt.eu-S1760157AbYFLUwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbYFLUwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 16:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbYFLUwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 16:52:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38459 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752952AbYFLUwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 16:52:33 -0400
Date: Thu, 12 Jun 2008 15:52:32 -0500
From: Jack Steiner <steiner@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 00/11] GRU Driver
Message-ID: <20080612205232.GB17826@sgi.com>
References: <20080609211028.110089743@attica.americas.sgi.com> <20080612132700.GA18107@elte.hu> <20080612140509.GA21437@sgi.com> <20080612110336.cde5fccb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080612110336.cde5fccb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 11:03:36AM -0700, Andrew Morton wrote:
> On Thu, 12 Jun 2008 09:05:09 -0500 Jack Steiner <steiner@sgi.com> wrote:
> 
> > On Thu, Jun 12, 2008 at 03:27:00PM +0200, Ingo Molnar wrote:
> > > 
> > > * steiner@sgi.com <steiner@sgi.com> wrote:
> > > 
> > > > This series of patches adds a driver for the SGI UV GRU. The driver is 
> > > > still in development but it currently compiles for both x86_64 & IA64. 
> > > > All simple regression tests pass on IA64. Although features remain to 
> > > > be added, I'd like to start the process of getting the driver into the 
> > > > kernel. Additional kernel drivers will depend on services provide by 
> > > > the GRU driver.
> > > > 
> > > > The GRU is a hardware resource located in the system chipset. The GRU 
> > > > contains memory that is mmaped into the user address space. This 
> > > > memory is used to communicate with the GRU to perform functions such 
> > > > as load/store, scatter/gather, bcopy, AMOs, etc.  The GRU is directly 
> > > > accessed by user instructions using user virtual addresses. GRU 
> > > > instructions (ex., bcopy) use user virtual addresses for operands.
> > > 
> > > did i get it right that it's basically a fast, hardware based message 
> > > passing interface that allows two tasks to communicate via DMA and 
> > > interrupts, without holding up the CPU? 
> > 
> > Yes
> > 
> > 
> > > If that is the case, wouldnt the 
> > > proper support model be a network driver, instead of these special 
> > > ioctls. (a network driver with no checksumming, with scatter-gather, 
> > > zero-copy and TSO support, etc.)
> > > 
> > > or a filesystem. Anything but special-purpose ioctls ...
> > 
> > The ioctls are not used directly by users.
> > 
> > Users function the GRU by directly writing to the memory that is mmaped into
> > GRU space, ie; load/store directly to GRU space. The ioctls are used
> > infrequently by libgru.so to configure the driver during user initialization
> > and to handle errors that may occur.
> > 
> > For example, here is the code that is required to issue a GRU
> > instruction & wait for completion:
> > 
> 
> But could/should it be implemented as (say) a net driver?

I don't think so.

The GRU driver is not primarily a point-to-point communication engine. The
most common use of the GRU is by a single process, or possibly an OpemMP/MPI
application.  There is typically no end-to-end communication or RDMA
involved.  All data transfer takes place between blocks of cacheable memory
that are resident in the process address space.  There is nothing in the GRU
or GRU libraries that does anything equivalent to connection establishment
between different processes.

Applications on large NUMA systems use the GRU to access data that is
located on memory within the process address space but located on remote
nodes. For example, the GRU can pull large blocks of data from a remote node
to the local node asynchronously. Other GRU instructions provide
scatter/gather, AMOs, etc. but always operating on memory within the
existing process address space.

The one place where there is process-to-process communication is between MPI
processes. However, separate from the GRU, the MPI processes have to memory
map a common block of memory into the address spaces of both processes.
Nothing in the GRU or GRU library is aware that interprocess communication
is taking place.


The GRU hardware is the next generation of what SN2 refers to the "mspec"
driver (see drivers/char/mspec.c). The GRU is much more complicated but it
provide a similar capability - mmaping of special memory into the user
address space.

>From a user standpoint, the user simply mmaps a chunk of GRU memory into the
user address space, then does loads & stores to the GRU memory to issue GRU
instructions to do data transfers. The user could also do the same data
transfers using processor load/store instructions but at a slower (we hope)
rate.


--- jack
