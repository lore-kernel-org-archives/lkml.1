Return-Path: <linux-kernel-owner+w=401wt.eu-S1758769AbYHSUNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbYHSUNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbYHSUNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:13:25 -0400
Received: from pruts.nl ([82.94.235.106]:60831 "EHLO iron.pruts.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbYHSUNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:13:24 -0400
Date: Tue, 19 Aug 2008 22:13:11 +0200
From: Ico Doornekamp <lkml@zevv.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: TIOCGWINSZ retuns old pty size after receiving SIGWINCH
Message-ID: <20080819201311.GK29842@pruts.nl>
References: <20080810150859.GO3653@pruts.nl> <20080819004026.2dac3ba6.akpm@linux-foundation.org> <20080819075414.GV29842@pruts.nl> <20080819010702.c5300420.akpm@linux-foundation.org> <20080819114423.GB29842@pruts.nl> <20080819175639.GI29842@pruts.nl> <20080819120300.91cc6b08.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819120300.91cc6b08.akpm@linux-foundation.org>
X-Prutser: true
X-PGP-key: 4202FA2F
X-PGP-KeyServer: subkeys.pgp.net
X-PGP-Fingerprint: F042 F5CD B0A6 EC6A CB80  A829 CACD A4B5 4202 FA2F
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



* On 2008-08-19 Andrew Morton <akpm@linux-foundation.org> wrote  :

> On Tue, 19 Aug 2008 19:56:39 +0200
> Ico Doornekamp <lkml@zevv.nl> wrote:
> 
> > 
> > 
> > * On 2008-08-19 Ico Doornekamp <lkml@zevv.nl> wrote  :
> > 
> > > 
> > > 
> > > * On 2008-08-19 Andrew Morton <akpm@linux-foundation.org> wrote  :
> > > 
> > > > On Tue, 19 Aug 2008 09:54:14 +0200 Ico Doornekamp <lkml@zevv.nl> wrote:
> > > > > 
> > > > > * On 2008-08-19 Andrew Morton <akpm@linux-foundation.org> wrote  :
> > > > > 
> > > > > > On Sun, 10 Aug 2008 17:08:59 +0200 Ico Doornekamp <lkml@zevv.nl> wrote:
> > > > > > 
> > > > > > > Recently my X terminals showed annoying behaviour where the application
> > > > > > > in the terminal was not resized properly to the actual size of the X
> > > > > > > terminal emulator window, resulting in a lot of misaligned text on the
> > > > > > > screen. Hunting the issue down from the windowmanager and the terminal
> > > > > > > emulator program, I suspect the problem might lie in the kernel. I'm
> > > > > > > running 2.6.26 on a dual core i386.
> > > > > > > 
> > > > > > > What I see is this: the userspace application receives a SIGWINCH signal
> > > > > > > and acquires the terminal size usign the TIOCGWINSZ ioctl. It seems that
> > > > > > > in some cases the old instead of the new terminal size is returned.
> > > > > > > A small delay before the ioctl seems to 'fix' this behaviour.
> > > > > > > 
> > > > > > > I noticed some changes involving locking in the the pty code in the last
> > > > > > > kernel verions, could one of these changes cause the above behaviour ? If
> > > > > > > so, wouldn't this affect much more users ?
> > > > > > 
> > > > > > hm, that code is pretty simple and although it does the SIGWINCH and
> > > > > > the window-size setting in a peculiar order, it looks to be race-free.
> > > > > > 
> > > > > > Approximately what proportion of the time does it go wrong?
> > > > > 
> > > > > I guess about 10 to 20% of the resizes. I happen to be using a tiling
> > > > > window manager which causes resizing more often and more agressive then
> > > > > 'normal' window managers, I guess this helps triggering the problem.
> > > > > 
> > > > > I temporary worked around this issue this by changing the order of the
> > > > > signal and the updating of the pty size in tty_io.c's tiocswinsz(), but
> > > > > this is not much of a real fix.
> > > > > 
> > > > 
> > > > Well damn.  Are you sure?  The code looks solid to me.
> > > > 
> > > > At least, it does after 
> > > > 
> > > > Author: Alan Cox <alan@redhat.com>  2008-08-15 02:39:38
> > > > Committer: Linus Torvalds <torvalds@linux-foundation.org>  2008-08-15 10:34:07
> > > > Parent: 000b9151d7851cc1e490b2a76d0206e524f43cca (Fix race/oops in tty layer after BKL pushdown)
> > > > Branches: git-cifs, git-ia64, git-nfs, git-powerpc-merge, linux-next, remotes/origin/master
> > > > Follows: v2.6.27-rc3
> > > > Precedes: next-20080818
> > > > 
> > > >     tty: remove resize window special case
> > > > 
> > > > perhaps you're still running a kernel which is earlier than that?
> > > 
> > > I reported the behaviour on 2.6.26.2, but I was not aware this issue was
> > > adressed already in the 2.6.27 tree. I will update to the latest 2.6.27
> > > rc and report if the problem still persists.
> > 
> > I am not able to reproduce the problem with git 2.6.27-rc3-next-20080819.
> 
> That's linux-next, yes?
> 
> linux-next has additional locking in there:
> 
> commit 2283faa9cec083b6ddc1fa02a974ce1c797e847f
> Author: Alan Cox <alan@redhat.com>
> Date:   Thu Aug 14 09:53:22 2008 +1000
> 
>     tty-fix-pty-termios-race
>     
>     Kanru Chen posted a patch versus the old code which deals with the case
>     where you resize the pty side of a pty/tty pair. In that situation the
>     termios data is updated for both pty and tty but the locks are not held
>     on both sides.
>     
>     This reimplements the fix against the updated tty code. Patch by self but
>     the hard bit (noticing and fixing the bug) is thanks to Kanru Chen.
>     
>     Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
> index a8ddcba..779c6b5 100644
> --- a/drivers/char/tty_io.c
> +++ b/drivers/char/tty_io.c
> @@ -2068,7 +2068,7 @@ static int tiocgwinsz(struct tty_struct *tty, struct winsize __user *arg)
>  /**
>   *	tty_do_resize		-	resize event
>   *	@tty: tty being resized
> - *	@real_tty: real tty (if using a pty/tty pair)
> + *	@real_tty: real tty (not the same as tty if using a pty/tty pair)
>   *	@rows: rows (character)
>   *	@cols: cols (character)
>   *
> @@ -2085,6 +2085,14 @@ int tty_do_resize(struct tty_struct *tty, struct tty_struct *real_tty,
>  	mutex_lock(&tty->termios_mutex);
>  	if (!memcmp(ws, &tty->winsize, sizeof(*ws)))
>  		goto done;
> +
> +	/* If a pty/tty pair is updated we will have a real_tty defined
> +	   which doesn't match the tty. In this case as we will update
> +	   both of the tty termios sets. We can lock both mutex safely here
> +	   as in this case real_tty is the tty, tty is the pty side and we
> +	   have lock ordering */
> +	if (real_tty != tty)
> +		mutex_lock(&real_tty->termios_mutex);
>  	/* Get the PID values and reference them so we can
>  	   avoid holding the tty ctrl lock while sending signals */
>  	spin_lock_irqsave(&tty->ctrl_lock, flags);
> @@ -2102,6 +2110,8 @@ int tty_do_resize(struct tty_struct *tty, struct tty_struct *real_tty,
>  
>  	tty->winsize = *ws;
>  	real_tty->winsize = *ws;
> +	if (real_tty != tty)
> +		mutex_unlock(&real_tty->termios_mutex);
>  done:
>  	mutex_unlock(&tty->termios_mutex);
>  	return 0;
> 
> which perhaps fixed the problem.
> 
> 
> This bug may have been present in released kernels for some time - I
> think I read in another thread that CPU scheduler changes might have
> caused it to surface.  Doesn't matter really - we don't want
> user-visible races like this affecting desktop applications in stable
> kernels!
> 
> Can you please help us to complete this list?

2.6.25.9:	good
2.6.26-rc1	bad ( +/- 10% of the resizes)
2.6.26.2:	still bad ( +/- 10% of the resizes )
2.6.27-rc3:	ugly bad ( > 75% of the resizes )
linux-next	good

Any other versions to test ?

-- 
:wq
^X^Cy^K^X^C^C^C^C
