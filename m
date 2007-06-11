Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbXFKW0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbXFKW0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 18:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbXFKW0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 18:26:12 -0400
Received: from ns1.suse.de ([195.135.220.2]:49754 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbXFKW0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 18:26:10 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
Date: Tue, 12 Jun 2007 00:25:57 +0200
User-Agent: KMail/1.9.6
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       shaohua.li@intel.com, davem@davemloft.net
References: <20070606185658.138237000@askeshav-devel.jf.intel.com> <200706091147.24705.ak@suse.de> <20070611204442.GA4074@linux-os.sc.intel.com>
In-Reply-To: <20070611204442.GA4074@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706120025.58137.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Please advice.

I think the short term only safe option would be to fully preallocate an aperture.
If it is too small you can try GFP_ATOMIC but it would be just
a unreliable fallback. For safety you could perhaps have some kernel thread
that tries to enlarge it in the background depending on current
use. That would be not 100% guaranteed to keep up with load,
but would at least keep up if the system is not too busy.

That is basically what your resource pools do, but they seem
to be unnecessarily convoluted for the task :- after all you
could just preallocate the page tables and rewrite/flush them without
having some kind of allocator inbetween, can't you?

If you make the start value large enough (256+MB?) that might reasonably
work. How much memory in page tables would that take? Or perhaps scale
it with available memory or available devices. 

In theory it could also be precomputed from the block/network device queue 
lengths etc.; the trouble is just such checks would need to be added to all kinds of 
other odd subsystems that manage devices too.  That would be much more work.

Some investigation how to do sleeping block/network submit would be
also interesting (e.g. replace the spinlocks there with mutexes and see how
much it affects performance). For networking you would need to keep 
at least a non sleeping path though because packets can be legally
submitted from interrupt context. If it works out then sleeping
interfaces to the IOMMU code could be added.

-Andi
