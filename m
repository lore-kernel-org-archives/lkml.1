Return-Path: <linux-kernel-owner+w=401wt.eu-S1753765AbXFPDeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbXFPDeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 23:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbXFPDem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 23:34:42 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:15511 "EHLO
	asav17.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbXFPDel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 23:34:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlE4AAT3ckZKhRO4UGdsb2JhbACBToVjh3sBARsNBhEB
From: Dmitry Torokhov <dtor@insightbb.com>
To: Indan Zupancic <indan@nul.nu>
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
Date: Fri, 15 Jun 2007 23:34:39 -0400
User-Agent: KMail/1.9.3
Cc: Pavel Machek <pavel@ucw.cz>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Andi Kleen <ak@suse.de>, Jiri Kosina <jikos@jikos.cz>,
       kernel list <linux-kernel@vger.kernel.org>
References: <20070604112426.GA2707@elf.ucw.cz> <200706150141.06142.dtor@insightbb.com> <33677.81.207.0.53.1181959473.squirrel@secure.samage.net>
In-Reply-To: <33677.81.207.0.53.1181959473.squirrel@secure.samage.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706152334.40387.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 22:04, Indan Zupancic wrote:
> On Fri, June 15, 2007 07:41, Dmitry Torokhov wrote:
> >  /*
> > + * Schedule switch for execution. We need to throttle requests,
> > + * otherwise keyboard may become unresponsive.
> > + */
> > +static void atkbd_schedule_event_work(struct atkbd *atkbd, int event_bit)
> > +{
> > +	unsigned long delay = msecs_to_jiffies(50);
> > +
> > +	if (time_after(jiffies, atkbd->event_jiffies + delay))
> > +		delay = 0;
> > +
> > +	atkbd->event_jiffies = jiffies;
> > +	set_bit(event_bit, &atkbd->event_mask);
> > +	wmb();
> > +	schedule_delayed_work(&atkbd->event_work, delay);
> > +}
> 
> I don't know whether schedule_delayed_work() requeues event_work, or if
> it adds more work, but both seem to give wrong behaviour:

Well, my advise would be to research the matter before saying that
it will not work.

> In the first case 
> event_work can be postponed forever if atkbd_schedule_event_work() is
> called repeatedly each time within 50 ms, and for the second case there's a
> delay added, but the number of times the LED is switched stays the same,
> so it's not being throttled.
> 

No, once work is queued for execution subsequent attempts to queue the
same work will be ignored (until work starts executing). Therefore first
time work will be scheduled for execution immediately and then execution
be spaced by ~50 ms.

-- 
Dmitry
