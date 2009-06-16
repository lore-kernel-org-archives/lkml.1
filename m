Return-Path: <linux-kernel-owner+w=401wt.eu-S1759057AbZFPHL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbZFPHL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 03:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756281AbZFPHLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 03:11:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48088 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950AbZFPHLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 03:11:07 -0400
Date: Tue, 16 Jun 2009 09:10:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [bug] WARNING: at drivers/char/tty_io.c:1266 tty_open+0x1ea/0x388()
Message-ID: <20090616071057.GA29862@elte.hu>
References: <20090614081052.GA9276@elte.hu> <20090614115428.1127ed2d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090614115428.1127ed2d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Sun, 14 Jun 2009 10:10:52 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > Ok, this is one for those who like to look at weird crashes/bugs.
> > 
> > Here's a new regression that popped up in this merge window, there's 
> > some sort of slab corruption going on in tty data structures:
> 
> I split the ldisc and tty apart and redid the ldisc locking so its a fair
> bet I know what changeset is to blame, will just need to hunt it down a
> bit. kmemcheck found one leak case on Friday which I've fixed but not yet
> scribbles.
> 
> >  c65c9bc: tty: rewrite the ldisc locking
> 
> Almost certainly that one and will investigate on Monday

I have applied your patch from yesterday (attached further below for 
reference) and the SLAB corruption has not triggered - instead i'm 
now getting this warning, after 96 reboots:

[   20.782199] sshd used greatest stack depth: 5376 bytes left
[   22.260149] ------------[ cut here ]------------
[   22.261027] WARNING: at drivers/char/tty_io.c:1266 tty_open+0x1ea/0x388()
[   22.262018] Hardware name: System Product Name
[   22.262020] Modules linked in:
[   22.262024] Pid: 2553, comm: modprobe Tainted: G        W  2.6.30-tip #54059
[   22.262026] Call Trace:
[   22.262032]  [<c102d810>] warn_slowpath_common+0x60/0x90
[   22.262037]  [<c102d84d>] warn_slowpath_null+0xd/0x10
[   22.262041]  [<c11a88ae>] tty_open+0x1ea/0x388
[   22.262045]  [<c108e4c2>] chrdev_open+0x11b/0x132
[   22.262049]  [<c108a8a6>] __dentry_open+0x167/0x265
[   22.262052]  [<c108aa3e>] nameidata_to_filp+0x2c/0x43
[   22.262056]  [<c108e3a7>] ? chrdev_open+0x0/0x132
[   22.262060]  [<c1094bbd>] do_filp_open+0x3cd/0x712
[   22.262064]  [<c1083460>] ? check_valid_pointer+0x1f/0x4e
[   22.262068]  [<c109cd26>] ? alloc_fd+0xcb/0xd5
[   22.262071]  [<c109cd26>] ? alloc_fd+0xcb/0xd5
[   22.262075]  [<c108a63d>] do_sys_open+0x4a/0xed
[   22.262078]  [<c1002a5e>] ? sysenter_exit+0xf/0x21
[   22.262081]  [<c108a722>] sys_open+0x1e/0x26
[   22.262085]  [<c1002a2b>] sysenter_do_call+0x12/0x36
[   22.262087] ---[ end trace 81f0afc9843492f2 ]---
[   31.191037] CPA self-test:

Another test-box has produced this warning too. (Same config and 
same hw as i sent the details for earlier in this thread.)

So there's still something fishy going on.

Thanks,

	Ingo

-------------------->
>From 9f7a9ce1955c5f7af7456363a552819a82c19896 Mon Sep 17 00:00:00 2001
From: Alan Cox <alan@linux.intel.com>
Date: Mon, 15 Jun 2009 16:32:12 +0100
Subject: [PATCH] ldisc: Make sure the ldisc isn't active when we close it

Signed-off-by: Alan Cox <alan@linux.intel.com>
LKML-Reference: <20090615153206.4036.26148.stgit@t61.ukuu.org.uk>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/char/tty_ldisc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 69b912d..0ea4f63 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -792,6 +792,8 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 		/* Avoid racing set_ldisc */
 		mutex_lock(&tty->ldisc_mutex);
 		/* Switch back to N_TTY */
+		tty_ldisc_halt(tty);
+		tty_ldisc_wait_idle(tty);
 		tty_ldisc_reinit(tty);
 		/* At this point we have a closed ldisc and we want to
 		   reopen it. We could defer this to the next open but
