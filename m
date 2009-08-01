Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbZHAGzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbZHAGzF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 02:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbZHAGzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 02:55:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46839 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbZHAGzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 02:55:04 -0400
Date: Sat, 1 Aug 2009 08:44:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, drepper@redhat.com, jens@mcbone.net,
       mingo@elte.hu, peterz@infradead.org, sonnyrao@us.ibm.com,
       stable@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH v2] execve: must clear current->clear_child_tid
Message-ID: <20090801064438.GA30800@redhat.com>
References: <200907312142.n6VLgKfx021454@imap1.linux-foundation.org> <20090731222959.GA8195@redhat.com> <alpine.LFD.2.01.0907311732250.3304@localhost.localdomain> <20090731175101.1699d653.akpm@linux-foundation.org> <20090801015434.GA755@redhat.com> <4A73DCBE.7080309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A73DCBE.7080309@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01, Eric Dumazet wrote:
>
> I only wonder about core dumping, since mm_release() is also used by exiting tasks.
>
> Isnt clear_child_tid used by gdb or other debugger ?

Afaics it is not...

At least, I can't see how gdb (or any other user-space app) can figure
out the value of ->clear_child_tid.



Not that this really matters, but please note also that it is possible
that the coredumping task has ->clear_child_tid == NULL anyway, even
without this change. The PF_SIGNALED check in mm_release() is not 100&
reliable.

Suppose a thread T sleeps in do_exit()->ptrace_event(PT_TRACE_EXIT) path.
Another thread starts a coredump and kills T via zap_process(). This wakes
up T, it calls exit_mm()->mm_release() without PF_SIGNALED.

Oleg.

