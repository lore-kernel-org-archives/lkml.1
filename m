Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbZB1Cav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbZB1Cav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 21:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbZB1Cam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 21:30:42 -0500
Received: from n16.bullet.mail.mud.yahoo.com ([68.142.206.43]:24811 "HELO
	n16.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752196AbZB1Cal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 21:30:41 -0500
X-Yahoo-Newman-Id: 667207.72890.bm@omp420.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iEcB4WQGpX2eVklVSmNB3KoQOoaryR9UD39FjhClk2Th6Hp7a+OGZuTTOX2+xaAuwujMSxekiGnTT2Rxvlw5aup0PiZtnBE6NMK8teWSxz64IC3gOtq5C7uRciwx+vVFCihixbZ9sa1LkLbWCvd8Jwb5153MyxXHHfO3W3/Q5Rc=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: lockdep and threaded IRQs (was: ...)
Date: Fri, 27 Feb 2009 18:30:36 -0800
User-Agent: KMail/1.9.10
Cc: me@felipebalbi.com, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, felipe.balbi@nokia.com,
       dmitry.torokhov@gmail.com, sameo@openedhand.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <20090227153204.fc9c579c.akpm@linux-foundation.org> <20090227160110.8cf8cd6e.akpm@linux-foundation.org>
In-Reply-To: <20090227160110.8cf8cd6e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902271830.37207.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 February 2009, Andrew Morton wrote:
> On Fri, 27 Feb 2009 15:32:04 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Why does this function:
> > 
> > static irqreturn_t powerbutton_irq(int irq, void *dev_id)
> > {
> > 	... threaded irq handler body elided ...
> > }
> > 
> > Which is connected up via this statement:
> > 
> > 	err = request_irq(irq, powerbutton_irq,
> > 			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
> > 			"twl4030-pwrbutton", NULL);
> > 
> > reenable local interrupts?

Because threaded IRQ handlers are, well, threaded.  And all
the twl4030 IRQ handlers are threaded -- must be.  But when
CONFIG_LOCKDEP is enabled, it goofs such handlers ... as well
as a bunch of other perfectly functional driver code.

In the absense of the lockdep IRQF_DISABLED goofage, the IRQs
are properly dispatched -- IRQs stay enabled while these
handlers run, all the relevant locking invariants are obeyed.


> ah, OK, twl4030_i2c_read_u8() does i2c I/O.
> 
> Can't do that. 

Threaded IRQ handlers *can* do that.  That's the point.

Now, if you were to say "keep waiting a few more years
until some threaded IRQ framework finally merges" ...
the question comes up, "What to do in the meanwhile".
(Ditto, "well, we've been waiting a long time now to
see those threaded IRQs, what's up with them?")

"Nothing" is not an option.  The "something" being done
here is a reasonably clean approach, and doesn't call
for any surgery to kernel/irq/* ... the *only* problem
is the lockdep bug, which causes trouble for a variety
of other drivers too.


> If some random process currently holds 
> mutex_lock(&twl->xfer_lock) and an interrupt occurs then this interrupt
> handler will try to acquire mutex_lock(&twl->xfer_lock).  Deadlock.

No, no, no.  *THREADED IRQ HANDLER* at work here.  Bzzt.

Threaded IRQ handler.

The relevant mutexes are *never* accessed outside of a
thread context.  Not by this code.  Not by any other code.




