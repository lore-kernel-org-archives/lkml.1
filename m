Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbZJDU7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbZJDU7w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 16:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758038AbZJDU7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 16:59:52 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:60004 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021AbZJDU7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 16:59:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=rFgPwJ6xUQO1q8nul4m3o+dr9ISUdoy47nXDVYA8NmVzTkrtHXQAO5/+5DcUAnryCv
         7bkknQ52dUTOORxZNuxHe/FQFyqk4YvkbR50+Q3FXX+/ieatC+RRtVip+3MkpmgOIEl5
         3aFYi5wZf6out/OGwaQhZiGvoS3pJShFEajm8=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0910041202110.2646@localhost.localdomain>
References: <3efb10970909211136g4e74c8b3vc339d548cdd0959f@mail.gmail.com>
	 <alpine.LFD.2.00.0909301448030.2518@nanos>
	 <3efb10970909300911j44638434mc22adfd64aaef421@mail.gmail.com>
	 <alpine.LFD.2.00.0910041202110.2646@localhost.localdomain>
Date: Sun, 4 Oct 2009 22:59:13 +0200
X-Google-Sender-Auth: 53505e38c34689dd
Message-ID: <3efb10970910041359m1db64926pcf83ebd98a8b1bdd@mail.gmail.com>
Subject: Re: 2.6.31-rt11 freeze on userland start on ARM
From: Remy Bohmer <linux@bohmer.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2009/10/4 Thomas Gleixner <tglx@linutronix.de>:
> On Wed, 30 Sep 2009, Remy Bohmer wrote:
>> > The serial irq cannot run in hard irq context.
>>
>> Indeed most drivers cannot, but for this particular handler can you
>> please explain me why?
>> Maybe I am missing some new mechanism that prevents it that was not
>> there on older RT-kernels (tested up-to latest 2.6.24-rt +
>> 2.6.26-rt)...
>
> Which had the same problem ....

what problem...?

>> The atmel_serial IRQ was adapted such (I think it was mainlined in
>> 2.6.25 already) to make it suitable to run in hard-irq context. (I
>> know, because I did that myself)
>
> That's fine for mainline but not for -rt.

The goal was making its interrupt handler suitable for -rt as well as
mainline (on older kernels...).

> Yes. The serial code takes locks which are converted to sleeping locks
> on -RT. That's a nono.

Yes, I know that spinlocks are converted to mutexes and as such they
can sleep which is not allowed in hard interrupt context.

But, maybe I am really overlooking something, the serial interrupt
handler code of the atmel serial driver only reads the characters from
the device, and puts them in a local ringbuffer with atomic
instructions, then a tasklet is being scheduled to handle the data
outside interrupt context. This tasklet/softirq is being scheduled by
wake_up_process(), which is afaik allowed to be called from hard-irq
context.

The interface to the generic serial driver (that uses spinlocks) is
handled by the tasklet (softirq), not by the interrupt handler.

So, technically, as far as I can see the atmel-serial driver itself
should be safe to be run as nodelay-handler as it is now...(it is
doing that here for years already).
I do not see any path that conflicts with this rule. So,  I still do
not see what is technically wrong with this particular driver, except
that there is a new mechanism available now to solve this differently.

>> > 2) Make the serial driver explicitely threaded and check in the
>> > hardirq handler whether the irq originated from the serial driver. If
>> > yes, disable it in the serial device and return IRQ_WAKE_THREAD
>> > otherwise return IRQ_NONE.
>>
>> Interesting, this sounds new, and I have to dig into it to find out
>> how this is supposed to work... Do you happen to have any good
>> pointers for examples or doc?
>
> drivers/net/wireless/b43/main.c in mainline

Thanks, This is indeed a good/clear example.
I will adapt the atmel-serial driver to this new irq-threading model
and provide a patch for it, it seems cleaner and makes the tasklet
stuff obsolete for this driver.

>> TOL: could the generic interrupt code not check for this? It can see
>> the timer interrupt handler not returning 'IRQ_HANDLED', and still see
>> the interrupt being active, and know that there is a IRQ thread on the
>> same line, so it can conclude itself to mask the source in the
>> interrupt controller and wake the thread... Or am I wrong?
>
> What happens if both are active at the same time ? Also masking the
> interrupt line will block your timer interrupts until the threaded
> handler has completed.

That is indeed true, and proves once again that shared interrupt
handlers are really annoying, especially on -rt...

The old way we did in 2.6.24-rt + 2.6.26-rt was to adapt the handler
to allow it to run in hard-irq context for -rt as well as mainline.
The new way handles this differently... Since a -rt-friendly generic
solution seems not possible, I guess before -rt ever becomes mainline
_all_ interrupt handlers that are shared with a nodelay interrupt in
some configuration must be adapted to the new threaded_irq model... A
huge job...

Kind regards,

Remy
