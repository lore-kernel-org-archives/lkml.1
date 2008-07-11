Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbYGKGPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbYGKGPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 02:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYGKGPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 02:15:06 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:54937 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbYGKGPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 02:15:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=N0XdbQ9Wsp76XLkrDPFydzgYKoITboblNPBRU52V3MndpYThdQiUPi/yr9jMD43PSd
         IplsxCSRi2+Yd4tHXQ2LTwR+hctBObSkrHZJGRi+McZGciUMWguc7H5QeQrQ1X8+RMad
         aRBjpgvQYx8eIAKnG633ahZA5/1By35GOQatc=
Message-ID: <aec7e5c30807102315i3048f68q245a4fbdfe89b1b2@mail.gmail.com>
Date: Fri, 11 Jul 2008 15:15:02 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" <Uwe.Kleine-Koenig@digi.com>
Subject: Re: [PATCH] uio: uio_pdrv_genirq V2
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hjk@linutronix.de" <hjk@linutronix.de>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
In-Reply-To: <20080710103036.GA32507@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080710035254.27378.18682.sendpatchset@rx1.opensource.se>
	 <20080710065639.GA16794@digi.com>
	 <20080710094641.0c52eaa7@the-village.bc.nu>
	 <20080710103036.GA32507@digi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 7:30 PM, Uwe Kleine-König
<Uwe.Kleine-Koenig@digi.com> wrote:
> Alan Cox wrote:
>>
>> > > +       else if (!irq_on && !priv->irq_disabled)
>> > > +               disable_irq(dev_info->irq);
>> > I'm not sure if this is a problem on SMP.  Should you use
>> > disable_irq_nosync here, too?  Probably it's OK.
>>
>> That one will also deadlock.
> Can you explain why?  I think irqcontrol is only called in task context.
> I only see one possible deadlock and that's disable_irq being called
> while the irq is IRQ_INPROGRESS on the same cpu.  I'm always willing to
> learn.
>
>> The easiest fix is probably to use test_and_set and friends for each I/O
>> operation.
> Actually using spinlock + irq_disabled variable is new in V2 of this
> patch.  Don't know why this changed, though.

Sorry for not being more clear about it. Basically, I wanted to
serialize user space access somehow, but I managed to screw it up. =)

Atomic enable-and-disable operations without serialization has this problem:

irq line    state      task0                         task1

enabled     enabled    write "0"
                       if (!test_and_set_bit())
enabled     disabled
                                                     write "1"
                                                     if (test_and_clear_bit())
                                                           enable_irq() <- ERR
                             disable_irq()

ERR will make the interrupt depth counter underflow.

The best solution in my mind is atomic operations,
disable_irq_nosync() in irq handler only, and serialize user space
only - not the irq handler.

Or maybe the UIO core layer should serialization in the case of multiple tasks?

/ magnus
