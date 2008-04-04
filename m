Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbYDDBxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbYDDBxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 21:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYDDBxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 21:53:03 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:45322 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbYDDBxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 21:53:01 -0400
Subject: Re: [PATCH 5 of 6] hotplug-memory: add section_ops
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <47F5809A.7040307@goop.org>
References: <785fe0877fea0f488bc5.1207267545@localhost>
	 <1207270272.943.27.camel@nimitz.home.sr71.net>  <47F5809A.7040307@goop.org>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 18:52:58 -0700
Message-Id: <1207273978.943.82.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-04-03 at 18:12 -0700, Jeremy Fitzhardinge wrote:
> Dave Hansen wrote:
> > On Thu, 2008-04-03 at 17:05 -0700, Jeremy Fitzhardinge wrote:
> > I think it might just be nicer to have a global list of these handlers
> > somewhere.  The Xen driver can just say "put me on the list of
> > callbacks" and we'll call them at online_page().  I really don't think
> > we need to be passing an ops structure around.
> >   
> 
> Yes, but it seems a bit awkward.  If we assume that:
> 
>    1. Xen will be the only user of the hook, and
>    2. Xen-balloon hotplug is exclusive of real memory hotplug
> 
> then I guess its reasonable (though if that's the case it would be 
> simpler to just put a direct call under #ifdef CONFIG_XEN_BALLOON in there).

Yeah, I'm OK with something along those lines, too.  I'd prefer sticking
some stubs in a header and putting the #ifdef there, if only for
aesthetic reasons.

> But if we think there can be multiple callbacks, and they all get called 
> on the online of each page, and there can be multiple kinds of hotplug 
> memory it gets pretty messy.  Each has to determine "why was I called on 
> this page?" and you'd to work out which one actually does the job of 
> onlining.  It just seems cleaner to say "this section needs to be 
> onlined like this", and there's no ambiguity.

I really wish we'd stop calling it "page online". :)

Let me think out loud for a sec here.  Here's how memory hotplug works
in a nutshell:

First step (add_memory() or probe time):
1. get more memory made available
2. create kva mapping for that memory (for lowmem)
3. allocate 'struct pages'

Second step, 'echo 1 > .../memoryXXX/online' time:
4. modify zone/pgdat spans (make the VM account for the memory)
5. Initialize the 'struct page'
6. free the memory into the buddy allocator

You can't do (2) because Xen doesn't allow mappings to be created until
real backing is there.  You've already done this, right?

You don't want to do (6) either, because there is no mapping for the
page and it isn't committed in hardware, yet, so you don't want someone
grabbing it *out* of the buddy allocator and using it.

Your solution is to take those first 1-5 steps, and had the balloon
driver call them directly.  The online_page() modifications are because
5/6 are a bit intertwined right now.  Are we on the same page so far?

Why don't we just free the page back into the balloon driver?  Take the
existing steps 1-5, use them as they stand today, and just chop of step
6 for Xen.  It'd save a bunch of this code churn and also stop us from
proliferating any kind of per-config section-online behavior like you're
asking about above.

That might also be generalizable to anyone else that wants the "fresh
meat" newly-hotplugged memory.  Large page users might be other
consumers here.

> I'm already anticipating using the ops mechanism to support another 
> class of Xen hotplug memory for managing large pages.

Do tell. :)

-- Dave

