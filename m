Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477AbZHCG5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbZHCG5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 02:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZHCG5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 02:57:43 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:20676 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbZHCG5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 02:57:42 -0400
X-IronPort-AV: E=Sophos;i="4.43,312,1246831200"; 
   d="scan'208";a="33958697"
Message-ID: <4A768A71.900@inria.fr>
Date: Mon, 03 Aug 2009 08:57:53 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jsquyres@cisco.com, rostedt@goodmis.org
Subject: Re: [PATCH v3] ummunotify: Userspace support for MMU notifications
References: <ada3a8oobis.fsf@cisco.com>	<20090722111538.58a126e3.akpm@linux-foundation.org>	<adad47smsb5.fsf@cisco.com>	<20090722124208.97d7d9d7.akpm@linux-foundation.org>	<adaeis53d2m.fsf_-_@cisco.com>	<20090727165329.4acfda1c.akpm@linux-foundation.org>	<adaws5szswf.fsf@cisco.com> <adaskgcptsz.fsf_-_@cisco.com>	<4A75F00D.7010400@inria.fr> <aday6q1o5re.fsf@cisco.com>
In-Reply-To: <aday6q1o5re.fsf@cisco.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> I suspect that MPI workloads will hit the overflow case in practice,
> since they probably want to run as close to out-of-memory as possible,
> and the application may not enter the MPI library often enough to keep
> the queue of ummunotify events short -- I can imagine some codes that do
> a lot of memory management, enter MPI infrequently, and end up
> overflowing the queue and flushing all registrations over and over.
> Having userspace register ranges means I can preallocate a landing area
> for each event and make the MMU notifier hook pretty simple.
>   

Thanks, I see.

> Second, it turns out that having the filter does cut down quite a bit on
> the events.  From running some Open MPI tests that Jeff provided, I saw
> that there were often several times as many MMU notifier events
> delivered in the kernel than ended up being reported to userspace.
>   

So maybe multiple invalidate_page are gathered into the same range
event? If so, maybe it'd make sense to cache the last used rb_node in
ummunotify_handle_notify()? (and if multiple ranges were invalidated at
once, just don't cache anything, it shouldn't happen often anyway)

>  > 2) What happens in case of fork? If father+child keep reading from the
>  > previously-open /dev/ummunotify, each event will be delivered only to
>  > the first reader, right? Fork is always a mess in HPC, but maybe there's
>  > something to do here.
>
> It works just like any other file where fork results in two file
> descriptors in two processes... as you point out the two processes can
> step on each other.  (And in the ummunotify case the file remains
> associated with the original mm)  However this is the case for simpler
> stuff like sockets etc too, and I think uniformity of interface and
> least surprise say that ummunotify should follow the same model.
>   

I was wondering if adding a special event such as "COWED" could help
user-space. But maybe fork already invalidates all COW'ed ranges in
copy_page_range() anyway?

Brice

