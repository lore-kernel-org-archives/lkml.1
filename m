Return-Path: <linux-kernel-owner+w=401wt.eu-S933498AbXCZDYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498AbXCZDYW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 23:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933504AbXCZDYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 23:24:22 -0400
Received: from pool-71-111-84-143.ptldor.dsl-w.verizon.net ([71.111.84.143]:52409
	"EHLO paulmck-laptop" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933498AbXCZDYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 23:24:21 -0400
Date: Sun, 25 Mar 2007 20:24:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: David Howells <dhowells@redhat.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: I/O memory barriers vs SMP memory barriers
Message-ID: <20070326032418.GA14557@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070323111350.GD3980@xi.wantstofly.org> <e9c3a7c20703021312y5f7aa228i5d1c84a8e9ea5676@mail.gmail.com> <20070303111427.GB16944@xi.wantstofly.org> <20070303113305.GB10515@flint.arm.linux.org.uk> <20070321221134.GA22497@xi.wantstofly.org> <tnxlkhpgslz.fsf@arm.com> <16051.1174657433@redhat.com> <20070325211542.GD3593@linux.vnet.ibm.com> <20070325213843.GE22126@xi.wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070325213843.GE22126@xi.wantstofly.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 11:38:43PM +0200, Lennert Buytenhek wrote:
> On Sun, Mar 25, 2007 at 02:15:42PM -0700, Paul E. McKenney wrote:
> 
> > > > [ background: On ARM, SMP synchronisation does need barriers but device
> > > >   synchronisation does not.  The question is that given this, whether
> > > >   mb() and friends can be NOPs on ARM or not (i.e. whether mb() is
> > > >   supposed to sync against other CPUs or not, or whether only smp_mb()
> > > >   can be used for this.)  ]
> > > 
> > > Hmmmm...
> > > 
> > > [snip]
> > 
> > 3.	Orders memory accesses and device accesses, but not necessarily
> > 	the union of the two -- mb(), rmb(), wmb().
> 
> If mb/rmb/wmb are required to order normal memory accesses, that means
> that the change made in commit 9623b3732d11b0a18d9af3419f680d27ea24b014
> to always define mb/rmb/wmb as barrier() on ARM systems was wrong.

This was on UP ARM systems, right?  Assuming that ARM CPUs respect the
usual CPU-self-consistency semantics, and given the background that
device accesses are ordered, then it might well be OK to have mb/rmb/wmb
be barrier() on UP ARM systems.

Most likely not on SMP ARM systems, however.

> Does everybody agree on these semantics, though?  At least David seems
> to think that mb/rmb/wmb aren't required to order normal memory accesses
> against each other..

Not on UP.  On SMP, ordering is (almost certainly) required.

> > 4.	Orders only device accesses, which is what seems to be looked
> > 	for here.
> 
> Yes.  (As above, on ARM, SMP synchronisation does need barriers but
> device synchronisation does not.  If mb/rmb/wmb were only required to
> synchronise device accesses, they could have been regular compiler
> barriers on ARM, but if they are also required to synchronise normal
> memory accesses against each other, they have to map to hardware
> barriers.)

Again, for kernels built for UP, you might well be able to make the
mb() primitives be barrier().  I don't see it for SMP, though.

						Thanx, Paul
