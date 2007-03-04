Return-Path: <linux-kernel-owner+w=401wt.eu-S932964AbXCDQCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964AbXCDQCD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 11:02:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932955AbXCDQCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 11:02:03 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932964AbXCDQCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 11:02:02 -0500
Message-ID: <45EAED6A.9090706@redhat.com>
Date: Sun, 04 Mar 2007 11:01:46 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>	<45E9DD4A.2060806@redhat.com>	<20070303131204.6706a95c.akpm@linux-foundation.org>	<45E9E910.2070804@redhat.com>	<20070303140744.b22699dd.akpm@linux-foundation.org>	<45E9F5DA.2070708@redhat.com>	<20070303145221.2a42cc0f.akpm@linux-foundation.org>	<45EA0C3D.1010001@redhat.com>	<20070303170237.31d26382.akpm@linux-foundation.org>	<45EA1F7B.9060107@redhat.com>	<20070303174927.2d314a71.akpm@linux-foundation.org>	<45EA274B.5090103@redhat.com> <20070304040742.e56fc57f.akpm@linux-foundation.org>
In-Reply-To: <20070304040742.e56fc57f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 03 Mar 2007 20:56:27 -0500 Rik van Riel <riel@redhat.com> wrote:
> 
>> Andrew Morton wrote:
>>
>>>>> Doing a refault thing would help a bit, but stops working at a certain point.
>>>> At what point does it stop working?
>>> We need to store that this-page-got-reclaimed info somewhere.  I don't know
>>> how space-efficient that is.  Did anyone ever do an implementation?
>> One 32 bit word per evicted page that we keep track of.
> 
> ok...
> 
> I wonder if we really need a new data structure to track that.  I mean,
> once a file-backed (or indeed swapcache) page has been reclaimed, its
> radix-tree slot is just sitting there with zeroes in it, asking us to reuse
> that space for something interesting, no?
> 
> Of course, if all 64 pages in a radix-tree node get removed, we'll
> currently free the node itself.  We could stop doing that, but the effects
> of that might be pretty bad sometimes.  Instead, it sounds sensible to
> populate the now-null slot in the parent radix-tree node with an
> average/max/min/per-child-bitmap/whatever of the metrics for the 64
> non-resident pages which that non-leaf slot represents.  So as the period
> since a single page got evicted increases and increases, our information
> about its state becomes less and less accurate.
> 
> If that inaccuracy is a problem then perhaps we could defer the collapsing
> of a now-empty node into its parent in some manner.

We know exactly how far to defer that collapsing, too.

We know at what rate we rotate through the active list,
and the size of the active list.

We also know the rate at which we reclaim pages, and
the size of the inactive list.

Combine the two, and you have an idea roughly how many
page faults there are between the accesses to the coldest
page on the active list.

We don't have to keep the evicted page history beyond
that point, because pages that get refaulted after such
a long interval have a longer inter-reference distance
and should go onto the inactive list - ie. the default
list for unknown pages.

>> If you can find holes in http://linux-mm.org/PageReplacementDesign
>> please let me know :)
> 
> That all looks pretty non-crazy and implementable to me.  Alas, getting the
> stuff written and working is 1% of the effort.  The rest is the nasty hunt
> for new corner-cases and general productisation hassle.  But if initial
> results show benefit, I expect we could manage all that.

True, but I've looked through a few hundred VM bugzillas
to validate the design against all the common corner cases,
all the way from RHEL3 (which also has split anon/file
lists) through today.

I'm trying to keep the known-good bits of our policy as
much as possible, introducing big changes only for those
corner cases that plagued multiple VMs in the past.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
