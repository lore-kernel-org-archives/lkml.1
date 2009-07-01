Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbZGASoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbZGASoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZGASoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:44:08 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:20188 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbZGASoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:44:07 -0400
X-IronPort-AV: E=Sophos;i="4.42,327,1243814400"; 
   d="scan'208";a="182229022"
From: Roland Dreier <rdreier@cisco.com>
To: Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: i915 (GM45) stuck task
X-Message-Flag: Warning: May contain useful information
Date: Wed, 01 Jul 2009 11:44:03 -0700
Message-ID: <adaeit0fdl8.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Jul 2009 18:44:09.0709 (UTC) FILETIME=[EB94D1D0:01C9FA7B]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I'm running 2.6.31-rc1+git (up-to-date as of today) on a Lenovo X200
laptop (GM45 graphics), using Ubuntu 9.10 userspace.  I just got an X
hang with the system basically sitting idle with a compiz desktop.  The
kernel prints a "stuck task" message (see below for full message) but it
seems that i915_gem_retire_work_handler() is stuck trying to get the
struct_mutex -- not sure how to tell who else is holding the mutex (I
have lockdep enabled but nothing helpful came from that).

The version of xserver-xorg-video-intel installed is
2:2.7.99.1+git20090602.ec2fde7c-0ubuntu4 (the newest available from the
main Ubuntu repository at least).  But of course in an ideal world the
userspace driver shouldn't be able to do anything to get eventd
deadlocked anyway...

Anway, suggestions for how to debug this furthre would be much
appreciated!

Thanks,
  Roland

[ 6121.144148] INFO: task events/0:9 blocked for more than 120 seconds.
[ 6121.144158] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6121.144165] events/0      D 000000010015564a     0     9      2 0x00000000
[ 6121.144178]  ffff880076803ce0 0000000000000046 0000000000000000 0000000000015840
[ 6121.144194]  ffff8800773fc3b0 0000000000015840 0000000000015840 0000000000015840
[ 6121.144207]  0000000000015840 ffff8800773fc3b0 0000000000015840 0000000000015840
[ 6121.144222] Call Trace:
[ 6121.144240]  [<ffffffff810e664f>] ? T.683+0xff/0x160
[ 6121.144253]  [<ffffffff815527f7>] __mutex_lock_common+0x177/0x3d0
[ 6121.144300]  [<ffffffffa0060b6f>] ? i915_gem_retire_work_handler+0x3f/0x90 [i915]
[ 6121.144328]  [<ffffffffa0060b6f>] ? i915_gem_retire_work_handler+0x3f/0x90 [i915]
[ 6121.144338]  [<ffffffff81552b56>] mutex_lock_nested+0x46/0x60
[ 6121.144365]  [<ffffffffa0060b6f>] i915_gem_retire_work_handler+0x3f/0x90 [i915]
[ 6121.144392]  [<ffffffffa0060b30>] ? i915_gem_retire_work_handler+0x0/0x90 [i915]
[ 6121.144404]  [<ffffffff81071cb8>] run_workqueue+0xf8/0x240
[ 6121.144412]  [<ffffffff81071c66>] ? run_workqueue+0xa6/0x240
[ 6121.144426]  [<ffffffff81071eb4>] worker_thread+0xb4/0x130
[ 6121.144436]  [<ffffffff810777a0>] ? autoremove_wake_function+0x0/0x40
[ 6121.144446]  [<ffffffff81071e00>] ? worker_thread+0x0/0x130
[ 6121.144455]  [<ffffffff810773be>] kthread+0x9e/0xb0
[ 6121.144466]  [<ffffffff8101430a>] child_rip+0xa/0x20
[ 6121.144477]  [<ffffffff81013c90>] ? restore_args+0x0/0x30
[ 6121.144487]  [<ffffffff81077320>] ? kthread+0x0/0xb0
[ 6121.144495]  [<ffffffff81014300>] ? child_rip+0x0/0x20

