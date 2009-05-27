Return-Path: <linux-kernel-owner+w=401wt.eu-S1759448AbZE0UJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448AbZE0UJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbZE0UJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:09:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41244 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbZE0UJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:09:00 -0400
Date: Wed, 27 May 2009 22:04:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: paul@mad-scientist.net, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [2.6.27.24] Kernel coredump to a pipe is failing
Message-ID: <20090527200419.GA1655@redhat.com>
References: <1243355634.29250.331.camel@psmith-ubeta.netezza.com> <878wkjobbm.fsf@basil.nowhere.org> <20090527183109.GA30574@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527183109.GA30574@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27, Oleg Nesterov wrote:
>
> On 05/26, Andi Kleen wrote:
> >
> > When a signal happens during core dump the core dump to a pipe
> > can fail, because the write returns short, but the ELF core dumpers
> > cannot handle that.
> >
> > There's no reason to handle signals during core dumping, so just
> > block them all.
>
> Actually, I think there is a strong reason to handle signals during
> core dumping. The coredump can take a lot of time/resources, not good
> it looks like unkillable procees to users.
>
> Please look at
>
> 	killable/interruptible coredumps
> 	http://marc.info/?l=linux-kernel&m=121665710711931
>
> at least, I think SIGKILL should terminate core dumping.

Forgot to mention, and we have problems with OOM. Not only the coredumping
task can't be killed (and it can populate the memory via get_user_pages).
The coredump just disables OOM, if select_bad_process() sees the PF_EXITING
task with ->mm == NULL it returns -1.

> This all needs more discussion, but imho for now something like
> Paul's patch http://marc.info/?l=linux-kernel&m=124340506200729
> is the best workaround. Note that we have the same dump_write()
> in binfmt_elf.c and binfmt_aout.c, perhaps it makes sense to
> create coredump_file_write() helper in fs/exec.c.


But I didn't notice Paul also reports the kernel panic:

	page:ffffe20010d63d00 flags:0x8000000000000001 mapping:0000000000000000 mapcount:0 \
	count:0 Trying to fix it up, but a reboot is needed
	Backtrace:
	Pid: 3346, comm: worker Tainted: P          2.6.27.24-worker #4

	Call Trace:
	 [<ffffffff80284fd4>] bad_page+0x74/0xc0
	 [<ffffffff80286168>] free_hot_cold_page+0x248/0x2f0
	 [<ffffffff802f4096>] free_wr_note_data+0x56/0x70
	 [<ffffffff802a95c6>] kfree+0x86/0x100
	 [<ffffffff802f4096>] free_wr_note_data+0x56/0x70
	 [<ffffffff802f0991>] elf_core_dump+0x611/0x1160

At first glance, this looks like a bug outside of coredump.c,
we are trying to free PG_locked page?

Oleg.

