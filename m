Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab0BCMZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 07:25:36 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:57037 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab0BCMZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 07:25:34 -0500
Date: Wed, 3 Feb 2010 17:55:26 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Lubos Lunak <l.lunak@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: Improving OOM killer
Message-ID: <20100203122526.GG19641@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <201002012302.37380.l.lunak@suse.cz>
 <20100203085711.GF19641@balbir.in.ibm.com>
 <201002031310.28271.l.lunak@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <201002031310.28271.l.lunak@suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lubos Lunak <l.lunak@suse.cz> [2010-02-03 13:10:27]:

> On Wednesday 03 of February 2010, Balbir Singh wrote:
> > * Lubos Lunak <l.lunak@suse.cz> [2010-02-01 23:02:37]:
> > >  In other words, use VmRSS for measuring memory usage instead of VmSize,
> > > and remove child accumulating.
> >
> > I am not sure of the impact of changing to RSS, although I've
> > personally believed that RSS based accounting is where we should go,
> > but we need to consider the following
> >
> > 1. Total VM provides data about potentially swapped pages,
> 
>  Yes, I've already updated my proposal in another mail to switch from VmSize 
> to VmRSS+InSwap. I don't know how to find out the second item in code, but at 
> this point of discussion that's just details.
> 

I am yet to catch up with the rest of the thread. Thanks for heads up.

> > overcommit, 
> 
>  I don't understand how this matters. Overcommit is memory for which address 
> space has been allocated but not actual memory, right? Then that's exactly 
> what I'm claiming is wrong and am trying to reverse. Currently OOM killer 
> takes this into account because it uses VmSize, but IMO it shouldn't - if a 
> process does malloc(400M) but then it uses only a tiny fraction of that, in 
> the case of memory shortage killing that process does not solve anything in 
> practice.

We have a way of tracking commmitted address space, which is more
sensible than just allocating memory and is used for tracking
overcommit. I was suggesting that, that might be a better approach.

> 
> > etc.
> > 2. RSS alone is not sufficient, RSS does not account for shared pages,
> > so we ideally need something like PSS.
> 
>  Just to make sure I understand what you mean with "RSS does not account for 
> shared pages" - you say that if a page is shared by 4 processes, then when 
> calculating badness for them, only 1/4 of the page should be counted for 
> each? Yes, I suppose so, that makes sense.

Yes, that is what I am speaking of

> That's more like fine-tunning at 
> this point though, as long as there's no agreement that moving away from 
> VmSize is an improvement.
>

There is no easy way to calculate the Pss today without walking the
page tables, but some simplification there will make it a better and a
more accurate metric.
 
> > I suspect the correct answer would depend on our answers to 1 and 2
> > and a lot of testing with any changes made.
> 
>  Testing - are there actually any tests for it, or do people just test random 
> scenarios when they do changes? Also, I'm curious, what areas is the OOM 
> killer actually generally known to work well in? I somehow get the feeling 
> from the discussion here that people just tweak oom_adj until it works for 
> them.
>

I've mostly found OOM killer to work well for me, but looking at the
design and our discussions I know there need to be certain improvements. 

-- 
	Balbir
