Return-Path: <linux-kernel-owner+w=401wt.eu-S1758454AbXFISC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454AbXFISC4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 14:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756907AbXFISCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 14:02:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756995AbXFISCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 14:02:48 -0400
Message-ID: <466AEAE8.2040800@redhat.com>
Date: Sat, 09 Jun 2007 11:01:12 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Pierre Peiffer <pierre.peiffer@bull.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, "Dave Jones"@redhat.com,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: FUTEX_CMP_REQUEUE_PI is not quite there
References: <46455A67.8040203@redhat.com> <1181062707.4404.119.camel@chaos>
In-Reply-To: <1181062707.4404.119.camel@chaos>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Thomas Gleixner wrote:
> Can you put the binaries somewhere for download please ? 

I was waiting until I could test the current patches.  DaveJ built a
kernel based on -rc4-git3 which I tested.  The results are the same.

I've put a statically linked x86-64 binary at

  http://people.redhat.com/drepper/tst-robustpi7.bz2

Running it produces a backtrace with the 2.6.21-1.3218.fc8 kernel and
the machine dies.

The test case creates a robust, PI mutex.  Five threads then run into a
condvar for this mutex.  The main threads wakes them all with a
broadcast which causes the new requeue_pi code to be used.  The woken
threads then (in pthread_cond_wait) lock the mutex and then kill
themselves while holding the mutex.  This is supposed to have the result
that all but the first thread get EDEADOWNER errors.

Note: the condvar futex is not a PI futex.  It cannot be, the semantics
is different.  This is no locking futex.  The kernel will have to deal
with this.  The requeue operation is meaningless if this is not done
since it's only use is for this situation.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGauro2ijCOnn/RHQRAluEAKC2rG4DSGjwNkYILzQsMtp7jgcN0QCgh4od
bN8HUrwjg1keVo8DjKTQL6o=
=twSF
-----END PGP SIGNATURE-----
