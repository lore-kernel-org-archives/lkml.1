Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbZF1Shd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbZF1Shd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 14:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755752AbZF1ShH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 14:37:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755174AbZF1ShG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 14:37:06 -0400
Date: Sun, 28 Jun 2009 11:36:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>
cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <20090628112748.2470f2d5@infradead.org>
Message-ID: <alpine.LFD.2.01.0906281129330.3605@localhost.localdomain>
References: <20090624094622.d0b0fd82.akpm@linux-foundation.org> <84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com> <20090624105517.904f93da.akpm@linux-foundation.org> <4A426825.80905@cs.helsinki.fi> <20090624113037.7d72ed59.akpm@linux-foundation.org>
 <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <20090624120617.1e6799b5.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain>
 <20090628101654.GB8673@ucw.cz> <alpine.LFD.2.01.0906281101030.3605@localhost.localdomain> <20090628112748.2470f2d5@infradead.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 28 Jun 2009, Arjan van de Ven wrote:
> > 
> > Almost the _only_ way to run out of memory is to have tons and tons
> > of dirty pages around. Yes, it can happen. But if it happens, you're
> > almost guaranteed to be screwed anyway. The whole VM is designed
> 
> my impression is that when the strict dirty accounting code went in,
> this problem largely went away.

Yes and no.

It's still pretty easy to have lots of dirty anonymous memory, no 
swap-space, and just run out of memory. If you do that, you're screwed. 
The oom killer may or may not help, but even if it works, it's probably 
going to work only after things have gotten pretty painful.

Also, we'll have to be pretty careful when/if we actually use that 
"gfp_allowed_mask" for suspend/resume/hibernate. The SLAB_GFP_BOOT_MASK 
has the __GFP_WAIT bit cleared, for example, which means that the VM won't 
try to free even trivially freeable memory.

So for hibernate, if/when we use this, we should make sure to still allow 
__GFP_WAIT (except, perhaps, during the stage when interrupts are actually 
disabled), but clear __GFP_IO and __GFP_FS.

Or whatever. The devil is in the details.

		Linus
