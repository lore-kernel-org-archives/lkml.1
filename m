Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbYDAIhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbYDAIhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 04:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYDAIg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:36:57 -0400
Received: from smtp.nokia.com ([192.100.122.233]:38385 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbYDAIg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:36:56 -0400
Message-ID: <47F1F33A.1020909@nokia.com>
Date: Tue, 01 Apr 2008 11:32:58 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Artem Bityutskiy <dedekind@yandex.ru>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [RFC PATCH 25/26] UBIFS: add debugging stuff
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>       <1206629746-4298-26-git-send-email-Artem.Bityutskiy@nokia.com> <84144f020803311400s1f34420dx153d197f4752c65e@mail.gmail.com> <47F1D44A.8010908@yandex.ru> <47F1E534.7050803@cs.helsinki.fi>
In-Reply-To: <47F1E534.7050803@cs.helsinki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2008 08:36:48.0598 (UTC) FILETIME=[869E8F60:01C893D3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka, I still do not see why you are opposed to assertions so much :-)

Pekka Enberg wrote:
> Why would you want to have assertions that are compiled out by default? 

Because we want to have a way to catch bugs and to quickly fix them. This
is why we injected many assertions all over the place. Enabling them by
default is inefficient and makes the code larger, which is not good
especially for small embedded systems.

If someone reports us an obscure oops, and we have no idea why it happened,
and we cannot reproduce it on our setup, we ask the reporter to enable
debugging and report us results. This helps us to figure out what was the
reason and to quickly fix the bug. I do not see why you want to prevent
us from doing this.

> Either you handle the error or don't (and have an assertion).
We handle all errors. Errors are things like I/O failures, memory allocation
failures, unexpected behavior. We do handle this. Assertion are about
_debugging_, when you already know you have a problem.

Indeed, bugs may be tricky. An oops may happen because half an hour ago a
function craped out something. Assertions allow us to catch problems on
_early_ stage, instead of dealing with consequences and scratching the head
what was the reason.

But I do agree we have too much of that. We will lessen the amount of
course.

> The reason 
> some subsystems have had their own asserts is because they go overboard 
> with defensive checks as they haven't bothered to think through a 
> reasonable error handling strategy. The downside? It clutters the code 
> and causes the (compiled out) assertions to bit-rot.

I am not sure what you mean. I would not want to delve into a general
discussion of the debugging stuff. I would better talk about specific
things. I'll just point you examples of debugging stuff in the kernel
in other subsystems which exists and does not hurt anyone. And I believe
it is helpful. It is compiled out by default and is enable when it is
needed to hunt a bug.

fs/ext2: ea_idebug(), EXT2FS_DEBUG
fs/xfs: #ifdef DEBUG, XFS_LOUD_RECOVERY and so on
fs/ocfs2: OCFS2_DEBUG_FS
fs/jfs: CONFIG_JFS_DEBUG, assert(), etc
fs: DEBUG_EPOLL, #ifdef DEBUG
fs/jbd2: assert_spin_locked(), CONFIG_JBD2_DEBUG, etc
mm: CONFIG_SLUB_DEBUG, SLABDEBUG, CONFIG_DEBUG_VM, and so on

> Note that they're also a total pain in the ass to enable for anyone not 
> intimately familiar with your code.

Of course. People who are not familiar with the code send bug reports and
we have to fix the problem quickly, and debugging stuff helps.

> Not to mention you're now making the 
> lives of those crazy embedded folks that disable CONFIG_BUG for smaller 
> kernel size harder as well.

It is OK to have few BUG_ON() checks, and we should probably turn few
assertions into BUG_ON(). But only few.

> Do you know why we don't have compiled out asserts in the core kernel? 
> That's because it simply can't just roll-over and die if something 
> unexpected happens and your filesystem shouldn't probably do that 
> either.

If something unexpected happens, UBIFS will just return -EINVAL in the
most cases, because one of the function will find out that something is
going wrong. Assertions have nothing to do with this. The help to _fix_
bugs which were hit in certain circumstances.

> Sure, if you have some debugging checks that are way too 
> expensive for production use, you might want to have a 
> CONFIG_UBIFS_DEBUG but that shouldn't happen at assertion level but 
> rather at much higher level.
We have heavy checks, right. They are expensive, so disabled by default.
Why can't assertions be similar?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
