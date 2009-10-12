Return-Path: <linux-kernel-owner+w=401wt.eu-S932103AbZJLMCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbZJLMCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 08:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbZJLMCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 08:02:42 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:62220 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754821AbZJLMCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 08:02:41 -0400
Date: Mon, 12 Oct 2009 14:01:49 +0200
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] panic.c: export panic_on_oops
Message-ID: <20091012140149.6789efab@marrow.netinsight.se>
In-Reply-To: <20091012113758.GB11035@elte.hu>
References: <1255241458-11665-1-git-send-email-dedekind1@gmail.com>
	<20091012111545.GB8857@elte.hu>
	<1255346731.9659.31.camel@localhost>
	<20091012113758.GB11035@elte.hu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Risking that Artem also replies, I'll bite on this one! Let's hope we
agree at least :-))

On Mon, 12 Oct 2009 13:37:58 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> > -       if (mtd->panic_write && in_interrupt())
> > +       if (mtd->panic_write && (in_interrupt() || panic_on_oops))
> >                 /* Interrupt context, we're going to panic so try and log */
> >                 mtdoops_write(cxt, 1);
> 
> Hm, the code seems to be somewhat confused about this. It tries to guess 
> when it's panic-ing, right? in_interrupt() is the wrong test for that.

Well, the main reason is to get the write done directly if we know
we're going to crash. The rest of the code around the patch looks like
this:

         if (mtd->panic_write && (in_interrupt() || panic_on_oops))
                 /* Interrupt context, we're going to panic so try and log */
                 mtdoops_write(cxt, 1);
         else
                 schedule_work(&cxt->work_write);

so if we're oopsing in interrupt context or are going to panic, we just
write directly. mtdoops_write will then use mtd->panic_write if it's
available to get the write done immediately without sleeping.

> mtdoops_console_sync() gets called by regular printk() as well via:
> 
> static void
> mtdoops_console_write(struct console *co, const char *s, unsigned int count)
> {
>         struct mtdoops_context *cxt = co->data;
>         struct mtd_info *mtd = cxt->mtd;
>         unsigned long flags;
> 
>         if (!oops_in_progress) {
>                 mtdoops_console_sync();
>                 return;
> 
> I think this is all layered incorrectly - because mtdoops (which is a 
> _VERY_ cool debugging facility btw - i wish generic x86 had something 
> like that) tries to be a 'driver' and tries to achieve these things 
> without modifying the core kernel.
> 
> But it really should do that. We can certainly enhance the core kernel 
> logic to tell the console driver more clearly when printk should go out 
> immediately.
> 
> Instead of using oops_in_progress it might be better to go into 'sync 
> immeditately' mode if the kernel gets tainted. Add a callback for that 
> to struct console (in include/linux/console.h). The ->unblank() callback 
> is already such a "user attention needed immediately" callback. We could 
> add a ->kernel_bug() callback to that.

I sent another patch which changes the mtdoops behavior a bit:

  http://patchwork.ozlabs.org/patch/35750/

(the thread with the patch series is here:

  http://lists.infradead.org/pipermail/linux-mtd/2009-October/027576.html)

the change is basically to log all messages in a circular buffer (the
current one only logs messages after an oops has started). It also
needed some restructuring, and I believe parts of the code becomes
simpler that way.

The console write now only adds messages to the buffer (never calls
mtdoops_console_sync), and mtdoops_console_sync (i.e., the ->unblank()
callback) simply becomes

  static void mtdoops_console_sync(void)
  {
	struct mtdoops_context *cxt = &oops_cxt;

	/* Write out the buffer if we are called during an oops */
	if (oops_in_progress)
		schedule_work(&cxt->work_write);
  }

To handle the panic case, I've simply added a panic notifier which does

  static int mtdoops_panic(struct notifier_block *this, unsigned long event,
		void *ptr)
  {
	struct mtdoops_context *cxt = &oops_cxt;

	cancel_work_sync(&cxt->work_write);
	cxt->ready = 0;
	if (cxt->mtd->panic_write)
		mtdoops_write(cxt, 1);
	else
		printk(KERN_WARNING "mtdoops: panic_write is not defined, "
					"cannot store dump from panic\n");

	return NOTIFY_DONE;
  }

So with this one, the exported panic_on_oops is no longer needed, and
normal oopses are handled by the scheduled work while panic_on_oopses
are handled by the panic handler.


Anyway, this particular patch is still up for discussion.

// Simon
