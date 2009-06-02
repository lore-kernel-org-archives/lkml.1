Return-Path: <linux-kernel-owner+w=401wt.eu-S1752507AbZFBTH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbZFBTH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 15:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZFBTHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 15:07:16 -0400
Received: from www.tglx.de ([62.245.132.106]:37340 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbZFBTHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 15:07:14 -0400
Date: Tue, 2 Jun 2009 20:59:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: George Dunlap <george.dunlap@eu.citrix.com>
cc: David Miller <davem@davemloft.net>, "jeremy@goop.org" <jeremy@goop.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       "avi@redhat.com" <avi@redhat.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "xen-users@lists.xensource.com" <xen-users@lists.xensource.com>,
       ksrinivasan <ksrinivasan@novell.com>,
       "EAnderson@novell.com" <EAnderson@novell.com>,
       "wimcoekaerts@wimmekes.net" <wimcoekaerts@wimmekes.net>,
       Stephen Spector <stephen.spector@citrix.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Subject: Re: Xen is a feature
In-Reply-To: <4A25564A.70608@eu.citrix.com>
Message-ID: <alpine.LFD.2.00.0906021922580.3419@localhost.localdomain>
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <alpine.LFD.2.00.0905311607560.3379@localhost.localdomain>
 <4A25564A.70608@eu.citrix.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jun 2009, George Dunlap wrote:

> Thomas Gleixner wrote:
> > Exactly that's the point. Adding dom0 makes life easier for a group of
> > users who decided to use Xen some time ago, but what Ingo wants is
> > technical improvement of the kernel.
> > 
> > There are many features which have been wildly used in the distro
> > world where developers tried to push support into the kernel with the
> > same line of arguments.
> > 
> > The kernel policy always was and still is to accept only those
> > features which have a technical benefit to the code base.
> >   
> I can appreciate the idea of resisting the pushing of random features.  Still,
> your definition of "improving Linux" is still lacking.  Obviously a new
> scheduler is taking something that's existing and improving it.  But adding a
> new filesystem, a new driver, or adding a new feature, such as notifications,
> AIO, a new hardware architecture, or even KVM: How do those classify as
> "technical improvement to the kernel" or "features which have technical
> benefit to the code base" in a way that Xen does not?

There is a huge difference between new filesystems, drivers,
architectures and Xen.

A new filesystem is not intrusive to the filesystem layers, it's not
adding its special cases all over the place. There is no single "if
(fs_whatever)" hackery in the code base. Neither does a driver nor a
new architecture.

If the new functionality needs some extension to the generic code base
then this is carefully added with the maintainers of that code and the
extension is usually useful to other (filesystems, drivers,
architectures) as well. If it's necessary to add some special case for
one architecture then this is done by proper abstraction to keep the
burden and the maintainence cost down.

There is no #ifdef ARCH_ARM in mm/ fs/ kernel/ block/ .....

Talking about KVM, there is not a single "if (kvm)" line in the
arch/x86 code base. There is _ONE_ lonely #ifdef CONFIG_KVM_CLOCK
(which could be eliminated) in the whole x86 codebase, but at least 10
CONFIG_XEN* ones all over the place. The KVM developers went great
length to avoid adding restrictions to the existing code base.

I'm not saying that the Xen folks did not listen to us, they improved
lots of their code base and Jeremy was particularly helpful to unify
the 32/64bit code.

But right now I see a big code dump with subtle details where some of
them are just not acceptable to me.

> If you mean "increases Linux's technical capability", and define Xen as
> outside of Linux, then I think the definition is too small.  After all,
> allowing Linux to run on an ARM processor isn't increasing Linux' technical
> capability, it's just allowing a new group of people (people with ARM chips)
> to use Linux.  It's the same with Xen.

No, it's not. ARM does not interfere with anything and it keeps its
architecture specific limitations confined in arch/arm.

Xen injects its design limitation workarounds into the arch/x86
codebase and burdens developers and maintainers with it.

> No one disputes the idea that changes shouldn't be ugly; no one disputes the
> idea that changes shouldn't introduce performance regressions.  But there are
> patchqueues that are ready, signed-off by other maintainers, and which Ingo
> admits that he has no technical objections to, but refuses to merge. 
> (His most recent "objection" is that he claims the currently existing pv_ops
> infrastructure (which KVM and others benefit from as well as Xen) introduces
> almost a 1% overhead on native in an mm-heavy microbenchmark.  So he refuses
> to merge feature Y (dom0 support) until the Xen community helps technically
> unrelated existing feature X (pv_ops) meets some criteria.  So it has nothing
> to do with the quality of the patches themselves.)

Oh well. It has a lot to do with the quality of the patches. The
design is part of the quality and right now the short comings of the
design are papered over by adding Xen restrictions into the x86 code
base.

> [Not qualified to speak to the specific technical objections.]
> > I really have a hard time to see why dom0 support makes Linux more
> > useful to people who do not use it. It does not improve the Linux
> > experience of Joe User at all.
> >   
> If Joe User uses Amazon, he benefits.  If Joe User downloads an Ubuntu or
> Debian distro, and the hosting providers were more secure and had to do less
> work because dom0 was inlined, then he benefits because of the lower cost /
> resources freed to do other things.

Right, then they can concentrate on adding another bunch out of tree
patches to their kernels. Next time you stand up and tell me the same
argument for apparmour, ndiswrapper or whatever people like to use.

> But what I was actually talking about is the number of people who don't use it
> now but would use it if it were merged in.  There hundreds of thousands of
> instances running now, and more people are chosing to use it at the moment,
> even though those who use it have the devil's choice between doing patching or
> using a 3-year old kernel.  How many more would use it if it were in mainline?

How many more would use ndiswrapper if it were in mainline ?

> > In fact it could be harmful to the average user, if it's merged in a
> > crappy way that increases overhead, has a performance cost and draws
> > away development and maintenance resources from other areas of the
> > kernel.
> >   
> No one is asking for something to be merged in a crappy way, or with
> unacceptable performance cost.  There are a number of patchqueues that Ingo
> has no technical objections to, but which he still refuses to merge.

Right, because the lineup of patches is not completely untangled and
we still have objections against the overall outcome and design of the
Dom0 integration into the kernel proper.

It's not our fault that the Dom0 design decisions were made in total
disconnect to the kernel community and now a "swallow them as is"
policy is imposed on us with the argument that the newer kernels need
to run on ancient hypervisors as well.

You whine about users having to use 3 year old kernels, but 3 years
old hypervisors are fine, right ?

I'm not against merging dom0 in general, I'm opposing that we need to
buy inferior technical solutions which we can not change for a long
time. Once we merged them the "you can not break existent hypervisors"
argument will be used to prevent any design change and cleanup.

> The main point of Jeremy's e-mail was NOT to say, "Lots of people use this so
> you should merge it."  He's was responding to Xen being treated like it had no
> benefit.  It does have a benefit; it is a feature.

Right, a feature which comes with cost. The cost is the de facto
injection of an dom0 ABI into the arch/x86 code base. A new driver is
a feature as well, but it just adds the feature w/o impact to the
general system.

Thanks,

	tglx
