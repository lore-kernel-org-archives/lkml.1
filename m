Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbXDZS1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbXDZS1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbXDZS1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:27:31 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54577 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754921AbXDZS1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:27:30 -0400
Date: Thu, 26 Apr 2007 11:27:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andy Whitcroft <apw@shadowen.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm2 -- PPC link failure
In-Reply-To: <4630EBFA.9000207@shadowen.org>
Message-ID: <Pine.LNX.4.64.0704261123080.3560@schroedinger.engr.sgi.com>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
 <4630A662.8090502@shadowen.org> <4630ABF2.1040305@shadowen.org>
 <4630EBFA.9000207@shadowen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Andy Whitcroft wrote:

> > Ok, this is a SLUB related link failure.  Am investigating if PPC simply
> > needs larger allocs and needs CONFIG_LARGE_ALLOCS, of if this is an
> > inlining issue.
> 
> Ok this is confirmed as an inlining issue.  With the compiler below on
> ppc64 we get the above link failure:
> 
>   gcc version 3.3.3 (SuSE Linux)
> 
> What seems to happen is that although the optimiser is capable of
> collapsing the kmalloc_index() call it then fails to collapse
> kmalloc_slab().  This leads to the never used reference to
> __kmalloc_size_too_large() and the link failure.  From my testing this
> seems to occur at sizes >= 32k.  At 16k all of the code collapses

Interesting. Why would that boundary be of relevance to the compiler? Some 
offset heuristics?

> correctly, at 32k it does not.  I am not entirely sure what to think at
> this point, it is cirtainly not at all clear why the 32k version fails
> and the 16k succeeds they are almost identical.

Likely a backend optimization issue.

> Either way it seems to me that assuming the optimiser will remove the
> code is perhaps over optimistic.  Perhaps it would make more sense to
> put a BUG() in here.  Though that points out the anomaly that the
> kmalloc() for constants has different semantics to that for variable values?

Yes but that has always been the case. We want to reduce kmalloc for 
constants at compile time to use the appropriate kmalloc cache. If kmalloc 
does not use a constant then we will do run time determination of the 
kmalloc cache.

The code in SLAB is easier to fold since it does not use a subroutine call.

We could simply #ifdef out the __kmalloc_sizes_too_large for ppc and let 
it fall back to __kmalloc? That would mean only that kmallocs >32k 
would require an additional determination of the kmalloc cache at run 
time.

But then how important is gcc 3.3 support?

