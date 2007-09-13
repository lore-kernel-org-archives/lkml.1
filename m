Return-Path: <linux-kernel-owner+w=401wt.eu-S1762400AbXIMXQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762400AbXIMXQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbXIMXP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:15:58 -0400
Received: from ozlabs.org ([203.10.76.45]:57535 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbXIMXP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:15:58 -0400
Subject: Re: [patch 1/8] Immediate Values - Global Modules List and Module
	Mutex
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20070913212107.GA15826@Krystal>
References: <20070906200228.086651361@polymtl.ca>
	 <20070906200314.079453533@polymtl.ca>
	 <20070908072811.GB1819@martell.zuzino.mipt.ru>
	 <1189468414.8023.66.camel@localhost.localdomain>
	 <20070911004541.GA4360@Krystal>
	 <1189487938.20631.53.camel@localhost.localdomain>
	 <20070911142733.GA7850@Krystal>
	 <1189662432.32322.1.camel@localhost.localdomain>
	 <20070913212107.GA15826@Krystal>
Content-Type: text/plain
Date: Fri, 14 Sep 2007 09:15:17 +1000
Message-Id: <1189725317.7262.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-13 at 17:21 -0400, Mathieu Desnoyers wrote:
> * Rusty Russell (rusty@rustcorp.com.au) wrote:
> > Sure, but why is that the caller's problem?  immediate_set() isn't
> > fastpath, so why not make it do an "if (early_boot)" internally?
> 
> I see two reasons:
> 1 - early_boot, or anything that looks like this, does not exist
> currently (and the following reason might show why).
> 2 - If we use this, we cannot declare the early code with __init, so it
> will have to stay there forever insteaf of being removable once boot is
> over.
> 
> Therefore, I think it's better to stick to an immediate_set_early
> version.

My problem is that I don't know when to use immediate_set_early!  You
say "early boot": what does that mean?  Is it arch-specific?  And why is
it my problem anyway?

Since arch_immediate_update_early() is a memcpy, I don't really buy the
bloat argument (it has some silly-looking optimization, but that should
be removed anyway).  I'd really rather see arch_immediate_update()
examine an internal flag and do the memcpy if it's too early for the
full algorithm.  That's the only place which really knows, after all.
You may need some external hook to update that internal "too early"
flag, of course.

Alternatively, if you called it "immediate_init" then the semantics
change slightly, but are more obvious (ie. only use this when the value
isn't being accessed yet).  But it can't be __init then anyway.

On an unrelated note, did you consider simply IPI-ing and doing the
substitution with all CPUs stopped?  If you only updated the immediate
references to this particular var, it should be fast enough not to upset
the RT guys, even.

> > I was thinking that we might find useful specific cases before we get
> > GCC support, which archs can override with tricky asm if they wish.
> > 
> 
> The first useful case is the Linux Kernel Markers, which really needs a
> completely boolean if: active or inactive. That would be a good test
> case to get gcc support.

Well, you can do that in asm without gcc support.  It's a little nasty:
since gcc will know nothing about the function call, it can't have side
effects which are visible in this function, and you'll have to save and
restore *all* regs if you decide to do the function call.  But it's
possible (a 5-byte nop gets changed to a call, the call does the pushes
and sets the args regs, calls the function, then pops everything and
rets).

Cheers,
Rusty.

