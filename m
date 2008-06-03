Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbYFCVRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbYFCVRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 17:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbYFCVQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 17:16:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752671AbYFCVQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 17:16:58 -0400
Date: Tue, 3 Jun 2008 14:15:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: ebiederm@xmission.com, mingo@elte.hu, torvalds@linux-foundation.org,
       roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] coredump: zap_threads() must skip kernel threads
Message-Id: <20080603141548.15d60a32.akpm@linux-foundation.org>
In-Reply-To: <20080601153045.GA8244@tv-sign.ru>
References: <20080601153045.GA8244@tv-sign.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jun 2008 19:30:45 +0400
Oleg Nesterov <oleg@tv-sign.ru> wrote:

> The main loop in zap_threads() must skip kthreads which may use the same mm.
> Otherwise we "kill" this thread erroneously (for example, it can not fork or
> exec after that), and the coredumping task stucks in the TASK_UNINTERRUPTIBLE
> state forever because of the wrong ->core_waiters count.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> 
> --- 26-rc2/fs/exec.c~3_CD_FIX_RACE_USE_MM	2008-05-31 20:05:21.000000000 +0400
> +++ 26-rc2/fs/exec.c	2008-06-01 19:04:39.000000000 +0400
> @@ -1568,11 +1568,13 @@ static inline int zap_threads(struct tas
>  	for_each_process(g) {
>  		if (g == tsk->group_leader)
>  			continue;
> +		if (g->flags & PF_KTHREAD)
> +			continue;
>  
>  		p = g;
>  		do {
>  			if (p->mm) {
> -				if (p->mm == mm) {
> +				if (unlikely(p->mm == mm)) {
>  					lock_task_sighand(p, &flags);
>  					zap_process(p);
>  					unlock_task_sighand(p, &flags);

This is a bugfix, yes?

How does it get triggered?

Do you think the bug is sufficiently serious to fix it in 2.6.26?  In
2.6.25.x?  If so, it would be better if this patch were not dependent
upon the preceding ones, which do not appear to be 2.6.26 or -stable
material.

