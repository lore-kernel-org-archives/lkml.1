Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbZHMQ1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbZHMQ1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 12:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZHMQ1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 12:27:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37552 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbZHMQ1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 12:27:03 -0400
Message-ID: <4A843EAE.6070200@redhat.com>
Date: Thu, 13 Aug 2009 12:26:22 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Wu Fengguang <fengguang.wu@intel.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
References: <20090806100824.GO23385@random.random> <4A7AD5DF.7090801@redhat.com> <20090807121443.5BE5.A69D9226@jp.fujitsu.com> <20090812074820.GA29631@localhost> <4A82D24D.6020402@redhat.com> <20090813010356.GA7619@localhost> <4A843565.3010104@redhat.com> <4A843B72.6030204@redhat.com>
In-Reply-To: <4A843B72.6030204@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 08/13/2009 06:46 PM, Rik van Riel wrote:
>> We need to ignore the referenced bit on active anon pages
>> on very large systems, but it could indeed be helpful to
>> respect the referenced bit on smaller systems.
>>
>> I have no idea where the cut-off between them would be.
>>
>> Maybe at inactive_ratio <= 4 ?
> 
> Why do we need to ignore the referenced bit in such cases?  To avoid 
> overscanning?

Because swapping out anonymous pages tends to be a relatively
rare operation, we'll have many gigabytes of anonymous pages
that all have the referenced bit set (because there was lots
of time between swapout bursts).

Ignoring the referenced bit on active anon pages makes no
difference on these systems, because all active anon pages
have the referenced bit set, anyway.

All we need to do is put the pages on the inactive list and
give them a chance to get referenced.

However, on smaller systems (and cgroups!), the speed at
which we can do pageout IO is larger, compared to the amount
of memory.  This means we can cycle through the pages more
quickly and we may want to count references on the active
list, too.

Yes, on smaller systems we'll also often end up with bursty
swapout loads and all pages referenced - but since we have
fewer pages to begin with, it won't hurt as much.

I suspect that an inactive_ratio of 3 or 4 might make a
good cutoff value.

-- 
All rights reversed.
