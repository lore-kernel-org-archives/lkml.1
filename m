Return-Path: <linux-kernel-owner+w=401wt.eu-S940810AbXGaEhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940810AbXGaEhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968163AbXGaEcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:32:01 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34596 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968158AbXGaEcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:32:00 -0400
Date: Mon, 30 Jul 2007 21:33:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, torvalds@osdl.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, akpm@osdl.org,
       drepper@redhat.com, mingo@elte.hu, Thomas Gleixner <tglx@linutronix.de>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 16/26] FUTEX: Restore the dropped ERSCH fix
Message-ID: <20070731043304.GQ3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="futex-restore-the-dropped-ersch-fix.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

The return value of futex_find_get_task() needs to be -ESRCH in case
that the search fails. This was part of the original futex fixes and 
got accidentally dropped, when the futex-tidy-up patch was split out.

Results in a NULL pointer dereference in case the search fails.

Restore it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/futex.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- linux-2.6.21.6.orig/kernel/futex.c
+++ linux-2.6.21.6/kernel/futex.c
@@ -390,14 +390,12 @@ static struct task_struct * futex_find_g
 
 	rcu_read_lock();
 	p = find_task_by_pid(pid);
-	if (!p)
-		goto out_unlock;
-	if ((current->euid != p->euid) && (current->euid != p->uid)) {
-		p = NULL;
-		goto out_unlock;
-	}
-	get_task_struct(p);
-out_unlock:
+
+	if (!p || ((current->euid != p->euid) && (current->euid != p->uid)))
+		p = ERR_PTR(-ESRCH);
+	else
+		get_task_struct(p);
+
 	rcu_read_unlock();
 
 	return p;

-- 
