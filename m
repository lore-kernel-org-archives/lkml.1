Return-Path: <linux-kernel-owner+w=401wt.eu-S933116AbZHDRO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116AbZHDRO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 13:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933107AbZHDRO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 13:14:26 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:53847 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933105AbZHDROZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 13:14:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAPsIeEqrR7MV/2dsb2JhbAC9FIgpj30FhBg
X-IronPort-AV: E=Sophos;i="4.43,322,1246838400"; 
   d="scan'208";a="181351864"
From: Roland Dreier <rdreier@cisco.com>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jsquyres@cisco.com, rostedt@goodmis.org
Subject: Re: [PATCH v3] ummunotify: Userspace support for MMU notifications
References: <ada3a8oobis.fsf@cisco.com>
	<20090722111538.58a126e3.akpm@linux-foundation.org>
	<adad47smsb5.fsf@cisco.com>
	<20090722124208.97d7d9d7.akpm@linux-foundation.org>
	<adaeis53d2m.fsf_-_@cisco.com>
	<20090727165329.4acfda1c.akpm@linux-foundation.org>
	<adaws5szswf.fsf@cisco.com> <adaskgcptsz.fsf_-_@cisco.com>
	<4A75F00D.7010400@inria.fr> <aday6q1o5re.fsf@cisco.com>
	<4A768A71.900@inria.fr>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 04 Aug 2009 10:14:25 -0700
In-Reply-To: <4A768A71.900@inria.fr> (Brice Goglin's message of "Mon, 03 Aug
	2009 08:57:53 +0200")
Message-ID: <ada3a87mrgu.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Aug 2009 17:14:26.0115 (UTC) FILETIME=[04C11130:01CA1527]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > > Second, it turns out that having the filter does cut down quite a bit on
 > > the events.  From running some Open MPI tests that Jeff provided, I saw
 > > that there were often several times as many MMU notifier events
 > > delivered in the kernel than ended up being reported to userspace.

 > So maybe multiple invalidate_page are gathered into the same range
 > event? If so, maybe it'd make sense to cache the last used rb_node in
 > ummunotify_handle_notify()? (and if multiple ranges were invalidated at
 > once, just don't cache anything, it shouldn't happen often anyway)

Well, I just meant that there were lots of events for parts of the
address space that Open MPI wasn't interested in... the fortran runtime
or whatever was freeing stuff that wasn't ever used for communication.

 > >  > 2) What happens in case of fork? If father+child keep reading from the
 > >  > previously-open /dev/ummunotify, each event will be delivered only to
 > >  > the first reader, right? Fork is always a mess in HPC, but maybe there's
 > >  > something to do here.

 > > It works just like any other file where fork results in two file
 > > descriptors in two processes... as you point out the two processes can
 > > step on each other.  (And in the ummunotify case the file remains
 > > associated with the original mm)  However this is the case for simpler
 > > stuff like sockets etc too, and I think uniformity of interface and
 > > least surprise say that ummunotify should follow the same model.

 > I was wondering if adding a special event such as "COWED" could help
 > user-space. But maybe fork already invalidates all COW'ed ranges in
 > copy_page_range() anyway?

The problem I guess is that there is only one file object (pointed to by
two file descriptors of course) after the fork.  And it is tracking
changes to the parent's mapping.  I guess in the parent when touching
pages and triggering COW, that might be interesting -- but I don't
really know how to distinguish it from any other type of invalidate
event (and I don't know how userspace would do anything different
anyway).

I haven't actually looked at what fork() does to the MMU notifiers --
but the MMU notifiers hook in at such a low level that it does seem hard
to know that what's going on is related to fork or even COW.

 - R.
