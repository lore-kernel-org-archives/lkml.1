Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbYHRQmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbYHRQmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbYHRQmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:42:46 -0400
Received: from ns1.suse.de ([195.135.220.2]:55489 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbYHRQmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:42:45 -0400
Date: Mon, 18 Aug 2008 09:39:06 -0700
From: Greg KH <gregkh@suse.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andrei Popa <andrei.popa@i-neo.ro>, Oliver Neukum <oneukum@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel oops
Message-ID: <20080818163906.GA11619@suse.de>
References: <1216817556.4415.29.camel@ierdnac> <20080723171144.GA7349@localhost.localdomain> <19f34abd0808180933r509b402i70fced0e1678d6fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0808180933r509b402i70fced0e1678d6fe@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 06:33:42PM +0200, Vegard Nossum wrote:
> On Wed, Jul 23, 2008 at 7:11 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > On Wed, Jul 23, 2008 at 2:52 PM, Andrei Popa <andrei.popa@i-neo.ro> wrote:
> >>
> >> I installed gnokii-0.6.22-r2 and gave the command "gnokii --identify"
> >> and the kernel oopsed:
> >>
> >> BUG: unable to handle kernel NULL pointer dereference at 00000458
> >> IP: [<c0444b52>] mutex_unlock+0x0/0xb
> >> *pde = 00000000
> >> Oops: 0002 [#1] PREEMPT SMP
> >>
> >> Pid: 19043, comm: gnokii Not tainted (2.6.26-ineo7 #2)
> >> EIP: 0060:[<c0444b52>] EFLAGS: 00010246 CPU: 0
> >> EIP is at mutex_unlock+0x0/0xb
> > ...
> >>  [<c03830ae>] acm_tty_open+0x4c/0x214
> >
> > This shouldn't be too hard; the code is trying to unlock the mutex
> > &acm->mutex even when "acm" is NULL. It seems that the label "err_out"
> > is otherwise unused, so it makes sense to move this one step further
> > down, so that it doesn't try to unlock the non-existent mutex.
> >
> > If the problem is reproducible, you could try the patch below!
> >
> >
> > Vegard
> >
> > PS: I actually think the code has some other problems too. Shouldn't
> > &acm->mutex be locked before we even inspect acm->dev?
> >
> >
> > Reported-by: Andrei Popa <andrei.popa@i-neo.ro>
> > Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> >
> > diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
> > index 63c3404..74d03a7 100644
> > --- a/drivers/usb/class/cdc-acm.c
> > +++ b/drivers/usb/class/cdc-acm.c
> > @@ -525,8 +525,8 @@ static int acm_tty_open(struct tty_struct *tty, struct file *filp)
> >        tasklet_schedule(&acm->urb_task);
> >
> >  done:
> > -err_out:
> >        mutex_unlock(&acm->mutex);
> > +err_out:
> >        mutex_unlock(&open_mutex);
> >        return rv;
> >
> >
> 
> Hi,
> 
> Latest -git seems to have the same problem, and this was about three
> weeks ago, so.. Ping?

Hm, I thought I took a patch to fix this a few weeks ago.

Oliver, have I missed anything recently?

thanks,

greg k-h
