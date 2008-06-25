Return-Path: <linux-kernel-owner+w=401wt.eu-S1758548AbYFYPVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbYFYPVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbYFYPVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:21:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752355AbYFYPVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:21:16 -0400
Date: Wed, 25 Jun 2008 08:19:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
cc: Paul Jackson <pj@sgi.com>, hpa@zytor.com, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       steiner@sgi.com, travis@sgi.com, linux-kernel@vger.kernel.org,
       ying.huang@intel.com, andi@firstfloor.org
Subject: Re: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal
 in some kernel info printks
In-Reply-To: <1214406026.21847.25.camel@johannes.berg>
Message-ID: <alpine.LFD.1.10.0806250813030.4733@hp.linux-foundation.org>
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>  <20080622142212.5591.64592.sendpatchset@polaris-admin.engr.sgi.com>  <86802c440806221238g78300952t2fc7f406c1842273@mail.gmail.com>  <20080623060939.6b6b3183.pj@sgi.com> 
 <86802c440806241429s  <alpine.LFD.1.10.0806242101460.20369@hp.linux-foundation.org> <1214406026.21847.25.camel@johannes.berg>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Jun 2008, Johannes Berg wrote:
> 
> In networking, we've gone through various incarnations of print_mac()
> which is similar to the sym() macro Paul proposed, and it turned out to
> be undesirable because of the way it interacts with static inlines that
> only optionally contain code at all, the print_mac() function call is
> still emitted by the compiler. People experimented with marking it
> __pure but that had other problems.

You don't even have to go that esoteric.

Just printing things like "sector_t" or "u64" is painful, because the 
exact type depends on config options and/or architecture.

> It would be nice to be able to say
> 
> u8 *eaddr;
> 
> printk(... %M ..., eaddr);

For special things, I do think we should extend the format more, and 
forget about single-character names. It would be lovely to do them as
%[mac], %[u64], %[symbol] or similar. Because once you don't rely on gcc 
checking the string, you can do it.

The problem is that right now we absolutely _do_ rely on gcc checking the 
string, and as such we're forced to use standard patterns, and standard 
patterns _only_. And that means that %M isn't an option, but also that if 
we want symbolic names we'd have to use %p, and not some extension.

But once you drop the 'standard patterns' requirement, I do think you 
should drop it _entirely_, and not just extend it with some pissant 
single-character unreadable mess.

				Linus
