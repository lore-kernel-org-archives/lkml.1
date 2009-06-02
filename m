Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbZFBAOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbZFBAOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 20:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbZFBAON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 20:14:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41685 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbZFBAOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 20:14:12 -0400
Date: Tue, 2 Jun 2009 02:08:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, paul@mad-scientist.net,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
Message-ID: <20090602000850.GA31064@redhat.com>
References: <1243748019.7369.319.camel@homebase.localnet> <20090531111851.07eb1df3@lxorguk.ukuu.org.uk> <20090601161234.GA10486@redhat.com> <20090601174159.48acf3f5@lxorguk.ukuu.org.uk> <20090601171119.GA13970@redhat.com> <20090601184608.6379440c@lxorguk.ukuu.org.uk> <20090601182305.GA16372@redhat.com> <20090601203845.B010DFC3C7@magilla.sf.frob.com> <20090601223241.GA26788@redhat.com> <20090601230210.C0B15FC3C7@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601230210.C0B15FC3C7@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01, Roland McGrath wrote:
>
> That is almost a separate subject, really.  Having i/o calls' waits wrongly
> interrupted and then clearing TIF_SIGPENDING just seems goofy to me.

Yes, agreed. The patch I sent make the coredumping task invisible to all
signals except SIGKILL.

> But there is the possibility of recalc_sigpending_and_wake
> via cancel_freezing, at least.  Seems safer to make recalc_sigpending_tsk
> robust in this case.

Oh, I forgot about freezer...

Well, not good to complicate recalc_sigpending_tsk() for this unlikely case.
And this can't help, freezer does signal_wake_up() unconditionally.

So in fact this is another argument to check signal_pending() and clear it
in dump_write/seek.

But since the coredumping task is not freezable anyway, perhaps we should
change fake_signal_wake_up() to ignore SIGNAL_GROUP_DUMPING task.

Or we should make the coredumping freezable. This means dump_write/seek
and exit_mm() should do try_to_freeze().


In any case, the coredumping is special. If ->write() returns -ERESTART/EINTR
it assumes the return to ths user-space, this is not true for the coredump.
This means that handling the spurious signals in coredump_file_write() is
not so bad if we can't avoid this.

Oleg.

