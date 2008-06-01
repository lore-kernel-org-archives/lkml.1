Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbYFAUXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbYFAUXr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 16:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYFAUXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 16:23:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53875 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbYFAUXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 16:23:10 -0400
Subject: Re: [PATCH] coredump: binfmt_elf{,_fdpic}.c: don't abuse GFP_ATOMIC
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080601165506.GA8880@tv-sign.ru>
References: <20080601165506.GA8880@tv-sign.ru>
Content-Type: text/plain
Date: Sun, 01 Jun 2008 22:21:18 +0200
Message-Id: <1212351678.6269.0.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-01 at 20:55 +0400, Oleg Nesterov wrote:
> kmalloc(GFP_ATOMIC) was needed because it was called under tasklist_lock.
> The code was changed to use rcu_read_lock(), we can use GFP_KERNEL.

Classic RCU - still frequently used - disables preemption and thus does
not allow us to use __GFP_WAIT.

> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> 
>  binfmt_elf.c       |    4 ++--
>  binfmt_elf_fdpic.c |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> --- 26-rc2/fs/binfmt_elf.c~NO_ATOMIC	2008-05-18 15:43:59.000000000 +0400
> +++ 26-rc2/fs/binfmt_elf.c	2008-06-01 20:47:08.000000000 +0400
> @@ -1524,7 +1524,7 @@ static int fill_note_info(struct elfhdr 
>  		if (p->mm == dump_task->mm) {
>  			t = kzalloc(offsetof(struct elf_thread_core_info,
>  					     notes[info->thread_notes]),
> -				    GFP_ATOMIC);
> +				    GFP_KERNEL);
>  			if (unlikely(!t)) {
>  				rcu_read_unlock();
>  				return 0;
> @@ -1726,7 +1726,7 @@ static int fill_note_info(struct elfhdr 
>  		rcu_read_lock();
>  		do_each_thread(g, p)
>  			if (current->mm == p->mm && current != p) {
> -				ets = kzalloc(sizeof(*ets), GFP_ATOMIC);
> +				ets = kzalloc(sizeof(*ets), GFP_KERNEL);
>  				if (!ets) {
>  					rcu_read_unlock();
>  					return 0;
> --- 26-rc2/fs/binfmt_elf_fdpic.c~NO_ATOMIC	2008-05-18 15:43:59.000000000 +0400
> +++ 26-rc2/fs/binfmt_elf_fdpic.c	2008-06-01 20:47:20.000000000 +0400
> @@ -1626,7 +1626,7 @@ static int elf_fdpic_core_dump(long sign
>  		rcu_read_lock();
>  		do_each_thread(g,p)
>  			if (current->mm == p->mm && current != p) {
> -				tmp = kzalloc(sizeof(*tmp), GFP_ATOMIC);
> +				tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
>  				if (!tmp) {
>  					rcu_read_unlock();
>  					goto cleanup;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

