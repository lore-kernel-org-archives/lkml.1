Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbXFPLye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbXFPLye (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 07:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbXFPLy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 07:54:26 -0400
Received: from neon.samage.net ([85.17.153.66]:33294 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbXFPLyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 07:54:25 -0400
Message-ID: <60127.81.207.0.53.1181994857.squirrel@secure.samage.net>
In-Reply-To: <200706152334.40387.dtor@insightbb.com>
References: <20070604112426.GA2707@elf.ucw.cz>
    <200706150141.06142.dtor@insightbb.com>
    <33677.81.207.0.53.1181959473.squirrel@secure.samage.net>
    <200706152334.40387.dtor@insightbb.com>
Date: Sat, 16 Jun 2007 13:54:17 +0200 (CEST)
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
From: "Indan Zupancic" <indan@nul.nu>
To: "Dmitry Torokhov" <dtor@insightbb.com>
Cc: "Pavel Machek" <pavel@ucw.cz>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Andi Kleen" <ak@suse.de>, "Jiri Kosina" <jikos@jikos.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 40b81d93390a3dca3ee709c9c36a2335
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, June 16, 2007 05:34, Dmitry Torokhov wrote:
> On Friday 15 June 2007 22:04, Indan Zupancic wrote:
>> On Fri, June 15, 2007 07:41, Dmitry Torokhov wrote:
>> >  /*
>> > + * Schedule switch for execution. We need to throttle requests,
>> > + * otherwise keyboard may become unresponsive.
>> > + */
>> > +static void atkbd_schedule_event_work(struct atkbd *atkbd, int event_bit)
>> > +{
>> > +	unsigned long delay = msecs_to_jiffies(50);
>> > +
>> > +	if (time_after(jiffies, atkbd->event_jiffies + delay))
>> > +		delay = 0;
>> > +
>> > +	atkbd->event_jiffies = jiffies;
>> > +	set_bit(event_bit, &atkbd->event_mask);
>> > +	wmb();
>> > +	schedule_delayed_work(&atkbd->event_work, delay);
>> > +}
>>
>> I don't know whether schedule_delayed_work() requeues event_work, or if
>> it adds more work, but both seem to give wrong behaviour:
>
> Well, my advise would be to research the matter before saying that
> it will not work.

Good advise. My advise to others is, that if you do research it, then don't
do it hastily like I did. ;-)

My quick search didn't find the exact behaviour of schedule_delayed_work(),
when looking in LDD, but I should've digged through to the description of
queue_delayed_work().


>> In the first case
>> event_work can be postponed forever if atkbd_schedule_event_work() is
>> called repeatedly each time within 50 ms, and for the second case there's a
>> delay added, but the number of times the LED is switched stays the same,
>> so it's not being throttled.
>>
>
> No, once work is queued for execution subsequent attempts to queue the
> same work will be ignored (until work starts executing). Therefore first
> time work will be scheduled for execution immediately and then execution
> be spaced by ~50 ms.

Thank you for the explanation.

I applied the patch, and it compiles and runs as expected, can't lockup the
keyboard anymore with it applied.

Greetings,

Indan


