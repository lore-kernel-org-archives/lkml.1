Return-Path: <linux-kernel-owner+w=401wt.eu-S932506AbZHLKhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506AbZHLKhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 06:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932236AbZHLKhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 06:37:16 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:63001 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205AbZHLKhO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 06:37:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gn/XgbTpiNk2me31koHlaVVNwZWPfXndIfpqY3PRkQ0Ekc8uzv0/xITpVAa7xwljVB
         9nLBwTST1xCXHpD4Uj0uG8+dL5LrCHiyDes1l35Ff5UTDfOu7Dc1K0LMGPKoJS5kKPT/
         FyzFGjTkNmm1dU2jHZFnsDdZEKt8Oc3bneJG0=
MIME-Version: 1.0
In-Reply-To: <200908092313.05541.rjw@sisk.pl>
References: <200908081625.57333.rjw@sisk.pl> <200908092313.05541.rjw@sisk.pl>
Date: Wed, 12 Aug 2009 19:37:15 +0900
Message-ID: <aec7e5c30908120337g2928b825m1a17a311a0756305@mail.gmail.com>
Subject: Re: [PATCH update] PM: Introduce core framework for run-time PM of 
	I/O devices (rev. 15)
From: Magnus Damm <magnus.damm@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Mon, Aug 10, 2009 at 6:13 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM: Introduce core framework for run-time PM of I/O devices (rev. 15)
>
> Introduce a core framework for run-time power management of I/O
> devices.  Add device run-time PM fields to 'struct dev_pm_info'
> and device run-time PM callbacks to 'struct dev_pm_ops'.  Introduce
> a run-time PM workqueue and define some device run-time PM helper
> functions at the core level.  Document all these things.
>
> Special thanks to Alan Stern for his help with the design and
> multiple detailed reviews of the pereceding versions of this patch
> and to Magnus Damm for testing feedback.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Looking good! I have a few nitpicks below, but from a functional
perspective it's all good. I've tested v15 with platform device
drivers for I2C, UIO and framebuffer. Before adding my "Acked-by"  I
also want to test the V4L capture driver, but I need to wait a few
days until I can get my hands on such a hardware platform.

Thanks for folding in and fixing up the debug patch. I was able to
drop most remaining patches thanks to feedback from Alan. So the only
needed patch apart from this one (and the ones in your linux-next
branch) is the one in this micro-series: "PM: Runtime PM v15 for
Platform Devices 20090812".

> --- linux-2.6.orig/include/linux/pm.h
> +++ linux-2.6/include/linux/pm.h
[..]
>  struct dev_pm_info {
>        pm_message_t            power_state;
> -       unsigned                can_wakeup:1;
> -       unsigned                should_wakeup:1;
> +       unsigned int            can_wakeup:1;
> +       unsigned int            should_wakeup:1;
>        enum dpm_state          status;         /* Owned by the PM core */
> -#ifdef CONFIG_PM_SLEEP
> +#ifdef CONFIG_PM_SLEEP
>        struct list_head        entry;
>  #endif
> +#ifdef CONFIG_PM_RUNTIME
> +       struct timer_list       suspend_timer;
> +       unsigned long           timer_expires;
> +       struct work_struct      work;
> +       wait_queue_head_t       wait_queue;
> +       spinlock_t              lock;
> +       atomic_t                usage_count;
> +       atomic_t                child_count;

I suppose child_count has to be atomic?

> --- /dev/null
> +++ linux-2.6/drivers/base/power/runtime.c
[...]
> +int __pm_runtime_suspend(struct device *dev, bool from_wq)
> +       __releases(&dev->power.lock) __acquires(&dev->power.lock)
[...]
> +       if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_suspend) {
> +               spin_unlock_irq(&dev->power.lock);
> +
> +               retval = dev->bus->pm->runtime_suspend(dev);
> +
> +               spin_lock_irq(&dev->power.lock);
> +               dev->power.runtime_error = retval;
> +       } else {
> +               retval = -ENOSYS;
> +       }

Nit: { and } above do not follow the regular coding style.

> +int __pm_runtime_resume(struct device *dev, bool from_wq)
> +       __releases(&dev->power.lock) __acquires(&dev->power.lock)
[...]
> +       if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_resume) {
> +               spin_unlock_irq(&dev->power.lock);
> +
> +               retval = dev->bus->pm->runtime_resume(dev);
> +
> +               spin_lock_irq(&dev->power.lock);
> +               dev->power.runtime_error = retval;
> +       } else {
> +               retval = -ENOSYS;
> +       }

Same minor issue here.

Apart from that all is fine. Thank you.

/ magnus
