Return-Path: <linux-kernel-owner+w=401wt.eu-S965607AbXCMJ2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965607AbXCMJ2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030234AbXCMJ2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:28:13 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34686 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965607AbXCMJ2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:28:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kirill Korotaev <dev@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, devel@openvz.org, xemul@openvz.org
Subject: Re: [Devel] Re: [RFC][PATCH 2/7] RSS controller core
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru>
	<20070306140036.4e85bd2f.akpm@linux-foundation.org>
	<45F3F581.9030503@sw.ru>
	<20070311045111.62d3e9f9.akpm@linux-foundation.org>
	<m1wt1nvajx.fsf@ebiederm.dsl.xmission.com>
	<45F51C08.2020108@openvz.org>
Date: Tue, 13 Mar 2007 03:26:53 -0600
In-Reply-To: <45F51C08.2020108@openvz.org> (Kirill Korotaev's message of "Mon,
	12 Mar 2007 12:23:20 +0300")
Message-ID: <m17itltrxe.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill Korotaev <dev@openvz.org> writes:

> Eric,
>
>> And misses every resource sharing opportunity in sight.
>
> that was my point too.
>
>> Except for
>> filtering the which pages are eligible for reclaim an RSS limit should
>> not need to change the existing reclaim logic, and with things like the
>> memory zones we have had that kind of restriction in the reclaim logic
>> for a long time.  So filtering out ineligible pages isn't anything new.
>
> exactly this is implemented in the current patches from Pavel.
> the only difference is that filtering is not done in general LRU list,
> which is not effective, but via per-container LRU list.
> So the pointer on the page structure does 2 things:
> - fast reclamation
    Better than the rmap list?
> - correct uncharging of page from where it was charged
>   (e.g. shared pages can be mapped first in one container, but the last unmap
>    done from another one).
    We should charge/uncharge all of them, not just one.

>>>We need to work out what the requirements are before we can settle on an
>>>implementation.
>> 
>> 
>> If you are talking about RSS limits the term is well defined.  The
>> number of pages you can have mapped into your set of address space at
>> any given time.
>> 
>> Unless I'm totally blind that isn't what the patchset implements.
>
> Ouch, what makes you think so?
> The fact that a page mapped into 2 different processes is charged only once?
> Imho it is much more correct then sum of process' RSS within container, due to:
> 1. it is clear how much container uses physical pages, not abstract items
> 2. shared pages are charged only once, so the sum of containers RSS is still
>    about physical RAM.

No the fact that a page mapped into 2 separate mm_structs in two
separate accounting domains is counted only once.  This is very likely
to happen with things like glibc if you have a read-only shared copy
of your distro.  There appears to be no technical reason for such a
restriction.

A page should not be owned.  

Going further unless the limits are draconian I don't expect users to
hit the rss limits often or frequently.  So in 99% of all cases page
reclaim should continue to be global.  Which makes me question messing
with the general page reclaim lists.

Now if the normal limits turn out to be draconian it may make sense to
split the first level of page lists by some reasonable approximation
to their rss group, so we don't normally scan unnecessary pages.

>> The whole filesystem interface also is over general and makes it too
>> easy to express the hard things (like move an existing task from one
>> group of tasks to another) leading to code complications.
> the things which are not supported are easy to disable.

Maybe.  The extra locking complexity gives me fits.  But in the grand
scheme of things it is minor as long as it is not user perceptible we
can fix it later.  I'm still wrapping my head around the weird fs concepts.

Eric
