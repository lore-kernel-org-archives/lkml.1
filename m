Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbYC1SYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbYC1SYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbYC1SYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:24:39 -0400
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:63840 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754241AbYC1SYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:24:38 -0400
Date: Fri, 28 Mar 2008 20:24:35 +0200
From: Pekka Paalanen <pq@iki.fi>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Pavel Roskin" <proski@gnu.org>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] mmiotrace full patch, preview 2
Message-ID: <20080328202435.6a58e21d@daedalus.pq.iki.fi>
In-Reply-To: <19f34abd0803271613vc6d6e9ic0491643eb25a3e8@mail.gmail.com>
References: <20080309164050.2194461e@daedalus.pq.iki.fi>
	<19f34abd0803271613vc6d6e9ic0491643eb25a3e8@mail.gmail.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008 00:13:48 +0100
"Vegard Nossum" <vegard.nossum@gmail.com> wrote:

> I may of course be wrong, but... Shouldn't the post_kmmio_handler(),
> called from the die notifier chain, check for the DR_STEP condition?
> This makes sure that the function is not called in the cases where the
> source of the debug exception was not a single-stepping event. Though
> I guess you'll also have other checks in place to notice that the
> interrupt was not the one you were expecting. I guess a little extra
> safety won't hurt though?
> 
> On Sun, Mar 9, 2008 at 3:40 PM, Pekka Paalanen <pq@iki.fi> wrote:
> >  +/*
> >  + * Interrupts are disabled on entry as trap1 is an interrupt gate
> >  + * and they remain disabled thorough out this function.
> >  + * This must always get called as the pair to kmmio_handler().
> >  + */
> >  +static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
> >  +{
> >  +       int ret = 0;
> >  +       struct kmmio_context *ctx = &get_cpu_var(kmmio_ctx);
> 
> if (!(condition & DR_STEP))
>     return;

I guess that would be appropriate. I think it should go into this
function:

+static int kmmio_die_notifier(struct notifier_block *nb, unsigned long val,
+								void *args)
+{
+	struct die_args *arg = args;
+
+	if (val == DIE_DEBUG)
+		if (post_kmmio_handler(arg->err, arg->regs) == 1)
+			return NOTIFY_STOP;
+
+	return NOTIFY_DONE;
+}

On the other hand I am thinking of not using the die notifier chain
at all and adding a direct call from do_debug() or something.
This is the last dynamic hook remaining from the out-of-tree module
era of mmiotrace.

I guess with the notifier list there is a possibility that another
module intercepts my single step trap, so that this is never called,
which would leave mmiotrace half blind, and also trigger a recursive
probe hit.

btw. what if someone uses kmemcheck and mmiotrace at the same time?
Mmiotrace will not fiddle with any other pages than returned via
__ioremap(), but can kmemcheck "hide" the same mmio pages?
Also keeping in mind, that some day I'd like to make mmiotrace able
to catch mmio accesses originating in user space.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
