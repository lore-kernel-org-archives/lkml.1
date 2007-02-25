Return-Path: <linux-kernel-owner+w=401wt.eu-S1751024AbXBYUke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751024AbXBYUke (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 15:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbXBYUkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 15:40:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56642 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbXBYUkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 15:40:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH 4/7] Freezer: Fix vfork problem
Date: Sun, 25 Feb 2007 21:33:37 +0100
User-Agent: KMail/1.9.5
Cc: Aneesh Kumar <aneesh.kumar@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com, ego@in.ibm.com, akpm@osdl.org,
       mingo@elte.hu, vatsa@in.ibm.com, dipankar@in.ibm.com,
       venkatesh.pallipadi@intel.com
References: <200702231116.23607.rjw@sisk.pl> <200702252017.22077.rjw@sisk.pl> <20070225203154.GA2276@tv-sign.ru>
In-Reply-To: <20070225203154.GA2276@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702252133.39011.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 February 2007 21:31, Oleg Nesterov wrote:
> On 02/25, Rafael J. Wysocki wrote:
> >
> > On Sunday, 25 February 2007 16:40, Aneesh Kumar wrote:
> > > On 2/25/07, Aneesh Kumar <aneesh.kumar@gmail.com> wrote:
> > > > On 2/25/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > > On Sunday, 25 February 2007 15:33, Aneesh Kumar wrote:
> > > > > > On 2/25/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > [--snip--]
> > > 
> > > Thinking about this  i guess we have a problem with the above approach
> > > i outlined. if we have one task that is waiting on the event and more
> > > than one that can generate the event then the above logic would not
> > > work. Also with cases other than vfork; logic of tracking the waiting
> > > task gets complex. I guess what we have right now is better.
> > 
> > I assume by "righ now" you mean the latest version of my patch. ;-)
> > 
> > Still, having pondered the Pavel's suggestion for a while I think it's doable
> > without the addtitional process flag.  Patch below.
> 
> Probably I missed something, (I didn't see this patch and I missed the
> start of discussion), but I can't understand this patch.

Please see http://lkml.org/lkml/2007/2/25/53 .

> > +__wait_for_completion(struct completion *x, int freezable)
> >  {
> >  	might_sleep();
> >  
> > @@ -3817,6 +3818,9 @@ void fastcall __sched wait_for_completio
> >  			__set_current_state(TASK_UNINTERRUPTIBLE);
> >  			spin_unlock_irq(&x->wait.lock);
> >  			schedule();
> > +			if (freezable)
> > +				try_to_freeze();
> > +
> >  			spin_lock_irq(&x->wait.lock);
> >  		} while (!x->done);
> >  		__remove_wait_queue(&x->wait, &wait);
> > @@ -3824,7 +3828,7 @@ void fastcall __sched wait_for_completio
> >  	x->done--;
> >  	spin_unlock_irq(&x->wait.lock);
> >  }
> >
> > ..........
> >
> > @@ -48,6 +48,9 @@ void refrigerator(void)
> >  		task_unlock(current);
> >  		return;
> >  	}
> > +	if (current->vfork_done)
> > +		wake_up_process(current->parent);
> > +
> 
> What if current->parent doesn't have TIF_FREEZE yet? ->parent will schedule()
> again, child goes to refrigerator. Now, how can we freeze the ->parent?

Good point.  I didn't think about it.

All in all, having tried some different approaches I think that the patch at
http://lkml.org/lkml/2007/2/25/80 is the right thing to do.

Pavel, do you agree?

Rafael
