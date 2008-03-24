Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbYCXMja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbYCXMja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 08:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYCXMjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 08:39:21 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:64370 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752090AbYCXMjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 08:39:20 -0400
Message-Id: <20080324122424.671168000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 24 Mar 2008 13:24:24 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/2] printk vs rq->lock and xtime lock
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

As to the regression reported by Marcin; what happens is that we invoke
printk() while holding the xtime lock for writing. printk() will call
wake_up_klogd() which tries to enqueue klogd on some rq.

The known deadlock here is calling printk() while holding rq->lock, which
would then try to recusively lock the rq again when trying to wake klogd.

The new deadlock is due to task enqueues setting an hrtimer, which requires
reading the time, which will result in a live-lock when the printk() call-
site is holding the xtime lock for writing.

Thomas would like to preserve the printk() information if possible, hence my
proposal of printk_nowakeup(). It will do everything printk() normally does,
except ommit to wake up of klogd. The call is explicitly not EXPORTed so that
its use is confined to core kernel code.

Marcin, could you please test these two patches to confirm they do indeed
solve your issue as well?

Peter



