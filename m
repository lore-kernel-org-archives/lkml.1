Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbZFBPf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbZFBPf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbZFBPfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:35:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47947 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366AbZFBPfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:35:51 -0400
Date: Tue, 2 Jun 2009 17:29:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Roland McGrath <roland@redhat.com>, paul@mad-scientist.net,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
Message-ID: <20090602152927.GA13515@redhat.com>
References: <1243748019.7369.319.camel@homebase.localnet> <20090531111851.07eb1df3@lxorguk.ukuu.org.uk> <20090601161234.GA10486@redhat.com> <20090601174159.48acf3f5@lxorguk.ukuu.org.uk> <20090601171119.GA13970@redhat.com> <20090601184608.6379440c@lxorguk.ukuu.org.uk> <20090601182305.GA16372@redhat.com> <20090601203845.B010DFC3C7@magilla.sf.frob.com> <20090601223241.GA26788@redhat.com> <20090602092119.1a12a356@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602092119.1a12a356@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02, Alan Cox wrote:
>
> > Perhaps it is easier to change dump_write() to clear TIF_SIGPENDING
> > unless fatal_signal_pending(),
>
> If you are receiving a continuous stream of SIGIO's say then how do you
> guarantee the code below will make progress ?

Yes, the second SIGIO has no effect.

> > 	int coredump_file_write(struct file *file, const void *addr, int nr)
> > 	{
> > 		while (nr > 0) {
> > 			int res = file->f_op->write(file, addr, nr, &file->f_pos);
> >
> > 			if (res > 0) {
> > 				nr -= res;
> > 				continue;
> > 			}
> >
> > 			if (!signal_pending(current))
> > 				break;
> > 			if (__fatal_signal_pending(current))
> > 				break;
> > 			clear_thread_flag(TIF_SIGPENDING);
> > 		}
> >
> > 		return !nr;
> > 	}
> >
>
> > Of course, this all assumes f_op->write() does not do recalc_sigpending().
>
> Which is itself a dangerous assumption that shouldn't be propogated.

I don't think this assumption is dangerous. Why should ->write() call
recalc_sigpending() ? It should not be called outside of signal code.

But yes, if we add SIGNAL_GROUP_DUMPING we can change recalc_sigpending_tsk().
Just I don't like the idea to slow down / complicate this helper for the
very special case.


Hmm. Does ->core_dump() report the state of ->sighand->action? I can't
find any usage. Perhaps we can just ignore all signals except SIGKILL ?

Oleg.

