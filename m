Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbYK1T0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbYK1T0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 14:26:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbYK1T0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 14:26:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34022 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbYK1T0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 14:26:35 -0500
Date: Fri, 28 Nov 2008 20:25:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <ak@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Vitaly Mayatskikh <vmayatsk@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: BUG? "Call fasync() functions without the BKL" is racy
Message-ID: <20081128192508.GA21369@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Let's suppose we have the tasks T1, T2, T3 which share the same file,
all do sys_fcntl(file, F_SETFL) in parallel. file->f_flags == 0.

setfl(arg) does:

	if ((arg ^ filp->f_flags) & FASYNC)
// --- WINDOW_1 ---
		filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0)
// --- WINDOW_2 ---
	filp->f_flags = arg;

T1 calls setfl(FASYNC), preempted in WINDOW_1.

T2 calls setfl(FASYNC), does all job and returns.

T3 calls setfl(0), sees ->f_flags & FASYNC, does ->fasync(on => 0),
preempted in WINDOW_2.

T1 resumes, does ->fasync(on => 1) again, update ->f_flags (it
already has FASYNC) and returns.

T3 resumes, and clears FASYNC from ->f_flags.



Now, this file was added into some "struct fasync_struct", but
->f_flags doesn't have FASYNC. This means __fput() will skip
->fasync(on => 0) and the next kill_fasync() can crash because
fa_file points to the freed/reused memory.

I think a238b790d5f99c7832f9b73ac8847025815b85f7 should be reverted.
Or do you see the better fix?

Unless I missed something of course.

Oleg.

