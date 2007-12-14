Return-Path: <linux-kernel-owner+w=401wt.eu-S932675AbXLNEYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675AbXLNEYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 23:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757139AbXLNEYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 23:24:45 -0500
Received: from relay1.sgi.com ([192.48.171.29]:58360 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756356AbXLNEYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 23:24:44 -0500
Date: Thu, 13 Dec 2007 20:24:42 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com>
References: <1197049846.1645.68.camel@localhost.localdomain>
 <20071211143336.GA17866@elte.hu> <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmmm... Some tests here on an 8p 8G machine:

SLAB

N=10 Time: 0.341
N=20 Time: 0.605
N=50 Time: 1.487

SLUB 

N=10 Time: 0.675
N=20 Time: 1.434
N=50 Time: 3.996

So its factor 2 for untuned SLUB. Looking at hackbench: This is a 
test that allocates objects that are then consumed by N cpus that then 
return them. The allocating processor can allocate from the per cpu slab 
(the freelist is copied to a per cpu structure when its activated)
avoiding touching the page struct. However, the freeing processors 
must update the freelist of the slab page directly. So they all content 
for the cacheline of the page struct.

Since we do directly free there is the chance of lots of contention 
between the N cpus that free the objects. This is in particular high in a 
synthetic benchmark like this.

However, if the object to be freed is still in a cpu slab then the freeing 
action will reduce the taking of the listlock. So we can actually 
decrease the overhead by increasing the slab page size.

In an extreme case (boot with slub_min_order=9 to get huge page sized 
slabs) SLUB can win against SLAB:

N=10 Time: 0.338	Minimally faster
N=20 Time: 0.560	10% faster
N=50 Time: 1.353	15% faster

Not sure how to get that mainstream yet but there certainly is a way to 
get there. Need to get an idea how to reduce listlock contention in the 
remote free case.
