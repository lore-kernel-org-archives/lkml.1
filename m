Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128Ab0A1Jc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab0A1Jc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 04:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755661Ab0A1Jc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 04:32:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:47797 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab0A1Jc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 04:32:28 -0500
Subject: Re: [BUG] perf_event: circular lock dependency
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <bd4cb8901001280119j20a5404ds16079b5238b5271e@mail.gmail.com>
References: <bd4cb8901001280119j20a5404ds16079b5238b5271e@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jan 2010 10:32:23 +0100
Message-ID: <1264671143.4283.2085.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-28 at 10:19 +0100, Stephane Eranian wrote:

> On Intel Core, one of my test programs generate this kind of
> warning when it unmaps the sampling buffer after it has closed
> the events fds.

> [ 1729.441066] the existing dependency chain (in reverse order) is:
> [ 1729.441092]
> [ 1729.441093] -> #1 (&mm->mmap_sem){++++++}:
> [ 1729.441123]        [<ffffffff81077f97>] validate_chain+0xc17/0x1360
> [ 1729.441151]        [<ffffffff81078a53>] __lock_acquire+0x373/0xb30
> [ 1729.441170]        [<ffffffff810792ac>] lock_acquire+0x9c/0x100
> [ 1729.441189]        [<ffffffff810e74a4>] might_fault+0x84/0xb0
> [ 1729.441207]        [<ffffffff810c3605>] perf_read+0x135/0x2d0
> [ 1729.441225]        [<ffffffff8110c604>] vfs_read+0xc4/0x180
> [ 1729.441245]        [<ffffffff8110ca10>] sys_read+0x50/0x90
> [ 1729.441263]        [<ffffffff81002ceb>] system_call_fastpath+0x16/0x1b
> [ 1729.441284]
> [ 1729.441284] -> #0 (&ctx->mutex){+.+...}:
> [ 1729.441313]        [<ffffffff810786cd>] validate_chain+0x134d/0x1360
> [ 1729.441332]        [<ffffffff81078a53>] __lock_acquire+0x373/0xb30
> [ 1729.441351]        [<ffffffff810792ac>] lock_acquire+0x9c/0x100
> [ 1729.441369]        [<ffffffff81442e59>] mutex_lock_nested+0x69/0x340
> [ 1729.441389]        [<ffffffff810c2ebd>] perf_event_release_kernel+0x2d/0xe0
> [ 1729.441409]        [<ffffffff810c2f8b>] perf_release+0x1b/0x20
> [ 1729.441426]        [<ffffffff8110d051>] __fput+0x101/0x230
> [ 1729.441444]        [<ffffffff8110d457>] fput+0x17/0x20
> [ 1729.441462]        [<ffffffff810e98d1>] remove_vma+0x51/0x90
> [ 1729.441480]        [<ffffffff810ea708>] do_munmap+0x2e8/0x340
> [ 1729.441498]        [<ffffffff810ebac0>] sys_munmap+0x50/0x80
> [ 1729.441516]        [<ffffffff81002ceb>] system_call_fastpath+0x16/0x1b
> [ 1729.441535]

Crap, the thing is right.. you've been using group reads, which require
holding the ctx->mutex to ensure the group doesn't change while you're
reading it, leading to this inversion thing...

Not sure where to break this loop though, the hacky way is pushing all
of perf_event_release_kernel() into a work, but that's yucky.. Let me
ponder this a bit more.

