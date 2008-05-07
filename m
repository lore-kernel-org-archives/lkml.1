Return-Path: <linux-kernel-owner+w=401wt.eu-S1762624AbYEGG1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762624AbYEGG1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 02:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756174AbYEGG07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 02:26:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34047 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754872AbYEGG05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 02:26:57 -0400
Date: Wed, 7 May 2008 08:26:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Matthew Wilcox <matthew@wil.cx>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080507062639.GA26031@elte.hu>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <1210126286.3453.37.camel@ymzhang> <1210131712.3453.43.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210131712.3453.43.camel@ymzhang>
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


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> 3) Caller of lock_kernel are sys_fcntl/vfs_ioctl/tty_release/chrdev_open.

that's one often-forgotten BKL site: about 1000 ioctls are still running 
under the BKL. The TTY one is hurting the most. To make sure it's only 
that BKL acquire/release that hurts, could you try the hack patch below, 
does it make any difference to performance?

but even if taking the BKL does hurt, it's quite unexpected to cause a 
40% drop. Perhaps AIM7 has tons of threads that exit at once and all try 
to release their controlling terminal or something like that?

	Ingo

------------------------>
Subject: DANGEROUS tty hack: no BKL
From: Ingo Molnar <mingo@elte.hu>
Date: Wed May 07 08:21:22 CEST 2008

NOT-Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/char/tty_io.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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
 
