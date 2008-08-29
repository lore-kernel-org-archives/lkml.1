Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbYH2N0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbYH2N0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 09:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbYH2N0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 09:26:38 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:60538 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbYH2N0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 09:26:37 -0400
Message-ID: <48B7F877.6070906@novell.com>
Date: Fri, 29 Aug 2008 09:24:07 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: mingo@elte.hu
CC: srostedt@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, npiggin@suse.de,
       gregory.haskins@gmail.com
Subject: Re: [PATCH v2 6/6] sched: create "pushable_tasks" list to limit pushing
 to one attempt
References: <20080826173131.16413.17862.stgit@dev.haskins.net> <20080826173515.16413.39166.stgit@dev.haskins.net>
In-Reply-To: <20080826173515.16413.39166.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEC7EB108149896663D041132"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEC7EB108149896663D041132
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

Gregory Haskins wrote:
> The RT scheduler employs a "push/pull" design to actively balance tasks=

> within the system (on a per disjoint cpuset basis).  When a task is
> awoken, it is immediately determined if there are any lower priority
> cpus which should be preempted.  This is opposed to the way normal
> SCHED_OTHER tasks behave, which will wait for a periodic rebalancing
> operation to occur before spreading out load.
>
> When a particular RQ has more than 1 active RT task, it is said to
> be in an "overloaded" state.  Once this occurs, the system enters
> the active balancing mode, where it will try to push the task away,
> or persuade a different cpu to pull it over.  The system will stay
> in this state until the system falls back below the <=3D 1 queued RT
> task per RQ.
>
> However, the current implementation suffers from a limitation in the
> push logic.  Once overloaded, all tasks (other than current) on the
> RQ are analyzed on every push operation, even if it was previously
> unpushable (due to affinity, etc).  Whats more, the operation stops
> at the first task that is unpushable and will not look at items
> lower in the queue.  This causes two problems:
>
> 1) We can have the same tasks analyzed over and over again during each
>    push, which extends out the fast path in the scheduler for no
>    gain.  Consider a RQ that has dozens of tasks that are bound to a
>    core.  Each one of those tasks will be encountered and skipped
>    for each push operation while they are queued.
>
> 2) There may be lower-priority tasks under the unpushable task that
>    could have been successfully pushed, but will never be considered
>    until either the unpushable task is cleared, or a pull operation
>    succeeds.  The net result is a potential latency source for mid
>    priority tasks.
>
> This patch aims to rectify these two conditions by introducing a new
> priority sorted list: "pushable_tasks".  A task is added to the list
> each time a task is activated or preempted.  It is removed from the
> list any time it is deactivated, made current, or fails to push.
>
> This works because a task only needs to be attempted to push once.
> After an initial failure to push, the other cpus will eventually try to=

> pull the task when the conditions are proper.  This also solves the
> problem that we don't completely analyze all tasks due to encountering
> an unpushable tasks.  Now every task will have a push attempted (when
> appropriate).
>
> This reduces latency both by shorting the critical section of the
> rq->lock for certain workloads, and by making sure the algorithm
> considers all eligible tasks in the system.
>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> CC: Steven Rostedt <srostedt@redhat.com>
>  =20

We have found a crash bug in this patch in our lab caused by this
patch.  So if you had any plans to pull this series in, please skip this
last patch for now (6/6).  I will send out a refresh after I fix the issu=
e.

Thanks,
-Greg



--------------enigEC7EB108149896663D041132
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAki3+HcACgkQlOSOBdgZUxmF7ACfb/ZJaddBCthbghoG2fLx+5Ht
TdcAn2CrJC6ZLVokzoILsykHQMy5OU5n
=9rTm
-----END PGP SIGNATURE-----

--------------enigEC7EB108149896663D041132--
