Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbZCFR1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbZCFR1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 12:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbZCFR1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 12:27:03 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:51569 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbZCFR1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 12:27:01 -0500
Subject: Re: Regression - locking (all from 2.6.28)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, jan sonnek <ha2nny@gmail.com>,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <1236359888.3882.77.camel@pc1117.cambridge.arm.com>
References: <49AC334A.9030800@gmail.com>
	 <20090302121127.e46dc4be.akpm@linux-foundation.org>
	 <1236076864.8547.20.camel@pc1117.cambridge.arm.com>
	 <1236092480.8547.67.camel@pc1117.cambridge.arm.com>
	 <1236214452.22399.68.camel@nimitz>
	 <1236357616.3882.66.camel@pc1117.cambridge.arm.com>
	 <1236358369.10626.58.camel@nimitz>
	 <1236359888.3882.77.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 09:26:55 -0800
Message-Id: <1236360415.10626.67.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 17:18 +0000, Catalin Marinas wrote:
> > > Are the pgdat->node_start_pfn and pgdat->node_spanned_pages always
> > > valid? Thanks.
> > 
> > The variables themselves?  I'm sure there's a window in early boot where
> > they aren't valid, but other than that they should be OK unless you're
> > int the middle of a hotplug operation.
> > 
> > See pgdat_resize_(un)lock() in include/linux/memory_hotplug.h.
> 
> I wouldn't hold a lock for that long. It's not really critical to scan
> all the page structures at a time as there are subsequent scans as well,
> so some can be missed.

I think you should be more worried about consistency rather than missing
entries.  Take these two lines of code:

	start_pfn = node->node_start_pfn;
	/* hotplug occurs here */
	end_pfn = start_pfn + node->node_spanned_pages;

What if someone comes in and adds memory to the node, at the beginning
of the node, after you have calculated start_pfn?  Try to think of what
value you'll get for end_pfn and whether it is consistent and was *ever*
valid at all.  Would that oops the kernel?

-- Dave

