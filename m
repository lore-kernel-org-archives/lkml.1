Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbYH0Lx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbYH0Lx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 07:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbYH0LxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 07:53:19 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:38763 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbYH0LxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 07:53:18 -0400
Message-ID: <48B53F97.20101@novell.com>
Date: Wed, 27 Aug 2008 07:50:47 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: mingo@elte.hu, srostedt@redhat.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       npiggin@suse.de, gregory.haskins@gmail.com
Subject: Re: [PATCH 2/5] sched: pull only one task during NEWIDLE balancing
 to limit critical section
References: <20080825200852.23217.13842.stgit@dev.haskins.net> <200808261621.33810.nickpiggin@yahoo.com.au> <48B3EAD9.60609@novell.com> <200808271641.46359.nickpiggin@yahoo.com.au>
In-Reply-To: <200808271641.46359.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6F81121601523986E2C346A0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6F81121601523986E2C346A0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Nick Piggin wrote:
> On Tuesday 26 August 2008 21:36, Gregory Haskins wrote:
>  =20
>> Nick Piggin wrote:
>>    =20
>>> On Tuesday 26 August 2008 06:15, Gregory Haskins wrote:
>>>      =20
>>>> git-id c4acb2c0669c5c5c9b28e9d02a34b5c67edf7092 attempted to limit
>>>> newidle critical section length by stopping after at least one task
>>>> was moved.  Further investigation has shown that there are other
>>>> paths nested further inside the algorithm which still remain that al=
low
>>>> long latencies to occur with newidle balancing.  This patch applies
>>>> the same technique inside balance_tasks() to limit the duration of
>>>> this optional balancing operation.
>>>>
>>>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>>>> CC: Nick Piggin <npiggin@suse.de>
>>>>        =20
>>> Hmm, this (andc4acb2c0669c5c5c9b28e9d02a34b5c67edf7092) still could
>>> increase the amount of work to do significantly for workloads where
>>> the CPU is going idle and pulling tasks over frequently. I don't
>>> really like either of them too much.
>>>      =20
>> I had a feeling you may object to this patch based on your comments on=

>> the first one.  Thats why I CC'd you so you wouldnt think I was trying=

>> to sneak something past ;)
>>    =20
>
> Appreciated.
>
>
>  =20
>>> Maybe increasing the limit would effectively amortize most of the
>>> problem (say, limit to move 16 tasks at most).
>>>      =20
>> The problem I was seeing was that even moving 2 was too many in the
>> ftraces traces I looked at.  I think the idea of making a variable lim=
it
>> (set via a sysctl, etc) here is a good one, but I would recommend we
>> have the default be "1" for CONFIG_PREEMPT (or at least
>> CONFIG_PREEMPT_RT) based on what I know right now.   I know last time
>> you objected to any kind of special cases for the preemptible kernels,=

>> but I think this is a good compromise.  Would this be acceptable?
>>    =20
>
> Well I _prefer_ not to have a special case for preemptible kernels, but=

> we already have similar arbitrary kind of changes like in tlb flushing,=

> so...
>
> I understand and accept there are some places where fundamentally you
> have to trade latency for throughput, so at some point we have to have =
a
> config and/or sysctl for that.
>
> I'm surprised 2 is too much but 1 is OK. Seems pretty fragile to me.

Its not that 1 is magically "ok".  Its simply that newidle balancing
hurts latency, and 1 is the minimum to pull to reasonably reduce the
critical section.  I already check if we NEEDS_RESCHED before taking the
rq->lock in newidle, so waiting for one task to pull is the first
opportunity I have to end the section as quickly as possible.  It would
be nice if I could just keep going if  I could detect whether there was=20
not any real contention.  Let me  give this angle some more thought.

>  Are
> you just running insane tests that load up the runqueues heaps and test=
s
> latency? -rt users will have to understand that some algorithms scale
> linearly or so with the number of a particular resource allocated, so
> they aren't going to get a constant low latency under arbitrary
> conditions.
>
> FWIW, if you haven't already, then for -rt you might want to look at a
> more advanced data structure than simple run ordered list for moving ta=
sks
> from one rq to the other. A simple one I was looking at is a time order=
ed
> list to pull the most cache cold tasks (and thus we can stop searching
> when we encounter the first cache hot task, in situations where it is
> appropriate, etc).
>  =20

Im not sure I follow your point, but if I do note that the RT scheduler
uses a completely different load balancer (that is priority ordered).


> Anyway... yeah I'm OK with this if it is under a config option.
>  =20

Cool..  See v2 ;)

Thanks Nick,
-Greg



--------------enig6F81121601523986E2C346A0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAki1P5cACgkQlOSOBdgZUxmO4wCeLS9sxpCWgbwMWKpbkCadUPXV
Ud4An2bTi5oCdYylnWNhWD+ygokEtwZe
=eDkE
-----END PGP SIGNATURE-----

--------------enig6F81121601523986E2C346A0--
