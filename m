Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYDGGsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYDGGsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 02:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYDGGsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 02:48:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975AbYDGGsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 02:48:42 -0400
Date: Sun, 6 Apr 2008 23:48:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm1 - BUG: scheduling while atomic:
 swapper/0/0xffffffff
Message-Id: <20080406234814.a40025fb.akpm@linux-foundation.org>
In-Reply-To: <4487.1207549282@turing-police.cc.vt.edu>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
	<4487.1207549282@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Apr 2008 02:21:22 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Tue, 01 Apr 2008 21:32:14 PDT, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm1/
> 
> Been seeing these crop up once in a while - can take hours after a reboot
> before I see the first one, but once I see one, I'm likely to see more, at
> a frequency of anywhere from ~5seconds to ~10 minutes between BUG msgs.
> 
> BUG: scheduling while atomic: swapper/0/0xffffffff
> Pid: 0, comm: swapper Tainted: P          2.6.25-rc8-mm1 #4
> 
> Call Trace:
>  [<ffffffff8020b2f4>] ? default_idle+0x0/0x74
>  [<ffffffff8022be19>] __schedule_bug+0x5d/0x61
>  [<ffffffff80552aea>] schedule+0x11a/0x9e4
>  [<ffffffff805536ce>] ? preempt_schedule+0x3c/0xaa
>  [<ffffffff802480f1>] ? hrtimer_forward+0x82/0x96
>  [<ffffffff804600a4>] ? cpuidle_idle_call+0x0/0xd5
>  [<ffffffff8020b2f4>] ? default_idle+0x0/0x74
>  [<ffffffff8020b2e0>] cpu_idle+0xf6/0x10a
>  [<ffffffff80540cb2>] rest_init+0x86/0x8a
> 
> Eventually, I end up with a basically hung system, and need to alt-sysrq-B.
> 
> Yes, I know it's tainted, and it's possible the root cause is a self-inflicted
> buggy module - but the traceback above seems odd.  Did some of my code manage
> to idle the CPU while is_atomic was set, or is the path from cpu_idle on down
> doing something it shouldn't be?

I'd say that there's an unlock missing somewhere.

> (I admit being confused - if my code was the source of the is_atomic error,
> shouldn't it have been caught on the *previous* call to schedule - the one
> that ran through all the queues and decided we should invoke idle?

Sounds sane.  Perhaps preempt_count is getting mucked up in interrupt
context?

iirc there's some toy in either the recently-added tracing code or still in
the -rt tree which would help find a missed unlock, but I forget what it was.
Ingo will know...


