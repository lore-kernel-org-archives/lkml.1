Return-Path: <linux-kernel-owner+w=401wt.eu-S1752052AbZGYRGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbZGYRGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 13:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbZGYRGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 13:06:37 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:44439 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbZGYRGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 13:06:37 -0400
Date: Sat, 25 Jul 2009 22:36:25 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ray Lee <ray-lk@madrabbit.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression] kdesu broken
Message-ID: <20090725170625.GA6671@skywalker>
References: <200907240145.31935.rjw@sisk.pl> <2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com> <20090724182547.GB29851@skywalker> <20090725130703.04c42572@lxorguk.ukuu.org.uk> <20090725161844.GA4814@skywalker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090725161844.GA4814@skywalker>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 25, 2009 at 09:48:44PM +0530, Aneesh Kumar K.V wrote:
> On Sat, Jul 25, 2009 at 01:07:03PM +0100, Alan Cox wrote:
> > > > See the thread starting here: ("possible regression with pty.c commit")
> > > >    http://lkml.org/lkml/2009/7/11/125
> > > 
> > > I am also facing a similar problem.
> > > 
> > > http://bugzilla.kernel.org/show_bug.cgi?id=13815
> > 
> > Probably something like this fixes it. I'll be working on that Monday/Tuesday
> > along with various other bugs that need a review.
> > 
> > --
> > 
> > 
> > pty: ensure writes hit the reader before close
> > 
> > From: Alan Cox <alan@linux.intel.com>
> > 
> > Logically we move the buffering from one side to the other
> > ---
> > 
> >  drivers/char/pty.c |   11 +++++++++++
> >  1 files changed, 11 insertions(+), 0 deletions(-)
> > 
> > 
> > diff --git a/drivers/char/pty.c b/drivers/char/pty.c
> > index 6e6942c..7555890 100644
> > --- a/drivers/char/pty.c
> > +++ b/drivers/char/pty.c
> > @@ -36,6 +36,15 @@ static struct tty_driver *ptm_driver;
> >  static struct tty_driver *pts_driver;
> >  #endif
> > 
> > +static int pty_empty(struct tty_struct *tty)
> > +{
> > +	if (tty->buf.memory_used == 0)
> > +		return 1;
> > +	if (test_bit(TTY_HUPPED, &tty->flags))
> > +		return 1;
> > +	return 0;
> > +}
> > +
> >  static void pty_close(struct tty_struct *tty, struct file *filp)
> >  {
> >  	BUG_ON(!tty);
> > @@ -47,9 +56,11 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
> >  	}
> >  	wake_up_interruptible(&tty->read_wait);
> >  	wake_up_interruptible(&tty->write_wait);
> > +	
> >  	tty->packet = 0;
> >  	if (!tty->link)
> >  		return;
> > +	wait_event_interruptible(tty->write_wait, pty_empty(tty->link));
> >  	tty->link->packet = 0;
> >  	set_bit(TTY_OTHER_CLOSED, &tty->link->flags);
> >  	wake_up_interruptible(&tty->link->read_wait);
> 
> 
> After applying the patch on Fedora 10 the system bootup hangs after modrpobe.
> on ubuntu jaunty i have the system booting fine. But trying to recompile
> the test prg on emacs gives me the error message 
> 
> -UUU:%*--F1  *compilation*   All (1,0)      (Compilation:run Compiling)----<E> -------
> A compilation process is running; kill it? (yes or no)
> 
> So i guess even though it gets the error information it cause emacs to think that
> the compliation process is still running. The process details listed by emacs
> Proc        Status   Buffer        Tty        Command 
> ----        ------   ------        ---        -------
> compilation run      *compilation* /dev/pts/2 /bin/bash -c cc -g a.c                                                                     
> 
> But a ps -eaf doesn't list the command running. So something more  is going on. 
> 

ok i have in the process list

kvaneesh  6584  6583  0 22:34 pts/6    00:00:00 [cc]

-aneesh
