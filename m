Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbYJIGXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbYJIGXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 02:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbYJIGX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 02:23:26 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:51296 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbYJIGXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 02:23:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ffq8ZnwWUjAouekS7cei7fc9TYOrsPFpF1PNIfGvITJBaYJs3F8YzpxmchZH4K5W5J
         ZYzLGBpst6dNwibvjsqcJek3lbYcGfI2VLNr5awRPnwmVWSFzHU7uvLuXrr9SXYzaNJm
         XNM18kvYTPy3gjhIx2dqQ3oNhjDfaXftoe++0=
Message-ID: <cabda6420810082323g50887af7q9d718b0fd4e1e4f1@mail.gmail.com>
Date: Thu, 9 Oct 2008 08:23:22 +0200
From: chri <chripell@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] max3100 driver
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
In-Reply-To: <20080920012454.e40f03cc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221895208650-git-send-email-chripell@gmail.com>
	 <20080920012454.e40f03cc.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 10:24 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:

>> +#define MAX3100_MAJOR 204
>
> Allocating a new major is a Big Deal.  It involves getting the major
> registered by contacting device@lanana.org.
>
> It's better to dynamically allocate it - let udev handle it.
>

The MAX3100 is used in just small embedded systems where there is
usually no udev. I looked at other serial drivers but I haven't seen
none that uses dynamic allocation (they are share just 2 major
numbers). I followed the guide in devices.txt and asked for an
allocation of 4 minor numbers in the "Low-density serial ports".

>> +#include <linux/freezer.h>
>
> Gad. Are all those includes needed?
>

cleaned

>> +
>> +struct max3100_port_s {
>
> `struct max3100_port' is sufficient, and would be more typical.
>

done

>> +     struct uart_port port;
>> +     struct spi_device *spi;
>> +
>> +     int cts:1;              /* last CTS received for flow ctrl */
>> +     int tx_empty:1;         /* last TX empty bit */
>
> These two bits will share a word and hence locking is needed to prevent
> modifications to one from trashing modifications to the other on SMP.
>
> That's OK, but it would be best to document that locking right here, and
> to check that it is adhered to.
>

I reverted to using word aligned data.

>> +     /* and it's timer */
>
> s/it's/its/
>

done. I just found the useful flyspell-prog-mode so I will drastically
reduce English errors in the patches!

>> +             parity = parity ^ ((c>>i) & 1);
>
> hrmpf.  Don't we have a library function for that?
>
> Perhaps you could use hweight8(c)&1.
>

done

>> +     return parity;
>> +}
>> +
>> +static int max3100_check_parity(struct max3100_port_s *s, u16 c)
>> +{
>> +     return max3100_do_parity(s, c) ==
>> +       ((c >> (s->parity & MAX3100_7BIT ? 7 : 8)) & 1);
>
> <checks his C precedence table>
>
> OK...

done. Anyway I think that if precedence is unclear to me, it may be
unclear to others too; so I prefer to use a parenthesis too much than
one too few.


>> +     *c &=  ~MAX3100_PT;
>
> s/  / /
>

done

>
>> +}
>> +
>> +static void max3100_work(struct work_struct *w);
>> +
>> +static void max3100_dowork(struct max3100_port_s *s)
>> +{
>> +     if (!s->force_end_work && !work_pending(&s->work)) {
>> +             PREPARE_WORK(&s->work, max3100_work);
>
> This is a strange place to run PREPARE_WORK().  Normally it would be
> done during driver/device initialsiation, and I think that can be done
> here.
>

done, I checked the meaning of PREPARE_WORK in the header file.

>> +
>> +     etx = htons(tx);
>> +     spi_message_init(&message);
>> +     memset(&tran, 0, sizeof(tran));
>> +     tran.tx_buf = &etx;
>> +     tran.rx_buf = &erx;
>> +     tran.len = 2;
>
> could do
>
>        struct spi_transfer tran = {
>                .tx_buf = &etx,
>                .rx_buf = &erx
>                .len = 2,
>        };
>
> and the compiler will zero out the rest.  Minor point.
>

done

>> +
>> +     dev_dbg(&s->spi->dev, "%s\n", __func__);
>> +
>> +     /* may not be truely up-to-date */
>
> s/truely/truly/
>

done, next time flypsell-prog-mode will help me :-)

>> +
>> +     sprintf(b, "max3100-%d", s->minor);
>
> hm.  This will go nasty if s->minor > 9.  I'd suggest that b[] be made
> larger.
>

I limit the number of MAX3100s to 4, anyway I enlarged the buffer by
one so to be sure.

>> +     if (request_irq(s->irq, max3100_irq, irq_type, "max3100", s) < 0) {
>> +             dev_warn(&s->spi->dev, "cannot allocate irq %d\n", s->irq);
>> +             s->irq = 0;
>
> Shouldn't we tear down that workqueue before returning?
>

done

>> +static void max3100_release_port(struct uart_port *port)
>> +{
>> +     struct max3100_port_s *s = (struct max3100_port_s *)port;
>
> container_of()
>

done


Sorry again for not replying in firs time.


-- 
Christian Pellegrin, see http://www.evolware.org/chri/
"Real Programmers don't play tennis, or any other sport which requires
you to change clothes. Mountain climbing is OK, and Real Programmers
wear their climbing boots to work in case a mountain should suddenly
spring up in the middle of the computer room."
