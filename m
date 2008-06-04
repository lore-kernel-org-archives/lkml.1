Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbYFDFGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbYFDFGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 01:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbYFDFGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 01:06:24 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38838 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbYFDFGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 01:06:23 -0400
Date: Wed, 04 Jun 2008 14:05:48 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: David Miller <davem@davemloft.net>
Subject: Re: sparc64 bootup regression...
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com
In-Reply-To: <20080603.151416.266389541.davem@davemloft.net>
References: <20080430213831.F808.E1E9C6FF@jp.fujitsu.com> <20080603.151416.266389541.davem@davemloft.net>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080604112717.9792.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David-san.

Thank you for your concern. I'm very glad.

> > I'll reconsider around here.
> 
> I think I know at least one of the problems in this change.
> 
> This code assumes that it can take __pa() on NODE_DATA().
> 
> But, if NUMA is disabled, NODE_DATA() is &contig_page_data which is a
> kernel image symbol.  __pa() is not supported for such addresses.
> 
> It happens to work on x86, but it will not work on just about every
> other platform.
> 
> There are several things to consider to fix this changeset and
> get it back into a state where it can be resubmitted into the
> tree:
> 
> 1) What is the goal here wrt. allocating the usemap when NUMA
>    is disabled.
> 
> 2) What is appropriate if section_nr targetted allocation of
>    the usemap fails.
> 
> It seems to me that the pgdat and usemap should be allocated
> together if putting them into the same section is important.
> This allows us to avoid case #2 completely, and therefore we
> don't even need to consider how to handle such a failure.

Basically, this is for memory hot-remove feature.
Pgdat's section and usemap section can't be removed until
that all other section are removed.
If usemap is allocated another section from pgdat,
both section's can't be removed due to each other dependency.
So, I would like to allocate them on the same section to
remove whole of node completely.

IIRC, some of architecture (like powerpc) allow un-removable section,
because its box will gather -removable- sections and pass them to
other "partition" via "dynamic logical partitioning" feature.
Especially, powerpc's section size is very small, this allocation failure
may often occur than I thought.

In this case, usemap should be allocated on another section and
kernel should just show message of unremovable sections.
I think it would be simple workaround.

Just I didn't notice the case of sparsemem with non-NUMA.
So, it should be fixed.

Ok. Now I have some internal works for my company in this week.
And I would like to help clean up of bootmem before this.
But, I'll fix this next week. Sorry for late.

Thanks.

-- 
Yasunori Goto 

