Return-Path: <linux-kernel-owner+w=401wt.eu-S936226AbXEUT74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936226AbXEUT74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934957AbXEUToe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:44:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934838AbXEUToc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:44:32 -0400
Message-ID: <4651F653.9060802@redhat.com>
Date: Mon, 21 May 2007 12:43:15 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: second, bigger problem with private futexes
References: <4651D628.1070206@redhat.com> <4651E1D4.6010705@cosmosbay.com> <4651E44A.9070301@redhat.com> <4651E992.9080205@cosmosbay.com> <4651F261.2040903@cosmosbay.com>
In-Reply-To: <4651F261.2040903@cosmosbay.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Eric Dumazet wrote:
> 3) if condvar is PRIVATE and mutex is SHARED, a FUTEX_WAKE_PRIVATE
> should be done. (and loose the REQUEUE optim)
> Yes we could add a special futex primitive for this special case. But I
> cannot see how a program could use such a construct.

Very easily: mutexes are often created independently from the condvars
and they are used for many things.  Maybe a program is even creating all
mutexes as shared to be ready for all situations.  Normally doing this
is no big problem, the performance penalties are minimal.


> 4) if condvar is SHARED and mutex is private, we have a *problem*,
> because the process doing the broadcast() can be in another mm. So a
> requeue is not possible at all.

It is if we can specify the owner of the mutex.  I.e., the PID.

But yes, this case is extremely ugly.


The problem is that all these cases worked nice so far.  They all had
the same good performance.  Now we are severely penalizing code which
mismatches condvar and mutex shared attributes.  There is a good reason
why we introduced FUTEX_CMP_REQUEUE, the benefits in certain programs is
huge.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGUfZT2ijCOnn/RHQRAkT0AJ4pgX7RtdUf8uwyP9v7o+nkv/9uMACfbx6+
kBaJLSSvDBjN09KMgmLKnSI=
=4XMz
-----END PGP SIGNATURE-----
