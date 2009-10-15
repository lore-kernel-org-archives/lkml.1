Return-Path: <linux-kernel-owner+w=401wt.eu-S1762843AbZJOPrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762843AbZJOPrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 11:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbZJOPrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 11:47:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55805 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758541AbZJOPrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 11:47:40 -0400
Date: Thu, 15 Oct 2009 17:46:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v8 4/5] core: Add kernel message dumper to call on
	oopses and panics
Message-ID: <20091015154640.GA11408@elte.hu>
References: <20091015094057.7298e0d7@marrow.netinsight.se> <20091015094805.754461fa@marrow.netinsight.se> <20091015093133.GF10546@elte.hu> <20091015161052.0752208e@marrow.netinsight.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015161052.0752208e@marrow.netinsight.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Simon Kagstrom <simon.kagstrom@netinsight.net> wrote:

> The core functionality is implemented as per Linus suggestion from
> 
>   http://lists.infradead.org/pipermail/linux-mtd/2009-October/027620.html
> 
> (with the kmsg_dump implementation by Linus). A struct kmsg_dumper has
> been added which contains a callback to dump the kernel log buffers on
> crashes. The kmsg_dump function gets called from oops_exit() and panic()
> and invokes this callbacks with the crash reason.
> 
> Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
> Reviewed-by: Anders Grafstrom <anders.grafstrom@netinsight.net>

The general structure looks very nice now! Assuming my review comments 
below are addressed all patches are:

  Reviewed-by: Ingo Molnar <mingo@elte.hu>

> diff --git a/kernel/printk.c b/kernel/printk.c
> index f38b07f..960406a 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -33,6 +33,8 @@
>  #include <linux/bootmem.h>
>  #include <linux/syscalls.h>
>  #include <linux/kexec.h>
> +#include <linux/kmsg_dump.h>
> +#include <linux/spinlock.h>

( Small nit: in theory the spinlock.h include should not be needed as 
  printk.c already uses spinlocks and gets the types via mutex.h. )

>  
>  #include <asm/uaccess.h>
>  
> @@ -1405,3 +1407,105 @@ bool printk_timed_ratelimit(unsigned long *caller_jiffies,
>  }
>  EXPORT_SYMBOL(printk_timed_ratelimit);
>  #endif
> +
> +static LIST_HEAD(dump_list);
> +static DEFINE_SPINLOCK(dump_list_lock);

Please switch it around to be:

  static DEFINE_SPINLOCK(dump_list_lock);

  static LIST_HEAD(dump_list);

as the lock will be cacheline aligned on SMP, so the list head can come 
after it 'for free'.

If it's the other way around we'll use 8/16 more .data bytes on average.

> +
> +/**
> + *	kmsg_dump_register - register a kernel log dumper.
> + *	@dump: pointer to the kmsg_dumper structure
> + *	@priv: private data for the structure
> + *
> + *	Adds a kernel log dumper to the system. The dump callback in the
> + *	structure will be called when the kernel oopses or panics and must be
> + *	set. Returns zero on success and -EINVAL or -EBUSY otherwise.
> + */
> +int kmsg_dump_register(struct kmsg_dumper *dumper)
> +{
> +	unsigned long flags;
> +
> +	/* The dump callback needs to be set */
> +	if (!dumper->dump)
> +		return -EINVAL;
> +
> +	/* Don't allow registering multiple times */
> +	if (dumper->registered)
> +		return -EBUSY;
> +
> +	dumper->registered = 1;
> +
> +	spin_lock_irqsave(&dump_list_lock, flags);
> +	list_add(&dumper->list, &dump_list);
> +	spin_unlock_irqrestore(&dump_list_lock, flags);
> +	return 0;
> +}
> +EXPORT_SYMBOL(kmsg_dump_register);

There's a race here: dumper->registered should be set to 1 inside the 
spinlock - to make the register/unregister API SMP safe.

It probably doesnt matter much in practice right now (as the dumper will 
be registered during bootup and unregistered during shutdown), but still 
- it could matter to modular loading of multiple dumpers at once, in the 
future.

Also, the check for ->registered should be done inside too.

Plus a style nit: please put a newline before the 'return 0' - it looks 
more symmetric and separates the return from other code flow.

> +
> +/**
> + *	kmsg_dump_unregister - unregister a kmsg dumper.
> + *	@dump: pointer to the kmsg_dumper structure
> + *
> + *	Removes a dump device from the system.
> + */
> +void kmsg_dump_unregister(struct kmsg_dumper *dumper)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&dump_list_lock, flags);
> +	list_del(&dumper->list);
> +	spin_unlock_irqrestore(&dump_list_lock, flags);
> +}
> +EXPORT_SYMBOL(kmsg_dump_unregister);

I'd suggest for this API to use an error return as well, and to do it 
safely - i.e. any combination of these APIs should result in a safe 
result.

Right now a call sequence kmsg_dump_register() + kmsg_dump_unregister() 
+ kmsg_dump_register() will corrupt memory.

> +
> +static const char *kmsg_reasons[] = {
> +	[KMSG_DUMP_OOPS]	= "oops",
> +	[KMSG_DUMP_PANIC]	= "panic",
> +};

Should be 'const char const' for max constness.

> +static const char *kmsg_to_str(enum kmsg_dump_reason reason)
> +{
> +	if (reason > ARRAY_SIZE(kmsg_reasons) || reason < 0)
> +		return "unknown";

That should be ">=" i guess, for the check to be correct.

> +
> +	return kmsg_reasons[reason];
> +}
> +
> +/**
> + *	dump_kmsg - dump kernel log to kernel message dumpers.
> + *	@reason: the reason (oops, panic etc) for dumping
> + *
> + *	Iterate through each of the dump devices and call the oops/panic
> + *	callbacks with the log buffer.
> + */
> +void kmsg_dump(enum kmsg_dump_reason reason)
> +{
> +	unsigned long len = ACCESS_ONCE(log_end);
> +	struct kmsg_dumper *dumper;
> +	const char *s1, *s2;
> +	unsigned long l1, l2;
> +
> +	s1 = "";
> +	l1 = 0;
> +	s2 = log_buf;
> +	l2 = len;
> +
> +	/* Have we rotated around the circular buffer? */
> +	if (len > log_buf_len) {
> +		unsigned long pos = len & LOG_BUF_MASK;
> +
> +		s1 = log_buf + pos;
> +		l1 = log_buf_len - pos;
> +
> +		s2 = log_buf;
> +		l2 = pos;
> +	}
> +
> +	if (!spin_trylock(&dump_list_lock)) {
> +		printk(KERN_ERR "dump_kmsg: dump list lock is held during %s, skipping dump\n",
> +				kmsg_to_str(reason));
> +		return;
> +	}
> +	list_for_each_entry(dumper, &dump_list, list)
> +		dumper->dump(dumper, reason, s1, l1, s2, l2);
> +	spin_unlock(&dump_list_lock);
> +}

( Might make sense to use _irqsave()/_irqrestore() variants here - so 
  that if an IRQ comes in and panics too we dont recurse. The trylock 
  protects us above, but we are already non-preempt here - going irqsafe 
  is even better i guess. )

	Ingo
