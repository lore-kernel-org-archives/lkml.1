Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbXDOXm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbXDOXm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 19:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbXDOXm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 19:42:56 -0400
Received: from relay.felk.cvut.cz ([147.32.80.7]:49422 "EHLO
	relay.felk.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbXDOXmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 19:42:55 -0400
X-Greylist: delayed 1914 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Apr 2007 19:42:54 EDT
From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Date: Mon, 16 Apr 2007 01:09:29 +0200
User-Agent: KMail/1.9.4
Cc: William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070413202100.GA9957@elte.hu> <20070413222151.GD8915@holomorphy.com> <Pine.LNX.4.64.0704140008001.10930@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0704140008001.10930@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704160109.31310.pisa@cmp.felk.cvut.cz>
X-FELK-MailScanner-Information: 
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-1.799, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_50 0.00)
X-FELK-MailScanner-From: pisa@cmp.felk.cvut.cz
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 April 2007 00:38, Davide Libenzi wrote:
> Haven't looked at the scheduler code yet, but for a similar problem I use
> a time ring. The ring has Ns (2 power is better) slots (where tasks are
> queued - in my case they were som sort of timers), and it has a current
> base index (Ib), a current base time (Tb) and a time granularity (Tg). It
> also has a bitmap with bits telling you which slots contains queued tasks.
> An item (task) that has to be scheduled at time T, will be queued in the
> slot:
>
> S = Ib + min((T - Tb) / Tg, Ns - 1);
>
> Items with T longer than Ns*Tg will be scheduled in the relative last slot
> (chosing a proper Ns and Tg can minimize this).
> Queueing is O(1) and de-queueing is O(Ns). You can play with Ns and Tg to
> suite to your needs.
> This is a simple bench between time-ring (TR) and CFS queueing:
>
> http://www.xmailserver.org/smart-queue.c
>
> In my box (Dual Opteron 252):
>
> davide@alien:~$ ./smart-queue -n 8
> CFS = 142.21 cycles/loop
> TR  = 72.33 cycles/loop
> davide@alien:~$ ./smart-queue -n 16
> CFS = 188.74 cycles/loop
> TR  = 83.79 cycles/loop
> davide@alien:~$ ./smart-queue -n 32
> CFS = 221.36 cycles/loop
> TR  = 75.93 cycles/loop
> davide@alien:~$ ./smart-queue -n 64
> CFS = 242.89 cycles/loop
> TR  = 81.29 cycles/loop

Hello all,

I cannot help myself to not report results with GAVL
tree algorithm there as an another race competitor.
I believe, that it is better solution for large priority
queues than RB-tree and even heap trees. It could be
disputable if the scheduler needs such scalability on
the other hand. The AVL heritage guarantees lower height
which results in shorter search times which could
be profitable for other uses in kernel.

GAVL algorithm is AVL tree based, so it does not suffer from
"infinite" priorities granularity there as TR does. It allows
use for generalized case where tree is not fully balanced.
This allows to cut the first item withour rebalancing.
This leads to the degradation of the tree by one more level
(than non degraded AVL gives) in maximum, which is still
considerably better than RB-trees maximum.

http://cmp.felk.cvut.cz/~pisa/linux/smart-queue-v-gavl.c

The description behind the code is there

http://cmp.felk.cvut.cz/~pisa/ulan/gavl.pdf

The code is part of much more covering uLUt library

http://cmp.felk.cvut.cz/~pisa/ulan/ulut.pdf
http://sourceforge.net/project/showfiles.php?group_id=118937&package_id=130840

I have included all required GAVL code directly into smart-queue-v-gavl.c
to provide it for easy testing.

There are tests run on my little dated computer - Duron 600 MHz.
Test are run twice to suppress run order influence.

./smart-queue-v-gavl -n 1 -l 2000000
gavl_cfs = 55.66 cycles/loop
CFS = 88.33 cycles/loop
TR  = 141.78 cycles/loop
CFS = 90.45 cycles/loop
gavl_cfs = 55.38 cycles/loop

./smart-queue-v-gavl -n 2 -l 2000000
gavl_cfs = 82.85 cycles/loop
CFS = 104.18 cycles/loop
TR  = 145.21 cycles/loop
CFS = 102.74 cycles/loop
gavl_cfs = 82.05 cycles/loop

./smart-queue-v-gavl -n 4 -l 2000000
gavl_cfs = 137.45 cycles/loop
CFS = 156.47 cycles/loop
TR  = 142.00 cycles/loop
CFS = 152.65 cycles/loop
gavl_cfs = 139.38 cycles/loop

./smart-queue-v-gavl -n 10 -l 2000000
gavl_cfs = 229.22 cycles/loop           (WORSE)
CFS = 206.26 cycles/loop
TR  = 140.81 cycles/loop
CFS = 208.29 cycles/loop
gavl_cfs = 223.62 cycles/loop           (WORSE)

./smart-queue-v-gavl -n 100 -l 2000000
gavl_cfs = 257.66 cycles/loop
CFS = 329.68 cycles/loop
TR  = 142.20 cycles/loop
CFS = 319.34 cycles/loop
gavl_cfs = 260.02 cycles/loop

./smart-queue-v-gavl -n 1000 -l 2000000
gavl_cfs = 258.41 cycles/loop
CFS = 393.04 cycles/loop
TR  = 134.76 cycles/loop
CFS = 392.20 cycles/loop
gavl_cfs = 260.93 cycles/loop

./smart-queue-v-gavl -n 10000 -l 2000000
gavl_cfs = 259.45 cycles/loop
CFS = 605.89 cycles/loop
TR  = 196.69 cycles/loop
CFS = 622.60 cycles/loop
gavl_cfs = 262.72 cycles/loop

./smart-queue-v-gavl -n 100000 -l 2000000
gavl_cfs = 258.21 cycles/loop
CFS = 845.62 cycles/loop
TR  = 315.37 cycles/loop
CFS = 860.21 cycles/loop
gavl_cfs = 258.94 cycles/loop

The GAVL code has not been tuned by any "likely"/"unlikely"
constructs. It brings even some other overhead from it generic
design which is not necessary for this use - it keeps
permanently even pointer to the last element, ensures,
that the insertion order is preserved for same key values
etc. But it still proves much better scalability then
kernel used RB-tree code. On the other hand, it does not
encode color/height in one of the pointers and requires
additional field for height.

May it be, that difference is due some bug in my testing,
then I would be interrested in correction. The test case
is oversimplified probably. I have already run more different
tests against GAVL code in the past to compare it with
different tree and queues implementations and I have not found
case with real performance degradation. On the other hand, there
are cases for small items counts where GAVL is sometimes
a little worse than others (array based heap-tree for example).

The GAVL code itself is used in more opensource and commercial
projects and we have noticed no problems after one small fix
at the time of the first release in 2004.

Best wishes

                Pavel Pisa
        e-mail: pisa@cmp.felk.cvut.cz
        www:    http://cmp.felk.cvut.cz/~pisa
        work:   http://www.pikron.com
