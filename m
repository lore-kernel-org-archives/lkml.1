Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbYFVWGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbYFVWGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 18:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbYFVWGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 18:06:41 -0400
Received: from bu3sch.de ([62.75.166.246]:51471 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271AbYFVWGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 18:06:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: Oops when using growisofs
Date: Mon, 23 Jun 2008 00:05:51 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>
References: <200806221818.24372.mb@bu3sch.de> <200806222322.05706.arnd@arndb.de>
In-Reply-To: <200806222322.05706.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806230005.51356.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 June 2008 23:22:04 Arnd Bergmann wrote:
> > [28375.893181] Faulting instruction address: 0xc00000000012df84
> > [28375.893186] Oops: Kernel access of bad area, sig: 11 [#1]
> > [28375.893189] PREEMPT SMP NR_CPUS=4 NUMA PowerMac
> 
> Ok, important information: ppc64 architecture. It would be nice to mention
> in the bug report, but here we can see it as well.

Yeah I'm sorry. I thought this was obvious. :)

> > [28375.893320] TASK = c00000011636db00[4667] 'kded' THREAD: c000000116ae8000 CPU: 2
> 
> task was kded, i.e. not growisofs itself, thouh growisofs is probably the one
> that has caused this problem (by exausting memory).

I don't think it exausted memory. oom-killer messages would have been in the logs.
And this machine has 2.5GiB memory. It continued to run fine after restarting kded.
I sent this bugreport on the machine that oopsed without a reboot.

Is it possible that this was a kernel race between kded and growisofs?
This is a 4-way SMP machine.

> > [28375.893327] GPR00: c00000000012df70 c000000116aeb580 c00000000090ff20 0000000000000000 
> > [28375.893340] GPR04: 0000000000010000 0000000000000001 c00000011bfe37a0 0000000000000010 
> > [28375.893352] GPR08: f00000000694d280 0000000000000000 c0000000008c0be0 0000000000000000 
> > [28375.893364] GPR12: 0000000028004842 c000000000941700 0000000000000004 c000000116aeb840 
> > [28375.893377] GPR16: c0000001195d8f78 c0000000008c0cb8 c0000000000bd064 0000000000000003 
> > [28375.893389] GPR20: 0000000000000000 c0000001195d8d68 0000000000000004 c0000001195d8f80 
> > [28375.893402] GPR24: c00000000082c700 0000000000010000 f00000000694d280 0000000000000000 
> > [28375.893415] GPR28: 0000000000000000 f00000000694d280 c00000000088e640 c000000116aeb580 
> 
> Note: r9 and r3 are both NULL pointers. r3 is the value returned from alloc_page_buffers.
> R9 is a copy of that, which gets accessed.

Hm, yeah. I looked at that code already, but I can't see how it could return
a NULL pointer.

> > [28375.893560] Instruction dump:
> > [28375.893566] f8010010 f821ff61 7cbb2b78 38a00001 7c7d1b78 7c3f0b78 4bfffe65 7c7c1b78 
> > [28375.893586] 7c691b78 4800000c 60000000 7d695b78 <e9690008> e8090000 2fab0000 7c00db78 
> > [28375.893607] ---[ end trace d2a7775e4472c36e ]---
> > 
> 
> 4800000c is the branch to alloc_page_buffers
> 7d695b78 copies the return value of that to r9
> e9690008 dereferences r9
> 
> Evidently, alloc_page_buffers got an out of memory condition, which was not caught
> by create_empty_buffers. No idea how it should be handled, but the fact that it's
> not looks like a bug to me ;-).

alloc_page_buffers should never return a NULL pointer here, as far as I can see.
It clearly is a bug. An oops always is a bug.


-- 
Greetings Michael.
