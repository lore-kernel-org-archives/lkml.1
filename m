Return-Path: <linux-kernel-owner+w=401wt.eu-S1752021AbXCWP2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbXCWP2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 11:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945915AbXCWP2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 11:28:06 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:39852 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbXCWP2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 11:28:04 -0400
X-Greylist: delayed 1146 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Mar 2007 11:28:04 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=hQBhpKP32TP4KD5ZtIOfGVASBapJ+VY/HlE2EumUM9/VL8yFlb69SrX8fD6zQ
	zuHemKiy1SwxDVsCg4QnwbFYg==
Date: Fri, 23 Mar 2007 16:08:53 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: David Howells <dhowells@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, paulmck@us.ibm.com
Subject: Re: I/O memory barriers vs SMP memory barriers
Message-ID: <20070323150853.GJ3980@xi.wantstofly.org>
References: <20070323111350.GD3980@xi.wantstofly.org> <e9c3a7c20703021312y5f7aa228i5d1c84a8e9ea5676@mail.gmail.com> <20070303111427.GB16944@xi.wantstofly.org> <20070303113305.GB10515@flint.arm.linux.org.uk> <20070321221134.GA22497@xi.wantstofly.org> <tnxlkhpgslz.fsf@arm.com> <16051.1174657433@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16051.1174657433@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 01:43:53PM +0000, David Howells wrote:

> > [ background: On ARM, SMP synchronisation does need barriers but device
> >   synchronisation does not.  The question is that given this, whether
> >   mb() and friends can be NOPs on ARM or not (i.e. whether mb() is
> >   supposed to sync against other CPUs or not, or whether only smp_mb()
> >   can be used for this.)  ]
> 
> Hmmmm...
> 
> I see your problem.  I think the right way to deal with this is to get
> rid of mb(), rmb(), wmb() and read_barrier_depends() and replace them
> with io_mb(), io_rmb(), ...

There's actually three different cases of interest on ARM:
1. direct-mapped and vmalloc()ed kernel memory
2. coherent DMA memory
3. I/O memory (device mappings)

smp_*() only make sense on (1).  Here, you'd want a hardware barrier
on SMP systems, and just a compiler barrier on UP systems.

For (2), most ARM systems use uncached mappings of kernel memory, which
are strongly ordered, and you don't need hardware barriers.  However,
some ARM systems are cache coherent, and they can use ordinary mappings
for (2) (i.e. kmalloc), _but_, such ordinary mappings are weakly ordered,
and so on those systems, you _would_ need hardware barriers for (2).

For (3), Device memory (i.e. I/O mappings) are strongly ordered on all
ARM platforms.

(And of course, then there's the synchronisation issues _between_ the
different mapping types.)

Anyway, we could split the barrier types into three groups, or even
more groups (I bet that on, say, ia64, there's at least a couple more
different scenarios of interest), however, I'm really worried that the
Average Joe Driver Writer's head is just going to explode.


> > [4] says that mandatory barriers (i.e. from [3]: mb(), wmb(), rmb(),
> > read_barrier_depends()) SHOULD not be used to control SMP effects, but
> > it does not say that they MUST not.
> 
> As it stands, mb() is a superset of smp_mb(), and rmb() of smp_rmb(),
> etc.,

Not (anymore) on ARM:

	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9623b3732d11b0a18d9af3419f680d27ea24b014

The question is whether this change was correct.


> so, yes, currently, mb() implies smp_mb().  However, mb() shouldn't
> be used if smb_mb() is sufficient as that may impact performance on
> a UP system.

There's two different statements that can be made about mb():

1. You shouldn't use mb() to synchronise with other CPUs as that is
   unnecessarily slow.

2. You must not use mb() to synchronise with other CPUs as that is
   wrong.

Which is it, (1) or (2)?  The memory-barriers.txt document confuses
these two issues, and you confuse these two issues, but there is a
_fundamental_ _semantic_ _difference_ between these two statements.
Let's not confuse them.


> Really, mb() should only be used with respect to I/O.

OK.  Can we clarify the docs on this point, please?


> > > The memory-barriers.txt doc says that smp_* must be used for the SMP
> > > case.
> > 
> > The exact wording is:
> > 
> > 	[!] Note that SMP memory barriers _must_ be used to control the
> > 	ordering of references to shared memory on SMP systems, though
> > 	the use of locking instead is sufficient.
> > 
> > This can IMHO be interpreted in two ways:
> > 1. If you want to control ordering of references to shared memory on
> >    SMP systems, you must use SMP memory barriers and not any other kind
> >    of memory barrier.
> 
> If the shared memory is purely an inter-CPU effect, yes.  If the shared
> memory is actually a device with side effects, then I/O safe memory
> barriers are required - mb() and co.  Note that there must _also_ be
> safety wrt to other CPUs in the system, as other CPUs may also try to
> access the device.

I was not making any statement, I was just giving two possible
interpretations of the above-quoted snippet from memory-barriers.txt.

Yes, I'm aware of the issues you mention, and yes, all the other
necessary guarantees are provided on the ARM platform.


> > 2. If you want to control ordering of references to shared memory on
> >    SMP systems, you must use memory barriers, and the SMP memory barrier
> >    is the most appropriate barrier type to use.
> 
> You may use locking instead to control inter-CPU effects.  Locks imply
> one-way permeable SMP-class memory barriers.

Again, I was not trying to make a statement here, just giving a
possible interpretation of a statement in memory-barriers.txt.


> > I'm thinking that [2] is what was intended.  [1] doesn't seem
> > consistent with the rest of the document, but if [1] _is_ what
> > is what was intended, we're off the hook and mb() and friends
> > can be NOPs on ARM.  (But it'd probably still need a thorough
> > audit... :-/ )
> 
> I think the best way to do an audit would be to make mb() and co.
> deprecated, pending obsolete, and to replace them with io_mb() and
> co.  That way people would have to eyeball any usages of mb() and
> co.

Sounds OK to me.  Then again, I have an idea of what all the different
types of barriers do.. Joe Driver Writer might not.


> > > This means that if code uses mb() to control SMP sharing, it is
> > > broken.
> > 
> > I'm not so sure.
> 
> If it's _purely_ to control inter-CPU SMP sharing, then yes, it's
> broken.

Bah.  Until the docs are changed to be utterly and unambiguously
clear on this point, that's just rubbish.


cheers,
Lennert
