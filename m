Return-Path: <linux-kernel-owner+w=401wt.eu-S1759199AbYA1Klz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199AbYA1Klz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 05:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756720AbYA1Kkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 05:40:53 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:63741 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755630AbYA1Kkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 05:40:45 -0500
Message-Id: <20080128103953.326762000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 28 Jan 2008 11:39:53 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: rth@twiddle.net, rmk@arm.linux.org.uk, bryan.wu@analog.com,
       dhowells@redhat.com, gerg@uclinux.org, lethal@linux-sh.org,
       wli@holomorphy.com, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, torvalds@linux-foundation.org,
       a.p.zijlstra@chello.nl
Subject: [RFC][PATCH 0/2] hrtimer breakage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If you're in the To: field, I broke your arch with (post .24) commit:
  d3d74453c34f8fd87674a8cf5b8a327c68f22e99

So, to be clear, that broke:
  alpha, arm, blackfin, frv, m68knommu, sh, sh64 and sparc

The deadlock resulting was found by Russell:

  IRQ handle 
    -> timer_tick() - xtime seqlock held for write
      -> update_process_times() 
        -> run_local_timers()
          -> hrtimer_run_queues()
            -> hrtimer_get_softirq_time() - tries to get a read lock

Now, Thomas assures me the fix is trivial, only do_timer() needs to be
done under the xtime_lock, and update_process_times() can savely be removed
from under it.

So that is what the next two patches do, the first patch is by Russell and
covers most of the arm sub-arch, the second one does the other archs and a
few arm archs that were missed by rmk.

This patch should probably be folded into one, or at least the arm bits
from the second moved to the first patch, to avoid more bisect breakage.

If you're all ok I'll polish the patches (maybe one per arch?) and ask for
merger.

(for obvious reasons I'm unable to actually test any of this)

Peter

