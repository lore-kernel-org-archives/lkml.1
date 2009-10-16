Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbZJPKLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbZJPKLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 06:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbZJPKLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 06:11:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45434 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbZJPKLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 06:11:49 -0400
Date: Fri, 16 Oct 2009 12:10:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: dedekind1@gmail.com, linux-mtd <linux-mtd@lists.infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v10 4/5] core: Add kernel message dumper to call on
	oopses and panics
Message-ID: <20091016101045.GA3263@elte.hu>
References: <20091015094057.7298e0d7@marrow.netinsight.se> <20091015094805.754461fa@marrow.netinsight.se> <20091015093133.GF10546@elte.hu> <20091015161052.0752208e@marrow.netinsight.se> <20091015154640.GA11408@elte.hu> <20091016094601.4e2c2d3e@marrow.netinsight.se> <20091016080935.GA3895@elte.hu> <1255681467.32489.360.camel@localhost> <20091016112556.6902b2dc@marrow.netinsight.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091016112556.6902b2dc@marrow.netinsight.se>
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


* Simon Kagstrom <simon.kagstrom@netinsight.net> wrote:

> +int kmsg_dump_register(struct kmsg_dumper *dumper)
> +{
> +	unsigned long flags;
> +
> +	/* The dump callback needs to be set */
> +	if (!dumper->dump)
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&dump_list_lock, flags);
> +
> +	/* Don't allow registering multiple times */
> +	if (dumper->registered) {
> +		spin_unlock_irqrestore(&dump_list_lock, flags);
> +
> +		return -EBUSY;
> +	}
> +
> +	dumper->registered = 1;
> +	list_add(&dumper->list, &dump_list);
> +	spin_unlock_irqrestore(&dump_list_lock, flags);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kmsg_dump_register);


i dont want to bikeshed paint this but this sequence caught my eyes. We 
generally do flatter and clearer locking sequences:

int kmsg_dump_register(struct kmsg_dumper *dumper)
{
	unsigned long flags;
	int err = -EBUSY;

	/* The dump callback needs to be set */
	if (!dumper->dump)
		return -EINVAL;

	spin_lock_irqsave(&dump_list_lock, flags);

	/* Don't allow registering multiple times */
	if (!dumper->registered) {
		dumper->registered = 1;
		list_add_tail(&dumper->list, &dump_list);
		err = 0;
	}

	spin_unlock_irqrestore(&dump_list_lock, flags);

	return err;
}
EXPORT_SYMBOL_GPL(kmsg_dump_register);

(warning: untested, written in mail editor)

Same goes for kmsg_dump_unregister().

	Ingo
