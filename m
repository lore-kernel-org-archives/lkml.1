Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbZHMTMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbZHMTMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755383AbZHMTMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:12:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34224 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbZHMTMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:12:41 -0400
Message-ID: <4A846581.2020304@redhat.com>
Date: Thu, 13 Aug 2009 22:12:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
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
References: <20090806100824.GO23385@random.random> <4A7AD5DF.7090801@redhat.com> <20090807121443.5BE5.A69D9226@jp.fujitsu.com> <20090812074820.GA29631@localhost> <4A82D24D.6020402@redhat.com> <20090813010356.GA7619@localhost> <4A843565.3010104@redhat.com> <4A843B72.6030204@redhat.com> <4A843EAE.6070200@redhat.com>
In-Reply-To: <4A843EAE.6070200@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2009 07:26 PM, Rik van Riel wrote:
>> Why do we need to ignore the referenced bit in such cases?  To avoid 
>> overscanning?
>
>
> Because swapping out anonymous pages tends to be a relatively
> rare operation, we'll have many gigabytes of anonymous pages
> that all have the referenced bit set (because there was lots
> of time between swapout bursts).
>
> Ignoring the referenced bit on active anon pages makes no
> difference on these systems, because all active anon pages
> have the referenced bit set, anyway.
>
> All we need to do is put the pages on the inactive list and
> give them a chance to get referenced.
>
> However, on smaller systems (and cgroups!), the speed at
> which we can do pageout IO is larger, compared to the amount
> of memory.  This means we can cycle through the pages more
> quickly and we may want to count references on the active
> list, too.
>
> Yes, on smaller systems we'll also often end up with bursty
> swapout loads and all pages referenced - but since we have
> fewer pages to begin with, it won't hurt as much.
>
> I suspect that an inactive_ratio of 3 or 4 might make a
> good cutoff value.
>

Thanks for the explanation.  I think my earlier idea of

- do not ignore the referenced bit
- if you see a run of N pages which all have the referenced bit set, do 
swap one

has merit.  It means we cycle more quickly (by a factor of N) through 
the list, looking for unreferenced pages.  If we don't find any we've 
spent a some more cpu, but if we do find an unreferenced page, we win by 
swapping a truly unneeded page.

Cycling faster also means reducing the time between examinations of any 
particular page, so it increases the meaningfulness of the check on 
large systems (otherwise even rarely used pages will always show up as 
referenced).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

