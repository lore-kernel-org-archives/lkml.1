Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbYAIDas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbYAIDas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 22:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbYAIDaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 22:30:39 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48847 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092AbYAIDai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 22:30:38 -0500
Date: Tue, 8 Jan 2008 19:29:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, hch@lst.de, ak@suse.de, pq@iki.fi,
       jbeulich@novell.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert
 "x86: optimize page faults like all other achitectures and kill notifier cruft"
Message-Id: <20080108192951.a4dc394f.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.0.82.0801090308230.9570@skynet.skynet.ie>
References: <alpine.DEB.0.82.0801090226240.9570@skynet.skynet.ie>
	<20080108190611.3b9c0760.akpm@linux-foundation.org>
	<alpine.DEB.0.82.0801090308230.9570@skynet.skynet.ie>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008 03:17:37 +0000 (GMT) Dave Airlie <airlied@linux.ie> wrote:

> 
> > On Wed, 9 Jan 2008 02:34:46 +0000 (GMT) Dave Airlie <airlied@linux.ie> wrote:
> > 
> > > 
> > > [This an initial RFC but I'd like to have this patch in before 2.6.24 goes 
> > > final as it really breaks this useful feature]
> > > 
> > > mmiotrace the MMIO access tracer used to reverse engineer binary blobs
> > > used this notifier interface and is planned on being pushed upstream.
> > > 
> > > Having users able to just use the tracer module without having to rebuild 
> > > their kernel to add in a page fault handler hack means we get a lot 
> > > greater coverage for reverse engineering efforts.
> > 
> > Sorry, but that's a really really small benefit.  This very small number of
> > fairly (or very) technical users will be able to work out a way of getting
> > this to work in 2.6.24.  And in 2.6.25 with a merged mmiotrace we can do
> > something different.
> 
> mmiotrace isn't targetted at fairly or technical users, its whole 
> usefulness is that you don't need a kernel re-build, the distro kernels 
> all contain enough support for us to just get a user to grab mmiotrace, 
> run make and get a trace.... so in my eyes this a major feature regression 
> to have to go back to custom kernel builds...

An alternative might be to come up with something decent and target 2.6.24.x

> > It's a modest convenience to a very small number of people.  And the cost? 
> > Multiple functions calls and multiple cachelines hit for every pagefault
> > on, what?  Tens of millions of machines?
> 
> Which has been happening for how many months? perhaps if we merge 
> mmiotrace in 2.6.25 we can clean up this function, otherwise I just count 
> it as a feature regression...

We put the crappy code back in for 2.6.24 then take it out immediately
after 2.6.24 and put something else in to support mmiotrace and perhaps the
other new mystery features to which you refer below.  hm.

> > pagefault it populates a struct on the stack, passes that around for a
> > while, does a bit of RCU stuff only to find that there was nothing to do. 
> > Surely we should at least be doing something along the lines of
> > 
> > 	if (unlikely(notify_page_fault_chain.notifier_call != NULL)) {
> > 		all that crap
> > 	}
> > 
> > 
> > But that's all speculation.  Has anyone actually measured the pagefault
> > latency impact of this change?

^^ this.

> > > +/*
> > > + * These are only here because kprobes.c wants them to implement a
> > > + * blatant layering violation.  Will hopefully go away soon once all
> > > + * architectures are updated.
> > > + */
> > > +static inline int register_page_fault_notifier(struct notifier_block *nb)
> > > +{
> > > +	return 0;
> > > +}
> > > +static inline int unregister_page_fault_notifier(struct notifier_block *nb)
> > > +{
> > > +	return 0;
> > > +}
> > > +
> > 
> > And this doesn't look very good either.  For how long did this fixme remain
> > unfixed?
> > 
> > 
> > So I'd suggest that we leave things as they are for 2.6.24 - mmiotrace
> > people will work something out, I'm sure.  For 2.6.25 if we merge mmiotrace
> > we can look at doing something which is vaguely efficient and tasteful.
> > 
> 
> I just reverted Christophs patch I didn't try and work out if the old code 
> had problems no one has fixed...
> 
> So all distros with 2.6.24 kernels are useless to mmiotrace I don't see 
> why leaving things as is until a suitable replacement mechanism can be 
> used.. I've heard others give out about this also madwifi and SuSE kernel 
> folks...

That change has been in the mainline tree for nearly three months.  All
these affected parties have left it until the eve of 2.6.24 to actually
tell us about it.  This is causing me sympathy problems :(
