Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbYAVV1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbYAVV1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 16:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbYAVV06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 16:26:58 -0500
Received: from gir.skynet.ie ([193.1.99.77]:49730 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987AbYAVV05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 16:26:57 -0500
Date: Tue, 22 Jan 2008 21:26:54 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <clameter@sgi.com>
Cc: Olaf Hering <olaf@aepfle.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       hanth Aravamudan <nacc@us.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       lee.schermerhorn@hp.com, Linux MM <linux-mm@kvack.org>,
       akpm@linux-foundation.org
Subject: Re: crash in kmem_cache_init
Message-ID: <20080122212654.GB15567@csn.ul.ie>
References: <Pine.LNX.4.64.0801170628580.19208@schroedinger.engr.sgi.com> <20080117181222.GA24411@aepfle.de> <Pine.LNX.4.64.0801171049190.21058@schroedinger.engr.sgi.com> <20080117211511.GA25320@aepfle.de> <Pine.LNX.4.64.0801181043290.30348@schroedinger.engr.sgi.com> <20080118213011.GC10491@csn.ul.ie> <Pine.LNX.4.64.0801181414200.8924@schroedinger.engr.sgi.com> <20080118225713.GA31128@aepfle.de> <20080122195448.GA15567@csn.ul.ie> <Pine.LNX.4.64.0801221203340.27950@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801221203340.27950@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (22/01/08 12:11), Christoph Lameter didst pronounce:
> On Tue, 22 Jan 2008, Mel Gorman wrote:
> 
> > Christoph/Pekka, this patch is papering over the problem and something
> > more fundamental may be going wrong. The crash occurs because l3 is NULL
> > and the cache is kmem_cache so this is early in the boot process. It is
> > selecting l3 based on node 2 which is correct in terms of available memory
> > but it initialises the lists on node 0 because that is the node the CPUs are
> > located. Hence later it uses an uninitialised nodelists and BLAM. Relevant
> > parts of the log for seeing the memoryless nodes in relation to CPUs is;
> 
> Would it be possible to run the bootstrap on a cpu that has a 
> node with memory associated to it?

Not in the way the machine is currently configured. All the CPUs appear to
be on a node with no memory. It's best to assume I cannot get the machine
reconfigured (which just hides the bug anyway). Physically, it's thousands
of miles away so I can't do the work. I can get lab support to do the job
but that will take a fair while and at the end of the day, it doesn't tell
us a lot. We know that other PPC64 machines work so it's not a general problem.

> I believe we had the same situation 
> last year when GFP_THISNODE was introduced?
> 

It feels vaguely familiar but I don't recall the details in sufficient detail
to recognise if this is the same problem or not.

> After you reverted the slab memoryless node patch there should be per node 
> structures created for node 0 unless the node is marked offline. Is it? If 
> so then you are booting a cpu that is associated with an offline node. 
> 

I'll roll a patch that prints out the online states before startup and
see what it looks like.

> > Can you see a better solution than this?
> 
> Well this means that bootstrap will work by introducing foreign objects 
> into the per cpu queue (should only hold per cpu objects). They will 
> later be consumed and then the queues will contain the right objects so 
> the effect of the patch is minimal.
> 

By minimal, do you mean that you expect it to break in some other
respect later or minimal as in "this is bad but should not have no
adverse impact".

> I thought we fixed the similar situation last year by dropping 
> GFP_THISNODE for some allocations?
> 

Whatever this was a problem fixed in the past or not, it's broken again now
:( . It's possible that there is a __GFP_THISNODE that can be dropped early
at boot-time that would also fix this problem in a way that doesn't
affect runtime (like altering cache_grow in my patch does).

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
