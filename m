Return-Path: <linux-kernel-owner+w=401wt.eu-S933937AbXHNTlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937AbXHNTlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 15:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbXHNTlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 15:41:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41513 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759794AbXHNTlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 15:41:11 -0400
Date: Tue, 14 Aug 2007 12:41:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-mm@kvack.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
In-Reply-To: <1187119978.5337.1.camel@lappy>
Message-ID: <Pine.LNX.4.64.0708141233370.30435@schroedinger.engr.sgi.com>
References: <20070814142103.204771292@sgi.com>  <1187102203.6114.2.camel@twins>
  <Pine.LNX.4.64.0708140828060.27248@schroedinger.engr.sgi.com>
 <1187119978.5337.1.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Peter Zijlstra wrote:

> > Ok but that could be addressed by making sure that a certain portion of 
> > memory is reserved for clean file backed pages.
> 
> Which gets us back to the initial problem of sizing this portion and
> ensuring it is big enough to service the need.

Clean file backed pages dominate memory on most boxes. They can be 
calculated by NR_FILE_PAGES - NR_FILE_DIRTY

On my 2G system that is 

Cached:        1731480 kB
Dirty:             424 kB

So for most load the patch as is will fix your issues. The problem arises 
if you have extreme loads that are making the majority of pages anonymous.

We could change min_free_kbytes to specify the number of free + clean 
pages required (if we can do atomic reclaim then we do not need it 
anymore). Then we can specify a large portion of memory for 
min_free_kbytes. 20%? That would give you 400M on my box which would 
certainly suffice.

If the amount of clean file backed pages falls below that limit then do 
the usual reclaim. If we write anonymous pages out to swap then they 
can also become clean and reclaimable.


