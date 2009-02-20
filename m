Return-Path: <linux-kernel-owner+w=401wt.eu-S1758757AbZBTPli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757AbZBTPli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 10:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbZBTPlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 10:41:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755967AbZBTPlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 10:41:21 -0500
Date: Fri, 20 Feb 2009 07:40:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Steven Rostedt <rostedt@goodmis.org>, Huang Ying <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: use the right protections for split-up pagetables
In-Reply-To: <20090220072915.GB28085@elte.hu>
Message-ID: <alpine.LFD.2.00.0902200728520.21686@localhost.localdomain>
References: <20090220011316.379904625@goodmis.org> <alpine.LFD.2.00.0902191753240.21686@localhost.localdomain> <alpine.DEB.1.10.0902192107230.31658@gandalf.stny.rr.com> <alpine.LFD.2.00.0902191923300.21686@localhost.localdomain>
 <20090220072915.GB28085@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 20 Feb 2009, Ingo Molnar wrote:
> 
> Agreed, split_large_page() was just plain confused here - there 
> was no hidden reason for this logic. It makes no sense to bring 
> any pte level protection information to the PMD level because a 
> pmd entry covers a set of 512 ptes so there's no singular 
> protection attribute that can be carried to it.

Btw, I think split_large_page() is confused in another way too, although 
I'm not entirely sure that it matters. I suspect that it doesn't, if I 
read things correctly.

The confusion? When it moves the 'ref_prot' bits from the upper level, it 
doesn't do the right thing for the PAT bit. That bit is special, and moves 
around depending on level. In the upper levels, it's bit#12, and in the 
final 4k pte level it's bit#7.

So _if_ the PAT bit ever matters, it looks like split_large_page() does 
the wrong thing.

Now, it looks like we avoid the PAT bit on purpose, and we only ever 
encode four PAT values (ie we use only the PCD/PWT bits, and leave the PAT 
bit clear - we don't need any more cases), _but_ we actually do end up 
looking at the PAT bit anyway in cache_attr(). So it looks like at least 
some of the code is _trying_ to handle the PAT bit, but I can pretty much 
guarantee that at least split_large_page() is broken if it is ever set.

			Linus
