Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbYJUGdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbYJUGdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 02:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbYJUGc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 02:32:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:44431 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbYJUGcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 02:32:55 -0400
Subject: Bug in "genirq: record trigger type"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
In-Reply-To: <200810202205.m9KM5une024759@hera.kernel.org>
References: <200810202205.m9KM5une024759@hera.kernel.org>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 17:32:10 +1100
Message-Id: <1224570730.7654.242.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-20 at 22:05 +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0c5d1eb77a8be917b638344a22afe1398236482b
> Commit:     0c5d1eb77a8be917b638344a22afe1398236482b
> Parent:     d6d5aeb661fc14655c417f3582ae7ec52985d2a8
> Author:     David Brownell <dbrownell@users.sourceforge.net>
> AuthorDate: Wed Oct 1 14:46:18 2008 -0700
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu Oct 2 10:24:09 2008 +0200

This one is obviously broken and breaks booting on a whole bunch of
machines (including powermac's and thus my G5, it's never good when my
own machine breaks !).

Nice to see 3 SOB's and one Ack and nobody caught the obvious bug :-)

>  	desc = irq_desc + irq;
> -	if (desc->chip->set_type) {
> -		spin_lock_irqsave(&desc->lock, flags);
> -		ret = desc->chip->set_type(irq, type);
> -		spin_unlock_irqrestore(&desc->lock, flags);
> -	}
> +	if (type == IRQ_TYPE_NONE)
> +		return 0;
> +
> +	spin_lock_irqsave(&desc->lock, flags);
> +	ret = __irq_set_trigger(desc, irq, flags);
                                             ^^^^ type maybe ?

> +	spin_unlock_irqrestore(&desc->lock, flags);
>  	return ret;
>  }

I have to run so no patch until tomorrow unless somebody beats me to it.

Cheers,
Ben.


