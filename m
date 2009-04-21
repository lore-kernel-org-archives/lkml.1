Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbZDUQm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbZDUQm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756907AbZDUQjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:39:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756906AbZDUQjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:39:52 -0400
Date: Tue, 21 Apr 2009 09:31:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Oleg Nesterov <oleg@redhat.com>
cc: Hugh Dickins <hugh@veritas.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Q: check_unsafe_exec() races (Was: [PATCH 2/4] fix setuid
 sometimes doesn't)
In-Reply-To: <20090421161006.GC5402@redhat.com>
Message-ID: <alpine.LFD.2.00.0904210924270.2199@localhost.localdomain>
References: <20090330013612.GA4080@redhat.com> <20090330014040.GA4807@redhat.com> <20090330123101.GQ28946@ZenIV.linux.org.uk> <Pine.LNX.4.64.0903301506310.11454@blonde.anvils> <20090331061615.GS28946@ZenIV.linux.org.uk> <Pine.LNX.4.64.0904010106310.16500@blonde.anvils>
 <20090401023849.GW28946@ZenIV.linux.org.uk> <20090401030339.GX28946@ZenIV.linux.org.uk> <20090406153127.GA21220@redhat.com> <Pine.LNX.4.64.0904191710320.9099@blonde.anvils> <20090421161006.GC5402@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Apr 2009, Oleg Nesterov wrote:
> 
> > (You do rcu_read_unlock() earlier, but that's okay.)
> 
> Yes, but unless we have a "strong" reason, it is better to take
> fs->lock first. rcu_read_lock() is free, but disables preemption.

.. but so does taking a spinlock. So it shouldn't matter.

We could play games with that (the same way I think we have some games for 
large-system irq latency with '__raw_spin_lock_flags()' on ia64), but that 
makes sense only when you have lots of CPU's and expect irq latency to 
suffer. 

And it doesn't tend to make sense for preemption latency, because if you 
have so many CPU's that you have lots of spinning on locks, you would 
normally not really care deeply about preemption (sure, in theory it's a 
real-time thing, in practice I doubt you'll find anybody who cares).

			Linus
