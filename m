Return-Path: <linux-kernel-owner+w=401wt.eu-S932076AbZJFJPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbZJFJPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 05:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756724AbZJFJPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 05:15:42 -0400
Received: from smtp-out.google.com ([216.239.45.13]:14404 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719AbZJFJPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 05:15:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=i4/RTHa1+UvvuxR02pIFPjYLkUqe2vOQ9rWqFMWU+rIiCspkkYzcPzHLTa0hOVoKL
	1XtR6nbNB3f3FKR6cwupQ==
Date: Tue, 6 Oct 2009 02:14:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>, linux-mm@kvack.org
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
In-Reply-To: <20091006085345.GA18185@csn.ul.ie>
Message-ID: <alpine.DEB.1.00.0910060210320.24787@chino.kir.corp.google.com>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <200910050851.02056.elendil@planet.nl> <20091005085739.GB5452@csn.ul.ie> <200910052334.23833.elendil@planet.nl> <alpine.DEB.1.00.0910051700440.31688@chino.kir.corp.google.com>
 <20091006085345.GA18185@csn.ul.ie>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009, Mel Gorman wrote:

> > > And the winner is:
> > > 2ff05b2b4eac2e63d345fc731ea151a060247f53 is first bad commit
> > > commit 2ff05b2b4eac2e63d345fc731ea151a060247f53
> > > Author: David Rientjes <rientjes@google.com>
> > > Date:   Tue Jun 16 15:32:56 2009 -0700
> > > 
> > >     oom: move oom_adj value from task_struct to mm_struct
> > > 
> > > I'm confident that the bisection is good. The test case was very reliable 
> > > while zooming in on the merge from akpm.
> > > 
> > 
> > I doubt it for two reasons: (i) this commit was reverted in 0753ba0 since 
> > 2.6.31-rc7 and is no longer in the kernel, and (ii) these are GFP_ATOMIC 
> > allocations which would be unaffected by oom killer scores.
> > 
> 
> However, the problem was reported to start showing up in 2.6.31-rc1 so
> while it might not be *the* patch, it might be making the type of change
> that caused more fragmentation. This patch adjusted the size of
> mm_struct and maybe it was enough to change the "order" required for the
> slab. Maybe there are other slabs that have changed size as well in that
> timeframe.
> 
> Frans, what is the size of mm_struct before and after this patch was
> applied? Find it with either
> 
> grep mm_struct /proc/slabinfo
> 
> and if the information is not available there, try
> 
> cat /sys/kernel/slab/mm_struct/slab_size and
> /sys/kernel/slab/mm_struct/order
> 

If that's the case and the problem still persists in 2.6.31-rc7 as 
reported, then you'd need to compare the current slab order for both 
mm_struct and signal_struct to the previously known working kernel 
since the latter is where oom_adj was moved.  (You'd still have to check 
the former to see if there were any mm_struct additions between rc1 and 
rc7 between the commit and revert, though.)
