Return-Path: <linux-kernel-owner+w=401wt.eu-S1752978AbYHLIcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbYHLIcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 04:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbYHLIcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 04:32:16 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:32859 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbYHLIcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 04:32:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OO4ZEK5pUcHxQ10h8o8VSAFH+2BkfDR4tc8Z5yaApRYoVeniaWHvBAE8D/JuXjNxnH
         4cZAIQHM2qtY4wGnwtLH2HCsNhLuu8NO7PHTZOsIwbHGs9DQAzgBeJEacrw6Wq8vjfre
         gbgy1uFDk/JcT0WkZ4Obi5b3EYrmMcoI93OkY=
Message-ID: <87a5b0800808120132u11c3734es486b13027f3ec191@mail.gmail.com>
Date: Tue, 12 Aug 2008 09:32:13 +0100
From: "Will Newton" <will.newton@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] serial 8250: tighten test for using backup timer
Cc: alex.williamson@hp.com, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20080811143208.8cc89478.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1205945437.6881.13.camel@lappy>
	 <87a5b0800808050444t49480549t758f954c40139c4a@mail.gmail.com>
	 <1217966803.17091.72.camel@2710p.home>
	 <87a5b0800808060353v505c4957wbd26aaa9a2624786@mail.gmail.com>
	 <20080811143208.8cc89478.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 10:32 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 6 Aug 2008 11:53:13 +0100
> "Will Newton" <will.newton@gmail.com> wrote:
>
>> >From 36ac82a231498247ada098d31e8d12e735eb34f2 Mon Sep 17 00:00:00 2001
>> From: Will Newton <will.newton@gmail.com>
>> Date: Wed, 6 Aug 2008 11:48:29 +0100
>> Subject: [PATCH] 8250: Improve workaround for UARTs that don't
>> re-assert THRE correctly.
>>
>> Recent changes to tighten the check for UARTs that don't correctly
>> re-assert THRE caused problems when such a UART was opened for the second
>> time - the bug could only successfully be detected at first initialization.
>> This patch stores the information about the bug in the bugs field of the
>> port structure when the port is first started up so subsequent opens can
>> check this bit even if the test for the bug fails.
>>
>> Signed-off-by: Will Newton <will.newton@gmail.com>
>> Acked-by: Alex Williamson <alex.williamson@hp.com>
>
> What are the "recent changes" to which you refer?  I had a quick look
> and didn't spot any THRE-related changes this year?

Sorry, I should have been more specific. Commit
01c194d9278efc15d4785ff205643e9c0bdcef53.

>> ---
>>  drivers/serial/8250.c |   16 ++++++++++++----
>>  drivers/serial/8250.h |    1 +
>>  2 files changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
>> index 342e12f..9ccc563 100644
>> --- a/drivers/serial/8250.c
>> +++ b/drivers/serial/8250.c
>> @@ -1908,15 +1908,23 @@ static int serial8250_startup(struct uart_port *port)
>>                * kick the UART on a regular basis.
>>                */
>>               if (!(iir1 & UART_IIR_NO_INT) && (iir & UART_IIR_NO_INT)) {
>> +                     up->bugs |= UART_BUG_THRE;
>>                       pr_debug("ttyS%d - using backup timer\n", port->line);
>> -                     up->timer.function = serial8250_backup_timeout;
>> -                     up->timer.data = (unsigned long)up;
>> -                     mod_timer(&up->timer, jiffies +
>> -                             poll_timeout(up->port.timeout) + HZ / 5);
>>               }
>>       }
>>
>>       /*
>> +      * The above check will only give an accurate result the first time
>> +      * the port is opened so this value needs to be preserved.
>> +      */
>> +     if (up->bugs & UART_BUG_THRE) {
>> +             up->timer.function = serial8250_backup_timeout;
>> +             up->timer.data = (unsigned long)up;
>> +             mod_timer(&up->timer, jiffies +
>> +                       poll_timeout(up->port.timeout) + HZ / 5);
>> +     }
>> +
>> +     /*
>>        * If the "interrupt" for this port doesn't correspond with any
>>        * hardware interrupt, we use a timer-based system.  The original
>>        * driver used to do this with IRQ0.
>> diff --git a/drivers/serial/8250.h b/drivers/serial/8250.h
>> index 78c0016..5202603 100644
>> --- a/drivers/serial/8250.h
>> +++ b/drivers/serial/8250.h
>> @@ -47,6 +47,7 @@ struct serial8250_config {
>>  #define UART_BUG_QUOT        (1 << 0)        /* UART has buggy quot LSB */
>>  #define UART_BUG_TXEN        (1 << 1)        /* UART has buggy TX IIR status */
>>  #define UART_BUG_NOMSR       (1 << 2)        /* UART has buggy MSR status bits (Au1x00) */
>> +#define UART_BUG_THRE        (1 << 3)        /* UART has buggy THRE reassertion */
>>
>>  #define PROBE_RSA    (1 << 0)
>>  #define PROBE_ANY    (~0)
>
> Also, how serious is the problem which is being fixed here?  It
> _sounds_ like it's of the "fatal for people who have that hardware"
> variety, in which case we should get this into 2.6.27 and probably
> 2.6.26.x.  Not sure about 2.5.26.x though - the patch doesn't apply
> there, but I didn't check whether this is due to functional changes.

For users of this version of this particular UART IP it is fatal. From
looking at the git history it looks like the original patch went into
2.6.26 so it might also affect that kernel.

> Also2, we should officially use setup_timer(), like this:
>
> --- a/drivers/serial/8250.c~serial-8250-tighten-test-for-using-backup-timer-fix
> +++ a/drivers/serial/8250.c
> @@ -1964,8 +1964,8 @@ static int serial8250_startup(struct uar
>         * the port is opened so this value needs to be preserved.
>         */
>        if (up->bugs & UART_BUG_THRE) {
> -               up->timer.function = serial8250_backup_timeout;
> -               up->timer.data = (unsigned long)up;
> +               setup_timer(&up->timer, serial8250_backup_timeout,
> +                               (unsigned long)up);
>                mod_timer(&up->timer, jiffies +
>                          poll_timeout(up->port.timeout) + HZ / 5);
>        }
>
> but that is a functional change - setup_timer() runs init_timer(),
> whereas the code you have there does not.
>
> We _do_ have an init_timer(&up->timer) all the way over in
> serial8250_isa_init_ports().  It's all a bit weird.  Could you please
> double-check that we're being sensible about the initialisation of this
> timer?

I'll look into it. Some of the weirdness comes from the way the timer
is used for this bug workaround but also for irq-less ports.
