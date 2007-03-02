Return-Path: <linux-kernel-owner+w=401wt.eu-S1422803AbXCBFN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422803AbXCBFN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 00:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422811AbXCBFN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 00:13:27 -0500
Received: from gw.goop.org ([64.81.55.164]:47798 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422803AbXCBFN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 00:13:26 -0500
Message-ID: <45E7B276.3020504@goop.org>
Date: Thu, 01 Mar 2007 21:13:26 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Balbir Singh <balbir@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@skynet.ie>,
       npiggin@suse.de, clameter@engr.sgi.com, mingo@elte.hu,
       jschopp@austin.ibm.com, arjan@infradead.org, mbligh@mbligh.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
References: <20070301101249.GA29351@skynet.ie> <20070301160915.6da876c5.akpm@linux-foundation.org> <Pine.LNX.4.64.0703011642190.12485@woody.linux-foundation.org> <45E7835A.8000908@in.ibm.com> <Pine.LNX.4.64.0703011939120.12485@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703011939120.12485@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Virtualization in general. We don't know what it is - in IBM machines it's 
> a hypervisor. With Xen and VMware, it's usually a hypervisor too. With 
> KVM, it's obviously a host Linux kernel/user-process combination.
>
> The point being that in the guests, hotunplug is almost useless (for 
> bigger ranges), and we're much better off just telling the virtualization 
> hosts on a per-page level whether we care about a page or not, than to 
> worry about fragmentation.
>
> And in hosts, we usually don't care EITHER, since it's usually done in a 
> hypervisor.
>   

The paravirt_ops patches I just posted implement all the machinery
required to create a pseudo-physical to machine address mapping under
the kernel.  This is used under Xen because it directly exposes the
pagetables to its guests, but there's no reason why you couldn't use
this layer to implement the same mapping without an underlying
hypervisor.  This allows the kernel to see a normal linear "physical"
address space which is in fact its mapped over a discontigious set of
machine ("real physical") pages.

Andrew and I discussed using it for a kdump kernel, so that you could
load it into a random bunch of pages, and set things up so that it sees
itself as being contiguous.

The mapping is pretty simple.  It intercepts __pte (__pmd, etc) to map
the "physical" page to the real machine page, and pte_val does the
reverse mapping.

You could implement this today as a farily simple, thin paravirt_ops
backend.  The main tricky part is making sure all the device drivers are
correct in using bus addresses (which are mapped to real machine
addresses), and that they don't assume that adjacent kernel virtual
pages are physically adjacent.

    J
