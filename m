Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbZCJRUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbZCJRUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbZCJRUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:20:42 -0400
Received: from waste.org ([66.93.16.53]:50323 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755619AbZCJRUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:20:40 -0400
Subject: Re: PROBLEM: kernel BUG at mm/slab.c:3002!
From: Matt Mackall <mpm@selenic.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org, penberg@cs.helsinki.fi, linux-mm@kvack.org
In-Reply-To: <49B68450.9000505@hp.com>
References: <49B68450.9000505@hp.com>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 12:18:52 -0500
Message-Id: <1236705532.3205.14.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 11:16 -0400, Alan D. Brunelle wrote:
> Running blktrace & I/O loads cause a kernel BUG at mm/slab.c:3002!.

Pid: 11346, comm: blktrace Tainted: G    B      2.6.29-rc7 #3 ProLiant
DL585 G5   

That 'B' there indicates you've hit 'bad page' before this. That bug
seems to be strongly correlated with some form of hardware trouble.
Unfortunately, that makes everything after that point a little suspect.

Both this slab BUG and the bad page issue are "shouldn't happen"
situations that are generally caused by memory changing out from under
the subsystem, either by some other code scribbling on the relevant
memory or DRAM trouble or the like. If you want to pursue this further,
please gather up a collection of any bad page reports you can find on
your system and change the BUG code at slab.c:3002 to read something
like:

	if (slabp->inuse < 0 || slabp->inuse >= cachep->num) {
		printk("SLAB: slabp %p inuse %d max %d\n",
			slabp, slabp->inuse, cachep->num);
		BUG();
	}

We might find that the slab and the bad page are the same page or
nearby. We might find that inuse has a single bit flipped (hardware
error). Or we might find that it has a revealing value scribbled over it
that points to the culprit. From your trace, it appears to contain 0x70,
which is a rather large number of objects to have on a slab but as we
don't know what slab it is, it's hard to say what happened.

-- 
http://selenic.com : development and support for Mercurial and Linux


