Return-Path: <linux-kernel-owner+w=401wt.eu-S1760512AbYGOARX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760512AbYGOARX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 20:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932250AbYGOARH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 20:17:07 -0400
Received: from mga07.intel.com ([143.182.124.22]:3924 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932477AbYGOARG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 20:17:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,361,1212390000"; 
   d="scan'208";a="20445826"
Date: Mon, 14 Jul 2008 17:17:05 -0700
From: mark gross <mgross@linux.intel.com>
To: "Jakub W. Jozwicki" <jozwicki@aster.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@timesys.com
Subject: Re: [PATCH 2.6.25.10] pm_qos_params: change spinlock to rwlock
Message-ID: <20080715001705.GB7079@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <200807130119.19663.jozwicki@aster.pl> <20080713012816.8c136efa.akpm@linux-foundation.org> <200807131505.25990.jozwicki@aster.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200807131505.25990.jozwicki@aster.pl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 15 Jul 2008 00:17:05.0045 (UTC) FILETIME=[1C673450:01C8E610]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2008 at 03:05:25PM +0200, Jakub W. Jozwicki wrote:
> Sunday, 13 of July 2008 10:28:16 Andrew Morton napisał(a):
> > On Sun, 13 Jul 2008 01:19:19 +0200 "Jakub W. Jozwicki" <jozwicki@aster.pl> 
> wrote:
> > > Concurrent calls to pm_qos_requirement shouldn't block each other. This
> > > patch changes spinlock to rwlock and fixes issues with PREEMPT_RT.
> >
> > "fixes issues" is nowhere near an adequate description.
> >
> > Please provide complete descriptions for kernel patches.  That includes
> > describing the mysterious "issue" in full!
> >
> > Thanks.
> 
> [  114.647010] BUG: sleeping function called from invalid context swapper(0) 
> at kernel/rtmutex.c:742
> [  114.647010] in_atomic():1 [00000001], irqs_disabled():0
> [  114.647010] Pid: 0, comm: swapper Not tainted 2.6.25.10-rtXXX #10
> [  114.647010]  [<c0120fc4>] __might_sleep+0xf1/0xf8
> [  114.647010]  [<c045499c>] __rt_spin_lock+0x24/0x61
> [  114.647010]  [<c04549e1>] rt_spin_lock+0x8/0xa
> [  114.647010]  [<c013ec8d>] pm_qos_requirement+0x10/0x29
> [  114.647010]  [<c038ef36>] menu_select+0x5d/0x7f
> [  114.647010]  [<c038e4d8>] cpuidle_idle_call+0x47/0x9b
> [  114.647010]  [<c038e491>] ? cpuidle_idle_call+0x0/0x9b
> [  114.647010]  [<c01060ff>] cpu_idle+0xaf/0x106
> [  114.647010]  [<c0441c87>] rest_init+0x67/0x69
> [  114.647010]  =======================
> [  115.649517] BUG: sleeping function called from invalid context swapper(0) 
> at kernel/rtmutex.c:742
> [  115.649517] in_atomic():1 [00000001], irqs_disabled():0
> [  115.649517] Pid: 0, comm: swapper Not tainted 2.6.25.10-rtXXX #10
> [  115.649517]  [<c0120fc4>] __might_sleep+0xf1/0xf8
> [  115.649517]  [<c045499c>] __rt_spin_lock+0x24/0x61
> [  115.649517]  [<c04549e1>] rt_spin_lock+0x8/0xa
> [  115.649517]  [<c013ec8d>] pm_qos_requirement+0x10/0x29
> [  115.649517]  [<c038ef36>] menu_select+0x5d/0x7f
> [  115.649517]  [<c038e4d8>] cpuidle_idle_call+0x47/0x9b
> [  115.649517]  [<c038e491>] ? cpuidle_idle_call+0x0/0x9b
> [  115.649517]  [<c01060ff>] cpu_idle+0xaf/0x106
> [  115.649517]  [<c0441c87>] rest_init+0x67/0x69
> [  115.649517]  =======================
> [  116.650040] BUG: sleeping function called from invalid context swapper(0) 
> at kernel/rtmutex.c:742
> [  116.650040] in_atomic():1 [00000001], irqs_disabled():0
> [  116.650040] Pid: 0, comm: swapper Not tainted 2.6.25.10-rtXXX #10
> [  116.650040]  [<c0120fc4>] __might_sleep+0xf1/0xf8
> [  116.650040]  [<c045499c>] __rt_spin_lock+0x24/0x61
> [  116.650040]  [<c04549e1>] rt_spin_lock+0x8/0xa
> [  116.650040]  [<c013ec8d>] pm_qos_requirement+0x10/0x29
> [  116.650040]  [<c038ef36>] menu_select+0x5d/0x7f
> [  116.650040]  [<c038e4d8>] cpuidle_idle_call+0x47/0x9b
> [  116.650040]  [<c038e491>] ? cpuidle_idle_call+0x0/0x9b
> [  116.650040]  [<c01060ff>] cpu_idle+0xaf/0x106
> [  116.650040]  [<c0441c87>] rest_init+0x67/0x69
> [  116.650040]  =======================

Ah, this a PREEMPT_RT only issue.  Let me study up on rwlocks a bit and
get back to you on this.

--mgross

