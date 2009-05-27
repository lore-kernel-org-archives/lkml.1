Return-Path: <linux-kernel-owner+w=401wt.eu-S1761762AbZE0UYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761762AbZE0UYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbZE0UX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:23:56 -0400
Received: from mta.netezza.com ([12.148.248.132]:62720 "EHLO netezza.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755891AbZE0UX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:23:56 -0400
Subject: Re: [2.6.27.24] Kernel coredump to a pipe is failing
From: Paul Smith <paul@mad-scientist.net>
Reply-To: paul@mad-scientist.net
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
In-Reply-To: <20090527200419.GA1655@redhat.com>
References: <1243355634.29250.331.camel@psmith-ubeta.netezza.com>
	 <878wkjobbm.fsf@basil.nowhere.org> <20090527183109.GA30574@redhat.com>
	 <20090527200419.GA1655@redhat.com>
Content-Type: text/plain
Organization: GNU's Not Unix!
Date: Wed, 27 May 2009 16:22:49 -0400
Message-Id: <1243455769.29250.459.camel@psmith-ubeta.netezza.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2009 20:22:50.0151 (UTC) FILETIME=[E7FB5370:01C9DF08]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 22:04 +0200, Oleg Nesterov wrote:
> Forgot to mention, and we have problems with OOM. Not only the coredumping
> task can't be killed (and it can populate the memory via get_user_pages).
> The coredump just disables OOM, if select_bad_process() sees the PF_EXITING
> task with ->mm == NULL it returns -1.
> 
> > This all needs more discussion, but imho for now something like
> > Paul's patch http://marc.info/?l=linux-kernel&m=124340506200729
> > is the best workaround. Note that we have the same dump_write()
> > in binfmt_elf.c and binfmt_aout.c, perhaps it makes sense to
> > create coredump_file_write() helper in fs/exec.c.
> 
> But I didn't notice Paul also reports the kernel panic:
> 
> 	page:ffffe20010d63d00 flags:0x8000000000000001 mapping:0000000000000000 mapcount:0 \
> 	count:0 Trying to fix it up, but a reboot is needed
> 	Backtrace:
> 	Pid: 3346, comm: worker Tainted: P          2.6.27.24-worker #4
> 
> 	Call Trace:
> 	 [<ffffffff80284fd4>] bad_page+0x74/0xc0
> 	 [<ffffffff80286168>] free_hot_cold_page+0x248/0x2f0
> 	 [<ffffffff802f4096>] free_wr_note_data+0x56/0x70
> 	 [<ffffffff802a95c6>] kfree+0x86/0x100
> 	 [<ffffffff802f4096>] free_wr_note_data+0x56/0x70
> 	 [<ffffffff802f0991>] elf_core_dump+0x611/0x1160
> 
> At first glance, this looks like a bug outside of coredump.c,
> we are trying to free PG_locked page?

This might be something different, or a side-effect that's not
understood; I haven't seen this happen again since I applied my change,
and I used to be able to make it happen every time within 2 or 3
invocations of my "failing" core dump procedure.  Now I have dumped core
using my "failing" procedure 10-15 times in a row with no ill-effects.

I'll keep an eye out for this one though.

