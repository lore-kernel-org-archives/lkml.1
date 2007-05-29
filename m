Return-Path: <linux-kernel-owner+w=401wt.eu-S1758855AbXE2TXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbXE2TXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 15:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbXE2TXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 15:23:00 -0400
Received: from mail.screens.ru ([213.234.233.54]:42685 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbXE2TW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 15:22:59 -0400
Date: Tue, 29 May 2007 23:22:43 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [BUG] signal: multithread program returns with wrong errno on receiving SIGSTOP
Message-ID: <20070529192243.GA189@tv-sign.ru>
References: <20070528070753.GA989@tv-sign.ru> <20070529073354.729431F8511@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529073354.729431F8511@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29, Roland McGrath wrote:
>
> Your fix seems like the only way to go.  From skimming all the ERESTART*
> uses, I think that in all cases (except for n_tty.c:job_control before your
> patch), TIF_SIGPENDING is indeed set when a thread returns -ERESTART*.
> 
> But it makes me realize that there is a danger of leaking a -ERESTART*
> return code to userland when TIF_SIGPENDING gets cleared by another thread
> doing a recalc_sigpending_tsk.  Because of -ERESTART* I think we must make
> it a rule that no thread can clear another thread's TIF_SIGPENDING, only
> set it (unless it's known to be stopped in the signal code or something).
> >From our recent work on it, I think that do_sigaction is in fact the only
> place this can happen.  So that says we should err in the other direction
> from what I said before in do_sigaction, and not have it do recalc at all.

I think you are right.

But please note that cancel_freezing(p) is special. It is also called when
try_to_freeze_tasks() fails. So it should clear TIF_SIGPENDING if "p" is a
kernel thread, otherwise p may run with signal_pending() forever.

Unfortunately, it is not easy to detect the kernel thread, is_user_space()
is not reliable. Probably we should ignore this minor problem and do not
change cancel_freezing().

Oleg.

