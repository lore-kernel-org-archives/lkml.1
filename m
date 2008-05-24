Return-Path: <linux-kernel-owner+w=401wt.eu-S1761605AbYEXUfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761605AbYEXUfP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 16:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758702AbYEXUfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 16:35:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42906 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbYEXUfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 16:35:00 -0400
Date: Sat, 24 May 2008 13:34:25 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] futex: fix miss ordered wakeups
Message-ID: <20080524133425.543694ab@infradead.org>
In-Reply-To: <1211656774.18130.198.camel@localhost.localdomain>
References: <20080523042923.594531457@mvista.com>
	<20080523042923.916202203@mvista.com>
	<alpine.LFD.1.10.0805241039220.3295@apollo.tec.linutronix.de>
	<1211643165.18130.166.camel@localhost.localdomain>
	<alpine.LFD.1.10.0805241852490.3295@apollo.tec.linutronix.de>
	<1211649860.18130.182.camel@localhost.localdomain>
	<alpine.LFD.1.10.0805242031560.3295@apollo.tec.linutronix.de>
	<1211656774.18130.198.camel@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 May 2008 12:19:34 -0700
Daniel Walker <dwalker@mvista.com> wrote:

> > There is no kernel side controlled handover of a normal futex. The
> > woken up waiters race for it and a low prio thread on another CPU
> > can steal it even if there is a high prio waiter woken up.
> 
> After reading futex_wake, Doesn't it depend how many waiters are
> woken? Given that comes from userspace, glibc could wake a single
> waiter and obtain a priority ordering, couldn't it?

nope. Don't look at the release path... look at the acquire path.
If a thread sees the futex is free, it'll take it, without even going
to the kernel at all. So you have the situation where the kernel spends
a lot of time finding the "perfect" candidate to wake up, but kaboom
some other thread just happens to try to get the mutex between the
wakeup and the acquire of the wakee.. and just "steal" the lock.


