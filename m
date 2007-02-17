Return-Path: <linux-kernel-owner+w=401wt.eu-S965211AbXBQLpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965211AbXBQLpp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 06:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965213AbXBQLpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 06:45:45 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:48916 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965211AbXBQLpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 06:45:44 -0500
Date: Sat, 17 Feb 2007 14:44:18 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 08/14] syslets: x86, add create_async_thread() method
Message-ID: <20070217114418.GA6725@2ka.mipt.ru>
References: <20070215165239.GI4285@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070215165239.GI4285@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Sat, 17 Feb 2007 14:44:43 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 05:52:39PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> +/*
> + * Create an async thread
> + */
> +int create_async_thread(int (*fn)(void *), void * arg, unsigned long flags)
> +{
> +	struct pt_regs regs;
> +
> +	memset(&regs, 0, sizeof(regs));
> +
> +	regs.ebx = (unsigned long) fn;
> +	regs.edx = (unsigned long) arg;
> +
> +	regs.xds = __USER_DS;
> +	regs.xes = __USER_DS;
> +	regs.xgs = __KERNEL_PDA;
> +	regs.orig_eax = -1;
> +	regs.eip = (unsigned long) async_thread_helper;
> +	regs.xcs = __KERNEL_CS | get_kernel_rpl();
> +	regs.eflags = X86_EFLAGS_IF | X86_EFLAGS_SF | X86_EFLAGS_PF | 0x2;
> +
> +	/* Ok, create the new task.. */
> +	return do_fork(flags, 0, &regs, 0, NULL, NULL);
> +}

What about complete disabling of signals and only enabling them in the
thread which returns to userspace?

-- 
	Evgeniy Polyakov
