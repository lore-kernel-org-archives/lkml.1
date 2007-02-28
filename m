Return-Path: <linux-kernel-owner+w=401wt.eu-S1751315AbXB1U3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315AbXB1U3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 15:29:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbXB1U3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 15:29:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52297 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbXB1U3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 15:29:00 -0500
Date: Wed, 28 Feb 2007 21:21:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070228202156.GA15846@elte.hu>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <Pine.LNX.4.64.0702221130050.1356@alien.or.mcafeemobile.com> <20070228094522.GA17716@elte.hu> <Pine.LNX.4.64.0702280740250.5935@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702280740250.5935@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Davide Libenzi <davidel@xmailserver.org> wrote:

> My point is, the syslet infrastructure is expensive for the kernel in 
> terms of compat, [...]

it is not. Today i've implemented 64-bit syslets on x86_64 and 
32-bit-on-64-bit compat syslets. Both the 64-bit and the 32-bit syslet 
(and threadlet) binaries work just fine on a 64-bit kernel, and they 
share 99% of the infrastructure. There's only a single #ifdef 
CONFIG_COMPAT in kernel/async.c:

#ifdef CONFIG_COMPAT

asmlinkage struct syslet_uatom __user *
compat_sys_async_exec(struct syslet_uatom __user *uatom,
                      struct async_head_user __user *ahu)
{
        return __sys_async_exec(uatom, ahu, &compat_sys_call_table,
                                compat_NR_syscalls);
}

#endif

Even mixed-mode syslets should work (although i havent specifically 
tested them), where the head switches between 64-bit and 32-bit mode and 
submits syslets from both 64-bit and from 32-bit mode, and at the same 
time there might be both 64-bit and 32-bit syslets 'in flight'.

But i'm happy to change the syslet API in any sane way, and did so based 
on feedback from Jens who is actually using them.

	Ingo
