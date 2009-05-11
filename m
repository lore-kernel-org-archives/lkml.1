Return-Path: <linux-kernel-owner+w=401wt.eu-S1759309AbZEKVF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309AbZEKVF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbZEKVFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:05:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36805 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756571AbZEKVFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:05:10 -0400
Date: Mon, 11 May 2009 23:04:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/5] Split wait_noreap_copyout()
Message-ID: <20090511210433.GA9588@elte.hu>
References: <1242036759-4025-1-git-send-email-v.mayatskih@gmail.com> <1242036759-4025-2-git-send-email-v.mayatskih@gmail.com> <20090511120418.GA3859@infradead.org> <20090511121708.GD13954@elte.hu> <87zldjwemo.wl%vmayatsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zldjwemo.wl%vmayatsk@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vitaly Mayatskikh <v.mayatskih@gmail.com> wrote:

> At Mon, 11 May 2009 14:17:08 +0200, Ingo Molnar wrote:
> 
> > > 	if (put_user(signal, &infop->si_signo) ||
> > > 	    put_user(0, &infop->si_errno) ||
> > > 	    put_user((short)why, &infop->si_code) ||
> > > 	    put_user(pid, &infop->si_pid) ||
> > > 	    put_user(uid, &infop->si_uid) ||
> > > 	    put_user(status, &infop->si_status))
> > > 		return -EFAULT;
> > 
> > For best assembly code this should generally be written as a series 
> > of:
> > 
> >    __uaccess_err |= __put_user(x, ptr);
> >    __uaccess_err |= __put_user(y, ptr);
> >    __uaccess_err |= __put_user(z, ptr);
> > 
> > As this generates non-dependent, compressed, branch-less code.
> 
> Yeah, my first intention was to eliminate a lot of branches in one
> place. It's terrible for CPU pipeline, I bet.
> 
> > See the (new) put_user_try / put_user_ex() / put_user_catch() 
> > abstraction in arch/x86/include/asm/uaccess.h, and how all the 
> > x86 signal code makes use of that to optimize such patterns of 
> > per field user copies.
> 
> So, there's catch block to handle GPF and the code inside of `try' 
> block is still branch-less, right? I was thinking of minimized 
> version of struct siginfo (up to si_uid) and copying it with 
> single copy_to_user(), but the idea with try/catch is definitely 
> much better.

It creates really nice assembly code. Hiroshi-san experimented with 
it a lot until he found this form.

Regarding potentially generalizing that facility into generic code, 
it relies on the exception code filling in 
current_thread_info()->uaccess_err with -EFAULT. So it needs 
architecture level support. It also kind of relies on 
current_thread_info()->uaccess_err being super-optimal - which it is 
on x86. (the assembler can optimize it)

But a compatible wrapper could be added, for architectures that dont 
support, or that dont need support.

	Ingo
