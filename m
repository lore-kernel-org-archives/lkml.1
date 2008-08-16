Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbYHPQAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbYHPQAy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 12:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbYHPQAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 12:00:45 -0400
Received: from mcbehr.de ([81.169.141.90]:44998 "EHLO
	h1328092.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbYHPQAp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 12:00:45 -0400
X-Greylist: delayed 1659 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Aug 2008 12:00:44 EDT
From: "Matthias Behr" <linux@mcbehr.de>
To: "'Gregory Haskins'" <ghaskins@novell.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>,
       <gregory.haskins@gmail.com>, <mingo@elte.hu>, <David.Holmes@sun.com>,
       <jkacur@gmail.com>, <paulmck@linux.vnet.ibm.com>,
       <peterz@infradead.org>, <tglx@linutronix.de>, <rostedt@goodmis.org>
References: <20080815202408.668.23736.stgit@dev.haskins.net> <20080815202823.668.26199.stgit@dev.haskins.net>
In-Reply-To: <20080815202823.668.26199.stgit@dev.haskins.net>
Subject: AW: [PATCH RT RFC v4 1/8] add generalized priority-inheritance interface
Date: Sat, 16 Aug 2008 17:32:55 +0200
Message-ID: <073b01c8ffb5$5c597870$150c6950$@de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acj/FeazwmQMzANPS3iMNyqhaQyC6gAiwiSA
Content-Language: de
X-Spam_score: 0.1
X-Spam_score_int: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I got a few review comments/questions. Pls see below.

Best Regards,
Matthias

P.S. I'm a kernel newbie so don't hesitate to tell me if I'm wrong ;-)

> +/**
> + * pi_sink_init - initialize a pi_sink before use
> + * @sink: a sink context
> + * @ops: pointer to an pi_sink_ops structure
> + */
> +static inline void
> +pi_sink_init(struct pi_sink *sink, struct pi_sink_ops *ops)
> +{
> +	atomic_set(&sink->refs, 0);
> +	sink->ops = ops;
> +}

Shouldn't ops be tested for 0 here? (ASSERT/BUG_ON/...) (get's dereferenced later quite often in the form "if (sink->ops->...)".

> +/**
> + * pi_sink_put - down the reference count, freeing the sink if 0
> + * @node: the node context
> + * @flags: optional flags to modify behavior.  Reserved, must be 0.
> + *
> + * Returns: none
> + */
> +static inline void
> +pi_sink_put(struct pi_sink *sink, unsigned int flags)
> +{
> +	if (atomic_dec_and_test(&sink->refs)) {
> +		if (sink->ops->free)
> +			sink->ops->free(sink, flags);
> +	}
> +}

Shouldn't the atomic/locked part cover the ...->free(...) as well? A pi_get right after the atomic_dec_and_test but before the free() could lead to a free() with refs>0?



