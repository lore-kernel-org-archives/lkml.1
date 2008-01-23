Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbYAWKw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbYAWKw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 05:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYAWKwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 05:52:50 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39315 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751834AbYAWKwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 05:52:49 -0500
Date: Wed, 23 Jan 2008 04:52:47 -0600
From: Robin Holt <holt@sgi.com>
To: Avi Kivity <avi@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrea Arcangeli <andrea@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       Andrew Morton <akpm@osdl.org>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, holt@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [kvm-devel] [PATCH] export notifier #1
Message-ID: <20080123105246.GG26420@sgi.com>
References: <478F9C9C.7070500@qumranet.com> <20080117193252.GC24131@v2.random> <20080121125204.GJ6970@v2.random> <4795F9D2.1050503@qumranet.com> <20080122144332.GE7331@v2.random> <20080122200858.GB15848@v2.random> <Pine.LNX.4.64.0801221232040.28197@schroedinger.engr.sgi.com> <20080122223139.GD15848@v2.random> <Pine.LNX.4.64.0801221433080.2271@schroedinger.engr.sgi.com> <479716AD.5070708@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479716AD.5070708@qumranet.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 12:27:57PM +0200, Avi Kivity wrote:
>> The approach with the export notifier is page based not based on the
>> mm_struct. We only need a single page count for a page that is exported to
>> a number of remote instances of linux. The page count is dropped when all
>> the remote instances have unmapped the page.
>
> That won't work for kvm.  If we have a hundred virtual machines, that means
> 99 no-op notifications.

But 100 callouts holding spinlocks will not work for our implementation
and even if the callouts are made with spinlocks released, we would very
strongly prefer a single callout which messages the range to the other
side.

> Also, our rmap key for finding the spte is keyed on (mm, va).  I imagine
> most RDMA cards are similar.

For our RDMA rmap, it is based upon physical address.

>> There is only the need to walk twice for pages that are marked Exported.
>> And the double walk is only necessary if the exporter does not have its
>> own rmap. The cross partition thing that we are doing has such an rmap and
>> its a matter of walking the exporters rmap to clear out the external
>> references and then we walk the local rmaps. All once.
>>
>
> The problem is that external mmus need a reverse mapping structure to
> locate their ptes.  We can't expand struct page so we need to base it on mm
> + va.

Our rmap takes a physical address and turns it into mm+va.

> Can they wait on that bit?

PageLocked(page) should work, right?  We already have a backoff
mechanism so we expect to be able to adapt it to include a
PageLocked(page) check.


Thanks,
Robin
