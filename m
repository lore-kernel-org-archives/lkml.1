Return-Path: <linux-kernel-owner+w=401wt.eu-S1763563AbXJETke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763563AbXJETke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760419AbXJETkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:40:21 -0400
Received: from gw.goop.org ([64.81.55.164]:42764 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759232AbXJETkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:40:19 -0400
Message-ID: <47069315.8030802@goop.org>
Date: Fri, 05 Oct 2007 12:40:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Hugh Dickins <hugh@veritas.com>, David Rientjes <rientjes@google.com>,
       Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Keir Fraser <keir@xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: race with page_referenced_one->ptep_test_and_clear_young and
 pagetable setup/pulldown
References: <470596C4.8060804@goop.org>	<Pine.LNX.4.64.0710051146300.25518@blonde.wat.veritas.com> <20071005145828.17ba9c69@cuia.boston.redhat.com>
In-Reply-To: <20071005145828.17ba9c69@cuia.boston.redhat.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> This makes for a narrow race window, during which ptep_test_and_clear_young
> cannot clear the referenced bit and may end up causing a crash.  We do not
> care about it not clearing the referenced bit during that window, since it
> will be cleared during the next go-around and the race is very rare.
>   

Is this the only possible case?  It's just the one I found while testing
under high memory pressure.

> Hence, the only thing we need to fix is the crash.
>
> We can do that by adding an entry for ptep_test_and_clear_young to the
> exception table.  This way we do not need to turn this into a new paravirt
> ops hook (since the fast path is exactly the same as x86 native) and there
> is no need for added complexity.
>
> Also, Xen would not conflict with SPLIT_PTLOCK_CPUS.
>   

Well, isn't the correct fix to make Xen take all the pagetable locks
while pinning/unpinning?  Adding exception handling to
test_and_clear_bit would solve this particular race, but are there
others (either now or potentially)?  Seems fragile.

    J
