Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbZCECuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbZCECuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 21:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbZCECuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 21:50:07 -0500
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:45469 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752600AbZCECuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 21:50:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=cvBnMLzadFe0XvxzToWd10pMMYhidvrkA3t35QpNiRUP3Cuv7pjVrBq32kVtd7/4XMoZxrK/oIuIxP6xORIcUFImTj0QEfFmLcODy7iYckCu1W8ro/VjiS/CkH34uSoz+1f8GAa8t+sebmpak8HplCLKJ52aomc+ZhtYLebUfv4=  ;
X-YMail-OSG: xejmZbgVM1l8Sao3RtciwFQVlP5KoE79LBY3MsUmv.G3gtGh4yf.gG4FGAZ3N_qAwv2yBC7OebPVKD7l.OjxoEoQp0JftQGIhh1vwx48fvU36JBUM_zAusW1jhi3w0aylisWTPB1u3y1PDo3NGjnb_qDuXvDB.dAAwVf_VmhCn3nu8zTyhUXcB2jMRKi
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: lockdep and threaded IRQs (was: ...)
Date: Wed, 4 Mar 2009 18:49:59 -0800
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903021542.25153.david-b@pacbell.net> <alpine.LFD.2.00.0903031207240.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903031207240.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903041850.00108.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 March 2009, Thomas Gleixner wrote:
> > 
> > > [patch 0/4] genirq: add infrastructure for threaded interrupt handlers V2
> > 
> > I did check them out, as noted earlier in this thread.
> > 
> > The significant omission is lack of support for chaining
> > such threads.  Example, an I2C device that exposes
> > several dozen IRQs with mask/ack/... operations that
> > require I2C access.
> 
> Well, the significant omission is on your side.

The facts don't quite match up with that story though ... for
starters, as I've already pointed out in this thread, I didn't
write that code (or even "create a private form of abuse" as 
you put it).  My name isn't even on the copyright. 

I did however clean it up a lot, in hope that such cleanup
would make later updates easier.  Anyone could tell such
updates would be needed.  In fact ...


> Instead of talking to 
> us about the problems and possible shortcomings of the genirq code you
> went there and created your private form of abuse and now you are
> complaining about that.

... I told you about that  *SPECIFIC* driver at the kernel summit,
as something to address with the threaded IRQ infrastructure you
presented at that time.  (The prototype Overo hardware you received
at that time uses this driver, so you could even have tested such
things.  If you went a bit out of your way to do so.)  ISTR cc'ing
you on the IRQ details of that driver a few times around, for that
matter, in case you had some feedback.

Your IRQ threading patches appeared well after this driver went
to mainline.  So I did talk to "us" about those problems, earlier,
but it doesn't seem to have gotten your attention until now.


> The lockdep issue is not caused by lockdep, 
> it's caused by your using code which is designed to run in hardirq
> context from a thread context. It does not become more correct just
> because it works fine w/o lockdep.

No; there are two lockdep symptoms caused by forcing
IRQF_DISABLED on in all cases. I'm repeating myself
again here, again ...

 - one symptom shows up in standard hardirq code, I
   gave the example of two MMC host adapters which
   don't work because of those semantic changes.

 - this driver shows a related symptom, since it needs
   to chain IRQ threads.

You're referring to the second issue.  The code in
question doesn't actually have any dependency on
hardirq context though.


> > I'm not sure what Thomas intends to do with that issue,
> 
> I can do something about that, when I know about it, but I have just
> learned about the details in the last few days.

Well, I did tell you about this earlier.


> > if anything.  It does touch on messy bits of genirq.
> 
> Which mess are you referring to ? 

Assuming all IRQ configuring and dispatching runs with IRQs
disabled.  Your threaded IRQ patches kick in only *after*
dispatching has been done.  So it affects just one of the
three main unusual bits of behavior involved here.

Which mess were you thinking of?  :)


> The problem you described is straight forward and as I said before
> it's not rocket science to provide support for that in the genirq
> code. Your use case does not need to use the chained handler setup at
> all, it just needs to request the main IRQ as a simple type and handle
> the ack/mask/unmask from the two handler parts.

When there is a "main IRQ" that calls the handlers, that's
exactly what chaining involves ...


> The only change in the generic code which is needed is a new handler
> function for the chained irqs "handle_irq_simple_threaded()" which is
> designed to handle the calls from thread context.

I'm not 100% sure that's right; the dispatching is a bit quirky.
That is however where I'll start.

The top level handler (for the PIH module) could easily use a
"handle_irq_simple_threaded()", yes ... but the secondary (SIH)
handlers have a few oddball behaviors including mixes of edge
and level trigger modes. 

- Dave

