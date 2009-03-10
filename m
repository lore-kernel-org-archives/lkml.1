Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbZCJSs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbZCJSs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 14:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbZCJSss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 14:48:48 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:21772 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbZCJSss convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 14:48:48 -0400
MIME-Version: 1.0
In-Reply-To: <1236699004-1863-1-git-send-email-timur@freescale.com>
References: <1236699004-1863-1-git-send-email-timur@freescale.com>
Date: Tue, 10 Mar 2009 12:41:47 -0600
Message-ID: <fa686aa40903101141l33fbfc7cha0d2d85f6e1cb795@mail.gmail.com>
Subject: Re: [PATCH v4] introduce macro spin_event_timeout()
From: Grant Likely <grant.likely@secretlab.ca>
To: Timur Tabi <timur@freescale.com>
Cc: linux-kernel@vger.kernel.org, rdreier@cisco.com, jirislaby@gmail.com,
       peterz@infradead.org, will.newton@gmail.com, hancockrwd@gmail.com,
       jeremy@goop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 9:30 AM, Timur Tabi <timur@freescale.com> wrote:
> The macro spin_event_timeout() takes a condition and timeout value
> (in microseconds) as parameters.  It spins until either the condition is true
> or the timeout expires.  It returns zero if the timeout expires first, non-zero
> otherwise.
>
> This primary purpose of this macro is to poll on a hardware register until a
> status bit changes.  The timeout ensures that the loop still terminates if the
> bit doesn't change as expected.  This macro makes it easier for driver
> developers to perform this kind of operation properly.
>
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
>
> v4: removed cpu_relax (redundant), changed timeout to unsigned long
>
> v3: eliminated secondary evaluation of condition, replaced jiffies with udelay
>
> v2: added cpu_relax and time_before
>
>  include/linux/delay.h |   27 +++++++++++++++++++++++++++
>  1 files changed, 27 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/delay.h b/include/linux/delay.h
> index fd832c6..4af6df6 100644
> --- a/include/linux/delay.h
> +++ b/include/linux/delay.h
> @@ -51,4 +51,31 @@ static inline void ssleep(unsigned int seconds)
>        msleep(seconds * 1000);
>  }
>
> +/**
> + * spin_event_timeout - spin until a condition gets true or a timeout elapses
> + * @condition: a C expression to evalate
> + * @timeout: timeout, in microseconds
> + *
> + * The process spins until the @condition evaluates to true (non-zero) or
> + * the @timeout elapses.
> + *
> + * This primary purpose of this macro is to poll on a hardware register
> + * until a status bit changes.  The timeout ensures that the loop still
> + * terminates if the bit never changes.
> + *
> + * The return value is the number of microseconds left in the timeout, so if
> + * the return value is non-zero, then it means the condition is true.
> + *
> + * Short-circuit evaluation in the while-loop ensures that if the condition
> + * becomes true exactly when the timeout expires, non-zero will still be
> + * returned.
> + */
> +#define spin_event_timeout(condition, timeout)                         \
> +({                                                                     \
> +       unsigned long __timeout = timeout;                              \
> +       while (!(condition) && --__timeout)                             \
> +               udelay(1);                                              \

Do you really want to do a udelay() here?  Or any other kind of delay
for that matter?  When using a delay then, unless the condition is
immediately true, the code will burn a minimum of 1us of cycles, even
if the condition does become true right after the first read.  If the
CPU is spinning anyway, then it should be doing using those cycles to
try and bail out as soon as possible.

I typically use something in the form of this pattern on powerpc code
when I absolutely have to busywait.
    int end_ts = get_tbl() + some_delay;  /* note that this is signed */
    while (end_ts - get_tbl() > 0)
        if (condition)
            break;

This macro also looks like a tempting unbounded latency tarpit to fall
into when people start using it in critical regions,  but that goes
for code using a non-timed-out busywait also.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
