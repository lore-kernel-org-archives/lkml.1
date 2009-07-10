Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbZGJJgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbZGJJgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZGJJgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:36:04 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59969 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbZGJJgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:36:03 -0400
Date: Fri, 10 Jul 2009 11:36:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Alan.Brunelle@hp.com,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] Fix blktrace unaligned memory access
Message-ID: <20090710093601.GF23611@kernel.dk>
References: <20090710075339.GX23611@kernel.dk> <4A5704EA.5000807@cn.fujitsu.com> <20090710091337.GD23611@kernel.dk> <4A570A34.5090002@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A570A34.5090002@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10 2009, Li Zefan wrote:
> Jens Axboe wrote:
> > On Fri, Jul 10 2009, Li Zefan wrote:
> >> Jens Axboe wrote:
> >>> Hi,
> >>>
> >>> It seems that relay_reserve() (or the ring_buffer_event_data(), that one
> >>> still needs some love) can return unaligned memory, there's no way
> >>> around that when you have pdu lengths that aren't a nice size. This can
> >>> cause unaligned access warnings on platforms that care about alignment.
> >>>
> >> Seems relay_reserve() does nothing for alignment..On the other hand,
> >> ring_buffer_event_data() returns a ptr which is 32bit-aligned, but
> >> this still means it can cause unaligned accesses on 64bits arch, while
> >> I think it's fixable in ring buffer, it's certainly not an easy job.
> > 
> > Right, it's a bit nasty...
> > 
> 
> Lai Jiangshan noticed this issue long ago and had some ideas in mind
> how to fix ring buffer, but never try it out for it will probably be
> frustrating..
> 
> >>> This is an RFC, perhaps we can fix this in some other way. This one takes
> >>> the simple approach, use an on-stack copy and memcpy() that to the
> >>> destination.
> >>>
> >> or get_unaligned() ?
> > 
> > put_unaligned(), you mean? The big question is then which is faster, using
> > put_unaligned() or doing the memcpy() of the structure...
> > 
> 
> Ah, I meant put_unaligned().
> 
> I think the patch you posted can be a workaround at least for now, and
> can be improved by detecting HAVE_EFFICIENT_UNALIGNED_ACCESS

We either do one or the other, I don't want to clutter the code with
both methods implemented and some ifdef checking and deciding. I'll
check the unaligned put here on x86/ppc/sparc and then decide which one
is faster.

-- 
Jens Axboe

