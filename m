Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbZCIQGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbZCIQGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 12:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZCIQGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 12:06:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:34192 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbZCIQGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 12:06:24 -0400
Subject: Re: [PATCH v2] add function spin_event_timeout()
From: Peter Zijlstra <peterz@infradead.org>
To: Timur Tabi <timur@freescale.com>
Cc: linux-kernel@vger.kernel.org, rdreier@cisco.com, jirislaby@gmail.com
In-Reply-To: <1236611904-9843-1-git-send-email-timur@freescale.com>
References: <1236611904-9843-1-git-send-email-timur@freescale.com>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 17:06:15 +0100
Message-Id: <1236614775.8389.692.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-09 at 10:18 -0500, Timur Tabi wrote:
> The function spin_event_timeout() takes a condition and timeout value
> (in jiffies) as parameters.  It spins until either the condition is true
> or the timeout expires.  It returns non-zero if the condition is true,
> zero otherwise.

This changelog utterly fails to justify this interface. And to me it
seems a rather bad one. Why would we ever be wanting to spin in order of
jiffies?

> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
> 
> v2: changes based on feedback
> 
>  include/linux/delay.h |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/delay.h b/include/linux/delay.h
> index fd832c6..235ca25 100644
> --- a/include/linux/delay.h
> +++ b/include/linux/delay.h
> @@ -51,4 +51,26 @@ static inline void ssleep(unsigned int seconds)
>  	msleep(seconds * 1000);
>  }
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
> + * zero if the @timeout elapsed.  If both occurs (e.g. the loop was
> + * pre-empted and the @condition became true in the meantime, but when the
> + * loop resumed the @timeout had already elapsed), then non-zero will be
> + * returned.
> + */
> +#define spin_event_timeout(condition, timeout)			\
> +({								\
> +	unsigned long __timeout = jiffies + (timeout);		\
> +	while (!(condition) && time_before(jiffies, __timeout))	\
> +		cpu_relax();					\
> +	(condition);						\
> +})
> +
>  #endif /* defined(_LINUX_DELAY_H) */

