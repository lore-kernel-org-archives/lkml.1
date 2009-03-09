Return-Path: <linux-kernel-owner+w=401wt.eu-S1751939AbZCIPbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbZCIPbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 11:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbZCIPbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 11:31:35 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:60940 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbZCIPbf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 11:31:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hMHGkICjpJYpNgIvh986wD/yWyawXBwrsQTvaYElGEPWK6kA+16mFGIcEGX1JYgqVk
         7cP8UKyKuOClavK2zqO+4dWKsKjS6HPHIPA6wYzGBUD2Yw9EXs2/YIrN5Gpv5k5re8TX
         gj6ytYRxwKVxw9vaFktuE1WsSjiWIjD8e2Qx0=
MIME-Version: 1.0
In-Reply-To: <1236611904-9843-1-git-send-email-timur@freescale.com>
References: <1236611904-9843-1-git-send-email-timur@freescale.com>
Date: Mon, 9 Mar 2009 15:31:31 +0000
Message-ID: <87a5b0800903090831l6a74b8afhd640ce880be36114@mail.gmail.com>
Subject: Re: [PATCH v2] add function spin_event_timeout()
From: Will Newton <will.newton@gmail.com>
To: Timur Tabi <timur@freescale.com>
Cc: linux-kernel@vger.kernel.org, rdreier@cisco.com, jirislaby@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 9, 2009 at 3:18 PM, Timur Tabi <timur@freescale.com> wrote:
> The function spin_event_timeout() takes a condition and timeout value
> (in jiffies) as parameters.  It spins until either the condition is true
> or the timeout expires.  It returns non-zero if the condition is true,
> zero otherwise.
>
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
>
> v2: changes based on feedback
>
>  include/linux/delay.h |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/delay.h b/include/linux/delay.h
> index fd832c6..235ca25 100644
> --- a/include/linux/delay.h
> +++ b/include/linux/delay.h
> @@ -51,4 +51,26 @@ static inline void ssleep(unsigned int seconds)
>        msleep(seconds * 1000);
>  }
>
> +/**
> + * spin_event_timeout - spin until a condition gets true or a timeout elapses
> + * @condition: a C expression for the event to wait for
> + * @timeout: timeout, in jiffies
> + *
> + * The process spins until the @condition evaluates to true or the @timeout
> + * elapses.
> + *
> + * The function returns non-zero if the @condition evaluated to true, or
> + * zero if the @timeout elapsed.  If both occurs (e.g. the loop was
> + * pre-empted and the @condition became true in the meantime, but when the
> + * loop resumed the @timeout had already elapsed), then non-zero will be
> + * returned.
> + */
> +#define spin_event_timeout(condition, timeout)                 \
> +({                                                             \
> +       unsigned long __timeout = jiffies + (timeout);          \
> +       while (!(condition) && time_before(jiffies, __timeout)) \
> +               cpu_relax();                                    \
> +       (condition);                                            \
> +})
> +
>  #endif /* defined(_LINUX_DELAY_H) */

Are you sure you want to evaluate condition a second time when
returning? Some memory mapped registers don't have a stable value so
e.g. the first test could succeed but the return value could still be
zero.

> --
> 1.6.1.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
