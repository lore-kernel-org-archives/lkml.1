Return-Path: <linux-kernel-owner+w=401wt.eu-S1752737Ab0AZXFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab0AZXFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628Ab0AZXFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:05:16 -0500
Received: from cantor.suse.de ([195.135.220.2]:57951 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab0AZXFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:05:13 -0500
Date: Tue, 26 Jan 2010 15:04:02 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Al Viro <viro@ZenIV.linux.org.uk>,
       Tavis Ormandy <taviso@google.com>, Jeff Dike <jdike@addtoit.com>,
       Julien Tinnes <jln@google.com>, Matt Mackall <mpm@selenic.com>
Subject: Re: [06/11] tty: fix race in tty_fasync
Message-ID: <20100126230402.GB24281@suse.de>
References: <20100126191624.538119758@mini.kroah.org>
 <m1bpggy7bt.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.1001261357390.3574@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001261357390.3574@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 02:11:28PM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 26 Jan 2010, Eric W. Biederman wrote:
> 
> > Greg KH <gregkh@suse.de> writes:
> > 
> > > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> > 
> > Only that __f_setown by way of f_modown unconditionally enables interrupts.  So
> > without touching f_modown as well in mainline we have nasty sounding lockdep warnings.
> 
> Hmm. That seems to be true in mainline too, isn't it?
> 
> So now we have:
>  - tty_fasync() gets tty->ctrl_lock, with spin_lock_irqsave()
> 
>  - it then calls __f_setown()
> 
>  - which calls f_modown(),
> 
>  - which does
> 
> 	write_lock_irq(&filp->f_owner.lock);
> 	..
> 	write_unlock_irq(&filp->f_owner.lock);
> 
>    which in turn enables interrupts while we still hold ctrl_lock.
> 
> so that whole commit 70362511806 was/is buggy in mainline too. 
> 
> The minimal fix is likely to just make f_modown() use 
> write_lock_irqsave/restore. Greg?

Yes, that looks correct.

Here's a patch that does just that:
---------

From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: fnctl: f_modown should call write_lock_irqsave/restore

Commit 703625118069f9f8960d356676662d3db5a9d116 exposed that f_modown()
should call write_lock_irqsave instead of just write_lock_irq so that
because a caller could have a spinlock held and it would not be good to
renable interrupts.

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tavis Ormandy <taviso@google.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 97e01dc..5ef953e 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -199,7 +199,9 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
                      int force)
 {
-	write_lock_irq(&filp->f_owner.lock);
+	unsigned long flags;
+
+	write_lock_irqsave(&filp->f_owner.lock, flags);
 	if (force || !filp->f_owner.pid) {
 		put_pid(filp->f_owner.pid);
 		filp->f_owner.pid = get_pid(pid);
@@ -211,7 +213,7 @@ static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
 			filp->f_owner.euid = cred->euid;
 		}
 	}
-	write_unlock_irq(&filp->f_owner.lock);
+	write_unlock_irqrestore(&filp->f_owner.lock, flags);
 }
 
 int __f_setown(struct file *filp, struct pid *pid, enum pid_type type,
