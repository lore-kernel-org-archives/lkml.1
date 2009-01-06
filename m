Return-Path: <linux-kernel-owner+w=401wt.eu-S1754992AbZAFUC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbZAFUC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 15:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbZAFUCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 15:02:35 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:61780 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbZAFUCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 15:02:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from;
        b=dee4SNPTgMFSF3zK2ektS/tnh6Buqte9oYInyk0XBLQKUqV1MCMq/HvCtkBeVXMRDZ
         fd/ukpDPyYMQczBxHFW79Y32kLA/LcVHW5OtQ5jFWsa9XgecvD7FYy7VDE+pB+biUZa0
         f7dLABSs3p1c9HSRXkMCTB0cnUW4Of1kiXu6Y=
Message-ID: <4963B8BE.9000204@gmail.com>
Date: Tue, 06 Jan 2009 20:02:06 +0000
User-Agent: Thunderbird 2.0.0.19 (X11/20090104)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.28: warn_slowpath in orinoco receive path
References: <200901052005.12428.arvidjaar@mail.ru> <49626E4D.3010705@gmail.com> <200901061251.41628.arvidjaar@mail.ru>
In-Reply-To: <200901061251.41628.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Dave <kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> On 05 January 2009 23:32:13 Dave wrote:
> 
>> Looks like the RX interrupt occurred at an inconvenient point during
>> the list_del call in the RX tasklet (orinoco_rx_isr_tasklet).
>>
>> The call needs to be protected from the RX interrupt.
>>
>> Quick patch included below - I'm not sure that the local_irq_*
>> functions are the ones we need, but it compiles and runs.
>>
> 
> As was already pointed out, we can't be sure tasklet runs on the same 
> CPU as interrupt handler. What about attached patch? It actually moves 
> list to temporary head which can be processed without races; the idea is 
> to minimize amount and number of times we need to disable interrupts. 
> Patch compiles and runs :)

>@ -1568,9 +1568,15 @@ static void orinoco_rx_isr_tasklet(unsigned long
>data)
> 	struct orinoco_rx_data *rx_data, *temp;
> 	struct hermes_rx_descriptor *desc;
> 	struct sk_buff *skb;
>+	struct list_head temp_rx_list;
>+
>+	/* Move list to temporary head to avoid races with interrupt >handler */
>+	spin_lock_irq(&priv->lock);
>+	list_replace_init(&priv->rx_list, &temp_rx_list);
>+	spin_unlock_irq(&priv->lock);
>
> 	/* extract desc and skb from queue */
>-	list_for_each_entry_safe(rx_data, temp, &priv->rx_list, list) {
>+	list_for_each_entry_safe(rx_data, temp, &temp_rx_list, list) {
> 		desc = rx_data->desc;
> 		skb = rx_data->skb;
> 		list_del(&rx_data->list);

Nice - I like the use of list_replace_init.

In using local_irq_*, I was trying to avoid using priv->lock, which is
used by the rest of the driver to protect other data and hermes_* calls.

Since we have to use spinlock we should introduce an rx_lock
specifically to protect the list so the tasklet is not held up by
anything else the driver is doing. I'll put something together if you
don't get round to it first.

> By the way. Agere driver takes different approach. The only thing it 
> does in interrupt handler directly is to turn off Hermes interrupts and 
> start off another thread to process pending events. After all events are 
> processed interrupts are enabled again. It means the bulk of code is 
> executed in non-interrupt context; and looking how much is done in 
> orinoco driver during interrupt processing, this does not sound like bad 
> idea. Do you see any obvious cons here?

When I moved the RX handling into a tasklet I had a go at moving all the
interrupt handling code into the tasklet, and just couldn't get the card
to play nice. It might have worked if I disabled the interrupts (which I
didn't try), but my personal preference is not to touch interrupt
enables if we don't have to. Anyway, cons I can think of? :

* Ensuring the handler completes fast enough that we aren't late in
processing a 'more important' interrupt?

In the bug you've just seen, our tasklet failed to finish processing the
receive before the next receive. Where the whole interrupt is in a
tasklet with interrupts disabled, you rely on the firmware/hardware
buffering your RX data until you get around to it. If this situation
keeps happening it will run out of space. The current (RX)
implementation behaves better because we copy the data into an SKB ASAP,
ACK, and just leave the processing to later. We do rely on having
sufficient host memory.

* We'd have check the new implementation works on all the different cards.



The only thing of note left in the interrupt handler is processing scan
results, so overall I don't think it is worth spending time going down
this route.


Regards,

Dave.
