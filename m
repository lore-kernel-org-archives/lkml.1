Return-Path: <linux-kernel-owner+w=401wt.eu-S933819AbZLFO4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933819AbZLFO4W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 09:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933796AbZLFO4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 09:56:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933795AbZLFO4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 09:56:19 -0500
Date: Sun, 6 Dec 2009 15:49:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Miloslav Trmac <mitr@redhat.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Renaud Lottiaux <renaud.lottiaux@kerlabs.com>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       David Howells <dhowells@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Veaceslav Falico <vfalico@redhat.com>
Subject: Re: [PATCH v2 4/4] copy_signal cleanup: clean tty_audit_fork()
Message-ID: <20091206144934.GA3637@redhat.com>
References: <20091205165804.GD23152@redhat.com> <1166728910.1204311260043462476.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1166728910.1204311260043462476.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05, Miloslav Trmac wrote:
>
> ----- "Oleg Nesterov" <oleg@redhat.com> wrote:
> > On 12/04, Veaceslav Falico wrote:
> > > diff --git a/drivers/char/tty_audit.c b/drivers/char/tty_audit.c
> > > index ac16fbe..283a15b 100644
> > > --- a/drivers/char/tty_audit.c
> > > +++ b/drivers/char/tty_audit.c
> > > @@ -148,7 +148,6 @@ void tty_audit_fork(struct signal_struct *sig)
> > >  	spin_lock_irq(&current->sighand->siglock);
> > >  	sig->audit_tty = current->signal->audit_tty;
> > >  	spin_unlock_irq(&current->sighand->siglock);
> > > -	sig->tty_audit_buf = NULL;
> > >  }
> >
> > Off-topic question to this who understands this code.
> >
> > But afaics we can also remove ->siglock from this helper and make
> > it really trivial for being inline. ->siglock buys nothing, we just
> > read a boolean. In fact, after the quick grep I do not understand
> > how ->siglock is connected to ->audit_tty. OK, it protects
> > tty_audit_buf,
> > but why we always take ->siglock to access ->audit_tty ?
> AFAIK there is no explicit documentation of the atomicity semantics
> expected by the Linux kernel (both from the hardware and from the compiler),
> so every access to the boolean is protected by a lock, to be on the safe side.

Not sure I understand, but the kernel relies on fact it is always safe
to load/store a word.

What atomicity semantics do you mean and how ->siglock can help? Sure,
we can race with AUDIT_TTY_SET, but this can happen with or without
this lock. This "race" is unavoidable and harmless.

I believe every spin_lock(siglock) around ->audit_tty is bogus.

Oleg.

