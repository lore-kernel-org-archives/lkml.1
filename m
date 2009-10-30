Return-Path: <linux-kernel-owner+w=401wt.eu-S932897AbZJ3Vp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897AbZJ3Vp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 17:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757447AbZJ3Vp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 17:45:56 -0400
Received: from mail.perches.com ([173.55.12.10]:1131 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757305AbZJ3Vpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 17:45:55 -0400
Subject: Re: [PATCH] show message when exceeded rlimit of pending signals
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Naohiro Ooiwa <nooiwa@miraclelinux.com>, Ingo Molnar <mingo@elte.hu>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, roland@redhat.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, oleg@redhat.com
In-Reply-To: <20091030143333.414ea29c.akpm@linux-foundation.org>
References: <4AEACFBF.4060108@miraclelinux.com>
	 <20091030143333.414ea29c.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Oct 2009 14:45:58 -0700
Message-ID: <1256939158.1917.43.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-30 at 14:33 -0700, Andrew Morton wrote:
> On Fri, 30 Oct 2009 20:36:31 +0900
> Naohiro Ooiwa <nooiwa@miraclelinux.com> wrote:
> > +static void show_reach_rlimit_sigpending(void)
> > +	if (!printk_ratelimit())
> > +		return;
> 
> printk_ratelimit() is a bad thing and we should be working toward
> removing it altogether, not adding new callers.
> 
> Because it uses global state.  So if subsystem A is trying to generate
> lots of printk's, subsystem B's important message might get
> accidentally suppressed.

http://lkml.org/lkml/2009/9/21/323

I think there should be a generic kernel.h macro for this.
Something like:

#define printk_ratelimited(fmt, arg...)			\
({	static struct ratelimit_state _rs = {		\
		.interval = DEFAULT_RATELIMIT_INTERVAL,	\
		.burst = DEFAULT_RATELIMIT_BURST,	\
	};						\
	int rtn;					\
							\
	if (!__ratelimit(&_rs))				\
		rtn = printk(fmt, ##arg);		\
	else						\
		rtn = 0;				\
	rtn;						\
})
#define pr_info_rl(fmt, arg) \
	printk_ratelimited(KERN_INFO pr_fmt(fmt), ##arg)
etc...



