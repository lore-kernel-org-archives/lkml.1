Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbYKSK57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbYKSK57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 05:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbYKSK5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 05:57:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40348 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbYKSK5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 05:57:49 -0500
Date: Wed, 19 Nov 2008 11:57:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/7] Porting dynmaic ftrace to PowerPC
Message-ID: <20081119105719.GA21533@elte.hu>
References: <20081116212428.938752312@goodmis.org> <18720.42209.880409.297291@cargo.ozlabs.ibm.com> <alpine.DEB.1.10.0811171035530.2919@gandalf.stny.rr.com> <alpine.DEB.1.10.0811180853390.15003@gandalf.stny.rr.com> <18723.31762.522696.647294@cargo.ozlabs.ibm.com> <alpine.DEB.1.10.0811182150530.14914@gandalf.stny.rr.com> <20081119092723.GC22309@elte.hu> <18723.60578.179210.736789@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18723.60578.179210.736789@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > On Wed, 19 Nov 2008, Paul Mackerras wrote:
> > > 
> > > > Steven Rostedt writes:
> > > > 
> > > > > Can I add your Acked-by: to all these patches that I submitted? I'm going 
> > > > > to recommit them with a consistent subject (all lower case ppc), but I'm 
> > > > > not going to change the patches themselves.
> > > > > 
> > > > > Would you two be fine with that? Or at least one of you?
> > > > 
> > > > My preference would be for the patches to go through the powerpc tree
> > > > unless there is a good reason for them to go via another tree.
> > > 
> > > I have no problem with that. The only thing is that we have a lot of 
> > > pending work still in the linux-tip tree, which you may need to pull 
> > > in to get these patches working. Well, there's two or three commits 
> > > in the generic code that I know the PPC code is dependent on.
> > > 
> > > I could give you a list of commits in tip that need to go mainline 
> > > first before we can pull in the PPC changes. Then you could wait 
> > > till those changes make it into 29 and then you could push the PPC 
> > > modifications in from your tree.
> > 
> > note that this inserts a lot of (unnecessary) serialization and a 
> > window of non-testing - by all likelyhood this will delay ppc ftrace 
> > to v2.6.30 or later kernels.
> 
> Well, note that I said "unless there is a good reason".  If it does 
> need to go via your tree, it can, though I don't see that it will 
> get much testing on powerpc there, and having it there will make it 
> harder to manage any conflicts with the other stuff I have queued 
> up.

this is the diffstat:

 arch/powerpc/Kconfig              |    2 +
 arch/powerpc/include/asm/ftrace.h |   14 +-
 arch/powerpc/include/asm/module.h |   16 ++-
 arch/powerpc/kernel/ftrace.c      |  460 +++++++++++++++++++++++++++++++++---
 arch/powerpc/kernel/idle.c        |    5 +
 arch/powerpc/kernel/module_32.c   |   10 +
 arch/powerpc/kernel/module_64.c   |   13 +
 scripts/recordmcount.pl           |   18 ++-
 8 files changed, 495 insertions(+), 43 deletions(-)

90% of it creates new code that shouldnt be collision-happy.

it does not "need" to go via tip/tracing, i just pointed out the 
effects of the proposed workflow and i'm just trying to find a more 
efficient workflow for it - while not impacting yours either. I think 
it can be done - git gives us tons of tools to do this intelligently.

> How much generic stuff that's not upstream do the powerpc ftrace 
> patches depend on?

a lot:

   66 files changed, 3266 insertions(+), 985 deletions(-)

and it's all in flux (we are in the middle of the development cycle), 
so i dont think it would be a good idea for you to pull those bits 
into the powerpc tree.

Maybe Steve could do the following trick: create a Linus -git based 
branch that uses the new APIs but marks ppc's ftrace as "depends 0" in 
the powerpc Kconfig. (the new ftrace.c wont build)

You could pull that tree into the powerpc tree and everything should 
still work fine in PPC - sans ftrace.

In tip/tracing we'd merge it too (these commits will never be 
rebased), and we'd also remove the depends 0 from the powerpc Kconfig. 
That sole change wont conflict with anything powerpc.

It would all play out just fine in linux-next: we'd have both the 
latest powerpc bits and the latest ftrace bits on powerpc. You could 
test the non-ftrace impact of Steve's changes in the powerpc tree as 
well and have it all part of your usual workflow.

The 2.6.29 merge window would be trouble-free as well: since the 
sha1's are the same, any of the trees can be merged upstream without 
having to wait for the other one and without creating conflicts or 
other trouble for the other one.

Hm?

	Ingo
