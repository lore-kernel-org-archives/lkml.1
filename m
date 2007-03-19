Return-Path: <linux-kernel-owner+w=401wt.eu-S1030727AbXCSWer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030727AbXCSWer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 18:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965371AbXCSWer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 18:34:47 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:50888 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965145AbXCSWeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 18:34:46 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 19 Mar 2007 15:33:25 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/13] signal/timer/event fds v6 - signalfd core ...
In-Reply-To: <20070319203615.GA83@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0703191530270.2101@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.9367.1174004536.2>
 <m1mz29xi8g.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0703191112500.2101@alien.or.mcafeemobile.com>
 <20070319203615.GA83@tv-sign.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007, Oleg Nesterov wrote:

> On 03/19, Davide Libenzi wrote:
> >
> > On Mon, 19 Mar 2007, Eric W. Biederman wrote:
> > 
> > > > +struct signalfd_ctx {
> > > > +	struct list_head lnk;
> > > > +	wait_queue_head_t wqh;
> > > > +	sigset_t sigmask;
> > > > +	struct task_struct *tsk;
> > > > +};
> > > 
> > > I think you want to use a struct pid *pid instead of a pointer to the
> > > task struct here.  It is slightly less efficient (one more
> > > dereference) but it means that we won't pin the task struct in memory
> > > indefinitely.  Pinning the task_struct like this makes for a very
> > > interesting way to get around the limits on the number of processes a
> > > user can have.
> > 
> > Hmm, when the task is detached from the sighand, we get a notify, so I 
> > could do a put from there. This would avoid the extra de-reference. I need 
> > to verify locking though ...
> 
> In that case (if I understand you correctly) we don't need {get,put}_task_struct()
> at all.
> 
> signalfd_deliver(-1) sets ctx->tsk = NULL, signalfd_get_sighand() reads ->tsk
> under rcu_read_lock(). The code becomes even simpler, we don't need to check
> list_empty(&ctx->lnk).

I'd need a get_task_struct in any case in order to safely call 
unlock_task_sighand(). At that point I'd prefer to just pass through the 
struct pid*. I'll be posting the new version for review as soon as I 
complete a few tests ...



- Davide


