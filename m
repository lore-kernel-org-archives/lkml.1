Return-Path: <linux-kernel-owner+w=401wt.eu-S935743AbYDQKJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935743AbYDQKJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935875AbYDQKGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 06:06:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933304AbYDQKGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 06:06:53 -0400
Date: Thu, 17 Apr 2008 03:06:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-Id: <20080417030611.af071ac3.akpm@linux-foundation.org>
In-Reply-To: <20080417094606.GA19607@elte.hu>
References: <20080416202338.GA6007@elte.hu>
	<20080417002552.5742ad65.akpm@linux-foundation.org>
	<20080417083000.GA4935@elte.hu>
	<20080417014054.ea788f1f.akpm@linux-foundation.org>
	<20080417090626.GA14383@elte.hu>
	<20080417021813.04df7912.akpm@linux-foundation.org>
	<20080417093025.GA17389@elte.hu>
	<20080417023603.672d1032.akpm@linux-foundation.org>
	<20080417094606.GA19607@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 11:46:06 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > you mean kmemcheck? Yes, that's planned. We've been working 4 months 
> > > non-stop on kmemcheck to make it mergeable and usable, it's at 
> > > version 7 right now, and it caught a handful of real bugs already 
> > > (such as 63a7138671c - unfortunately not credited in the log to 
> > > kmemcheck). But because it touches SLUB (because it has to - and 
> > > they are acked by Pekka) i never had the chance to move it into the 
> > > for-akpm branch.
> > 
> > Does it really really really need to consume one of our few remaining 
> > page flags?  We'll be in a mess when we run out.
> 
> well AFAICS the shortage really mostly affects 32-bit platforms. And 
> there we've got 19 bits used, out of 23 available, right?

Unfortunately the answer to that question is surprisingly hard to generate
and it probably has changed over time.  Christoph sat down and worked it
all out a few months ago.

One surprising problem is ia64 which uses (or used to use?) basically all
of the upper 32-bits.

> whether we track a page or not is rather fundamental to kmemcheck, i 
> dont see any easy way to get rid of that usage. (and since kmemcheck is 
> a transparent add-on, i dont see any obvious other candidate like 
> page->private either - all those fields might be utilized)

oooh yeah.  We've squeezed blood out of the pageframe.

> if we run out of that in the future: the high bits get used by sparse 
> section and numa node ID bits, worst-case we could live with restricting 
> the max number of NUMA nodes on 32-bit from 64 to 32? [NUMA on 32-bit is 
> an afterthought anyway.]

Yes, I think it's only NUMAQ and one of the old IBM machines.  I don't
think numaq ever went beyond 8 nodes.  superh is (or will) use NUMA, but
surely not with many nodes.

> Or we could do a CONFIG_KMEMCHECK=y only 
> page->flags_debug.

Yes, that'd be OK.   We could do that now, or just pop a comment in there.
