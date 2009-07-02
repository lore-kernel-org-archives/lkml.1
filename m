Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbZGBRkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbZGBRkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbZGBRkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:40:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145AbZGBRkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:40:03 -0400
Date: Thu, 2 Jul 2009 10:39:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Catalin Marinas <catalin.marinas@arm.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       git-commits-head@vger.kernel.org
Subject: Re: Exiting with locks still held (was Re: [PATCH] kmemleak: Fix 
 scheduling-while-atomic bug)
In-Reply-To: <1246544024.13320.95.camel@pc1117.cambridge.arm.com>
Message-ID: <alpine.LFD.2.01.0907021031260.4830@localhost.localdomain>
References: <200907010300.n6130rRf026194@hera.kernel.org>  <20090701075332.GA17252@elte.hu>  <1246439937.8492.18.camel@pc1117.cambridge.arm.com>  <20090701093015.GA6862@elte.hu>  <1246441592.8492.38.camel@pc1117.cambridge.arm.com>  <20090701110438.GA15958@elte.hu>
  <1246538899.13320.86.camel@pc1117.cambridge.arm.com>  <84144f020907020554n1b098e28o8b4a4a58a08728e3@mail.gmail.com> <1246544024.13320.95.camel@pc1117.cambridge.arm.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 Jul 2009, Catalin Marinas wrote:
> 
> Initially, the scan_mutex was acquired in kmemleak_open() and released
> in kmemleak_release() (corresponding to /sys/kernel/debug/kmemleak
> operations). This was causing some lockdep reports when the file was
> closed from a different task than the one opening it. This patch moves
> the scan_mutex acquiring in kmemleak_write() or kmemleak_seq_show().

This is better, but not really how you are supposed to do it.

The whole seq-file thing is very much _designed_ for taking a lock at the 
beginning of the operation, and releasing it at the end. It's a very 
common pattern.

But you should _not_ do it in the "show" routine. If you do, you're always 
going to be racy wrt lseek() and friends.

What you _should_ do is to take the lock in the "seq_start" routine, and 
release it in "seq_stop". The "seq_show" routine may be called multiple 
times in between.

For a trivial example, see the drivers/char/misc.c file. Note how it needs 
to hold the lock over the whole list traversal, and how seqfiles allows it 
to do that quite naturally.

		Linus
