Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbZKSINF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbZKSINF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 03:13:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbZKSINE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 03:13:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185AbZKSIND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 03:13:03 -0500
Date: Thu, 19 Nov 2009 09:13:07 +0100
From: Nick Piggin <npiggin@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Beulich <JBeulich@novell.com>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
       Ravikiran Thirumalai <kiran@scalex86.org>,
       Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH] x86: eliminate redundant/contradicting cache line size config options
Message-ID: <20091119081307.GA20534@wotan.suse.de>
References: <4AFD5710020000780001F8F0@vpn.id2.novell.com> <20091116041407.GB5818@wotan.suse.de> <4B011677020000780001FD9D@vpn.id2.novell.com> <20091116105657.GE5818@wotan.suse.de> <20091119035640.GA18236@elte.hu> <20091118205240.11d3d660@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118205240.11d3d660@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 08:52:40PM -0800, Arjan van de Ven wrote:
> On Thu, 19 Nov 2009 04:56:40 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Nick Piggin <npiggin@suse.de> wrote:
> > 
> > > The only other use for L1 cache size macro is to pack objects to 
> > > cachelines better (so they always use the fewest number of lines).
> > > But this case is more rare nowadays people don't really count
> > > cachelines anymore, but I think even then it makes sense for it to
> > > be the largest line size in the system because we don't know how
> > > big L1s are, and if you want opimal L1 packing, you likely also
> > > want optimal Ln packing.
> > 
> > We could do that - but then this default of X86_INTERNODE_CACHE_SHIFT:
> > 
> > +       default "7" if NUMA
> > 
> > will bite us and turns the 64 bytes L1_CACHE_BYTES into an effective
> > 128 bytes value.
> > 
> > So ... are you arguing for an increase of the default x86 linesize to 
> > 128 bytes?

Basically what I think we should do is consider L1_CACHE_BYTES to be
*the* correct default value to use for 1) avoiding false sharing (which
seems to be the most common use), and 2) optimal and repeatable per-object
packing into cachelines (which is more of a micro-optimization to be
applied carefully to really critical structures).

But in either case, I think basicaly with these semantics, it makes mots
sense to use the largest line size in the system here (ie. "L1" isn't
really a good semantic because generic code still doesn't really know
enough to do much with that).

And then, I believe INTERNODE should basically just remain as a way
for vSMP to fine tune the size/speed tradeoffs on their platform, which
makes sense because it is so dissimilar to everyone else.

So with !VSMP, I think INTERNODE should just be the same as L1_CACHE_BYTES.

So this was my main point.


> 128 is basically always wrong.
> (unless you have a P4... but for default really we should not care
> about those anymore)

My other point was just this, but I don't care too much. But it is worded
pretty negatively. The key here is that increasing the value too large
tends to only cost a very small amount of size (and no increase in cacheline
foot print, only RAM). Wheras making the value too small could hurt 
scalability by orders of magnitude in the worst case.

For a generic optimised kernel that is claiming to support P4, I think 128
has to be the correct value. If we want an option that supports a generic
for everything but P4 option, fine, but I have my doubts that 128 matters
that much.

Not such a relevant question for mainline, but are distros going to use
64 soon? I would certainly hate to have a customer "upgrade" a big P4
system to a much slower kernel that can't be fixed because of ABI issues,
even if there are only one or two of them left out there.

I don't know, I don't worry about this second point so much though :)

