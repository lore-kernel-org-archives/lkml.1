Return-Path: <linux-kernel-owner+w=401wt.eu-S1760815AbXEQW15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815AbXEQW15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 18:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbXEQW1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 18:27:51 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40605 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756665AbXEQW1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 18:27:50 -0400
Date: Thu, 17 May 2007 15:27:46 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Graf <tgraf@suug.ch>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 0/5] make slab gfp fair
In-Reply-To: <1179437209.2925.29.camel@lappy>
Message-ID: <Pine.LNX.4.64.0705171516260.4593@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl> 
 <Pine.LNX.4.64.0705161957440.13458@schroedinger.engr.sgi.com> 
 <1179385718.27354.17.camel@twins>  <Pine.LNX.4.64.0705171027390.17245@schroedinger.engr.sgi.com>
  <20070517175327.GX11115@waste.org>  <Pine.LNX.4.64.0705171101360.18085@schroedinger.engr.sgi.com>
  <1179429499.2925.26.camel@lappy>  <Pine.LNX.4.64.0705171220120.3043@schroedinger.engr.sgi.com>
 <1179437209.2925.29.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007, Peter Zijlstra wrote:

> The way I read the cpuset page allocator, it will only respect the
> cpuset if there is memory aplenty. Otherwise it will grab whatever. So
> still, it will only ever use ALLOC_NO_WATERMARKS if the whole system is
> in distress.

Sorry no. The purpose of the cpuset is to limit memory for an application. 
If the boundaries would be fluid then we would not need cpusets.

But the same principles also apply for allocations to different zones in a 
SMP system. There are 4 zones DMA DMA32 NORMAL and HIGHMEM and we have 
general slabs for DMA and NORMAL. A slab that uses zone NORMAL falls back 
to DMA32 and DMA depending on the watermarks of the 3 zones. So a 
ZONE_NORMAL slab can exhaust memory available for ZONE_DMA.

Again the question is the watermarks of which zone? In case of the 
ZONE_NORMAL allocation you have 3 to pick from. Its the last one? Then its 
the same as ZONE_DMA, and you got a collision with the corresponding
DMA slab. Depending the system deciding on a zone where we allocate the 
page from you may get a different watermark situation.

On x86_64 systems you have the additional complication that there are 
even multiple DMA32 or NORMAL zones per node. Some will have DMA32 and 
NORMAL, others DMA32 alone or NORMAL alone. Which watermarks are we 
talking about?

The use of ALLOC_NO_WATERMARKS depends on the contraints of the allocation 
in all cases. You can only compare the stresslevel (rank?) of allocations 
that have the same allocation constraints. The allocation constraints are
a result of gfp flags, cpuset configuration and memory policies in effect.




