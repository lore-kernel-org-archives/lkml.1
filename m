Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbYH1M2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbYH1M2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 08:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYH1M23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 08:28:29 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:54867 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbYH1M22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 08:28:28 -0400
Date: Thu, 28 Aug 2008 16:32:42 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Pierre Morel <pmorel@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       sameske@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [RFC] [Patch 1/1] [Self Ptrace] System call notification with self_ptrace
Message-ID: <20080828123242.GA187@tv-sign.ru>
References: <48B26083.8080506@linux.vnet.ibm.com> <20080825165403.GA604@tv-sign.ru> <48B40D5F.3020705@linux.vnet.ibm.com> <20080826162750.GA406@tv-sign.ru> <48B5658A.5000101@linux.vnet.ibm.com> <20080827162455.GA132@tv-sign.ru> <48B6942E.2050607@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B6942E.2050607@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28, Pierre Morel wrote:
>
> Oleg Nesterov wrote:
> >On 08/27, Pierre Morel wrote:
> >
> >>Oleg Nesterov wrote:
> >>
> >>
> >>>On s390 the patch changes handle_signal(), this is not clear to me too.
> >>>
> >>>
> >>The patch clears the trace flags before delivering the signal so
> >>that the signal handler can use system call without bouncing again.
> >>
> >
> >Yes I see. But the signal handler for SIGSYS can fisrt do
> >sys_ptrace(PTRACE_SELF_OFF) (which is filtered out), and then use any
> >other syscall.
> >
> It is right but brings the overhead of a syscall.

Well, this overhead is very small compared to the signal delivery.

> >With this patch PT_SELF is cleared on any signal. This doesn't look
> >right. Let's suppose that another signal comes in parallel with SIGSYS.
> >It is very possible that the handler for that another signal will be
> >called first, this handler can do some syscall which will be "missed".
> >
>
> If the tracing application catches all signals before delivering
> them to the instrumented original handler there is no problem,
> the catching code can reset PTRACE_SELF_ON before calling the
> instrumented application's original handler.
> The instrumented code will then bounce as expected.

Sorry, can't understand the text above :(

OK, let's suppose the application does

	ptrace(PTRACE_SELF_ON);
	...
	syscall();

This "syscall()" above should trigger the handler for SIGSYS.
But what if another signal (with handler) comes in between?
In that case handle_signal() clears PT_SELF/TIF_SYSCALL_TRACE,
this syscall() (or any other) doesn't send SIGSYS.

Oleg.

