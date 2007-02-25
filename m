Return-Path: <linux-kernel-owner+w=401wt.eu-S932995AbXBYUcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbXBYUcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 15:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933700AbXBYUcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 15:32:19 -0500
Received: from mail.screens.ru ([213.234.233.54]:53285 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932995AbXBYUcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 15:32:18 -0500
Date: Sun, 25 Feb 2007 23:31:54 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Aneesh Kumar <aneesh.kumar@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
       ego@in.ibm.com, akpm@osdl.org, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com
Subject: Re: [RFC][PATCH 4/7] Freezer: Fix vfork problem
Message-ID: <20070225203154.GA2276@tv-sign.ru>
References: <200702231116.23607.rjw@sisk.pl> <cc723f590702250728ra1bbb10l190ab73ce3d6fc77@mail.gmail.com> <cc723f590702250740t1fec263cq5378027527c3d9f8@mail.gmail.com> <200702252017.22077.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702252017.22077.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25, Rafael J. Wysocki wrote:
>
> On Sunday, 25 February 2007 16:40, Aneesh Kumar wrote:
> > On 2/25/07, Aneesh Kumar <aneesh.kumar@gmail.com> wrote:
> > > On 2/25/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > On Sunday, 25 February 2007 15:33, Aneesh Kumar wrote:
> > > > > On 2/25/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> [--snip--]
> > 
> > Thinking about this  i guess we have a problem with the above approach
> > i outlined. if we have one task that is waiting on the event and more
> > than one that can generate the event then the above logic would not
> > work. Also with cases other than vfork; logic of tracking the waiting
> > task gets complex. I guess what we have right now is better.
> 
> I assume by "righ now" you mean the latest version of my patch. ;-)
> 
> Still, having pondered the Pavel's suggestion for a while I think it's doable
> without the addtitional process flag.  Patch below.

Probably I missed something, (I didn't see this patch and I missed the
start of discussion), but I can't understand this patch.

> +__wait_for_completion(struct completion *x, int freezable)
>  {
>  	might_sleep();
>  
> @@ -3817,6 +3818,9 @@ void fastcall __sched wait_for_completio
>  			__set_current_state(TASK_UNINTERRUPTIBLE);
>  			spin_unlock_irq(&x->wait.lock);
>  			schedule();
> +			if (freezable)
> +				try_to_freeze();
> +
>  			spin_lock_irq(&x->wait.lock);
>  		} while (!x->done);
>  		__remove_wait_queue(&x->wait, &wait);
> @@ -3824,7 +3828,7 @@ void fastcall __sched wait_for_completio
>  	x->done--;
>  	spin_unlock_irq(&x->wait.lock);
>  }
>
> ..........
>
> @@ -48,6 +48,9 @@ void refrigerator(void)
>  		task_unlock(current);
>  		return;
>  	}
> +	if (current->vfork_done)
> +		wake_up_process(current->parent);
> +

What if current->parent doesn't have TIF_FREEZE yet? ->parent will schedule()
again, child goes to refrigerator. Now, how can we freeze the ->parent?

Oleg.

