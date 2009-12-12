Return-Path: <linux-kernel-owner+w=401wt.eu-S1761924AbZLLLDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924AbZLLLDO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 06:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756258AbZLLLDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 06:03:14 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60869 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756041AbZLLLDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 06:03:13 -0500
Date: Sat, 12 Dec 2009 11:02:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
Message-ID: <20091212110240.194760cc@lxorguk.ukuu.org.uk>
In-Reply-To: <20091212013927.58d386d1.akpm@linux-foundation.org>
References: <20091211232805.GA10652@kroah.com>
	<20091212084611.GA28266@elte.hu>
	<20091212013927.58d386d1.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The do_tty_hangup()->tty_fasync() path takes the locks in the
> file_list_lock()->lock_kernel() direction whereas most other code takes
> them in the other direction, which cannot be good.  But I'm not sure

Thats a bug - the BKL does want to be taken first (and will
sleep/yield/drop)

> Have a trace.  I'm actually wondering if perhaps there's a missing
> unlock_kernel() somewhere else, and the tty code is just the victim of
> that.

It's introduced by the BKL shuffle. Try the following


commit 1f61f07a985c7e8cfc20ad8fcced2f3d226bd0dc
Author: Alan Cox <alan@linux.intel.com>
Date:   Sat Dec 12 10:32:36 2009 +0000

    tty: Fix the AB-BA locking bug introduced in the BKL split
    
    The fasync path takes the BKL (it probably doesn't need to in fact) but
    this causes lock inversions and deadlocks so we can't do that. Leave the
    BKL over that bit for the moment.
    
    Identified by AKPM.
    
    Signed-off-by: Alan Cox <alan@linux.intel.com>

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 684f0e0..f15df40 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -516,7 +516,6 @@ static void do_tty_hangup(struct work_struct *work)
 	/* inuse_filps is protected by the single kernel lock */
 	lock_kernel();
 	check_tty_count(tty, "do_tty_hangup");
-	unlock_kernel();
 
 	file_list_lock();
 	/* This breaks for file handles being sent over AF_UNIX sockets ? */
@@ -531,7 +530,6 @@ static void do_tty_hangup(struct work_struct *work)
 	}
 	file_list_unlock();
 
-	lock_kernel();
 	tty_ldisc_hangup(tty);
 
 	read_lock(&tasklist_lock);
