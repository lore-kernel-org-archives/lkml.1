Return-Path: <linux-kernel-owner+w=401wt.eu-S1756367AbZJLLiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbZJLLiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 07:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbZJLLix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 07:38:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52154 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391AbZJLLix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 07:38:53 -0400
Date: Mon, 12 Oct 2009 13:37:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Artem Bityutskiy <dedekind1@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] panic.c: export panic_on_oops
Message-ID: <20091012113758.GB11035@elte.hu>
References: <1255241458-11665-1-git-send-email-dedekind1@gmail.com> <20091012111545.GB8857@elte.hu> <1255346731.9659.31.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255346731.9659.31.camel@localhost>
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


* Artem Bityutskiy <dedekind1@gmail.com> wrote:

> On Mon, 2009-10-12 at 13:15 +0200, ext Ingo Molnar wrote:
> > > We use the mtdoops module which stores oopses on the Flash partition,
> > > in order to make it possible to analyze them later. And mtdoops needs
> > > to know whether 'panic_on_oops' is on or off. Thus, we need this
> > > variable to be exported.
> > 
> > hm, why does it need it? Could you send the patch please that makes use 
> > of it (as an easy way to explain the need for the export) - current 
> > upstream drivers/mtd/mtdoops.c doesnt need it so it must be some pending 
> > change.
> 
> Yes, current drivers/mtd/mtdoops.c does not need it, but we have this
> patch:
> 
> http://lists.infradead.org/pipermail/linux-mtd/2009-October/027450.html
> 
> which makes sure mtdoops writes the oops log immediately, because we
> have 'panic_on_oops' set so this is our last chance to save the oops.
> 
> Here is the patch inlined as well:
> 
> Author: Aaro Koskinen <aaro.koskinen@nokia.com>
> Date:   Thu Oct 1 18:16:55 2009 +0300
> 
>     mtd: mtdoops: do not schedule work if we are going to die
> 
>     If panic_on_oops is set, the log should be written right away
>     because this is not going to be a second chance.
> 
>     Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
>     Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> diff --git a/drivers/mtd/mtdoops.c b/drivers/mtd/mtdoops.c
> index 1060337..ac67833 100644
> --- a/drivers/mtd/mtdoops.c
> +++ b/drivers/mtd/mtdoops.c
> @@ -335,7 +335,7 @@ static void mtdoops_console_sync(void)
>         cxt->ready = 0;
>         spin_unlock_irqrestore(&cxt->writecount_lock, flags);
> 
> -       if (mtd->panic_write && in_interrupt())
> +       if (mtd->panic_write && (in_interrupt() || panic_on_oops))
>                 /* Interrupt context, we're going to panic so try and log */
>                 mtdoops_write(cxt, 1);

Hm, the code seems to be somewhat confused about this. It tries to guess 
when it's panic-ing, right? in_interrupt() is the wrong test for that.

mtdoops_console_sync() gets called by regular printk() as well via:

static void
mtdoops_console_write(struct console *co, const char *s, unsigned int count)
{
        struct mtdoops_context *cxt = co->data;
        struct mtd_info *mtd = cxt->mtd;
        unsigned long flags;

        if (!oops_in_progress) {
                mtdoops_console_sync();
                return;

I think this is all layered incorrectly - because mtdoops (which is a 
_VERY_ cool debugging facility btw - i wish generic x86 had something 
like that) tries to be a 'driver' and tries to achieve these things 
without modifying the core kernel.

But it really should do that. We can certainly enhance the core kernel 
logic to tell the console driver more clearly when printk should go out 
immediately.

Instead of using oops_in_progress it might be better to go into 'sync 
immeditately' mode if the kernel gets tainted. Add a callback for that 
to struct console (in include/linux/console.h). The ->unblank() callback 
is already such a "user attention needed immediately" callback. We could 
add a ->kernel_bug() callback to that.

	Ingo
