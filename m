Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbYEaMsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbYEaMsW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 08:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYEaMsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 08:48:12 -0400
Received: from wr-out-0708.google.com ([64.233.184.250]:50126 "EHLO
	wr-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbYEaMsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 08:48:11 -0400
MIME-Version: 1.0
Date: Sat, 31 May 2008 05:48:07 -0700 (PDT)
In-Reply-To: <azwvH-5QW-5@gated-at.bofh.it>
X-IP: 144.32.126.11
References: <azwvH-5QW-5@gated-at.bofh.it>
User-Agent: G2/1.0
X-HTTP-UserAgent: Mozilla/5.0 (compatible; Konqueror/3.5; Linux) KHTML/3.5.9 
	(like Gecko) (Kubuntu),gzip(gfe),gzip(gfe)
X-HTTP-Via: 1.1 wc5.york.ac.uk:3128 (squid)
Message-ID: <3849b91c-cfca-4126-b14b-aa6d2b4b10b3@m45g2000hsb.googlegroups.com>
Subject: Re: OOM policy, overcommit control, and soft limits
From: Alan Jenkins <aj504@cs.york.ac.uk>
To: Chris Frey <cdfrey@foursquare.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Frey wrote:
> Hi,
>
> The kernel provides things like ulimit, overcommit_memory, and the OOM
> killer notifications, so in theory memory management should not be a
> problem, but from time to time, I have a real need to regain control of
> my system when it runs away on me.
>
> I like how mode 2 of overcommit_memory uses the ratio as a boundary limit.
> Ideally I would like something like this as a soft limit, so once the
> system gets that full, I get a warning.
>
> Here's my ideal OOM flow:
>
> 	1) set my soft limit to 90% of RAM
>
> 	2) any malloc that hits this limit first runs through a notification
> 		hook, that talks to a userspace daemon if present,
> 		or just denies the malloc if not
>
> 	3) the daemon can decide whether to allow the allocation, going
> 		beyond the soft limit
>
> 	4) the daemon can make these decisions automatically based on
> 		policy (i.e. X always gets the green light), or if we
> 		want to get fancy it can talk to some pre-allocated
> 		GUI to present the decision to the user...
> 		(i.e. Allocate / Deny / Stop / Kill)
>
> 	5) if the user foolishly keeps allocating, then the current
> 		OOM killer comes into play
>
> I'm sure someone has thought of this before me.  Does anything remotely
> similar to this already exist?  I've googled for OOM policy, but so far
> all I've seen is Rusty Lynch's patch from 2003, and really, I want this
> behaviour to happen when there is still a bit of memory left, so things
> can be dealt with before they are OOM-level dire.
>
> Thanks in advance,
> - Chris

I'm not sure how helpful this is.  It sounds like you may be missing
something, but I'm not competent to explain it.  But here are some of
my thoughts.

1. If your system is really running away, maybe killing the processes
responsible is a good idea.

2. Why do you want to set an _overcommit_ soft-limit at 90% of RAM?
Even without swap, that sounds very restrictrive.

If I naively add up the top 10 memory hogs on my 512M system, they're
using a total of over 4G of virtual memory.  (And I have less than
512M swap).  Some of that will be shared memory or backed by disk
files - but I don't think that it can account for all 3G of the
overcommit.  Shared memory tends to be code only, and my entire "disk"
is only 4G.

In other words, I reckon I have on the order of a gigabyte of virtual
address space, which has been malloc'ed or equivalent, but is not used
and therefore requires no memory resource (ram or swap).

3. Personally, without knowing whether it's already done, I think a
significant solution for the desktop is for browsers, mail clients and
similar to place strict limits on their anonymous memory consumption,
and use mmaped files for the caches / object stores which can grow so
large.  Similarly, the GIMP uses a "tile cache" file (which perhaps
shows its age).  If applications are storing caches on disk, they
should make this clear to the kernel - using mmapped files for cache
effectively turns them into swap files, letting the kernel page them
out to disk without using up the kernel swap file.  Exposing the cache
memory usage on disk also makes it slightly more accessible, e.g. to
disk quotas, or users with "du".
