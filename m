Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbYIILf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbYIILf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 07:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbYIILfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 07:35:22 -0400
Received: from scing.com ([217.160.110.58]:44802 "EHLO scing.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbYIILfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 07:35:21 -0400
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
From: Janne Grunau <j@jannau.net>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
Date: Tue, 9 Sep 2008 13:35:17 +0200
User-Agent: KMail/1.9.9
Cc: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Jarod Wilson <jarod@redhat.com>,
       Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>, Janne Grunau <j@jannau.net>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-2-git-send-email-jwilson@redhat.com> <87hc8ptzw7.fsf@basil.nowhere.org>
In-Reply-To: <87hc8ptzw7.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091335.17559.j@jannau.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 11:46:48 Andi Kleen wrote:
> Jarod Wilson <jwilson@redhat.com> writes:
>
> Just some quick comments, no complete review
>
> > +EXTRA_CFLAGS =-DIRCTL_DEV_MAJOR=61 -DLIRC_SERIAL_TRANSMITTER
> > -I$(src)
>
> Put the Ds into some include instead?

LIRC_SERIAL_TRANSMITTER is already gone, not sure that should happen to 
IRCTL_DEV_MAJOR but it could go into lirc.h. moved

> > +
> > +static int debug;
> > +#define dprintk(fmt, args...)					\
> > +	do {							\
> > +		if (debug)					\
> > +			printk(KERN_DEBUG fmt, ## args);	\
> > +	} while (0)
>
> There's some effort to replace that all with pr_printk

pr_printk is not found in include/ nor by google. please explain

> > +	dprintk(LOGHEAD "poll thread started\n", ir->p.name,
> > ir->p.minor); +
> > +	do {
> > +		if (ir->open) {
> > +			if (ir->jiffies_to_wait) {
> > +				set_current_state(TASK_INTERRUPTIBLE);
> > +				schedule_timeout(ir->jiffies_to_wait);
> > +			} else {
> > +				interruptible_sleep_on(
> > +					ir->p.get_queue(ir->p.data));
>
> sleep_on is really discouraged, consider replacing it with
> wait_event()

done

> > +			}
> > +			if (kthread_should_stop())
> > +				break;
> > +			if (!add_to_buf(ir))
> > +				wake_up_interruptible(&ir->buf->wait_poll);
> > +		} else {
> > +			/* if device not opened so we can sleep half a second */
> > +			set_current_state(TASK_INTERRUPTIBLE);
> > +			schedule_timeout(HZ/2);
>
> This means you always wake up every half a second? That will not make
> the powertop users happy. When there's nothing to do it should just
> sleep.

done

> The checks in plugin_register seem a bit extreme.
> At least make that all WARN_ONs
>
> > +
> > +	/* end up polling thread */
> > +	if (ir->task) {
> > +		wake_up_process(ir->task);
> > +		kthread_stop(ir->task);
> > +	}
> > +
> > +	dprintk("lirc_dev: plugin %s unregistered from minor number =
> > %d\n", +		ir->p.name, ir->p.minor);
> > +
> > +	ir->attached = 0;
> > +	if (ir->open) {
> > +		dprintk(LOGHEAD "releasing opened plugin\n",
> > +			ir->p.name, ir->p.minor);
> > +		wake_up_interruptible(&ir->buf->wait_poll);
>
> This seems racy with some users who are lockless
>
> > +		mutex_lock(&ir->buffer_lock);
> > +		ir->p.set_use_dec(ir->p.data);
> > +		module_put(ir->p.owner);
> > +		mutex_unlock(&ir->buffer_lock);
> > +	} else
> > +		cleanup(ir);
> > +	mutex_unlock(&plugin_lock);
> > +
> > +/*
> > + * Recent kernels should handle this autmatically by
> > increasing/decreasing + * use count when a dependant module is
> > loaded/unloaded.
> > + */
>
> All kernels are recent now.

removed

> > +#ifdef MODULE
> > +
> > +/*
> > + *
> > + */
> > +int init_module(void)
> > +{
> > +	return lirc_dev_init();
> > +}
> > +
> > +/*
> > + *
> > + */
> > +void cleanup_module(void)
> > +{
> > +	/* unregister_chrdev returns void now */
> > +	unregister_chrdev(IRCTL_DEV_MAJOR, IRCTL_DEV_NAME);
> > +	class_destroy(lirc_class);
> > +	dprintk("lirc_dev: module unloaded\n");
> > +}
> > +
> > +MODULE_DESCRIPTION("LIRC base driver module");
> > +MODULE_AUTHOR("Artur Lipowski");
> > +MODULE_LICENSE("GPL");
> > +MODULE_ALIAS_CHARDEV_MAJOR(IRCTL_DEV_MAJOR);
> > +
> > +module_param(debug, bool, 0644);
> > +MODULE_PARM_DESC(debug, "Enable debugging messages");
> > +
> > +#else /* not a MODULE */
> > +subsys_initcall(lirc_dev_init);
> > +
> > +#endif /* MODULE */
>
> Always use the #ifdef MODULE path, it does DTRT when compiled in too.
> Remove the init_module wrapper, replace with module_init()

done

thanks for the review. My changes are until Jarod pulls them in 
following tree git://git.jannau.net/linux-2.6-lirc.git

Janne
