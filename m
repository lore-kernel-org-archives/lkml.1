Return-Path: <linux-kernel-owner+w=401wt.eu-S1763657AbXEUR1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763657AbXEUR1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbXEUR1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:27:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756561AbXEUR1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:27:14 -0400
Message-ID: <4651D628.1070206@redhat.com>
Date: Mon, 21 May 2007 10:26:00 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: second, bigger problem with private futexes
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

This one is a big problem:

If I understand the code correctly, a FUTEX_CMP_REQUEUE from a private
futex will add the waiters to the other futex as a private futex.  And
similarly for shared.

I.e., it is not possible to have one futex private and the other shared.
 This is a huge problem.  The shared/private status of a conditional
variable and the mutex used with it don't have to match.  But this is
where FUTEX_CMP_REQUEUE is used.

If this is not changed (assuming I'm right with my analysis of the
kernel code) this means mutexes and condvars will not be able to use
private futexes.

What would be needed is an additional parameter for FUTEX_CMP_REQUEUE
and FUTEX_CMP_REQUEUE_PI which specifies the state (shared/private) of
the target futex.  The original futex' state is encoded in the command
(the FUTEX_PRIVATE_FLAG ORed to FUTEX_CMP_REQUEUE*).

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGUdYo2ijCOnn/RHQRArmXAKCdW9a/nuJun/0KjftIcMrsURNnrwCgzCf8
XGi6EzPV88DEIwHfnMfKdNg=
=0hVr
-----END PGP SIGNATURE-----
