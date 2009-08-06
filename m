Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbZHFKNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbZHFKNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 06:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbZHFKNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 06:13:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59498 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822AbZHFKNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 06:13:53 -0400
Message-ID: <4A7AAE07.1010202@redhat.com>
Date: Thu, 06 Aug 2009 13:18:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
References: <20090805024058.GA8886@localhost> <20090805155805.GC23385@random.random> <20090806100824.GO23385@random.random>
In-Reply-To: <20090806100824.GO23385@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2009 01:08 PM, Andrea Arcangeli wrote:
> After some conversation it seems reactivating on large systems
> generates troubles to the VM as young bit have excessive time to be
> reactivated, giving troubles to shrink active list. I see that, so
> then the check should be still nuked, but the unconditional
> deactivation should happen instead. Otherwise it's trivial to put the
> VM to its knees and DoS it with a simple mmap of a file with MAP_EXEC
> as parameter of mmap. My whole point is that deciding if activating or
> deactivating pages can't be in function  of VM_EXEC, and clearly it
> helps on desktops but then it probably is a signal that the VM isn't
> good enough by itself to identify the important working set using
> young bits and stuff on desktop systems, and if there's a good reason
> to not activate, we shouldn't activate the VM_EXEC either as anything
> and anybody can generate a file mapping with VM_EXEC set...
>    

Reasonable; if you depend on a hint from userspace, that hint can be 
used against you.

> Likely we need a cut-off point, if we detect it takes more than X
> seconds to scan the whole active list, we start ignoring young bits,
> as young bits don't provide any meaningful information then and they
> just hang the VM in preventing it to shrink active list and looping
> over it endlessy with million pages inside that list. But on small
> systems if inactive list is short it may be too quick to just clear
> the young bit and only giving it time to be re-enabled in inactive
> list. That may be the source of the problem. Actually I'm speculating
> here, because I barely understood that this is swapin... not sure
> exactly what this regression is about but testing the patch posted is
> good idea and it will tell us if we just need to dynamically
> differentiating the algorithm between large and small systems and start
> ignoring young bits only at some point.
>    

How about, for every N pages that you scan, evict at least 1 page, 
regardless of young bit status?  That limits overscanning to a N:1 
ratio.  With N=250 we'll spend at most 25 usec in order to locate one 
page to evict.


-- 
error compiling committee.c: too many arguments to function

