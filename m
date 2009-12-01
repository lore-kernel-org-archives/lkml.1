Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbZLATxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbZLATxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 14:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbZLATxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 14:53:46 -0500
Received: from www.tglx.de ([62.245.132.106]:49165 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbZLATxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 14:53:45 -0500
Date: Tue, 1 Dec 2009 20:53:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>
Subject: Re: [PATCH] audit: Call tty_audit_push_task() outside preempt disabled
 region
In-Reply-To: <20091201182202.GA12754@redhat.com>
Message-ID: <alpine.LFD.2.00.0912012051590.24119@localhost.localdomain>
References: <20091130100041.GA29610@infradead.org> <alpine.LFD.2.00.0911300722370.2872@localhost.localdomain> <20091130174638.GA9782@elte.hu> <alpine.LFD.2.00.0911302206370.24119@localhost.localdomain> <1259616429.26472.499.camel@laptop>
 <alpine.LFD.2.00.0911302300550.24119@localhost.localdomain> <alpine.LFD.2.00.0911301409560.2872@localhost.localdomain> <alpine.LFD.2.00.0911302328350.24119@localhost.localdomain> <alpine.LFD.2.00.0911301443110.2872@localhost.localdomain>
 <alpine.LFD.2.00.0912011608070.24119@localhost.localdomain> <20091201182202.GA12754@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009, Oleg Nesterov wrote:
> On 12/01, Thomas Gleixner wrote:
> >
> > -void tty_audit_push_task(struct task_struct *tsk, uid_t loginuid, u32 sessionid)
> > +int tty_audit_push_task(struct task_struct *tsk, uid_t loginuid, u32 sessionid)
> >  {
> > -	struct tty_audit_buf *buf;
> > +	struct tty_audit_buf *buf = NULL;
> > +	unsigned long flags;
> >
> > -	spin_lock_irq(&tsk->sighand->siglock);
> > -	buf = tsk->signal->tty_audit_buf;
> > -	if (buf)
> > +	if (!lock_task_sighand(tsk, &flags))
> > +		return -ESRCH;
> > +
> > +	if (tsk->signal->audit_tty && tsk->signal->tty_audit_buf) {
> > +		buf = tsk->signal->tty_audit_buf;
> >  		atomic_inc(&buf->count);
> > -	spin_unlock_irq(&tsk->sighand->siglock);
> > +	}
> > +	unlock_task_sighand(tsk, &flags);
> > +
> >  	if (!buf)
> > -		return;
> > +		return -EPERM;
> 
> I think the patch is correct, but it changes the behaviour of
> audit_prepare_user_tty() a bit.
> 
> Suppose that signal->audit_tty != NULL but signal->tty_audit_buf
> is not allocated yet. In this audit_prepare_user_tty() returns 0
> before the patch and -EPERM after.
> 
> I do not know if this matters, just to be sure this is OK.

Hmm, true. Missed that. Thanks for catching it.

     tglx
