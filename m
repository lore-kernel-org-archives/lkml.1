Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbZBDQZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbZBDQZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 11:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbZBDQZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 11:25:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942AbZBDQZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 11:25:24 -0500
Date: Wed, 4 Feb 2009 08:24:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Norbert Preining <preining@logic.at>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.29-rc3-git6: Reported regressions from 2.6.28
In-Reply-To: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
Message-ID: <alpine.LFD.2.00.0902040759420.3247@localhost.localdomain>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Feb 2009, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12599
> Subject		: dri /dev node disappeared with 2.6.29-rc1
> Submitter	: Norbert Preining <preining@logic.at>
> Date		: 2009-01-15 13:42 (21 days old)
> References	: http://marc.info/?l=linux-kernel&m=123202701026647&w=4

I think this one is simply that Intel DRI now requires CONFIG_FB.

So make sure that you say yes to the CONFIG_FB question (easiest fix: just 
edit the .config file and change the line "# CONFIG_FB is not set" to 
"CONFIG_FB=y" and do "make oldconfig" - I realize that people think that 
graphical config front-ends are simpler, but often just editing the file 
is the quickest way).

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12591
> Subject		: NULL pointer dereference in blk_queue_io_stat
> Submitter	: Petr Vandrovec <vandrove@vc.cvut.cz>
> Date		: 2009-01-31 23:58 (5 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=bc58ba9468d94d62c56ab9b47173583ec140b165
> Handled-By	: Jens Axboe <jens.axboe@oracle.com>

I think this one is fixed by commit fb8ec18c316d8.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12511
> Subject		: WARNING: at drivers/dma/dmaengine.c:352
> Submitter	: Ingo Molnar <mingo@elte.hu>
> Date		: 2009-01-19 21:31 (17 days old)
> References	: http://marc.info/?l=linux-kernel&m=123240070614443&w=4
> Handled-By	: Dan Williams <dan.j.williams@intel.com>

This warning just got removed as bogus.

Commit 83436a0560e9ef8af2f0796264dde4bed1415359

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12506
> Subject		: Undefined symbols when CONFIG_MFD_PCF50633 is enabled
> Submitter	: Ozan Çağlayan <ozan@pardus.org.tr>
> Date		: 2009-01-17 10:56 (19 days old)
> References	: http://marc.info/?l=linux-kernel&m=123218991104592&w=4

Commit 9e6f8ed7c3a303d37eb119847dd3029701e37e28

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12505
> Subject		: 2.6.29-rc1 Firefox crashing on page load
> Submitter	: Justin Madru <jdm64@gawab.com>
> Date		: 2009-01-16 20:56 (20 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4217458dafaa57d8e26a46f5d05ab8c53cf64191
> References	: http://marc.info/?l=linux-kernel&m=123213941914274&w=4
> Handled-By	: Justin P. Mattock <justinmattock@gmail.com>

Heh. That commit you point to is very innocuous.

Commit 4217458dafaa57d8e26a46f5d05ab8c53cf64191 is a pure cleanup, and it 
_does_ make the code look nicer, but while it looks lik a total no-op, it 
actually has a very subtle behavioural change: it makes gcc think that it 
owns the whole argument stack. Which is _not_ true of 'asmlinkage' 
functions, but we've never been able to tell gcc to keep its grubby hands 
off our stack.

So I suspect that gcc inlines the function and then creates a function 
call that re-uses the "struct pt_regs" on the stack as the argument area 
too. Which corrupts the "pt_regs", and then we return to user space with 
some random register contents.

So I think we need to just revert it. Ingo, Hiroshi?

				Linus
