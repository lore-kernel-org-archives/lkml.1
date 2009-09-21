Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775AbZIUVMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbZIUVMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 17:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbZIUVMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 17:12:17 -0400
Received: from mail.perches.com ([173.55.12.10]:1056 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbZIUVMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 17:12:16 -0400
Subject: Re: [patch] oom: dump stack and VM state when oom killer panics
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, rientjes@google.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090921134104.79668479.akpm@linux-foundation.org>
References: <alpine.DEB.1.00.0909171354570.17483@chino.kir.corp.google.com>
	 <20090918092427.8E48.A69D9226@jp.fujitsu.com>
	 <20090921134104.79668479.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Sep 2009 14:12:19 -0700
Message-Id: <1253567539.17725.23.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-21 at 13:41 -0700, Andrew Morton wrote:
> The code shouldn't be using printk_ratelimit() - in fact nothing should
> be using it and we should remove printk_ratelimit() from the kernel, I
> suspect.

Perhaps a per instance use instead.  Something like:

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


