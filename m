Return-Path: <linux-kernel-owner+w=401wt.eu-S932856AbYDQKaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856AbYDQKaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760918AbYDQK34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 06:29:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37448 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760803AbYDQK3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 06:29:55 -0400
Message-ID: <4807269E.8070202@firstfloor.org>
Date: Thu, 17 Apr 2008 12:29:50 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
References: <20080416202338.GA6007@elte.hu>	<20080417002552.5742ad65.akpm@linux-foundation.org>	<20080417083000.GA4935@elte.hu>	<20080417014054.ea788f1f.akpm@linux-foundation.org>	<20080417090626.GA14383@elte.hu>	<20080417021813.04df7912.akpm@linux-foundation.org>	<20080417093025.GA17389@elte.hu>	<20080417023603.672d1032.akpm@linux-foundation.org>	<87zlrshjtz.fsf@basil.nowhere.org> <20080417031829.15ec73df.akpm@linux-foundation.org>
In-Reply-To: <20080417031829.15ec73df.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 17 Apr 2008 12:11:36 +0200 Andi Kleen <andi@firstfloor.org> wrote:
> 
>> Andrew Morton <akpm@linux-foundation.org> writes:
>>> Does it really really really need to consume one of our few remaining page
>>> flags?  We'll be in a mess when we run out.
>> No we're not. Just the (imho always misguided) "encode zone/node number 
>> into flags" optimization has to be removed again or made 64bit only.
>> Then there will be plenty of flags again.
> 
> hm.  Or we add a new nid&zone field to the pageframe for 32bit NUMA.  Just
> don't tell Paul Mundt ;)

Most (all?) NUMA archs have some way to get from phys->nid. Getting from
pfn->nid is then easy.

Originally this was all optimized for text size when this stuff was
still inlined, but at some point they were all out of lined anyways
(unless on FLAT iirc) so a lot of the old design decisions became obsolete.

BTW I should disclose that my mask allocator that I'm still planning
to push needs one flag bit on 32/64bit and another one on 64bit
(for swiotlb)

> 
> Need to work out what's going on with ia64's use of the upper 32 bits too. 
> I have a feeling it's using less than it used too but at 3AM I can't be
> assed working it out.
> 
>> Really I see no real reason this can't be done with a small hash table
>> again like x86-64 originally did.
> 
> How did that work?  A pfn->zone-id hash table would be huge?

Sorry i meant it used the hash table to look up the node. In fact
that code is still in there, although used less because a lot of these
lookups are resolved from the flags.

Once you have the node from the pfn it is a at most three range checks
to get to the zone (usually less). The most efficient way to do that is
to just open code it in code.

-Andi

