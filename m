Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbZCFSBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbZCFSBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZCFSBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:01:33 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:33476 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbZCFSBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:01:33 -0500
Subject: Re: Regression - locking (all from 2.6.28)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, jan sonnek <ha2nny@gmail.com>,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <1236360415.10626.67.camel@nimitz>
References: <49AC334A.9030800@gmail.com>
	 <20090302121127.e46dc4be.akpm@linux-foundation.org>
	 <1236076864.8547.20.camel@pc1117.cambridge.arm.com>
	 <1236092480.8547.67.camel@pc1117.cambridge.arm.com>
	 <1236214452.22399.68.camel@nimitz>
	 <1236357616.3882.66.camel@pc1117.cambridge.arm.com>
	 <1236358369.10626.58.camel@nimitz>
	 <1236359888.3882.77.camel@pc1117.cambridge.arm.com>
	 <1236360415.10626.67.camel@nimitz>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 06 Mar 2009 18:00:36 +0000
Message-Id: <1236362436.3882.80.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2009 18:00:51.0006 (UTC) FILETIME=[7C4D75E0:01C99E85]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 09:26 -0800, Dave Hansen wrote:
> On Fri, 2009-03-06 at 17:18 +0000, Catalin Marinas wrote:
> > > > Are the pgdat->node_start_pfn and pgdat->node_spanned_pages always
> > > > valid? Thanks.
> > > 
> > > The variables themselves?  I'm sure there's a window in early boot where
> > > they aren't valid, but other than that they should be OK unless you're
> > > int the middle of a hotplug operation.
> > > 
> > > See pgdat_resize_(un)lock() in include/linux/memory_hotplug.h.
> > 
> > I wouldn't hold a lock for that long. It's not really critical to scan
> > all the page structures at a time as there are subsequent scans as well,
> > so some can be missed.
> 
> I think you should be more worried about consistency rather than missing
> entries.  Take these two lines of code:
> 
> 	start_pfn = node->node_start_pfn;
> 	/* hotplug occurs here */
> 	end_pfn = start_pfn + node->node_spanned_pages;
> 
> What if someone comes in and adds memory to the node, at the beginning
> of the node, after you have calculated start_pfn?  Try to think of what
> value you'll get for end_pfn and whether it is consistent and was *ever*
> valid at all.  Would that oops the kernel?

I assume pfn_valid() should handle this and kmemleak wouldn't scan the
page, unless we need locks around pfn_valid as well but I haven't seen
any used in the kernel.

-- 
Catalin

