Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796Ab0A0Bsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab0A0Bsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 20:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671Ab0A0Bs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 20:48:29 -0500
Received: from kroah.org ([198.145.64.141]:39499 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539Ab0A0Bs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 20:48:28 -0500
Date: Tue, 26 Jan 2010 17:47:09 -0800
From: Greg KH <greg@kroah.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Americo Wang <xiyou.wangcong@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Tavis Ormandy <taviso@google.com>,
       Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>,
       Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Patch] fix the lockdep warning in tty_fasync()
Message-ID: <20100127014709.GA1189@kroah.com>
References: <m1ljflxcyl.fsf@fess.ebiederm.org>
 <20100126155819.GB3780@hack>
 <20100127100742.6AD8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100127100742.6AD8.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 10:09:04AM +0900, KOSAKI Motohiro wrote:
> > Commit 703625118 causes a lockdep warning:
> >  
> > [ INFO: possible irq lock inversion dependency detected ]
> > 2.6.33-rc5 #77
> > ---------------------------------------------------------
> > emacs/1609 just changed the state of lock:
> >  (&(&tty->ctrl_lock)->rlock){+.....}, at: [<ffffffff8127c648>]
> > tty_fasync+0xe8/0x190
> > but this lock took another, HARDIRQ-unsafe lock in the past:
> >  (&(&sighand->siglock)->rlock){-.....}
> > 
> > This is due to we use write_lock_irq() in __f_setown() which turns
> > the IRQ on in write_unlock_irq(), causes this warning.
> > 
> > Switch it to write_lock_irqsave() and write_unlock_irqrestore(),
> > as suggested by Eric.
> > 
> > Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > 
> > ---
> > diff --git a/fs/fcntl.c b/fs/fcntl.c
> > index 97e01dc..82cc8a7 100644
> > --- a/fs/fcntl.c
> > +++ b/fs/fcntl.c
> > @@ -199,7 +199,8 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
> >  static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
> >                       int force)
> >  {
> > -	write_lock_irq(&filp->f_owner.lock);
> > +	unsigned long flags;
> > +	write_lock_irqsave(&filp->f_owner.lock, flags);
> >  	if (force || !filp->f_owner.pid) {
> >  		put_pid(filp->f_owner.pid);
> >  		filp->f_owner.pid = get_pid(pid);
> > @@ -211,7 +212,7 @@ static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
> >  			filp->f_owner.euid = cred->euid;
> >  		}
> >  	}
> > -	write_unlock_irq(&filp->f_owner.lock);
> > +	write_unlock_irqrestore(&filp->f_owner.lock, flags);
> >  }
> >  
> >  int __f_setown(struct file *filp, struct pid *pid, enum pid_type type,
> 
> I've confirmed the warning disappear :)

Great, I did the same fix, it's now commit id
b04da8bfdfbbd79544cab2fadfdc12e87eb01600 in Linus's tree.

thanks for testing,

greg k-h
