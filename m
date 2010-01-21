Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481Ab0AUXNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0AUXNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 18:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424Ab0AUXNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 18:13:10 -0500
Received: from smtp-out.google.com ([216.239.33.17]:62307 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab0AUXNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 18:13:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=FoTVUQ0QyZF/Gn5QfxD86SFR67w5bZ9OxoQKYMV3qK3g7CeUQmlnMk88+eLbua1dc
	WQdQxJ/03zg+oSaGWkFIw==
Date: Thu, 21 Jan 2010 15:12:58 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Haicheng Li <haicheng.li@linux.intel.com>
cc: Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: set hotpluggable nodes in nodes_possible_map
In-Reply-To: <4B581160.2090209@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1001211500290.31073@chino.kir.corp.google.com>
References: <4B501C4D.4080907@linux.intel.com> <alpine.DEB.2.00.1001171338170.16238@chino.kir.corp.google.com> <86802c441001172230y137b4916h7d744a96ab75873d@mail.gmail.com> <alpine.DEB.2.00.1001180231430.20677@chino.kir.corp.google.com> <4B5592B1.9030800@linux.intel.com>
 <alpine.DEB.2.00.1001191513010.24223@chino.kir.corp.google.com> <4B5731E2.4040207@linux.intel.com> <alpine.DEB.2.00.1001201152040.30528@chino.kir.corp.google.com> <4B57C2DD.3050402@linux.intel.com> <alpine.DEB.2.00.1001202252320.22343@chino.kir.corp.google.com>
 <4B5802EF.6040603@linux.intel.com> <alpine.DEB.2.00.1001202344580.29982@chino.kir.corp.google.com> <4B581160.2090209@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jan 2010, Haicheng Li wrote:

> > It's pointless to add another nodemask, the semantics of cpu_nodes_parsed is
> > perfectly legitimate for hotpluggable nodes as well.  Instead of fixating on
> > the name, look at the code that uses it.
> 
> I'm not meant to be rude, but it's illogical excuse. that it is now used by a
> single function doesn't mean that it will never be used by others in future or
> it is only useful for that single function.
> 

It will not be used by a single function in this context for any valid 
purpose, hp_nodes_parsed is completely unnecessary and overkill to address 
a problem that is a relative one-liner.  You're completely missing the 
points that (i) no other SRAT parsing code cares about distinguishing only 
nodes with hotpluggable memory ranges, and (ii) no other SRAT parsing code 
even cares about distinguishing memoryless nodes with only cpus attached.  
Thus, we can use cpu_nodes_allowed to represent _all_ nodes without online 
memory ranges (and you can even rename it to no_mem_nodes later, if you 
want).

This discussion is becoming very annoying because you have constantly 
proposed new patches (I think 4 now?) that are much more complex and 
without any real consistent idea behind them.  Your latest proposal is to 
add a nodemask because you speculate that someday it will become useful; 
the truth of the matter is that we don't need to do anything with them 
beyond detection so the bit gets set in nodes_possible_map.

Ingo should not need to look through what is becoming an extremely long 
discussion for a bugfix that should be applied for rc5 because we're 
getting _very_ late in the 2.6.33 release cycle.  Do you expect Ingo to 
push your fix to Linus with the rationale that "maybe someday we'll use 
this new nodemask even though it may be rc5 and nobody knows what we'd 
ever use it for"?  Is that appropriate for -stable candidates as well?

You've already tested my patch that this thread was restarted with and it 
works, so let's fix the bug.  Then, later, you can rename cpu_nodes_parsed 
to no_mems_nodes, which I'd agree with.  You may even try to seperate the 
hotpluggable nodes out into their own nodemask, but I trust that the x86 
maintainers will be looking for some rationale behind that other than "it 
may one day be useful."
