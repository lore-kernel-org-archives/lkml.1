Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbYDGXh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbYDGXh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 19:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbYDGXhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 19:37:20 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:34223 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754092AbYDGXhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 19:37:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=SW0TIKgRcq41YUm/1+fQlxYggXXvimyPWeXxhg+vnZ3jKIMUQ1AXH1xSKb34n6Q/6qVba952YdYXqvxCBoXqobeWGX5OoWpgFccu4GK3qtCF6KEFzJ3eNw7EheePkaShzc86YTvWmYTHPjt1VUYrmxTK9IAnopFVb4Q+cMfAbQI=  ;
X-YMail-OSG: sjKEX6kVM1kmNeYfs2aGs9OwvcLBrojbIu80BIO0Vi9kWetXOlPqGqmzbtfA8yXnaNGyVhSACA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb ehci_iaa_watchdog fix
Date: Mon, 7 Apr 2008 16:37:16 -0700
User-Agent: KMail/1.9.6
Cc: Mark Lord <lkml@rtr.ca>, pavel@suse.cz, oliver@neukum.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, jikos@suse.cz,
       gregkh@suse.de, akpm@linux-foundation.org
References: <Pine.LNX.4.44L0.0804021658170.2107-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0804021658170.2107-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804071637.16864.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 April 2008, Alan Stern wrote:
> On Wed, 2 Apr 2008, David Brownell wrote:
> 
> > > It fixes the cause rather than the symptom.
> > 
> > I'm not sure I'd agree with that.
> 
> Really?  The logic seemed clear enough to me.
> 
>      1. Evidently the ehci_iaa_watchdog routine was getting called at a 
> 	time when the host controller wasn't running -- which had to
> 	have been after it was suspended.

The change to remove the HC_IS_RUNNING test meant that routine
would then work when hcd->state is HC_STATE_SUSPENDED or possibly
HC_STATE_RESUMING.  (Since those are the two states for which
HC_IS_RUNNING fails, other than HC_STATE_HALTED which shouldn't
be happening here...)

Now, prior to the now-merged patch that was skipping some work,
and that seemed to cause resume problems.  Making it not skip
the work made the resume behave (as did the now-merged patch).


>      2. But ehci_bus_suspend() calls end_unlink_async(), which turns
> 	off the IAA watchdog timer.

Not exactly.  First, ehci_bus_suspend() force the timer off all
by itself ... way too early, while things can still retrigger it.
That's a buggy idiom that should be fixed.  (As you've agreed,
elsewhere.)

Second, it doesn't always call end_unlink_async() ... only when
one or more async unlink is still pending.

Third, if it *does* call end_unlink_async(), it can retriger
the timer when it needs to do another unlink.  Only when the
HC is halted (HC_STATE_HALT) is that logic bypassed, scrubbing
several endpoints at once.  (And a minor fourth point, direct
calls to end_unlink_async leaves the IAA IRQ machinery active.)

I think your fix handles the "one pending unlink" case, but
not the more general "N pending unlinks" ...


>      3. Hence the timer must have been restarted later on while 
> 	ehci_bus_suspend() was still running.  The call to ehci_work() 
> 	appeared to be the only place that could have happened.

Removing the state check in the watchdog changed behavior, so the
HC must have been in one of the two states I listed above when
that watchdog fired (SUSPENDED or RESUMING).  And it had work to
do, which (because of the state check) it didn't do.


>      4. Thus moving the end_unlink_async() call to after ehci_work()
> 	(or just to be doubly safe, after ehci_halt() and the change
> 	to HC_STATE_SUSPENDED) should take care of all pending QH
> 	unlinks and leave none of them unfinished.

It takes care of *ONE* pending QH unlink.  If there's more than
one, it retriggers the timer, so this problem will reappear...


> Strictly speaking, it would be best to move the del_timer_sync() calls
> to after ehci_lock is released.  But it doesn't really matter if the
> timer routines get invoked after the controller is suspended.

When the timer would be retriggered, to finish additional unlinks,
it does matter.  A complete fix for this would (a) disable the IAA
watchdog timer later, once it can never be retriggered again, and
(b) make end_unlink_async handle the multiple-unlinks case when the
HC is suspended, including not retriggering the watchdog.

- Dave


> 
> Alan Stern
> 


