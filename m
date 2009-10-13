Return-Path: <linux-kernel-owner+w=401wt.eu-S1760289AbZJMPib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289AbZJMPib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZJMPia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:38:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751404AbZJMPi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:38:29 -0400
Date: Tue, 13 Oct 2009 08:37:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
cc: linux-mtd <linux-mtd@lists.infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH/RFC v5 4/5]: core: Add dump device to call on oopses and
 panics
In-Reply-To: <20091013152235.188059d2@marrow.netinsight.se>
Message-ID: <alpine.LFD.2.01.0910130813320.26777@localhost.localdomain>
References: <20091012113758.GB11035@elte.hu> <20091012140149.6789efab@marrow.netinsight.se> <20091012120951.GA16799@elte.hu> <1255349748.10605.13.camel@macbook.infradead.org> <20091012122023.GA19365@elte.hu> <20091012150650.51a4b4dc@marrow.netinsight.se>
 <20091012131528.GC25464@elte.hu> <20091012153937.0dcd73e5@marrow.netinsight.se> <alpine.LFD.2.01.0910120828390.3438@localhost.localdomain> <20091012110954.67d7d8d8.akpm@linux-foundation.org> <20091012182346.GH17138@elte.hu> <alpine.LFD.2.01.0910121130190.3438@localhost.localdomain>
 <20091013151751.59e217a7@marrow.netinsight.se> <20091013152235.188059d2@marrow.netinsight.se>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Oct 2009, Simon Kagstrom wrote:
> +
> +struct dump_device {

I know I used that name myself in the example code I sent out, but 
thinking about it more, I hate the name.

Most people think a "dump" is something much more than just the kernel 
messages, so "dump_device" ends up being misleading. And the "device" part 
is kind of pointless and redundant (it need not be a real device).

So I suspect it would be better to name it by what it does, and make it 
clear what that is.

Maybe something like "struct kmsg_dumper" or similar. That is pretty 
unambiguous, and nobody is going to get confused about what the semantics 
are.

> +	void	(*oops)(struct dump_device *, const char *, unsigned long,
> +			const char *, unsigned long);
> +	void	(*panic)(struct dump_device *, const char *, unsigned long,
> +			const char *, unsigned long);

I don't much like this. Why separate 'oops' and 'panic' functions, 
especially since we migth have many more causes to do a kmsg dump in the 
future (ie 'shutdown', 'sysrq', 'suspend' etc etc)?

So separating them out as two different functions is just wrong. Make it 
one function, and then perhaps you can add a

	enum kmsg_dump_reason {
		kmsg_dump_panic,
		kmsg_dump_oops,
		..
	};

and pass it as an argument.

> +	int	(*setup)(struct dump_device *);

Why?

There seems to be no reason for this. Who ever registers the dumper should 
just do the setup call itself. Why would we have a callback that just gets 
called immediately, rather than have the registration code just do the 
call itself?

> +int register_dumpdevice(struct dump_device *dump, void *priv)
> +{
> +	/* We need at least one of these set */
> +	if (!dump->oops && !dump->panic)
> +		return -EINVAL;
> +	if (dump->setup && dump->setup(dump) != 0)
> +		return -EINVAL;

So the above two tests should be pointless.

> +	dump->priv = priv;
> +
> +	INIT_LIST_HEAD(&dump->list);

Don't do "INIT_LIST_HEAD()" here. It's pointless as far as I can tell (the 
list_add() will initialize it), but even in general we should basically 
have basic initialization done by callers if needed.

And judging by historical problems in areas like that, we should protect 
against people registering the same dumper twice. One way to do that would 
be to perhaps _require_ that the caller has initialized it, and then do a 

	if (!list_empty(&dump->list))
		return -EBUSY;

(but I could also see using just a "registered" flag)

> +	write_lock(&dump_list_lock);

This looks dubious. Dumping can obviously happen from interrupts, so _if_ 
you were to protect against dumpers, you'd need to use an interrupt-safe 
lock.

Of course, you do not actually take the lock at dump time (which may be 
intentional, and that is not necessarily wrong - taking locks at oops time 
is generally not a good thing to do, and it may be entirely reasonable to 
say "we take the risk of not locking properly in order to _maybe_ work 
even if the lock is scrogged").

But if you don't take the lock at dump time (or, perhaps preferably, if 
you make the dump-time lock be a "try_lock()" - maybe the oops is due to 
dump list corruption, and if the dump_list_lock is held thew oopser 
should simply not dump!), then you should probably use a spinlock rather 
than an rwlock.

> +	list_for_each_entry(dump, &dump_list, list) {
> +		if (panic && dump->panic)
> +			dump->panic(dump, s1, l1, s2, l2);
> +		else if (!panic && dump->oops)
> +			dump->oops(dump, s1, l1, s2, l2);
> +	}

So this would just become

	list_for_each_entry(dump, &dump_list, list)
		dump->fn(dump, s1, l1, s2, l2, reason);

or something.

			Linus
