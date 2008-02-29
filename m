Return-Path: <linux-kernel-owner+w=401wt.eu-S1764939AbYB2BOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764939AbYB2BOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757817AbYB2BNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 20:13:54 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1222 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1765078AbYB2BNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 20:13:51 -0500
Subject: Re: [PATCH] linux/fs.h - Convert debug functions declared inline 
	__attribute__((format (printf,x,y) to statement expression macros
From: Joe Perches <joe@perches.com>
To: Jan Hubicka <hubicka@ucw.cz>
Cc: Jakub Jelinek <jakub@redhat.com>, David Rientjes <rientjes@google.com>,
       Matthew Wilcox <matthew@wil.cx>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, gcc@gcc.gnu.org,
       zadeck@naturalbridge.com
In-Reply-To: <20080228102325.GC13246@atrey.karlin.mff.cuni.cz>
References: <1204081722.19319.405.camel@localhost>
	 <1204084947.19319.411.camel@localhost>
	 <20080227041316.GA23188@parisc-linux.org>
	 <alpine.DEB.1.00.0802262140160.23764@chino.kir.corp.google.com>
	 <1204095249.19319.444.camel@localhost>
	 <alpine.DEB.1.00.0802271454430.3836@chino.kir.corp.google.com>
	 <20080227235835.GA31048@atrey.karlin.mff.cuni.cz>
	 <20080228084237.GU24887@devserv.devel.redhat.com>
	 <20080228102325.GC13246@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 17:09:07 -0800
Message-Id: <1204247347.9959.31.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-28 at 11:23 +0100, Jan Hubicka wrote:
> The call ought to be always
> early inlined and not seen by any optimization pass.

The inlined functions don't actually appear in the generated code.

Look at the code generation differences for kernel/sched.c
function place_entity

$ size sched.inline.o sched.if0.o
   text    data     bss     dec     hex filename
  31385    2854     328   34567    8707 sched.inline.o
  31366    2854     328   34548    86f4 sched.if0.o

The current preprocessed only kernel/sched.i file contains:

# 612 "include/linux/device.h"
static inline __attribute__((always_inline)) int __attribute__ ((format (printf, 2, 3)))
dev_dbg(struct device *dev, const char *fmt, ...)
{
 return 0;
}
# 628 "include/linux/device.h"
static inline __attribute__((always_inline)) int __attribute__ ((format (printf, 2, 3)))
dev_vdbg(struct device *dev, const char *fmt, ...)
{
 return 0;
}

But the function place_entity doesn't use it directly or indirectly.
If the lines above are removed, the generated code for place_entity changes.

static void
place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
{
	u64 vruntime;

	vruntime = cfs_rq->min_vruntime;

	if (sched_feat(TREE_AVG)) {
		struct sched_entity *last = __pick_last_entity(cfs_rq);
		if (last) {
			vruntime += last->vruntime;
			vruntime >>= 1;
		}
	} else if (sched_feat(APPROX_AVG) && cfs_rq->nr_running)
		vruntime += sched_vslice(cfs_rq)/2;

	/*
	 * The 'current' period is already promised to the current tasks,
	 * however the extra weight of the new task will slow them down a
	 * little, place the new task so that it fits in the slot that
	 * stays open at the end.
	 */
	if (initial && sched_feat(START_DEBIT))
		vruntime += sched_vslice_add(cfs_rq, se);

	if (!initial) {
		/* sleeps upto a single latency don't count. */
		if (sched_feat(NEW_FAIR_SLEEPERS))
			vruntime -= sysctl_sched_latency;

		/* ensure we never gain time by being placed backwards. */
		vruntime = max_vruntime(se->vruntime, vruntime);
	}

	se->vruntime = vruntime;
}


