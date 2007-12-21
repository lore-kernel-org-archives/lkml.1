Return-Path: <linux-kernel-owner+w=401wt.eu-S1759672AbXLUWWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759672AbXLUWWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 17:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbXLUWWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 17:22:14 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53795 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754563AbXLUWWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 17:22:13 -0500
Date: Fri, 21 Dec 2007 14:22:10 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <84144f020712210944q3e0539f8vd8a249f69d456dc7@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0712211412040.3795@schroedinger.engr.sgi.com>
References: <1197049846.1645.68.camel@localhost.localdomain> 
 <20071211143336.GA17866@elte.hu>  <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com>
  <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com> 
 <20071221120908.GA15926@elte.hu> <84144f020712210944q3e0539f8vd8a249f69d456dc7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007, Pekka Enberg wrote:

> Christoph, did you see Steven's oprofile results for the hackbench
> runs (http://lkml.org/lkml/2007/12/8/198)? Any ideas why we're hitting
> add_partial like crazy?

Hmmm... SLUB is cycling through partial slabs. If it gets fed objects with 
a single free object from the free list again and again then this is the 
behavior that one would see.

The worst case scenario would be.

1. Processor 0 gets slab with one free entry from the partial list. 

2. Processor 0 allocates object and deactivates the slab since it is full.

3. Processor 1 frees the object and finds that it was not on the partial
   list since there were no free objects. Call put_partial()

4. processor 0 gets slab with one free entry from the partial list.

If we would make the partial list a mininum size (which is already done 
through MIN_PARTIAL maybe just increase it) then we may be able to avoid 
this particular case. Also we could make sure that the slab is not put at 
the beginning  of the partial list on free in order to increase the time 
that the slab spends on the partial list. That way it will gather more 
objects before it is picked up.

Hmmmm... This is a bit different from what I got to here.






