Return-Path: <linux-kernel-owner+w=401wt.eu-S1751738AbXDIJHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbXDIJHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 05:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbXDIJHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 05:07:21 -0400
Received: from mail.screens.ru ([213.234.233.54]:54475 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbXDIJHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 05:07:20 -0400
Date: Mon, 9 Apr 2007 13:06:43 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFC, PATCH 1/3] introduce SYS_CLONE_MASK
Message-ID: <20070409090643.GA121@tv-sign.ru>
References: <20070408155337.GA126@tv-sign.ru> <m1lkh23kkb.fsf@ebiederm.dsl.xmission.com> <20070408165750.GA149@tv-sign.ru> <m1d52e2w86.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d52e2w86.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
> > Perhaps it is better to add reparent_kthread() (next patch) to kthread()
> > and forget about CLONE_KERNEL_THREAD.
> 
> Please. 

OK, will do tomorrow.

> > Anyway, re-parenting to swapper breaks pstree, it doesn't show kernel
> > threads. And if ->parent == /sbin/init, we can't remove us from ->children
> > (unless we forbid sub-thread-of-init exec). So the only safe change is
> > set ->exit_state = -1.
> 
> Yes.  We certainly need ->exit_state = -1.
> Earlier I had forgotten about second the use of ->children to update
> the parent pointer of processes when their parent exits.
> 
> There is a practical question how much we care about pstree being
> confused (I assume it doesn't crash).  If this is just a confusion
> issue then I say go for it.  PPID == 0 is a very legitimate way to say
> the kernel is the parent process.

No, it doesn't crash. It just doesn't show kernel threads (ps ax is OK).
I didn't look into the sources, but I guess the reason is that pstree
assumes that the "root" of the tree is "pid == 1" process.

I personally think this is acceptable (and Roland seems to think the same).
Still, to be safe, I'll break this into 2 patches, the first one sets
->exit_state, the second re-parents to swapper.

In fact, we can do some odd things to make pstree happy. We need ->parent
only because /proc needs some ->parent fields. But I'd prefer to avoid
these hacks.

Still, it is sad that we can't have additional flags for kernel_thread().
However, I agree with your and Roland's objections.

Oleg.

