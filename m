Return-Path: <linux-kernel-owner+w=401wt.eu-S1763038AbYEGG3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763038AbYEGG3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 02:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756293AbYEGG2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 02:28:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58197 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbYEGG2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 02:28:51 -0400
Date: Wed, 7 May 2008 08:28:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Matthew Wilcox <matthew@wil.cx>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080507062834.GA30306@elte.hu>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <1210126286.3453.37.camel@ymzhang> <1210131712.3453.43.camel@ymzhang> <20080507062639.GA26031@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507062639.GA26031@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > 3) Caller of lock_kernel are sys_fcntl/vfs_ioctl/tty_release/chrdev_open.
> 
> that's one often-forgotten BKL site: about 1000 ioctls are still 
> running under the BKL. The TTY one is hurting the most. [...]

although it's an unlocked_ioctl() now in 2.6.26, so all the BKL locking 
has been nicely pushed down to deep inside the tty code.

> [...] To make sure it's only that BKL acquire/release that hurts, 
> could you try the hack patch below, does it make any difference to 
> performance?

if you use a serial console you will need the updated patch below.

	Ingo

---------------------->
Subject: no: tty bkl
From: Ingo Molnar <mingo@elte.hu>
Date: Wed May 07 08:21:22 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/char/tty_io.c        |    5 +++--
 drivers/serial/serial_core.c |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

Index: linux/drivers/char/tty_io.c
===================================================================
--- linux.orig/drivers/char/tty_io.c
+++ linux/drivers/char/tty_io.c
@@ -2844,9 +2844,10 @@ out:
 
 static int tty_release(struct inode *inode, struct file *filp)
 {
-	lock_kernel();
+	/* DANGEROUS - can crash your kernel! */
+//	lock_kernel();
 	release_dev(filp);
-	unlock_kernel();
+//	unlock_kernel();
 	return 0;
 }
 
Index: linux/drivers/serial/serial_core.c
===================================================================
--- linux.orig/drivers/serial/serial_core.c
+++ linux/drivers/serial/serial_core.c
@@ -1241,7 +1241,7 @@ static void uart_close(struct tty_struct
 	struct uart_state *state = tty->driver_data;
 	struct uart_port *port;
 
-	BUG_ON(!kernel_locked());
+//	BUG_ON(!kernel_locked());
 
 	if (!state || !state->port)
 		return;

