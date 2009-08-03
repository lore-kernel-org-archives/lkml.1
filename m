Return-Path: <linux-kernel-owner+w=401wt.eu-S1751033AbZHCEzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033AbZHCEzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 00:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbZHCEzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 00:55:52 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:26764 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbZHCEzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 00:55:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAIMKdkqrR7PD/2dsb2JhbAC6EIgpjgMFhBg
X-IronPort-AV: E=Sophos;i="4.43,312,1246838400"; 
   d="scan'208";a="222404698"
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
	<4A75F00D.7010400@inria.fr>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 02 Aug 2009 21:55:49 -0700
In-Reply-To: <4A75F00D.7010400@inria.fr> (Brice Goglin's message of "Sun, 02
	Aug 2009 21:59:09 +0200")
Message-ID: <aday6q1o5re.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 Aug 2009 04:55:51.0753 (UTC) FILETIME=[ACEC4B90:01CA13F6]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > I like the interface but I have a couple questions:

Thanks.

 > 1) Why does userspace have to register these address ranges? I would
 > have just reported all invalidation evens and let user-space check which
 > ones are interesting. My feeling is that the number of invalidation
 > events will usually be lower than the number registered ranges, so
 > you'll report more events through the file descriptor, but userspace
 > will do a lot less ioctls.

A couple of reasons.  First, MMU notifier events may be delivered (in
the kernel) in interrupt context so the amount of allocation we can do
in a notifier hook is limited (and any allocation will fail sometimes).
So if we just want to report all events to userspace then I don't see
any was around having to sometimes deliver an event like "uh, some
events got lost" and have userspace have to flush everything.

I suspect that MPI workloads will hit the overflow case in practice,
since they probably want to run as close to out-of-memory as possible,
and the application may not enter the MPI library often enough to keep
the queue of ummunotify events short -- I can imagine some codes that do
a lot of memory management, enter MPI infrequently, and end up
overflowing the queue and flushing all registrations over and over.
Having userspace register ranges means I can preallocate a landing area
for each event and make the MMU notifier hook pretty simple.

Second, it turns out that having the filter does cut down quite a bit on
the events.  From running some Open MPI tests that Jeff provided, I saw
that there were often several times as many MMU notifier events
delivered in the kernel than ended up being reported to userspace.

 > 2) What happens in case of fork? If father+child keep reading from the
 > previously-open /dev/ummunotify, each event will be delivered only to
 > the first reader, right? Fork is always a mess in HPC, but maybe there's
 > something to do here.

It works just like any other file where fork results in two file
descriptors in two processes... as you point out the two processes can
step on each other.  (And in the ummunotify case the file remains
associated with the original mm)  However this is the case for simpler
stuff like sockets etc too, and I think uniformity of interface and
least surprise say that ummunotify should follow the same model.

 > 3) What's userspace supposed to do if 2 libraries need such events in
 > the same process? Should each of them open /dev/ummunotify separately?
 > Doesn't matter much for performance, just wondering.

I guess the libraries could work out some way to share things, but that
would require one library to pass events to the other or something like
that.  It should work fine for 2 libraries to have independent
ummunotify files open though (I've not tested but "what could go wrong"?).

Thanks,
  Roland

