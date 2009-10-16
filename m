Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbZJPLEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbZJPLEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 07:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbZJPLD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 07:03:59 -0400
Received: from smtp.nokia.com ([192.100.105.134]:19564 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbZJPLD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 07:03:58 -0400
Subject: Re: [PATCH v10 4/5] core: Add kernel message dumper to call on
 oopses and panics
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20091016101045.GA3263@elte.hu>
References: <20091015094057.7298e0d7@marrow.netinsight.se>
	 <20091015094805.754461fa@marrow.netinsight.se>
	 <20091015093133.GF10546@elte.hu>
	 <20091015161052.0752208e@marrow.netinsight.se>
	 <20091015154640.GA11408@elte.hu>
	 <20091016094601.4e2c2d3e@marrow.netinsight.se>
	 <20091016080935.GA3895@elte.hu> <1255681467.32489.360.camel@localhost>
	 <20091016112556.6902b2dc@marrow.netinsight.se>
	 <20091016101045.GA3263@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Oct 2009 14:00:28 +0300
Message-Id: <1255690828.32489.368.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 16 Oct 2009 11:00:32.0336 (UTC) FILETIME=[E155CD00:01CA4E4F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 12:10 +0200, Ingo Molnar wrote:
> * Simon Kagstrom <simon.kagstrom@netinsight.net> wrote:
> 
> > +int kmsg_dump_register(struct kmsg_dumper *dumper)
> > +{
> > +	unsigned long flags;
> > +
> > +	/* The dump callback needs to be set */
> > +	if (!dumper->dump)
> > +		return -EINVAL;
> > +
> > +	spin_lock_irqsave(&dump_list_lock, flags);
> > +
> > +	/* Don't allow registering multiple times */
> > +	if (dumper->registered) {
> > +		spin_unlock_irqrestore(&dump_list_lock, flags);
> > +
> > +		return -EBUSY;
> > +	}
> > +
> > +	dumper->registered = 1;
> > +	list_add(&dumper->list, &dump_list);
> > +	spin_unlock_irqrestore(&dump_list_lock, flags);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(kmsg_dump_register);
> 
> 
> i dont want to bikeshed paint this but this sequence caught my eyes. We 
> generally do flatter and clearer locking sequences:
> 
> int kmsg_dump_register(struct kmsg_dumper *dumper)
> {
> 	unsigned long flags;
> 	int err = -EBUSY;
> 
> 	/* The dump callback needs to be set */
> 	if (!dumper->dump)
> 		return -EINVAL;
> 
> 	spin_lock_irqsave(&dump_list_lock, flags);
> 
> 	/* Don't allow registering multiple times */
> 	if (!dumper->registered) {
> 		dumper->registered = 1;
> 		list_add_tail(&dumper->list, &dump_list);
> 		err = 0;
> 	}
> 
> 	spin_unlock_irqrestore(&dump_list_lock, flags);
> 
> 	return err;
> }
> EXPORT_SYMBOL_GPL(kmsg_dump_register);

And while we are on it, I think these extra lines before and after
spinlocks are unneeded and even a bit annoying :-)

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

