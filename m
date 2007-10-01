Return-Path: <linux-kernel-owner+w=401wt.eu-S1752726AbXJAVcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbXJAVcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 17:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbXJAVcC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 17:32:02 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34922 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628AbXJAVcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 17:32:00 -0400
Date: Mon, 1 Oct 2007 14:30:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: a.p.zijlstra@chello.nl, nickpiggin@yahoo.com.au, hch@lst.de, mel@skynet.ie,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       dgc@sgi.com, jens.axboe@oracle.com
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
Message-Id: <20071001143047.238dfe49.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0710011354480.19779@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com>
	<20070919033643.763818012@sgi.com>
	<200709280742.38262.nickpiggin@yahoo.com.au>
	<Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
	<1191002119.18147.80.camel@lappy>
	<Pine.LNX.4.64.0709281114250.5149@schroedinger.engr.sgi.com>
	<1191003950.18147.85.camel@lappy>
	<20070929011311.8b51dedb.akpm@linux-foundation.org>
	<1191055632.18147.101.camel@lappy>
	<20070929020049.f73f4aea.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0710011354480.19779@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007 13:55:29 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Sat, 29 Sep 2007, Andrew Morton wrote:
> 
> > > atomic allocations. And with SLUB using higher order pages, atomic !0
> > > order allocations will be very very common.
> > 
> > Oh OK.
> > 
> > I thought we'd already fixed slub so that it didn't do that.  Maybe that
> > fix is in -mm but I don't think so.
> > 
> > Trying to do atomic order-1 allocations on behalf of arbitray slab caches
> > just won't fly - this is a significant degradation in kernel reliability,
> > as you've very easily demonstrated.
> 
> Ummm... SLAB also does order 1 allocations. We have always done them.
> 
> See mm/slab.c
> 
> /*
>  * Do not go above this order unless 0 objects fit into the slab.
>  */
> #define BREAK_GFP_ORDER_HI      1
> #define BREAK_GFP_ORDER_LO      0
> static int slab_break_gfp_order = BREAK_GFP_ORDER_LO;

Do slab and slub use the same underlying page size for each slab?

Single data point: the CONFIG_SLAB boxes which I have access to here are
using order-0 for radix_tree_node, so they won't be failing in the way in
which Peter's machine is.

I've never ever before seen reports of page allocation failures in the
radix-tree node allocation code, and that's the bottom line.  This is just
a drop-dead must-fix show-stopping bug.  We cannot rely upon atomic order-1
allocations succeeding so we cannot use them for radix-tree nodes.  Nor for
lots of other things which we have no chance of identifying.

Peter, is this bug -mm only, or is 2.6.23 similarly failing?
