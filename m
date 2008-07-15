Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbYGOWpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbYGOWpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbYGOWpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:45:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754830AbYGOWpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:45:05 -0400
Date: Tue, 15 Jul 2008 15:44:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coredump: kill mm->core_done
Message-Id: <20080715154407.4ffadcb7.akpm@linux-foundation.org>
In-Reply-To: <20080715162150.GA30927@tv-sign.ru>
References: <20080715140715.GA25824@tv-sign.ru>
	<20080715162150.GA30927@tv-sign.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008 20:21:50 +0400
Oleg Nesterov <oleg@tv-sign.ru> wrote:

> Now that we have core_state->dumper list we can use it to wake up the
> sub-threads waiting for the coredump completion.
> 
> This uglifies the code and .text grows by 47 bytes, but otoh mm_struct
> lessens by sizeof(struct completion). Also, with this change we can
> decouple exit_mm() from the coredumping code.

This conflicts with your
coredump-simplify-core_state-nr_threads-calculation.patch

fs/exec.c:

***************
*** 1597,1603 ****
  	struct completion *vfork_done;
  	int core_waiters;
  
- 	init_completion(&mm->core_done);
  	init_completion(&core_state->startup);
  	core_state->dumper.task = tsk;
  	core_state->dumper.next = NULL;
--- 1597,1602 ----
  	struct completion *vfork_done;
  	int core_waiters;
  
  	init_completion(&core_state->startup);
  	core_state->dumper.task = tsk;
  	core_state->dumper.next = NULL;
***************
*** 1812,1819 ****
  		argv_free(helper_argv);
  
  	current->fsuid = fsuid;
- 	complete_all(&mm->core_done);
- 	mm->core_state = NULL;
  fail:
  	return retval;
  }
--- 1832,1838 ----
  		argv_free(helper_argv);
  
  	current->fsuid = fsuid;
+ 	coredump_finish(mm);
  fail:
  	return retval;
  }

The second hunk is a bit worrisome.  The

	mm->core_state = NULL;

isn't there any more.


I have a bad feelnig that I have a coredump patch which should have
been dropped.  Can you please check everything?

Current queue:

#
# coredump
#
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
coredump-elf_core_dump-skip-kernel-threads.patch
#
coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state.patch
coredump-move-mm-core_waiters-into-struct-core_state.patch
coredump-simplify-core_state-nr_threads-calculation.patch
coredump-turn-core_state-nr_threads-into-atomic_t.patch
coredump-kill-mm-core_done.patch


All at http://userweb.kernel.org/~akpm/mmotm/

