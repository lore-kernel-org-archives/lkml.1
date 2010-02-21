Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab0BUPK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 10:10:57 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:39690 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957Ab0BUPKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 10:10:54 -0500
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Feb 2010 10:10:54 EST
Message-ID: <4B814AB3.1030404@shipmail.org>
Date: Sun, 21 Feb 2010 16:01:07 +0100
From: Thomas Hellstrom <thomas@shipmail.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090822)
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH][RFC] time: add wait_interruptible_timeout macro to sleep
 (w.	timeout) until wake_up
References: <1266761422-2921-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1266761422-2921-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafał Miłecki wrote:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> We try to implement some PM in radeon KMS and we need to sync with VLBANK for
> reclocking engine/memory. The easiest and cleanest way seems to be sleeping in
> timer handler just before reclocking. Then our IRQ handler calls wake_up and we
> continue reclocking.
>
> As you see our sleeping is condition-less, we just wait for waking up queue.
>
> We hope this waking will happen from IRQ handler, but for less-happy case we
> also use some timeout (this will probably cause some single corruption, but
> we can live with it).
>
> Following macro is soemthing that seems to work fine for us, but instead
> introducing this to radeon KMS only, I'd like to propose adding this to whole
> wait.h. Do you this it's something we should place there? Can someone take this
> patch for me? Or maybe you find this rather useless and we should keep this
> marco locally?
> ---
>  include/linux/wait.h |   25 +++++++++++++++++++++++++
>  1 files changed, 25 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/wait.h b/include/linux/wait.h
> index a48e16b..998475b 100644
> --- a/include/linux/wait.h
> +++ b/include/linux/wait.h
> @@ -332,6 +332,31 @@ do {									\
>  	__ret;								\
>  })
>  
> +/**
> + * wait_interruptible_timeout - sleep until a waitqueue is woken up
> + * @wq: the waitqueue to wait on
> + * @timeout: timeout, in jiffies
> + *
> + * The process is put to sleep (TASK_INTERRUPTIBLE) until the waitqueue
> + * @wq is woken up. It can be done manually with wake_up or will happen
> + * if timeout elapses.
> + *
> + * The function returns 0 if the @timeout elapsed, remaining jiffies
> + * if workqueue was waken up earlier.
> + */
> +#define wait_interruptible_timeout(wq, timeout)				\
> +({									\
> +	long __ret = timeout;						\
> +									\
> +	DEFINE_WAIT(__wait);						\
> +	prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);		\
> +	if (!signal_pending(current))					\
> +		__ret = schedule_timeout(__ret);			\
> +	finish_wait(&wq, &__wait);					\
> +									\
> +	__ret;								\
> +})
> +
>  #define __wait_event_interruptible_exclusive(wq, condition, ret)	\
>  do {									\
>  	DEFINE_WAIT(__wait);						\
>   
What about msleep_interruptible in <linux/delay.h> ?

/Thomas

