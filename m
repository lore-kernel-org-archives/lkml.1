Return-Path: <linux-kernel-owner+w=401wt.eu-S1760197AbZFXUlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197AbZFXUlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbZFXUk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:40:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751633AbZFXUk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:40:57 -0400
Date: Wed, 24 Jun 2009 13:40:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: penberg@cs.helsinki.fi, arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906241334260.3154@localhost.localdomain>
References: <20090624080753.4f677847@infradead.org> <20090624094622.d0b0fd82.akpm@linux-foundation.org> <84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com> <20090624105517.904f93da.akpm@linux-foundation.org> <4A426825.80905@cs.helsinki.fi>
 <20090624113037.7d72ed59.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <20090624120617.1e6799b5.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org>
 <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Jun 2009, Linus Torvalds wrote:
> On Wed, 24 Jun 2009, Andrew Morton wrote:
> > 
> > If the caller gets oom-killed, the allocation attempt fails.  Callers need
> > to handle that.
> 
> I actually disagree. I think we should just admit that we can always free 
> up enough space to get a few pages, in order to then oom-kill things.

Btw, if you want to change the WARN_ON() to warn when you're in the 
"allocate in order to free memory" recursive case, then I'd have no issues 
with that.

In fact, in that case it probably shouldn't even be conditional on the 
order. 

So a

	WARN_ON_ONCE((p->flags & PF_MEMALLOC) && (gfpmask & __GFP_NOFAIL));

actually makes tons of sense. 

There are other cases where __GFP_NOFAIL doesn't make sense too, and that 
could be warned about. The __GFP_NORETRY thing was already mentioned. 
Similarly, !__GFP_WAIT doesn't work with __GFP_NOFAIL - because the nofail 
obviously relies on being able to do something about the failure case.

We might want to also have rules like "in order to have NOFAIL, you need 
to allow IO and FS accesses". 

So I don't mind warnings with __GFP_NOFAIL. I just think they should be 
relevant, and make sense. The "order > 0" one is neither.

			Linus
