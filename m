Return-Path: <linux-kernel-owner+w=401wt.eu-S1751468AbXDHQ6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbXDHQ6Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 12:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbXDHQ6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 12:58:16 -0400
Received: from mail.screens.ru ([213.234.233.54]:43508 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbXDHQ6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 12:58:15 -0400
X-Greylist: delayed 3857 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Apr 2007 12:58:15 EDT
Date: Sun, 8 Apr 2007 20:57:50 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFC, PATCH 1/3] introduce SYS_CLONE_MASK
Message-ID: <20070408165750.GA149@tv-sign.ru>
References: <20070408155337.GA126@tv-sign.ru> <m1lkh23kkb.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1lkh23kkb.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08, Eric W. Biederman wrote:
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
> > For review only.
> >
> > To implement for-in-kerenl-use-only CLONE_ flags, we need to filter out them
> > in sys_clone().
> 
> Nack
> 
> The current clone_flags field is for user space consumption and we
> have proposed users for all or almost all of the remaining bits.

OK.

> If we are going to have kernel only flags please use an additional
> argument to do_fork and copy_process.

Yes, we can do this. But we have a number of architectures which use
sys_clone() to implement kernel_thread(). It would be nice to have an
architecture neutral kernel_thread() implementation as you proposed.
We should change all of them if we want to add a new parameter to
do_fork().

Perhaps it is better to add reparent_kthread() (next patch) to kthread()
and forget about CLONE_KERNEL_THREAD.

Anyway, re-parenting to swapper breaks pstree, it doesn't show kernel
threads. And if ->parent == /sbin/init, we can't remove us from ->children
(unless we forbid sub-thread-of-init exec). So the only safe change is
set ->exit_state = -1.

> Your current scheme also has the bad side that if user space supplied
> a kernel flag it is hard to detect it and return -EINVAL.  Which
> limits future expansion.  Silently dropping clone flags is a real
> pain, if you are trying to detect if a new flag has been implemented.

Yes. But that is what we are doing now. copy_process() just ignores
unknown flags.

Oleg.

