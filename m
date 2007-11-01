Return-Path: <linux-kernel-owner+w=401wt.eu-S1759486AbXKAWPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486AbXKAWPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbXKAWPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:15:41 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39534 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754620AbXKAWPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:15:40 -0400
Date: Thu, 1 Nov 2007 15:15:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
In-Reply-To: <20071101.142936.114015234.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0711011511450.22508@schroedinger.engr.sgi.com>
References: <20071101.000118.208338243.davem@davemloft.net>
 <20071101.021451.217578606.davem@davemloft.net>
 <Pine.LNX.4.64.0711010601430.27666@schroedinger.engr.sgi.com>
 <20071101.142936.114015234.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007, David Miller wrote:

> From: Christoph Lameter <clameter@sgi.com>
> Date: Thu, 1 Nov 2007 06:03:44 -0700 (PDT)
> 
> > In order to make it truly dynamic we would have to virtually map the
> > area.  vmap? But that reduces performance.
> 
> But it would still be faster than the double-indirection we do now,
> right?

I think I have an idea how to do this. Its a bit x86_64 specific but here 
it goes.

We define a virtual area of NR_CPUS * 2M areas that are each mapped by a
PMD. That means we have a fixed virtual address for each cpus per cpu 
area. 

First cpu is at PER_CPU_START
Second cpu is at PER_CPU_START + 2M

So the per cpu area for cpu n is easily calculated using

PER_CPU_START + cpu << 19

without any lookups.

On bootup we allocate the 2M pages.

After boot is complete we allow the reduction of the size of the per cpu 
areas . Lets say we only need 128k per cpu. Then the remaining pages will
be returned to the page allocator.

We create some sysfs thingy were one can see the current reserves of per 
cpu storage. If one wants to reduce memory then one can write something to 
that to return the remainder of the memory.

