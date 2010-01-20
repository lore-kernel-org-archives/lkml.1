Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687Ab0ATUyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab0ATUyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453Ab0ATUyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:54:08 -0500
Received: from gir.skynet.ie ([193.1.99.77]:40895 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193Ab0ATUyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:54:01 -0500
Date: Wed, 20 Jan 2010 20:53:49 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 5/7] Add /proc trigger for memory compaction
Message-ID: <20100120205348.GG5154@csn.ul.ie>
References: <1262795169-9095-1-git-send-email-mel@csn.ul.ie> <1262795169-9095-6-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1001071352100.23894@chino.kir.corp.google.com> <20100120094813.GC5154@csn.ul.ie> <alpine.DEB.2.00.1001201211020.14342@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1001201211020.14342@router.home>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 12:12:55PM -0600, Christoph Lameter wrote:
> On Wed, 20 Jan 2010, Mel Gorman wrote:
> 
> > True, although the per-node structures are only available on NUMA making
> > it necessary to have two interfaces. The per-node one is handy enough
> > because it would be just
> >
> > /sys/devices/system/node/nodeX/compact_node
> > 	When written to, this node is compacted by the writing process
> >
> > But there does not appear to be a "good" way of having a non-NUMA
> > interface. /sys/devices/system/node does not exist .... Does anyone
> > remember why !NUMA does not have a /sys/devices/system/node/node0? Is
> > there a good reason or was there just no point?
> 
> We could create a fake node0 for the !NUMA case I guess?

I would like to but I have the same concerns as you about programs or scripts
assuming the existence of /sys/devices/system/node/ imples NUMA.

> Dont see a major
> reason why not to do it aside from scripts that may check for the presence
> of the file to switch to a "NUMA" mode.
> 

That would suck royally and unfortunately it's partly the case with libnuma
at least. Well, not the library itself but one of the utilities.

numa_available() is implemented by checking the return value of get_mempolicy()
so it's ok.

It checks the max configured node by parsing the contents of the
/sys/devices/system/node/ directory so that should also be ok as long as
the UMA node is 0.

However, the numastat script is a perl script that makes assumptions on
NUMA versus UMA depending on the existence of the sysfs directory. If it
exists, it parses numastat. While this would be faked as well, we're
talking about adding a fair amount of fakery in there and still end up
with a behaviour change. Previously, the script would have identified
the system was not NUMA aware and afterwards, it prints out meaningless
values.

Not sure how great an option that is :(

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
