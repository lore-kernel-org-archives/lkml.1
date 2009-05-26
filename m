Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbZEZCnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbZEZCnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 22:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZEZCnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 22:43:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752654AbZEZCnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 22:43:41 -0400
Date: Mon, 25 May 2009 19:42:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       x86@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH 1/3] kernel.h: Add DO_ONCE statement expression macro
Message-Id: <20090525194221.8fd081c8.akpm@linux-foundation.org>
In-Reply-To: <7b063fda0675875d51a5da49f59e89520d025eee.1242943463.git.joe@perches.com>
References: <cover.1242943463.git.joe@perches.com>
	<7b063fda0675875d51a5da49f59e89520d025eee.1242943463.git.joe@perches.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 May 2009 16:00:22 -0700 Joe Perches <joe@perches.com> wrote:

> +/*
> + * Do something once (analogous to WARN_ONCE() et al):
> + */
> +#define DO_ONCE(x...) ({			\
> +	static bool __done = false;		\
> +						\
> +	if (!__done) {				\
> +		x;				\
> +		__done = true;			\
> +	}					\
> +})

Every single call site for this macro will be mind-bogglingly ugly and
complex callers won't look like C at all.

It would be much better to replace

	DO_ONCE(code-sequence);

with
	if (ONCE()) {
		code-sequence;
	}

I think that's fairly natural and clear and will allow us to clean up a
large number of callsites many of which do the same thing in different
ways, some of them buggily.

And yeah, if this is to be core kernel infrastructure then the default
implementation shouldn't be racy on SMP/preempt.

