Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbYHZQXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbYHZQXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 12:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbYHZQXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 12:23:16 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51958 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716AbYHZQXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 12:23:16 -0400
Date: Tue, 26 Aug 2008 20:27:50 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Pierre Morel <pmorel@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       sameske@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [RFC] [Patch 1/1] [Self Ptrace] System call notification with self_ptrace
Message-ID: <20080826162750.GA406@tv-sign.ru>
References: <48B26083.8080506@linux.vnet.ibm.com> <20080825165403.GA604@tv-sign.ru> <48B40D5F.3020705@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B40D5F.3020705@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26, Pierre Morel wrote:
>
> Oleg Nesterov wrote:
> >We have some "->ptrace != 0" checks which can misunderstand this. Just
> >for example, suppose that the task does sys_ptrace(PTRACE_SELF_ON) and
> >then its parent dies. I guess in that case forget_original_parent()
> >will hit BUG_ON(p->ptrace), no?
> >
> >
> Yes you are right, I will take care of those cases.
> I have the choice between:
>
> - tracking all references to the ptrace flags and add a test for PT_SELF
> or a mask.
>
> - add a dedicated task_struct entry to hold the PT_SELF flag

Well, given that PT_SELF is exotic, neither choice looks very good, imho.
But I am not expert and maintainer is cc'ed ;)

I don't understand why this patch changes the x86's sys_sigaction().
On s390 the patch changes handle_signal(), this is not clear to me too.
do_syscall_trace() filters out __NR_ptrace, this afaics means that the
handler for SIGSYS can happily call sys_ptrace(PTRACE_SELF_OFF) and
clear PT_SELF/TIF_SYSCALL_TRACE.

I must admit, personally I don't think the whole idea is good...
And what if the user of PT_SELF is ptraced? The usage of TIF_SYSCALL_TRACE
doesn't look "safe" in that case.


Isn't it possible to implement this behaviour in the user space? If the
task needs the PT_SELF behaviour, it can fork another process which will
do PTRACE_ATTACH and then send the notifications to the task. We can use
signals or something else.

Oleg.

