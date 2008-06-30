Return-Path: <linux-kernel-owner+w=401wt.eu-S932644AbYF3Usz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644AbYF3Usz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 16:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbYF3Usr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 16:48:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:52210 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbYF3Usq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 16:48:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=R8gA2A3xxNGEP68GH1rDnmEVYiouAsR1bt+QWs+c6XnswiFQA1v5jnoCSlK5xBrA80
         bhBfrDGWLK1ZOR5nlKuOOVfbXMckWaj2rp38dvpfZ3l5zKNISmMwDVgm8POY9Rux7qSy
         0a1cPCg2wf97zwXIRwOOqA7ZSBJCoUn/OQKqM=
Date: Mon, 30 Jun 2008 23:48:37 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>, "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
       proski@gnu.org
Subject: mmiotrace broken in linux-next (8-bit writes only)
Message-ID: <20080630234837.118fff8c@daedalus.pq.iki.fi>
In-Reply-To: <20080630123736.GA4011@elte.hu>
References: <20080628214626.5f9199d7@daedalus.pq.iki.fi>
	<20080630123736.GA4011@elte.hu>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008 14:37:36 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> it would also be nice if you could check whether ftrace as integrated 
> into linux-next has a functional mmiotrace. (and work with me in -tip on 
> fixing it if it doesnt)

I tested it and it is broken in two ways. First is the NULL pointer
dereference, for which I made a quick patch (in the end of this email)
and I don't know what is going on in there. The patch allows me to run
my simple test. However, the test shows, that all 8-bit MMIO writes are
recorded with datum 0x80, which is incorrect. I've no idea what could
have changed. All the 16 and 32-bit ops are ok, and so are 8-bit reads,
which means the writes really do happen with the correct data, but just
mmiotrace gets it wrong. Mmiotrace source files are unchanged.

Has there been changes in compiler flags or iowrite8() that would cause
different instructions to be used in implementing the MMIO write?
I'm completely baffled.

I guess I should try to bisect, but I don't know when I can do that.
I tested on Athlon64, 64-bit UP kernel.

Vegard, have you experienced any weird issues in instruction decoding?
But I guess sort of bug would not affect you, since kmemcheck is not
interested in the data.

- pq


>From 79e6a8eaf73b778dc76eb3c55bb82b18817c34df Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Mon, 30 Jun 2008 22:02:25 +0300
Subject: [PATCH] ftrace: do not call ftrace_special() from down().

The moment mmiotrace is enabled, I hit a NULL deref in:

IP: [<ffffffff80256e71>] __trace_special+0x17c/0x23a
Call Trace:
 [<ffffffff802573cc>] ftrace_special+0x6f/0x9a
 [<ffffffff8023e3e4>] down+0x19/0x4a
 [<ffffffff80228adc>] acquire_console_sem+0x42/0x58
 [<ffffffff8035d273>] con_flush_chars+0x28/0x43
 [<ffffffff80354a70>] write_chan+0x22e/0x334
 [<ffffffff802244e9>] ? default_wake_function+0x0/0xf
 [<ffffffff8035236d>] tty_write+0x195/0x228
 [<ffffffff80354842>] ? write_chan+0x0/0x334
 [<ffffffff8027c23a>] vfs_write+0xae/0x137
 [<ffffffff8027c6e3>] sys_write+0x47/0x70
 [<ffffffff8020b1db>] system_call_after_swapgs+0x7b/0x80

which means 'entry' in __trace_special() is NULL.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 kernel/semaphore.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/semaphore.c b/kernel/semaphore.c
index bbab232..62f30c2 100644
--- a/kernel/semaphore.c
+++ b/kernel/semaphore.c
@@ -54,7 +54,6 @@ void down(struct semaphore *sem)
 {
 	unsigned long flags;
 
-	ftrace_special(sem->count, 0, __LINE__);
 	spin_lock_irqsave(&sem->lock, flags);
 	if (likely(sem->count > 0))
 		sem->count--;
-- 
1.5.4.5

