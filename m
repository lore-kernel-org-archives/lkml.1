Return-Path: <linux-kernel-owner+w=401wt.eu-S932969AbYCEXIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969AbYCEXIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932414AbYCEXCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:02:38 -0500
Received: from relay1.sgi.com ([192.48.171.29]:56927 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932857AbYCEXCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:02:37 -0500
Date: Wed, 5 Mar 2008 15:02:25 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Joe Korty <joe.korty@ccur.com>
cc: linux-kernel@vger.kernel.org, npiggin@suse.de, davem@davemloft.net
Subject: Re: [PATCH] NUMA slab allocator migration bugfix
In-Reply-To: <20080305223314.GA4277@tsunami.ccur.com>
Message-ID: <Pine.LNX.4.64.0803051455320.4561@schroedinger.engr.sgi.com>
References: <20080305223314.GA4277@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008, Joe Korty wrote:

> The NUMA slab allocator (specifically, cache_alloc_refill)
> is not refreshing its local copies of what cpu and what
> numa node it is on, when it drops and reacquires the irq
> block that it inherited from its caller.  As a result
> those values become invalid if an attempt to migrate the
> process to another numa node occured while the irq block
> had been dropped.

The new slab is allocated for the node that was determined earlier and 
entered into the slab queues for that node. Howver, during the alloc we 
were rescheduled.

Then we find ourselves on another processor and recalculate the ac 
pointer. If we now retry then there is the danger of getting off node 
objects into the per cpu queue. Which may cause the wrong lock to be taken 
when draining queues. Sucks because it can cause data corruption. Same as
the other issues resolved by GFP_THISNODE.

Acked-by: Christoph Lameter <clameter@sgi.com>

Will queue it.

