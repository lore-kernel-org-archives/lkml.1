Return-Path: <linux-kernel-owner+w=401wt.eu-S1756416AbXGHJnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbXGHJnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 05:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbXGHJnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 05:43:09 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:30893 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753155AbXGHJnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 05:43:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=gtAxTczVCsIRwFjFI26xCvRTwsvcaXZfljqk5tGO8Mqn2b+Ydp4l7SRRUzG319ISSibkFa7gbEGuvuzBqRgBpwXV2bDvfW8pbgFU0GFAjfayHYAIIIQqjw1c8SQdw2rkKHZ4fcZCwe0r3EAs6olhwLHf2Q/JpNa6NWQnfOxrD4g=  ;
X-YMail-OSG: nTji.MEVM1k32k7kM6uGRPuP4TxWTvZLPIF_bliiZhn6woKausllu0pf6prwM6dir77OgCkfQw--
Message-ID: <4690B1A4.4010703@yahoo.com.au>
Date: Sun, 08 Jul 2007 19:43:00 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, suresh.b.siddha@intel.com,
       corey.d.gough@intel.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, Matt Mackall <mpm@selenic.com>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com> <20070708075119.GA16631@elte.hu>
In-Reply-To: <20070708075119.GA16631@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> (added Matt to the Cc: list)
> 
> * Christoph Lameter <clameter@sgi.com> wrote:
> 
> 
>>Maintenance of slab allocators becomes a problem as new features for 
>>allocators are developed. The SLOB allocator in particular has been 
>>lagging behind in many ways in the past:
>>
>>- Had no support for SLAB_DESTROY_BY_RCU for years (but no one 
>>  noticed)

It likely was not frequently used on SMP, I guess.


>>- Still has no support for slab reclaim counters. This may currently 
>>  not be necessary if one would restrict the supported configurations 
>>  for functionality relying on these. But even that has not been done.

SLOB has so far run fine without any of these, hasn't it?


>>The only current advantage over SLUB in terms of memory savings is 
>>through SLOBs kmalloc layout that is not power of two based like SLAB 
>>and SLUB which allows to eliminate some memory waste.

Wrong. All "slabs" allocate out of the same pool of memory in SLOB, so
you also wind up with less waste via _external_ fragmentation, which is
espeically important on small memory machines (the kmalloc layout issue
is a problem of internal fragmentation). SLOB is also smaller and simpler
code as Ingo pointed out.


>>Through that SLOB has still a slight memory advantage over SLUB of 
>>~350k in for a standard server configuration. It is likely that the 
>>savings are is smaller for real embedded configurations that have less 
>>functionality.

When I last tested, I got similar savings with a pretty stripped down
kernel and a small mem= available RAM. Ie. to the point where those 350K
saved were a very significant chunk of remaining free memory after init
comes up.

I said exactly the same thing last time this came up. I would love to
remove code if its functionality can be adequately replaced by existing
code, but I think your reasons for removing SLOB aren't that good, and
just handwaving away the significant memory savings doesn't work.

People run 2.6 kernels with several MB of RAM, don't they? So losing
several hundred K is as bad to them as a patch that causes an Altix to
waste several hundred GB is to you.


> A year ago the -rt kernel defaulted to the SLOB for a few releases, and 
> barring some initial scalability issues (which were solved in -rt) it 
> worked pretty well on generic PCs, so i dont buy the 'it doesnt work' 
> argument either.

It's actually recently been made to work on SMP, it is much more scalable
to large memories, and some initial NUMA work is happening that some
embedded guys are interested in, all without increasing static footprint
too much, and it has actually decreased dynamic footprint too.

-- 
SUSE Labs, Novell Inc.
