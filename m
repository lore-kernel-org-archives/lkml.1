Return-Path: <linux-kernel-owner+w=401wt.eu-S1760857AbYEOU1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857AbYEOU1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbYEOU12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:27:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42142 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbYEOU10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:27:26 -0400
Date: Thu, 15 May 2008 13:27:13 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
Message-ID: <20080515132713.18f1b953@infradead.org>
In-Reply-To: <alpine.LFD.1.10.0805151020460.3019@woody.linux-foundation.org>
References: <20080514174955.GA515@elte.hu>
	<alpine.LFD.1.10.0805151020460.3019@woody.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 10:41:54 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> So looking a bit more at your trivial fixups, I'd suggest strongly
> that they be re-organized a bit.

> >
> > diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
> > index 6eab9bf..e12e571 100644
> > --- a/net/sunrpc/sched.c
> > +++ b/net/sunrpc/sched.c
> > @@ -224,9 +224,15 @@ EXPORT_SYMBOL_GPL(rpc_destroy_wait_queue);
> >  
> >  static int rpc_wait_bit_killable(void *word)
> >  {
> > +	int bkl = kernel_locked();
> > +
> >  	if (fatal_signal_pending(current))
> >  		return -ERESTARTSYS;
> > +	if (bkl)
> > +		unlock_kernel();
> >  	schedule();
> > +	if (bkl)
> > +		lock_kernel();
> >  	return 0;
> >  }
> 
> The above doesn't even work in general. It depends on having just a
> single level of locking, and is ugly to boot. So wow about we just
> expose some version of
> 
> 	depth = release_kernel_lock()
> 	..
> 	reacquire_kernel_lock(depth);
> 
> to existing BKL users as a way to safely release and re-aquire it 
> regardless of depth. That makes the code more generic, but it *also*
> makes it more readable than that "if (bkl) [un]lock_kernel()"
> sequence.


can we make this even more specific/restricted? Like having something
like

call_bkl_unlocked(function_pointer, argument);

or something that will internally do the full unlock and then the
function call. The last thing we need is another nailgun that BKL using
code can use to staple themselves to something big and fast moving.
By having a more restricted interface... less likely.
Maybe we can even get away with only a

drop_bkl_and_schedule();

and nothing else.



