Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbZJGLIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbZJGLIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 07:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbZJGLIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 07:08:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:37507 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbZJGLIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 07:08:10 -0400
Date: Wed, 7 Oct 2009 11:06:45 GMT
From: tip-bot for Eero Nurkkala <ext-eero.nurkkala@nokia.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       greg@kroah.com, venkatesh.pallipadi@intel.com, riel@redhat.com,
       steven@uplinklabs.net, ext-eero.nurkkala@nokia.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, greg@kroah.com, riel@redhat.com,
       steven@uplinklabs.net, ext-eero.nurkkala@nokia.com, tglx@linutronix.de
In-Reply-To: <1254907901.30157.93.camel@eenurkka-desktop>
References: <1254907901.30157.93.camel@eenurkka-desktop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] NOHZ: update idle state also when NOHZ is inactive
Message-ID: <tip-fdc6f192e7e1ae80565af23cc33dc88e3dcdf184@git.kernel.org>
Git-Commit-ID: fdc6f192e7e1ae80565af23cc33dc88e3dcdf184
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 07 Oct 2009 11:06:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fdc6f192e7e1ae80565af23cc33dc88e3dcdf184
Gitweb:     http://git.kernel.org/tip/fdc6f192e7e1ae80565af23cc33dc88e3dcdf184
Author:     Eero Nurkkala <ext-eero.nurkkala@nokia.com>
AuthorDate: Wed, 7 Oct 2009 11:54:26 +0300
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 7 Oct 2009 13:05:05 +0200

NOHZ: update idle state also when NOHZ is inactive

Commit f2e21c9610991e95621a81407cdbab881226419b had unfortunate side
effects with cpufreq governors on some systems.

If the system did not switch into NOHZ mode ts->inidle is not set when
tick_nohz_stop_sched_tick() is called from the idle routine. Therefor
all subsequent calls from irq_exit() to tick_nohz_stop_sched_tick()
fail to call tick_nohz_start_idle(). This results in bogus idle
accounting information which is passed to cpufreq governors.

Set the inidle flag unconditionally of the NOHZ active state to keep
the idle time accounting correct in any case.

[ tglx: Added comment and tweaked the changelog ]

Reported-by: Steven Noonan <steven@uplinklabs.net>
Signed-off-by: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Steven Noonan <steven@uplinklabs.net>
Cc: stable@kernel.org
LKML-Reference: <1254907901.30157.93.camel@eenurkka-desktop>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-sched.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e0f59a2..89aed59 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -231,6 +231,13 @@ void tick_nohz_stop_sched_tick(int inidle)
 	if (!inidle && !ts->inidle)
 		goto end;
 
+	/*
+	 * Set ts->inidle unconditionally. Even if the system did not
+	 * switch to NOHZ mode the cpu frequency governers rely on the
+	 * update of the idle time accounting in tick_nohz_start_idle().
+	 */
+	ts->inidle = 1;
+
 	now = tick_nohz_start_idle(ts);
 
 	/*
@@ -248,8 +255,6 @@ void tick_nohz_stop_sched_tick(int inidle)
 	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
 		goto end;
 
-	ts->inidle = 1;
-
 	if (need_resched())
 		goto end;
 
