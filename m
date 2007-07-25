Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbXGYGS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbXGYGS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 02:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762796AbXGYGSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 02:18:50 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:36693 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753348AbXGYGSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 02:18:49 -0400
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
From: Eric St-Laurent <ericstl34@sympatico.ca>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Fengguang Wu <fengguang.wu@gmail.com>, Dave Jones <davej@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tim Pepper <lnxninja@us.ibm.com>, Chris Snook <csnook@redhat.com>
In-Reply-To: <46A6DD7F.1050505@yahoo.com.au>
References: <20070721210005.000228000@chello.nl>
	 <20070722023923.GA6438@mail.ustc.edu.cn> <20070722024428.GA724@redhat.com>
	 <20070722081010.GA6317@mail.ustc.edu.cn>
	 <1185093236.6344.87.camel@localhost.localdomain>
	 <46A46E4B.7050007@yahoo.com.au> <1185338106.7105.44.camel@perkele>
	 <46A6DD7F.1050505@yahoo.com.au>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 02:18:45 -0400
Message-Id: <1185344325.7105.91.camel@perkele>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-25-07 at 15:19 +1000, Nick Piggin wrote:

> What *I* think is supposed to happen is that newly read in pages get
> put on the inactive list, and unless they get accessed againbefore
> being reclaimed, they are allowed to fall off the end of the list
> without disturbing active data too much.
> 
> I think there is a missing piece here, that we used to ease the reclaim
> pressure off the active list when the inactive list grows relatively
> much larger than it (which could indicate a lot of use-once pages in
> the system).

Maybe a new list should be added to put newly read pages in it. If they
are not used or used once after a certain period, they can be moved to
the inactive list (or whatever).

Newly read pages...

- ... not used after this period are excessive readahead, we discard
immediately.
- ... used only once after this period, we discard soon.
- ... used many/frequently are moved to active list.

Surely the scan rate (do I make sense?) should be different for this
newly-read list and the inactive list. 

I also remember your split mapped/unmapped active list patches from a
while ago.

Can someone point me to a up-to-date documentation about the Linux VM?
The books and documents I've seen are outdated.

> I think I've been banned from touching vmscan.c, but if you're keen to
> try a patch, I might be convinced to come out of retirement :)

I'm more than willing!  Now that CFS is merged, redirect your energies
from nicksched to nick-vm ;)

Patches against any tree (stable, linus, mm, rt) are good. But I prefer
the last stable release because it narrows down the possible problems
that a moving target like the development tree may have.

I test this on my main system, so patches with basic testing and
reasonable stability are preferred. I just want to avoid data corruption
bugs. FYI, I used to run the -rt tree most of the time.

> One man's trash is another's treasure: some people will want the
> files to remain in cache because they'll use them again (copy it
> somewhere else, or start editing it after being copied or whatever).
> 
> But yeah, we can probably do better at the sequential read/write
> case.

Sure, but there are many hints to detect this: *large* (> most of the
RAM), *streaming*, *used once*

But if a program mmap() a 3/4 of the RAM area and "play" in it, it's a
good sign that the streaming code shouldn't be active.



- Eric


