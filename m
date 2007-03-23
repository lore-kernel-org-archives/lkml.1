Return-Path: <linux-kernel-owner+w=401wt.eu-S1422901AbXCWNt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422901AbXCWNt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 09:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422903AbXCWNt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 09:49:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422901AbXCWNt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 09:49:57 -0400
In-Reply-To: <20070323111350.GD3980@xi.wantstofly.org> 
References: <20070323111350.GD3980@xi.wantstofly.org>  <e9c3a7c20703021312y5f7aa228i5d1c84a8e9ea5676@mail.gmail.com> <20070303111427.GB16944@xi.wantstofly.org> <20070303113305.GB10515@flint.arm.linux.org.uk> <20070321221134.GA22497@xi.wantstofly.org> <tnxlkhpgslz.fsf@arm.com> 
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, paulmck@us.ibm.com
Subject: I/O memory barriers vs SMP memory barriers
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Fri, 23 Mar 2007 13:43:53 +0000
Message-ID: <16051.1174657433@redhat.com>
From: David Howells <dhowells@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[Resend - this time with a comma in the addresses, not a dot]

Lennert Buytenhek <buytenh@wantstofly.org> wrote:

> [ background: On ARM, SMP synchronisation does need barriers but device
>   synchronisation does not.  The question is that given this, whether
>   mb() and friends can be NOPs on ARM or not (i.e. whether mb() is
>   supposed to sync against other CPUs or not, or whether only smp_mb()
>   can be used for this.)  ]

Hmmmm...

I see your problem.  I think the right way to deal with this is to get rid of
mb(), rmb(), wmb() and read_barrier_depends() and replace them with io_mb(),
io_rmb(), ...

I think that there are only two places you should be using explicit memory
barriers:

 (1) To control inter-CPU effects on an SMP system.

 (2) To control CPU vs device effects.

> On Thu, Mar 22, 2007 at 04:17:44PM +0000, Catalin Marinas wrote:
> 
> > Is the requirement for mb() to act correctly in the SMP case as well?
> 
> That's what the docs seem to suggest.  A couple of snippets from
> memory-barriers.txt:
> 
> [1]  A write memory barrier gives a guarantee that all the STORE operations
>      specified before the barrier will appear to happen before all the STORE
>      operations specified after the barrier with respect to the other
>      components of the system.
> 
> [2]  A read barrier is a data dependency barrier plus a guarantee that all the
>      LOAD operations specified before the barrier will appear to happen before
>      all the LOAD operations specified after the barrier with respect to the
>      other components of the system.
> 
> [3]     TYPE            MANDATORY               SMP CONDITIONAL
>         =============== ======================= ===========================
>         GENERAL         mb()                    smp_mb()
>         WRITE           wmb()                   smp_wmb()
>         READ            rmb()                   smp_rmb()
>         DATA DEPENDENCY read_barrier_depends()  smp_read_barrier_depends()
> 
> [4]  Mandatory barriers should not be used to control SMP effects,
>      since mandatory barriers unnecessarily impose overhead on UP
>      systems.
> 
> Note the wording of 'other components of the system' in [1] and [2] --
> the way I read it, this includes devices as well as other CPUs.

Yes, but I suppose which "other components" may depend on the class of barrier
used.

> [4] says that mandatory barriers (i.e. from [3]: mb(), wmb(), rmb(),
> read_barrier_depends()) SHOULD not be used to control SMP effects, but
> it does not say that they MUST not.

As it stands, mb() is a superset of smp_mb(), and rmb() of smp_rmb(), etc.,
so, yes, currently, mb() implies smp_mb().  However, mb() shouldn't be used if
smb_mb() is sufficient as that may impact performance on a UP system.

Really, mb() should only be used with respect to I/O.

> > The memory-barriers.txt doc says that smp_* must be used for the SMP
> > case.
> 
> The exact wording is:
> 
> 	[!] Note that SMP memory barriers _must_ be used to control the
> 	ordering of references to shared memory on SMP systems, though
> 	the use of locking instead is sufficient.
> 
> This can IMHO be interpreted in two ways:
> 1. If you want to control ordering of references to shared memory on
>    SMP systems, you must use SMP memory barriers and not any other kind
>    of memory barrier.

If the shared memory is purely an inter-CPU effect, yes.  If the shared memory
is actually a device with side effects, then I/O safe memory barriers are
required - mb() and co.  Note that there must _also_ be safety wrt to other
CPUs in the system, as other CPUs may also try to access the device.

> 2. If you want to control ordering of references to shared memory on
>    SMP systems, you must use memory barriers, and the SMP memory barrier
>    is the most appropriate barrier type to use.

You may use locking instead to control inter-CPU effects.  Locks imply one-way
permeable SMP-class memory barriers.

> I'm thinking that [2] is what was intended.  [1] doesn't seem consistent
> with the rest of the document, but if [1] _is_ what is what was intended,
> we're off the hook and mb() and friends can be NOPs on ARM.  (But it'd
> probably still need a thorough audit... :-/ )

I think the best way to do an audit would be to make mb() and co. deprecated,
pending obsolete, and to replace them with io_mb() and co.  That way people
would have to eyeball any usages of mb() and co.

> > This means that if code uses mb() to control SMP sharing, it is broken.
> 
> I'm not so sure.

If it's _purely_ to control inter-CPU SMP sharing, then yes, it's broken.  It
must use either a lock or an smp_*mb() barrier.

Of course, Linus may disagree...

David

