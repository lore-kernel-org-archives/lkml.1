Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbYJZQaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbYJZQaZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 12:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYJZQaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 12:30:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751327AbYJZQaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 12:30:11 -0400
Date: Sun, 26 Oct 2008 09:29:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       walt <w41ter@gmail.com>
Subject: Re: [PULL] module, param and stop_machine patches
In-Reply-To: <200810261916.17311.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.0810260918250.5200@nehalem.linux-foundation.org>
References: <200810221005.59874.rusty@rustcorp.com.au> <200810260924.09479.rusty@rustcorp.com.au> <alpine.LFD.2.00.0810251529240.3327@nehalem.linux-foundation.org> <200810261916.17311.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 26 Oct 2008, Rusty Russell wrote:
> On Sunday 26 October 2008 09:33:43 Linus Torvalds wrote:
> >
> > I'm not seeing any "tracked it down".
> 
> He tracked it down to moving init_workqueues() too early, so he moved that
> back.

Yeah. I had done as well by my bisection. One of the reasons I didn't push 
out my initial fix (just the plain revert) was exactly the fact that I 
don't think that is sufficient. I want to _understand_ what was going on, 
and get a feel from the commit message that makes me go "yeah, ok, makes 
sense".

> Turns out it's the cpu_online_map difference.  If init_workqueues() is called
> too early, only the boot cpu is set.  We then only create_workqueue_thread()
> for the boot cpu.

Indeed. I figured it out yesterday, since I didn't get an explanation soon 
enough for my impatient self. So I ended up committing the fix as the 
minimal patch I sent out earlier, with a fairly minimal explanation. I'll 
happily take more fixes, but I think it should be ok.

If S390 wants to do stop_machine() even before some of the basic 
core_initcalls, I suspect it will have to change, but nothing I saw 
indicated that it really needs to.

> If CONFIG_HOTPLUG_CPU=y, it's fine since the hotplug callback will create the
> workqueue threads for the other cpus as they come up.  Without it, the kevent
> workqueues on non-boot cpus don't get processed.

.. and my default workstation config indeed hit this, since I normally 
have a fairly minimal setup.

> > Nor do I see a sign-off from Heiko on it.
> 
> I thought mine would be sufficient since we both work for IBM?

Technically, yes, since you all sign your life away and do this for work, 
but he normally signs off his patches, so the lack of sign-off didn't make 
me go "hmm, this looks odd from a legal copyright standpoint", but rather 
"hmm, maybe Heiko doesn't feel comfy with the patch since he didn't sign 
off".

To me, the legal side of the sign-off is actually secondary. The whole 
thing was designed to be useful even in the absense of it. I've grown very 
fond of seeing who has seen the patch (including who _should_ have seen it 
but didn't react - the "cc" part ;)

			Linus

