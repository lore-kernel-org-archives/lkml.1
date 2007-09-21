Return-Path: <linux-kernel-owner+w=401wt.eu-S1762313AbXIUUPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762313AbXIUUPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931AbXIUUPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:15:41 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59552 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750772AbXIUUPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:15:40 -0400
Date: Fri, 21 Sep 2007 13:15:40 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Luck, Tony" <tony.luck@intel.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       akpm@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org,
       "Mallick, Asit K" <asit.k.mallick@intel.com>
Subject: RE: x86_64: potential critical issue with quicklists and page table
 pages
In-Reply-To: <617E1C2C70743745A92448908E030B2A027C22D4@scsmsx411.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.64.0709211304440.18254@schroedinger.engr.sgi.com>
References: <20070921180742.GH20863@linux-os.sc.intel.com>
 <alpine.LFD.0.999.0709211139550.16478@woody.linux-foundation.org>
 <Pine.LNX.4.64.0709211149040.17160@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0709211153060.16478@woody.linux-foundation.org>
 <alpine.LFD.0.999.0709211204050.16478@woody.linux-foundation.org>
 <Pine.LNX.4.64.0709211205570.17160@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0709211212130.16478@woody.linux-foundation.org>
 <Pine.LNX.4.64.0709211221560.17698@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0709211235220.16478@woody.linux-foundation.org>
 <Pine.LNX.4.64.0709211249330.18088@schroedinger.engr.sgi.com>
 <617E1C2C70743745A92448908E030B2A027C22D4@scsmsx411.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007, Luck, Tony wrote:

> > The quicklists have a long history and this bug has therefore also been in 
> > IA64 for a long time and it also likely exists on sparc64, sh and sh64. We 
> > need the patch that I posted to fix the other platforms. And with this fix 
> > there would be nothing amiss on x86_64 either.
> 
> IA64 doesn't do a pgd>pud>pmd>pte table walk in h/w.  The VHPT leaps
> straight to the pte page (through the virtual mapping of the VHPT). So
> this wasn't a problem for IA64.

But this is concerning a page being freed before the TLB flush has been 
performed. Another process may then reuse the page and may rely on the 
fact that there is no TLB entry installed for the page that was just 
allocated. But there is still one there. The issues that result from this 
may be depend on the nature of each MMU.

Granted we usually install another TLB entry for the page mapping the page 
into a different address space and never use the old TLB. Which is likely 
the reason why we have never seen an issue before and also why this is 
probably difficult to cause any issues in the first place.

Plus this can only occur for off node pages, meaning this must involve a 
remote processor and the other processor is likely to have a completely 
different set of TLB entries.
