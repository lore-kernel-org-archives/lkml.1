Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYFIQdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYFIQdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 12:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYFIQdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 12:33:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55979 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbYFIQda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 12:33:30 -0400
Date: Mon, 9 Jun 2008 18:32:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Jeff Garzik <jeff@garzik.org>, Dave Jones <davej@redhat.com>
Subject: Re: Top kernel oopses/warnings for the week of May 30th 2008
Message-ID: <20080609163254.GA17191@elte.hu>
References: <48402DAA.60202@linux.intel.com> <Pine.LNX.4.64.0805302017580.16427@blonde.site> <Pine.LNX.4.64.0806030000110.9919@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806030000110.9919@blonde.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hugh Dickins <hugh@veritas.com> wrote:

> Veering off at a tangent away from the oops: I was rather sobered to 
> see all those traces of execve using kmap, I thought we were avoiding 
> kmap like BKL in common paths these days (though it is convenient for 
> symlinks).  Would a patch something like that below, copying the 
> filemap.c trick, be welcome?

FYI, i stuck this into -tip for testing and after some time i started 
getting:

[    8.540917] Freeing unused kernel memory: 304k freed
[   12.368096] BUG: scheduling while atomic: ifup-eth/1820/0x10000001
[   12.374144] Modules linked in:
[   12.377175] Pid: 1820, comm: ifup-eth Not tainted 2.6.26-rc5-00029-ga252672-dirty #3490
[   12.384031]  [<c0131a39>] __schedule_bug+0x59/0x60
[   12.388031]  [<c06b1375>] schedule+0x465/0x8c0
[   12.392031]  [<c013eecf>] ? update_process_times+0x4f/0x60
[   12.396031]  [<c013b50f>] ? irq_exit+0x3f/0x70
[   12.400451]  [<c012164b>] ? smp_apic_timer_interrupt+0x5b/0x90
[   12.406248]  [<c0117038>] ? apic_timer_interrupt+0x28/0x30
[   12.411702]  [<c0131a58>] __cond_resched+0x18/0x30
[   12.416466]  [<c06b1838>] _cond_resched+0x28/0x30
[   12.421141]  [<c03720bb>] strnlen_user+0x2b/0x60
[   12.425728]  [<c018dd53>] copy_strings+0x63/0x210
[   12.430403]  [<c018f986>] do_execve+0x176/0x200
[   12.434903]  [<c0372007>] ? strncpy_from_user+0x37/0x60
[   12.440031]  [<c0114ade>] sys_execve+0x2e/0x60
[   12.444447]  [<c01165ae>] sysenter_past_esp+0x6a/0x90
[   12.449469]  =======================
[   12.736676] eth1: link down
[   12.736919] ADDRCONF(NETDEV_UP): eth1: link is not ready

it would occur about every 10 bootups with the same config. Bisection 
led me to your patch.

	Ingo
