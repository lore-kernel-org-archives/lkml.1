Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbYH2HgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbYH2HgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 03:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbYH2HgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 03:36:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:43641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbYH2HgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 03:36:16 -0400
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 29 Aug 2008 17:36:08 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18615.42728.498883.440973@notabene.brown>
Cc: Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       jurriaan <thunder7@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc4: lots of 'in_atomic():1, irqs_disabled():0' with 
 software-raid1
In-Reply-To: message from Andrew Morton on Thursday August 28
References: <20080827170538.GA24393@amd64.of.nowhere>
	<200808272347.43577.rjw@sisk.pl>
	<20080828073324.GR20055@kernel.dk>
	<20080828004532.45d8b8c9.akpm@linux-foundation.org>
	<20080828074830.GV20055@kernel.dk>
	<18614.24929.952454.829021@notabene.brown>
	<20080828020018.a8ea85f0.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday August 28, akpm@linux-foundation.org wrote:
> 
> I'm curious about how this happened.
> 
> afaict from reading the code, this:
> 
> 	rcu_read_lock();
> 	might_sleep();
> 	rcu_read_unlock();
> 
> will warn if CONFIG_PREEMPT_RCU=n but won't warn if
> CONFIG_PREEMPT_RCU=y.  If correct, that's a nasty trap.
> 
> Is that what you did?

Uhm..
$ grep PREEMPT /home/src/md-x86-64/.config
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
$ grep DEBUG_SPIN /home/src/md-x86-64/.config
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
$ grep RCU /home/src/md-x86-64/.config
CONFIG_CLASSIC_RCU=y
# CONFIG_RCU_TORTURE_TEST is not set

This definitely doesn't report an error if I put "might_sleep" inside 
rcu_read_lock.  I tried to figure out why but got lost.

BTW, I need the following to get current -git to compile.

NeilBrown

Author: NeilBrown <neilb@suse.de>
Date:   Tue Aug 19 11:59:37 2008 +1000

    Fix compile error in security

diff --git a/include/linux/security.h b/include/linux/security.h
index 2ee5ecf..0cc23a1 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1757,7 +1757,7 @@ static inline int security_ptrace_may_access(struct task_struct *child,
 
 static inline int security_ptrace_traceme(struct task_struct *child)
 {
-	return cap_ptrace_traceme(parent);
+	return cap_ptrace_traceme(child);
 }
 
 static inline int security_capget(struct task_struct *target,


