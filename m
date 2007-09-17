Return-Path: <linux-kernel-owner+w=401wt.eu-S1757638AbXIQTht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638AbXIQTht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 15:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbXIQThm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 15:37:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51478 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755184AbXIQThl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 15:37:41 -0400
Date: Mon, 17 Sep 2007 12:37:40 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       ak@suse.de, eric.whitney@hp.com, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH]  2.6.23-rc6:  Fix NUMA Memory Policy Reference Counting
In-Reply-To: <1190057534.5460.131.camel@localhost>
Message-ID: <Pine.LNX.4.64.0709171235190.28178@schroedinger.engr.sgi.com>
References: <20070830185053.22619.96398.sendpatchset@localhost>
 <1190057534.5460.131.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007, Lee Schermerhorn wrote:

> Here is the 23-rc6 verison of the patch.  Andi considers it a high
> priority bug fix for .23.  I'm a bit uncomfortable with this, this late
> in the 23 cycle.  I've not heard of problems w/o this patch, but then,
> maybe no one notices if they leak a memory policy struct now and then,
> or occasionally allocate memory on the wrong node because they used a
> prematurely freed memory policy.

The patch does require concurrent increments and decrements in the main 
fault patch. The potential is to create another bouncing cacheline for 
concurrent faults. This looks like it would cause a performance issue.

> Kernel Build [16cpu, 32GB, ia64] - average of 10 runs:
> 
> 		w/o patch	w/ refcount patch
> 	    Avg	  Std Devn	   Avg	  Std Devn
> Real:	 100.59	    0.38	 100.63	    0.43
> User:	1209.60	    0.37	1209.91	    0.31
> System:   81.52	    0.42	  81.64	    0.34

Single threaded build? I would suggest to try concurrently faulting memory 
from multiple processors. You may not see this on a kernel build even if 
this is run with -j16 because concurrent faults are rare.

