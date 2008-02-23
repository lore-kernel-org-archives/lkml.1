Return-Path: <linux-kernel-owner+w=401wt.eu-S1757401AbYBWPKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbYBWPKN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 10:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYBWPKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 10:10:05 -0500
Received: from smtp-out.google.com ([216.239.33.17]:58882 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbYBWPKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 10:10:01 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=W9ydSNJO/Uwwb4AeU8sCEUlh0g2nLpgKhOL5cTA64G9FllMvW5tBjjHH/Sk+P1h7G
	yJYJb4SpEf8sWMWubocQA==
Message-ID: <6599ad830802230709m5f0cbf8aia2710bd832408ba7@mail.gmail.com>
Date: Sat, 23 Feb 2008 07:09:50 -0800
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: Tiny cpusets -- cpusets for small systems?
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Max Krasnyanskiy" <maxk@qualcomm.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Andreas Dilger" <adilger@sun.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Spang" <daniel.spang@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Jon Masters" <jonathan@jonmasters.org>,
       "Marcelo Tosatti" <marcelo@kvack.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Rik van Riel" <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080223060911.e1d13cc1.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080223060911.e1d13cc1.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 4:09 AM, Paul Jackson <pj@sgi.com> wrote:
> A couple of proposals have been made recently by people working Linux
>  on smaller systems, for improving realtime isolation and memory
>  pressure handling:
>
>  (1) cpu isolation for hard(er) realtime
>         http://lkml.org/lkml/2008/2/21/517
>         Max Krasnyanskiy <maxk@qualcomm.com>
>         [PATCH sched-devel 0/7] CPU isolation extensions
>
>  (2) notify user space of tight memory
>         http://lkml.org/lkml/2008/2/9/144
>         KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>         [PATCH 0/8][for -mm] mem_notify v6
>
>  In both cases, some of us have responded "why not use cpusets", and the
>  original submitters have replied "cpusets are too fat"  (well, they
>  were more diplomatic than that, but I guess I can say that ;)

Having read those threads, it looks to me as though:

- the parts of Max's problem that would be solved by cpusets can be
mostly accomplished just via sched_setaffinity()

- Motohiro wants to add a new system-wide API that you would also like
to have available on a per-cpuset basis. (Why not just add two access
points for the same feature?)

I'm don't think that either of these would be enough to justify big
changes to cpusets or cgroups, although eliminating bloat is always a
good thing.

>  The primary semantic limit I'd suggest would be supporting exactly
>  one layer depth of cpusets, not a full hierarchy.  So one could still
>  successfully issue from user space 'mkdir /dev/cpuset/foo', but trying
>  to do 'mkdir /dev/cpuset/foo/bar' would fail.  This reminds me of
>  very early FAT file systems, which had just a single, fixed size
>  root directory ;).  There might even be a configurable fixed upper
>  limit on how many /dev/cpuset/* directories were allowed, further
>  simplifying the locking and dynamic memory behavior of this apparatus.

I'm not sure that either of these would make much difference to the
overall footprint.

A single layer of cpusets would allow you to simplify
validate_change() but not much else.

I don't see how a fixed upper limit on the number of cpusets makes the
locking sufficiently simpler to save much code.

>
>  How this extends to cgroups I don't know; for now I suspect that most
>  cgroup module development is motivated by the needs of larger systems,
>  not smaller systems.  However, cpusets is now a module client of
>  cgroups, and it is cgroups that now provides cpusets with its interface
>  to the vfs infrastructure.  It would seem unfortunate if this relation
>  was not continued with tiny cpusets.  Perhaps someone can imagine a tiny
>  cgroups?  This might be the most difficult part of this proposal.

If we wanted to go this way, I can imagine a cgroups config option
that forces just a single hierarchy, which would allow a bunch of
simplifications that would save plenty of text.

>
>  Looking at some IA64 sn2 config builds I have laying about, I see the
>  following text sizes for a couple of versions, showing the growth of
>  the cpuset/cgroup apparatus over time:
>
>         25933   2.6.18-rc3-mm1/kernel/cpuset.o (Aug 2006)
>  vs.
>         37823   2.6.25-rc2-mm1/kernel/cgroup.o (Feb 2008)
>         19558   2.6.25-rc2-mm1/kernel/cpuset.o
>
>  So the total has grown from 25933 to 57381 text bytes (note that
>  this is IA64 arch; most arch's will have proportionately smaller
>  text sizes.)

On x86_64 they're:

cgroup.o: 17348
cpuset.o: 8533

Paul
