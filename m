Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbZIVIpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbZIVIpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 04:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZIVIpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 04:45:04 -0400
Received: from smtp-out.google.com ([216.239.45.13]:15687 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbZIVIpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 04:45:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=xeEF/ZXq7bvreS/ddoBxCbSvU5QS5u1VmBDWVCU32lj3+YuJDDXbb0ovL1XTXIOOn
	6R2ovQgJ/ZX7IMumpSA4A==
Date: Tue, 22 Sep 2009 01:44:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [RFC PATCH 0/3] Fix SLQB on memoryless configurations V2
In-Reply-To: <1253607077.7103.219.camel@pasglop>
Message-ID: <alpine.DEB.1.00.0909220132250.19097@chino.kir.corp.google.com>
References: <1253549426-917-1-git-send-email-mel@csn.ul.ie> <1253577603.7103.174.camel@pasglop> <alpine.DEB.1.00.0909211704180.4798@chino.kir.corp.google.com> <alpine.DEB.1.10.0909220227050.3719@V090114053VZO-1> <alpine.DEB.1.00.0909220023070.9061@chino.kir.corp.google.com>
 <1253607077.7103.219.camel@pasglop>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009, Benjamin Herrenschmidt wrote:

> While I like the idea of NUMA nodes being strictly memory and everything
> else being expressed by distances, we'll have to clean up quite a few
> corners with skeletons in various states of decompositions waiting for
> us there.
> 

Agreed, it's invasive.

> For example, we have code here or there that (ab)uses the NUMA node
> information to link devices with their iommu, that sort of thing. IE, a
> hard dependency which isn't really related to a concept of distance to
> any memory.
> 

ACPI's slit uses a distance of 0xff to specify that one locality is 
unreachable from another.  We could easily adopt that convention.

> At least on powerpc, nowadays, I can pretty much make everything
> fallback to some representation in the device-tree though, thus it
> shouldn't be -that- hard to fix I suppose.
> 

Cool, that's encouraging.

I really think that this type of abstraction would make things simpler in 
the long term.  For example, I just finished fixing a bug in tip where 
cpumask_of_pcibus() wasn't returning cpu_all_mask for busses without any 
affinity on x86.  This was a consequence of cpumask_of_pcibus() being 
forced to rely on pcibus_to_node() since there is no other abstraction 
available.  For busses without affinity to any specific cpus, the 
implementation had relied on returning the mapping's default node of -1 to 
represent all cpus.  That type of complexity could easily be avoided if 
the bus was isolated into its own locality and the mapping to all cpu 
localities was of local distance.
