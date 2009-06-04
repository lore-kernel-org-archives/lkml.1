Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbZFDBmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbZFDBmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 21:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbZFDBmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 21:42:15 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58771 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbZFDBmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 21:42:13 -0400
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Tejun Heo <tj@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 18/23] vfs: Teach epoll to use file_hotplug_lock
References: <m1oct739xu.fsf@fess.ebiederm.org>
	<1243893048-17031-18-git-send-email-ebiederm@xmission.com>
	<alpine.DEB.1.10.0906020944540.12866@makko.or.mcafeemobile.com>
	<m1eiu2qqho.fsf@fess.ebiederm.org>
	<alpine.DEB.1.10.0906021429570.12866@makko.or.mcafeemobile.com>
	<m13aaintb1.fsf@fess.ebiederm.org>
	<alpine.DEB.1.10.0906030754550.17143@makko.or.mcafeemobile.com>
	<m1tz2xox7n.fsf@fess.ebiederm.org>
	<alpine.DEB.1.10.0906031708480.18001@makko.or.mcafeemobile.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 03 Jun 2009 18:42:07 -0700
In-Reply-To: <alpine.DEB.1.10.0906031708480.18001@makko.or.mcafeemobile.com> (Davide Libenzi's message of "Wed\, 3 Jun 2009 17\:50\:01 -0700 \(PDT\)")
Message-ID: <m11vq0bwr4.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: davidel@xmailserver.org, ebiederm@aristanetworks.com, hch@infradead.org, akpm@linux-foundation.org, npiggin@suse.de, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, adobriyan@gmail.com, tj@kernel.org, hugh@veritas.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi <davidel@xmailserver.org> writes:

> On Wed, 3 Jun 2009, Eric W. Biederman wrote:
>
>> What code are you talking about?
>> 
>> To the open path a few memory writes and a smp_wmb.  No atomics and no
>> spin lock/unlocks.
>> 
>> Are you complaining because I retain the file_list?
>
> Sorry, did I overlook the patch? Weren't a couple of atomic ops and a spin 
> lock/unlock couple present in __dentry_open() (same sort of the release 
> path)?

You might be remembering v1.  In v2 I have operations like file_hotplug_read_trylock
that implement a lock but use an rcu like algorithm.  So there are no atomic
operations involved with their associated pipeline stalls.  Over my previous
version this made a reasonable performance benefit.

> And that's only like 5% of the code touched by the new special handling of 
> the file operations structure (basically, every f_op access ends up being 
> wrapped by two atomic ops and other extra code).

Yes there is a single extra wrapping of every file in the syscall path.  So
we know that someone is using it. 

> The question, that I'd like to reiterate is, is this stuff really needed?
> Anyway, my complaint ends here and I'll let others evaluate if merging 
> this patchset is worth the cost.

Sure.  My apologies for not answering that question earlier.

My perspective is that every subsystem that winds up supporting hotplug
hardware winds up rolling it's own version of something like this,
and they each have a different set of bugs.

So one generic version is definitely worth implementing.

Similarly there is a case for a generic revoke facility in the kernel.
Alan at least has made the case that there are certain security problems
that can not be solved in userspace without revoke.

>From an implementation point of view doing the generic implementation at
the vfs level has significant benefits.

The extra locking appears reasonable from a code maintenance and
comprehensibility point of view.  A real pain to find all of the entry
points into the vfs, and get other code to use the right vfs helpers
they should always have been using but I am volunteering to do that
work.

The practical question I see is are the performance overheads of my
primitives low enough that I do not cause performance regressions
on anyone's fast path.  As far as I have been able to measure is that 
the performance overhead is low enough, because I have been able to
avoid the use of atomics and have been able to use fairly small code
with predictable branches.  Which is why I pressed you to be certain
I understood where you are coming from.

Eric
