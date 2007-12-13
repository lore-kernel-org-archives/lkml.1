Return-Path: <linux-kernel-owner+w=401wt.eu-S932903AbXLMVEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbXLMVEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbXLMVDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:03:54 -0500
Received: from gate.crashing.org ([63.228.1.57]:36113 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455AbXLMVDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:03:53 -0500
Subject: Re: What was the problem with quicklists and x86-64?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Christoph Lameter <clameter@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Asit Mallick <asit.k.mallick@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0712131251300.18314@schroedinger.engr.sgi.com>
References: <47603321.4030700@goop.org>
	 <Pine.LNX.4.64.0712131131540.13396@schroedinger.engr.sgi.com>
	 <1197578876.15741.163.camel@pasglop>
	 <Pine.LNX.4.64.0712131251300.18314@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 08:03:08 +1100
Message-Id: <1197579788.15741.172.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-13 at 12:53 -0800, Christoph Lameter wrote:
> On Fri, 14 Dec 2007, Benjamin Herrenschmidt wrote:
> 
> > > These issues only exist with NUMA because of the freeing of off node pages 
> > > before the TLB flush was done. There was a discussion about this issue and 
> > > my fix of simply not freeing the offnode pages early was ignored. Instead 
> > > the x86_64 implementation (which has no problems that I know of) was 
> > > pulled leaving the issue open in the core. Benjamin Herrrenschmidt 
> > > wanted to take a look at these issues (CCing him).
> > 
> > I don't know how NUMA gets in the picture there, it's probably very x86
> > specific thing. The issue we have here happens on other platforms
> > unrelated to NUMA. The fact that is tired to NUMA on x86 might be due to
> > the way the HW tablewalk operates on these. 
> 
> This is a generic NUMA issue here! Quicklist pages that are not on 
> the current node are freed without waiting for the TLB flush. The patch 
> that I posted fixes that by requiring that all pages be flushed. 

Ah ok, so that's a NUMA issue due to how the quicklists are implemented,
I see. Note that the flush isn't necessary a solution on all platforms.
On powerpc, I -still- need to defer with RCU as we don't do anything in
flush tlb. Our TLB invalidations are HW broadcast in the first place,
but what we need to sync with is the SW hash reload code.

So your solution in the quicklists doesn't solve the problem for us.

Ben.


