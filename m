Return-Path: <linux-kernel-owner+w=401wt.eu-S1030603AbXBGJRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030603AbXBGJRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 04:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030604AbXBGJRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 04:17:47 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:39870 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030603AbXBGJRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 04:17:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gN9aOiDgZ4+yzDsA6gwiAYWmssZ02zIaHoEguv3aV7skz3owFRqtpMjlqK5sFDpAYKjm9B1j53H7AvmxEjppv3rID9bbcnr6yBVxcUJUNiYOr8A/8qN+Q2TCuIImFh8BtsjkdYLeJbr1SGVaCmRy3eS68RlG6QSV8jZFxjIDRRY=
Message-ID: <f2b55d220702070117r7fb612f0ta3151820ab33ecbc@mail.gmail.com>
Date: Wed, 7 Feb 2007 01:17:43 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>,
       "Kent Overstreet" <kent.overstreet@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Zach Brown" <zach.brown@oracle.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Benjamin LaHaise" <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <f2b55d220702062216n6b6757e5h10701851b422bc62@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702051223390.8424@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0702061238300.8424@woody.linux-foundation.org>
	 <6f703f960702061445q23dd9d48q7afec75d2400ef62@mail.gmail.com>
	 <Pine.LNX.4.64.0702061518220.19136@alien.or.mcafeemobile.com>
	 <20070206233907.GW32307@ca-server1.us.oracle.com>
	 <Pine.LNX.4.64.0702061541590.19136@alien.or.mcafeemobile.com>
	 <20070207000626.GC32307@ca-server1.us.oracle.com>
	 <Pine.LNX.4.64.0702061612220.19136@alien.or.mcafeemobile.com>
	 <20070207004443.GE32307@ca-server1.us.oracle.com>
	 <f2b55d220702062216n6b6757e5h10701851b422bc62@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Man, I should have edited that down before sending it.  Hopefully this
is clearer:

    - The usual programming model for AIO completion in GUIs, media
engines, and the like is an application callback.  Data that is
available immediately may be handled quite differently from data that
arrives after a delay, and usually the only reason for both code paths
to be in the same callback is shared code to maintain counters, etc.
associated with the AIO batch.  These shared operations, and the other
things one might want to do in the delayed path, needn't be able to
block or allocate memory.

    - AIO requests that are serviced from cache ought to immediately
invoke the callback, in the same thread context as the caller, fixing
up the stack so that the callback returns to the instruction following
the syscall.  That way the "immediate completion" path through the
callback can manipulate data structures, allocate memory, etc. just as
if it had followed a synchronous call.

    - AIO requests that need data not in cache should probably be
batched in order to avoid evicting the userspace AIO submission loop,
the immediate completion branch of the callback, and their data
structures from cache on every miss.  If you can use VM copy-on-write
tricks to punt a page of AIO request parameters and closure context
out to another CPU for immediate processing without stomping on your
local caches, great.

    - There's not much point in delivering AIO responses all the way
to userspace until the AIO submission loop is done, because they're
probably going to be handled through some completely different event
queue mechanism in the delayed path through the callback.  Trying to
squeeze a few AIO responses into the same data structure as if they
had been in cache is likely to create race conditions or impose
needless locking overhead on the otherwise serialized immediate
completion branch.

    - The result of the external AIO may arrive on a different CPU
with something completely else in foreground; but in real use cases
it's probably a different thread of the same process.  If you can use
the closure context page as the stack page for the kernel bit of the
AIO completion, and then use it again from userspace as the stack page
for the application bit, then the whole ISR -> softirq -> kernel
closure -> application closure path has minimal system impact.

    - The delayed path through the application callback can't block
and can't touch data structures that are thread-local or may be in an
incoherent state at this juncture (called during a more or less
arbitrary ISR exit path, a bit like a signal handler).  That's OK,
because it's probably just massaging the AIO response into fields of a
preallocated object dangling off of a global data structure and doing
a sem_post or some such.  (It might even just drop it if it's stale.)

    - As far as I can tell (knowing little about the scheduler per
se), these kernel closures aren't much like Zach's "fibrils"; they'd
be invoked from a tasklet chained more or less immediately after the
softirq dispatch tasklet.  I have no idea whether the cost of finding
the appropriate kernel closure(s) associated with the data that
arrived in the course of a softirq, pulling them over to the CPU where
the softirq just ran, and popping out to userspace to run the
application closure is exorbitant, or if it's even possible to force a
process switch from inside a tasklet that way.

Hope this helps, and sorry for the noise,
- Michael
