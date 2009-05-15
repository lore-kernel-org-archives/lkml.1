Return-Path: <linux-kernel-owner+w=401wt.eu-S1761750AbZEOKvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761750AbZEOKvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 06:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759629AbZEOKvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 06:51:38 -0400
Received: from relay1.sgi.com ([192.48.179.29]:53898 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759509AbZEOKvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 06:51:37 -0400
Date: Fri, 15 May 2009 05:51:37 -0500
From: Robin Holt <holt@sgi.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 4/4] zone_reclaim_mode is always 0 by default
Message-ID: <20090515105137.GO7601@sgi.com>
References: <20090513152256.GM7601@sgi.com> <alpine.DEB.1.10.0905141602010.1381@qirst.com> <20090515082836.F5B9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515082836.F5B9.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Current linux policy is, zone_reclaim_mode is enabled by default if the machine
> has large remote node distance. it's because we could assume that large distance 
> mean large server until recently.
> 
> Unfortunately, recent modern x86 CPU (e.g. Core i7, Opeteron) have P2P transport
> memory controller. IOW it's seen as NUMA from software view.
> 
> Some Core i7 machine has large remote node distance, but zone_reclaim don't
> fit desktop and small file server. it cause performance degression.
> 
> Thus, zone_reclaim == 0 is better by default if the machine is small.

What if I had a node 0 with 32GB or 128GB of memory.  In that case,
we would have 3GB for DMA32, 125GB for Normal and then a node 1 with
128GB.  I would suggest that zone reclaim would perform normally and
be beneficial.

You are unfairly classifying this as a size of machine problem when it is
really a problem with the underlying zone reclaim code being triggered
due to imbalanced node/zones, part of which is due to a single node
having multiple zones and those multiple zones setting up the conditions
for extremely agressive reclaim.  In other words, you are putting a
bandage in place to hide a problem on your particular hardware.

Can RECLAIM_DISTANCE be adjusted so your Ci7 boxes are no longer caught?
Aren't 4 node Ci7 boxes soon to be readily available?  How are your apps
different from my apps in that you are not impacted by node locality?
Are you being too insensitive to node locality?  Conversely am I being
too sensitive?

All that said, I would not stop this from going in.  I just think the
selection criteria is rather random.  I think we know the condition we
are trying to avoid which is a small Normal zone on one node and a larger
Normal zone on another causing zone reclaim to be overly agressive.
I don't know how to quantify "small" versus "large".  I would suggest
that a node 0 with 16 or more GB should have zone reclaim on by default
as well.  Can that be expressed in the selection criteria.

Thanks,
Robin Holt
