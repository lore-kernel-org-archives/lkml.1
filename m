Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbYGVPO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbYGVPO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 11:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbYGVPOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 11:14:48 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52706 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbYGVPOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 11:14:47 -0400
Subject: Re: [RFC] fix kallsyms to allow discrimination of local symbols
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
In-Reply-To: <20080722115101.GB9508@redhat.com>
References: <1216676595.3433.80.camel@localhost.localdomain>
	 <y0mprp68zg9.fsf@ton.toronto.redhat.com>
	 <1216698788.3433.116.camel@localhost.localdomain>
	 <20080722115101.GB9508@redhat.com>
Content-Type: text/plain
Date: Tue, 22 Jul 2008 10:14:43 -0500
Message-Id: <1216739683.3364.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-22 at 07:51 -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> On Mon, Jul 21, 2008 at 10:53:08PM -0500, James Bottomley wrote:
> > [...]
> > > - You disprefer systemtap's use of an established, non-deprecated API
> > >   for placing kernel probes.  [...]
> >
> > You mean embedding half a megabyte of symbols simply so you can avoid
> > the inconvenience of using a kernel API? yes, I think it's ...
> > suboptimal.
> 
> It has been explained already that the symbol table you saw in
> stap-symbols.h has nothing to do with the kprobe addressing issue.
> 
> http://www.gossamer-threads.com/lists/linux/kernel/947365#957365

You're confusing issues.  I said embedding half a megabyte of symbol
table that the kernel already has is a bad idea full stop.  The ultimate
think I'm looking to do is to evolve kernel APIs that makes this
practice unnecessary.

> > > - You argue that symbols+offset kprobing is better.  We can see that,
> > >   in some sense, but ...
> > > 
> > > - I explain that we are used to final address calculating, as we'll
> > >   have to do that regardless for user-space probes.  Plus we need to
> > >   work with kernels that predate the symbol+offset kprobe api
> > >   extension.  So this change would not simplify systemtap in any way.
> > >   You do not respond.
> > 
> > There is no current userspace infrastructure, since utrace still isn't
> > in the kernel, so you're predicating this argument on an event which
> > hasn't happened.
> 
> We exercise professional foresight.  And the backward compatibility
> issue remains even without that.

No ... you're trying to constrain the open source process to a
pre-conceived design which is unrealised by in-kernel code.  This is
directly producing an impasse.

Backwards compatibility is the province of distros.  The job of upstream
is to produce the best tool and environment we can.  After this, the
backwards portability of desirable pieces can be discussed.

> > Even assuming utrace is accepted, embedding the symbol table of
> > every user space process in the probes is still daft.  [....]
> 
> It would take space, no question, though we're not talking about
> "every" process, just designated ones.
> 
> > For instance, the obvious way to me of doing this would be to map
> > the user space stack into the systemtap runtime and unwind it from
> > there instead of vectoring it into the kernel.
> 
> Please elaborate.  What does mapping a stack into the runtime mean?

It means that the systemtap runtime and the process would share a
mapping for the process stacks Obviously the process would have to be
quiesced to poke about in it, but it obviates the need to vector
megabytes of stack information through the kernel.

> Do you mean to suggest having the userspace program unwind itself?

It's possible ... but more likely that the stap runtime would do the
unwinding.  Which is more efficient won't really be known until someone
actually tries coding it.

>   Or relying on the userspace programs' possibly-paged-out unwind data?
> That would be intrusive.

I think you'll find doing it in user space is an advantage for paged out
data.  It's much more complex to get to it in the kernel because you
have to be careful of context while you're asking for it to be paged
back in.

> > > - I offer _stext+offset (for the kernel) and (.text*)+offset (for
> > >   modules) kprobes: basically to use the "better" symbol+offset
> > >   kprobes api, but use the same single reference addresses we already
> > >   do, and leaving just the final addition to the kernel.  You do not
> > >   respond materially.
> > 
> > I thought this and subsequent emails addressed the points pretty well:
> > 
> > http://marc.info/?l=linux-kernel&m=121632572409118
> 
> No, they didn't.  Every time I explained about how it does work, you
> just claimed "not", without even a single worked-out substantiating
> example.

Really?  The mutability of _stext vs _text; the problem probing init
sections I think they're real issues.

> > [...]
> > >   - storage of all that new file name data in permanent unswappable
> > >     kernel data (>>100kB, if done simply prefixing local symbol names
> > >     file file names).
> > 
> > I'd check my facts before making assertions.  The kernel symbol table is
> > stored in a compressed form that actually eliminates most of these
> > repetitions.
> 
> A careful reader will notice the "if" in my sentence.  Anyway, that
> or a superior compression scheme could apply to systemtap's various
> tables too.
> 
> 
> > >   - possible further complications related to filename string matching
> > 
> > Any substantiation of that?
> 
> We have had reported problems with differences between kernels
> hand-built with long absolute source path names versus the smallest
> "kernel/foo.c" names.  If such canonicalization takes place but
> inconsistently by the different tools, we will have a problem.

What it currently does is add tree relative names, so, for example this
is a cut and paste from System.map:

c0100000 T _text
c0100000 T startup_32
c0100054 t arch/x86/kernel/head_32.S|default_entry
c01000a8 T startup_32_smp
c010012a t arch/x86/kernel/head_32.S|checkCPUtype
c01001ab t arch/x86/kernel/head_32.S|is486
c01001b2 t arch/x86/kernel/head_32.S|is386
c0100220 T initial_code
c0100224 t arch/x86/kernel/head_32.S|check_x87

There's no ambiguity about how the path is constructed.

> > [...]
> > > In total, this path would end up with both systemtap and the kernel
> > > more complex, larger and a bit slower too.
> > 
> > Really?  I count the reduction of the probe modules from 500kb to 50kb a
> > worthwhile saving.  
> 
> The red clupea harengus again.

only if alio populo leges tantum adhiberent 

> > I don't even see where anything became larger.
> 
> Even with ksymtab compression, there is still new data to be stored in
> the kernel, and it is extra for each systemtap probe datum.

I think the requirement that your huge data problem be solved at
absolutely no cost is possibly a bit ambitious.  However, it can be done
at little cost to the kernel.

> > > Does that still seem an acceptable cost, just to get systemtap to
> > > change its preferred kprobes api?
> 
> > [no answer]
> 
> Indeed.

Perhaps because that's the wrong question.  It's not about trying to
change a "preferred" API (and the concept of preferred means according
to your preset design).  It's about trying to get systemtap actually to
engage with the kernel and iterate to an actual solution.

James


