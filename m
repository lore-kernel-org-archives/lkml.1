Return-Path: <linux-kernel-owner+w=401wt.eu-S1761862AbZJIXTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761862AbZJIXTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761664AbZJIXRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:17:31 -0400
Received: from kroah.org ([198.145.64.141]:36851 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761636AbZJIXR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:17:28 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:01 2009
Message-Id: <20091009231001.532024807@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:08:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eero Nurkkala <ext-eero.nurkkala@nokia.com>,
       Rik van Riel <riel@redhat.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Steven Noonan <steven@uplinklabs.net>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 11/26] NOHZ: update idle state also when NOHZ is inactive
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=nohz-update-idle-state-also-when-nohz-is-inactive.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eero Nurkkala <ext-eero.nurkkala@nokia.com>

commit fdc6f192e7e1ae80565af23cc33dc88e3dcdf184 upstream.

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
Cc: Steven Noonan <steven@uplinklabs.net>
LKML-Reference: <1254907901.30157.93.camel@eenurkka-desktop>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/tick-sched.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -231,6 +231,13 @@ void tick_nohz_stop_sched_tick(int inidl
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
@@ -248,8 +255,6 @@ void tick_nohz_stop_sched_tick(int inidl
 	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
 		goto end;
 
-	ts->inidle = 1;
-
 	if (need_resched())
 		goto end;
 


