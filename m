Return-Path: <linux-kernel-owner+w=401wt.eu-S933929AbYAaNep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929AbYAaNep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 08:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763582AbYAaNeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 08:34:36 -0500
Received: from cantor.suse.de ([195.135.220.2]:33302 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762051AbYAaNef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 08:34:35 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 4/4] x86_64: increse MAX_EARLY_RES for NODE_DATA and bootmap
Date: Thu, 31 Jan 2008 14:34:30 +0100
User-Agent: KMail/1.9.6
Cc: Yinghai Lu <Yinghai.Lu@sun.com>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <200801291113.35974.yinghai.lu@sun.com> <200801291925.53726.yinghai.lu@sun.com> <20080131132438.GC8499@elte.hu>
In-Reply-To: <20080131132438.GC8499@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801311434.31011.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 January 2008 14:24:38 Ingo Molnar wrote:
> 
> * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
> > ok, discard 3, and 4.
> > 
> > how about 2 v2?
> 
> i'm leaning towards v4, but the more fundamental breakage is in the 
> early_node_mem() ad-hoc allocator that got butchered into this code a 
> year ago:

No it has nothing to do with early_node_mem which is just a thin
wrapper around find_e820_area() anyways.

I think the problem is that the page alignment in bad_addr() and friends is not 
always correct. e.g. the early_reserve for the kernel in head64.c really need to 
round up to pages. I suspect (not 100% sure yet that is the core of the problem) 

Note this was broken even before early reservation; the only difference
was that it was all hard coded in bad_addr() then.

There were various hacks around this in the past, but none fixed the problem 
completely.

>   commit a8062231d80239cf3405982858c02aea21a6066a
>   Author: Andi Kleen <ak@suse.de>
>   Date:   Fri Apr 7 19:49:21 2006 +0200
> 
>       [PATCH] x86_64: Handle empty PXMs that only contain hotplug memory
> 
>   ...
>   +static void * __init
>   +early_node_mem(int nodeid, unsigned long start, unsigned long end,
>   +             unsigned long size)
> 
> and we are now suffering the side-effects of that hack.
> 
> what i suspect we need instead is a proper early-allocator that works in 
> the e820 space.

That is find_e820_area() or rather find_e820_area+early_reserve now.

I had this implemented as a shrink wrapped function earlier for lockdep too, 
but dropped the patch because there was a nasty ordering issue with the e820 
command line parsing that i could not easily resolve.

-Andi
