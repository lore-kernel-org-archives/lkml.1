Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbZBIPNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbZBIPNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 10:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbZBIPNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 10:13:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:59323 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbZBIPNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 10:13:09 -0500
Subject: Re: mm_alloc()'ed structure leak
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1234190649.16083.44.camel@pc1117.cambridge.arm.com>
References: <1234181898.16083.26.camel@pc1117.cambridge.arm.com>
	 <1234190649.16083.44.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 16:12:43 +0100
Message-Id: <1234192363.5951.129.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 14:44 +0000, Catalin Marinas wrote:
> On Mon, 2009-02-09 at 12:18 +0000, Catalin Marinas wrote:
> > Basically bash forks and executes a command like "host kernel.org" which
> > finishes normally but the corresponding mm_struct isn't freed (I get
> > this consistently every time I run the above command):
> > 
> > unreferenced object 0xcfed4070 (size 368):
> >   comm "bash", pid 1674, jiffies 421592
> >   backtrace:
> >     [<c0082bd4>] kmemleak_alloc+0x140/0x2b0
> >     [<c007ff2c>] kmem_cache_alloc+0xd0/0x100
> >     [<c0036980>] mm_alloc+0x14/0x44
> >     [<c008a99c>] bprm_mm_init+0xc/0x13c
> >     [<c008ab70>] do_execve+0xa4/0x218
> >     [<c002718c>] sys_execve+0x34/0x54
> >     [<c0023e80>] ret_fast_syscall+0x0/0x28
> 
> Dumping the object in question:
> 
> mm_struct.mm_users = 0
> mm_struct.mm_count = 1
> 
> It looks like the mm_count didn't get to 0 hence no structure freeing
> via mmdrop().
> 
> The leak disappears if I revert commit 38d47c1b7075 - "futex: rely on
> get_user_pages() for shared futexes". Peter, any idea?

Looks like the futex key references go wrong somewhere, I'll go look at
it.



