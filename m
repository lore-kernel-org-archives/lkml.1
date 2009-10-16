Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbZJPM7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbZJPM7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 08:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759207AbZJPM7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 08:59:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56104 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759188AbZJPM7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 08:59:08 -0400
Date: Fri, 16 Oct 2009 14:57:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v10 4/5] core: Add kernel message dumper to call on
	oopses and panics
Message-ID: <20091016125752.GB24518@elte.hu>
References: <20091015094805.754461fa@marrow.netinsight.se> <20091015093133.GF10546@elte.hu> <20091015161052.0752208e@marrow.netinsight.se> <20091015154640.GA11408@elte.hu> <20091016094601.4e2c2d3e@marrow.netinsight.se> <20091016080935.GA3895@elte.hu> <1255681467.32489.360.camel@localhost> <20091016112556.6902b2dc@marrow.netinsight.se> <20091016101045.GA3263@elte.hu> <1255690828.32489.368.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255690828.32489.368.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Artem Bityutskiy <dedekind1@gmail.com> wrote:

> On Fri, 2009-10-16 at 12:10 +0200, Ingo Molnar wrote:
> > * Simon Kagstrom <simon.kagstrom@netinsight.net> wrote:
> > 
> > > +int kmsg_dump_register(struct kmsg_dumper *dumper)
> > > +{
> > > +	unsigned long flags;
> > > +
> > > +	/* The dump callback needs to be set */
> > > +	if (!dumper->dump)
> > > +		return -EINVAL;
> > > +
> > > +	spin_lock_irqsave(&dump_list_lock, flags);
> > > +
> > > +	/* Don't allow registering multiple times */
> > > +	if (dumper->registered) {
> > > +		spin_unlock_irqrestore(&dump_list_lock, flags);
> > > +
> > > +		return -EBUSY;
> > > +	}
> > > +
> > > +	dumper->registered = 1;
> > > +	list_add(&dumper->list, &dump_list);
> > > +	spin_unlock_irqrestore(&dump_list_lock, flags);
> > > +
> > > +	return 0;
> > > +}
> > > +EXPORT_SYMBOL_GPL(kmsg_dump_register);
> > 
> > 
> > i dont want to bikeshed paint this but this sequence caught my eyes. We 
> > generally do flatter and clearer locking sequences:
> > 
> > int kmsg_dump_register(struct kmsg_dumper *dumper)
> > {
> > 	unsigned long flags;
> > 	int err = -EBUSY;
> > 
> > 	/* The dump callback needs to be set */
> > 	if (!dumper->dump)
> > 		return -EINVAL;
> > 
> > 	spin_lock_irqsave(&dump_list_lock, flags);
> > 
> > 	/* Don't allow registering multiple times */
> > 	if (!dumper->registered) {
> > 		dumper->registered = 1;
> > 		list_add_tail(&dumper->list, &dump_list);
> > 		err = 0;
> > 	}
> > 
> > 	spin_unlock_irqrestore(&dump_list_lock, flags);
> > 
> > 	return err;
> > }
> > EXPORT_SYMBOL_GPL(kmsg_dump_register);
> 
> And while we are on it, I think these extra lines before and after 
> spinlocks are unneeded and even a bit annoying :-)

To me they increase readability quite a bit as it allows me to 
concentrate on just the inner critical section without the distraction 
of the lock/unlock sequence. YMMV.

	Ingo
