Return-Path: <linux-kernel-owner+w=401wt.eu-S1760103AbXGELyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103AbXGELyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 07:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbXGELyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 07:54:16 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2433 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754788AbXGELyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 07:54:15 -0400
Date: Thu, 5 Jul 2007 11:54:00 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: oliver@neukum.org, paulus@samba.org, stern@rowland.harvard.edu,
       johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070705115400.GF3984@ucw.cz>
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <Pine.LNX.4.44L0.0707041045150.25704-100000@netrider.rowland.org> <18060.14856.824473.325660@cargo.ozlabs.ibm.com> <200707050858.03638.oliver@neukum.org> <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu> <20070705091801.GB3084@elf.ucw.cz> <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > In which way can user space tasks depend on each other in a way that
> > > > allows a them members of that cycle to be in uninterruptible sleep?
> > > 
> > >  - process A calls rename() on a fuse fs
> > >  - process B, the fuse server, starts to process the rename request
> > >  - process B is frozen before it can reply
> > > 
> > > Now process A is unfreezable.  We cannot make rename() restartable,
> > > hence it cannot be interruptible.
> > 
> > Yes, we are claiming fuse is very special in this regard, and perhaps
> > even broken.
> > 
> > Let's see. If I SIGSTOP the fuse server, I can get unrelated tasks
> > unkillable (even for SIGKILL!) forever.
> 
> Actually fuse allows SIGKILL, because it's always fatal, and the
> syscall may not be restarted.

I think you want to stick try_to_freeze() at the same places where you
do SIGKILL handling. That should solve the 'syslogd is unfreezeable'
problem.

Plus, it would be nice to find out where suspend/hibernation is
triggering fuse activity. We can then decide where to fix it -- in
fuse or in suspend parts. You said sys_sync is not implemented... so
where is the problem?

> > That's very special, and maybe even a FUSE bug. And that is also
> > what makes FUSE special w.r.t. s2ram.
> 
> What makes fuse special is that some file operations are synchronous
> and non-restartable.  That's just how the UNIX filesystem API works
> and is hardly a bug in fuse.

Well, unix is not plan9, and maybe userland filesystems are impossible
in unix. But that is hardly a bug in unix :-).

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
