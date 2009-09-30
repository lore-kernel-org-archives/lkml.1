Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbZI3Ou2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbZI3Ou2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 10:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbZI3Ou1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 10:50:27 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45597 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754585AbZI3Ou0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 10:50:26 -0400
X-Sasl-enc: SWv0ItBB6Cw8OFaZygfxscs4N7YRIlj2thqG3rpIQWJ5 1254322229
Message-ID: <4AC37032.4030901@imap.cc>
Date: Wed, 30 Sep 2009 16:50:26 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
CC: Alan Cox <alan@linux.intel.com>
Subject: N_PPP_SYNC ldisc BUG: sleeping function called from invalid context
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

While testing pppd with capiplugin on kernel 2.6.31 (plus my CAPI and
Gigaset patches) I came across this BUG message. (Please ignore the
Tainted flag, it's from the Nvidia driver and doesn't influence what's
following.)

BUG: sleeping function called from invalid context at kernel/mutex.c:280
in_atomic(): 1, irqs_disabled(): 1, pid: 10, name: events/0
INFO: lockdep is turned off.
irq event stamp: 2034
hardirqs last  enabled at (2033): [<c0347b07>]
_spin_unlock_irqrestore+0x3c/0x6c
hardirqs last disabled at (2034): [<c03475d0>] _spin_lock_irq+0x11/0x3f
softirqs last  enabled at (2008): [<c012f598>] __do_softirq+0x114/0x11c
softirqs last disabled at (1971): [<c010593a>] do_softirq+0x69/0xc7
Pid: 10, comm: events/0 Tainted: P           2.6.31-vanilla #1
Call Trace:
 [<c0124a3c>] __might_sleep+0x10e/0x116
 [<c0346bdd>] mutex_lock_nested+0x18/0x31
 [<c026d39b>] tty_unthrottle+0x10/0x38
 [<f8dcc31f>] ppp_sync_receive+0x168/0x170 [ppp_synctty]
 [<f8fbb9ce>] handle_minor_recv+0x187/0x1cd [capi]
 [<f8fbc19b>] capi_recv_message+0x1d9/0x24e [capi]
 [<fa5be461>] recv_handler+0x56/0x6f [kernelcapi]
 [<c0138cba>] worker_thread+0x14a/0x21d
 [<c0138c9e>] ? worker_thread+0x12e/0x21d
 [<fa5be40b>] ? recv_handler+0x0/0x6f [kernelcapi]
 [<c013b375>] ? autoremove_wake_function+0x0/0x30
 [<c013b201>] kthread+0x64/0x69
 [<c0138b70>] ? worker_thread+0x0/0x21d
 [<c013b19d>] ? kthread+0x0/0x69
 [<c0103f33>] kernel_thread_helper+0x7/0x10

Turns out the ppp_sync_receive() function (drivers/net/ppp_synctty.c
line 385ff.) has a comment in front stating:

/*
 * This can now be called from hard interrupt level as well
 * as soft interrupt level or mainline.
 */

but calls tty_unthrottle() which in turn calls mutex_lock() which of
course can sleep.

That tty_unthrottle() call was already removed once by

commit a6540f731d506d9e82444cf0020e716613d4c46c
Author: Alan Cox <alan@linux.intel.com>
Date:   Mon Jun 22 18:42:29 2009 +0100

    ppp: Fix throttling bugs

but re-added by

commit 4a21b8cb3550f19f838f7c48345fbbf6a0e8536b
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Jul 16 09:14:23 2009 -0700

    Revert "ppp: Fix throttling bugs"

    This reverts commit a6540f731d506d9e82444cf0020e716613d4c46c, as
    requested by Alan:

      "... as it was wrong, the pty code is now fixed and the fact this
       isn't reverted is breaking pptp setups."

Opinions?

Thanks,
Tilman

- --
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFKw3AyQ3+did9BuFsRAiZXAKCGaos/qZNTlStEP4SE90PA0ZoMAQCdFtvf
U9chE7at35y8c6CGGS1IGg0=
=Vpq4
-----END PGP SIGNATURE-----
