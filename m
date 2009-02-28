Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbZB1ErN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbZB1ErN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 23:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757563AbZB1Eqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 23:46:55 -0500
Received: from n14.bullet.mail.mud.yahoo.com ([68.142.206.41]:33269 "HELO
	n14.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757517AbZB1Eqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 23:46:54 -0500
X-Yahoo-Newman-Id: 657390.55767.bm@omp420.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tNx0MPutPh1EQOMhu3m/0+Z15LOd3ZsEw+jvWXrYWo79Dio1w5WEqHOe48VLcZ/OhmjKhBXbUX8CvH89WsH/0mpXQ5bPte3R5fuEipP7rNlD0PWkABxu+miCj+/K0H5+YXM2cxR/e17/2ikd+aRL+w/B0yQON0R2HxfQeNB6ey8=  ;
X-YMail-OSG: Mh_Q5YYVM1mZnfAOJr3dhlMhjdR_TEMQPNxl_Z3UC.cM35vy_c8uP0.0AgjoYL8XRjT2CEru5Z51jIndsZP7XaZ1tALX2EAkmXT3az01ILRlSEPoraC7lkO0t.6uwdib9qEx3hYENOW6kCzsnqhlgyUV7Lmv7E8FNxHxCM7_OWdkPZx_MqxtDsz6tFHWSsLaZ6sSG76dWpl75fYr5nMmmSTXUEUJIbKi
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: lockdep and threaded IRQs (was: ...)
Date: Fri, 27 Feb 2009 20:46:50 -0800
User-Agent: KMail/1.9.10
Cc: me@felipebalbi.com, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, felipe.balbi@nokia.com,
       dmitry.torokhov@gmail.com, sameo@openedhand.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200902271830.37207.david-b@pacbell.net> <20090227183949.90f231e6.akpm@linux-foundation.org>
In-Reply-To: <20090227183949.90f231e6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902272046.50572.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 February 2009, Andrew Morton wrote:
> On Fri, 27 Feb 2009 18:30:36 -0800 David Brownell <david-b@pacbell.net> wrote:
> 
> > > ah, OK, twl4030_i2c_read_u8() does i2c I/O.
> > > 
> > > Can't do that. 
> > 
> > Threaded IRQ handlers *can* do that.  That's the point.
> > 
> > Now, if you were to say "keep waiting a few more years
> > until some threaded IRQ framework finally merges" ...
> > the question comes up, "What to do in the meanwhile".
> > (Ditto, "well, we've been waiting a long time now to
> > see those threaded IRQs, what's up with them?")
> 
> I don't have a clue what you're talking about.  Where is this "threaded
> irq handler" implementation of which you speak?  File and line?

You quoted the entirety of the *handler* a few messages ago
in this thread, where you asked the question which you
answer "ah, OK..." above.

Now, where is that being set up as being threaded?  I
referenced that a message or two earlier:

  drivers/mfd/twl4030-irq.c

Where you'll observe twl_init_irq() at line 688 setting
up the thread and the Primary IRQ Handler (PIH) dispatch.
That's pretty much bog-standard chained IRQ setup code,
except that it chains through a thread.

When an IRQ comes in, handle_twl4030_pih() acks and masks
that top level IRQ.  Then it wakes twl4030_irq_thread(),
which issues I2C operations to read the IRQ status from
the chip ... first PIH to find out which SIH modules are
raising an IRQ, then SIH to dispatch that status.  Then
handle_irq() from that thread to invoke the handler in
that thread context; it will issue more I2C ops.

And the lockdep thing kicks in through handle_irq(),
where the IRQ handler wrongly gets invoked with the
IRQs disabled -- iff lockdep is enabled.  Otherwise,
that IRQ thread is just like any other thread.

- Dave


