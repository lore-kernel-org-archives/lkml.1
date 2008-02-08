Return-Path: <linux-kernel-owner+w=401wt.eu-S933564AbYBHGbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564AbYBHGbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 01:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYBHGbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 01:31:47 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43772 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbYBHGbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 01:31:46 -0500
Message-ID: <47ABF715.60407@cs.helsinki.fi>
Date: Fri, 08 Feb 2008 08:30:45 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH 1/2] kmemcheck v3
References: <47AB79D4.2070605@gmail.com>  <Pine.LNX.4.64.0802071341500.2544@schroedinger.engr.sgi.com> <19f34abd0802071412m569e4993kffb4a3af163fa16c@mail.gmail.com> <Pine.LNX.4.64.0802071443440.3289@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0802071443440.3289@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

Christoph Lameter wrote:
> SLABs can be excepted from tracking?

Yes. __GFP_NOTRACK can be used to suppress tracking of objects (but we 
still take the page fault for each access). That is required for things 
like DMA filled pages that are never initialized by the CPU. 
SLAB_NOTRACK is for not tracking a whole *cache* so that we _don't_ take 
the page fault. This is needed for kmemcheck implementation (to avoid 
recursive page faults for memory accessed by the page fault handler).

> So it breaks recursion. But this adds a new cache that is rarely 
> used. There will be only about 50-100 kmem_cache objects in the system. I 
> thought you could control the tracking on an per object level? Would not a 
> kmalloc with __GFP_NOTRACK work?

No. We need to not track the whole page to avoid recursive faults. So 
for kmemcheck we absolutely do need cache_cache but we can, of course, 
hide that under a alloc_cache() function that only uses the extra cache 
when CONFIG_KMEMCHECK is enabled?
