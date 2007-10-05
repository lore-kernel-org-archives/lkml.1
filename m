Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbXJECoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbXJECoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 22:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbXJECoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 22:44:01 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51466 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750732AbXJECn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 22:43:59 -0400
Date: Thu, 4 Oct 2007 19:43:58 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matthew Wilcox <matthew@wil.cx>
cc: David Miller <davem@davemloft.net>, willy@linux.intel.com,
       nickpiggin@yahoo.com.au, hch@lst.de, mel@skynet.ie,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       dgc@sgi.com, jens.axboe@oracle.com, suresh.b.siddha@intel.com
Subject: Re: SLUB performance regression vs SLAB
In-Reply-To: <20071004210518.GR12049@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0710041917020.14135@schroedinger.engr.sgi.com>
References: <20071004183224.GA8641@linux.intel.com>
 <Pine.LNX.4.64.0710041046270.11091@schroedinger.engr.sgi.com>
 <20071004192824.GA9852@linux.intel.com> <20071004.135537.39158051.davem@davemloft.net>
 <20071004210518.GR12049@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just spend some time looking at the functions that you see high in the 
list. The trouble is that I have to speculate and that I have nothing to 
verify my thoughts. If you could give me the hitlist for each of the 
3 runs then this would help to check my thinking. I could be totally off 
here.

It seems that we miss the per cpu slab frequently on slab_free() which 
leads to the calling of __slab_free() and which in turn needs to take a 
lock on the page (in the page struct). Typically the page lock is 
uncontended which seems to not be the case here otherwise it would not be 
that high up.

The per cpu patch in mm should reduce the contention on the page struct by 
not touching the page struct on alloc and on free. Does not seem to work 
all the way though. slab_free() still has to touch the page struct if the 
free is not to the currently active cpu slab.

So there could still be page struct contention left if multiple processors 
frequently and simultaneously free to the same slab and that slab is not 
the per cpu slab of a cpu. That could be addressed by optimizing the 
object free handling further to not touch the page struct even if we miss 
the per cpu slab.

That get_partial* is far up indicates contention on the list lock that 
should be addressable by either increasing the slab size or by changing 
the object free handling to batch in some form.

This is an SMP system right? 2 cores with 4 cpus each? The main loop is 
always hitting on the same slabs? Which slabs would this be? Am I right in 
thinking that one process allocates objects and then lets multiple other 
processors do work and then the allocated object is freed from a cpu that 
did not allocate the object? If neighboring objects in one slab are 
allocated on one cpu and then are almost simultaneously freed from a set 
of different cpus then this may be explain the situation.
