Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbZENWz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbZENWz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756916AbZENWmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:42:50 -0400
Received: from kroah.org ([198.145.64.141]:52573 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405AbZENWmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:42:31 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:27 2009
Message-Id: <20090514223526.941816251@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:33:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [patch 40/51] lockd: fix list corruption on lockd restart
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=lockd-fix-list-corruption-on-lockd-restart.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: J. Bruce Fields <bfields@citi.umich.edu>

commit 89996df4b5b1a09c279f50b3fd03aa9df735f5cb upstream.

If lockd is signalled soon enough after restart then locks_start_grace()
will try to re-add an entry to a list and trigger a lock corruption
warning.

Thanks to Wang Chen for the problem report and diagnosis.

WARNING: at lib/list_debug.c:26 __list_add+0x27/0x5c()
...
list_add corruption. next->prev should be prev (ef8fe958), but was ef8ff128.  (next=ef8ff128).
...
Pid: 23062, comm: lockd Tainted: G        W  2.6.30-rc2 #3
Call Trace:
[<c042d5b5>] warn_slowpath+0x71/0xa0
[<c0422a96>] ? update_curr+0x11d/0x125
[<c044b12d>] ? trace_hardirqs_on_caller+0x18/0x150
[<c044b270>] ? trace_hardirqs_on+0xb/0xd
[<c051c61a>] ? _raw_spin_lock+0x53/0xfa
[<c051c89f>] __list_add+0x27/0x5c
[<ef8f6daa>] locks_start_grace+0x22/0x30 [lockd]
[<ef8f34da>] set_grace_period+0x39/0x53 [lockd]
[<c06b8921>] ? lock_kernel+0x1c/0x28
[<ef8f3558>] lockd+0x64/0x164 [lockd]
[<c044b12d>] ? trace_hardirqs_on_caller+0x18/0x150
[<c04227b0>] ? complete+0x34/0x3e
[<ef8f34f4>] ? lockd+0x0/0x164 [lockd]
[<ef8f34f4>] ? lockd+0x0/0x164 [lockd]
[<c043dd42>] kthread+0x45/0x6b
[<c043dcfd>] ? kthread+0x0/0x6b
[<c0403c23>] kernel_thread_helper+0x7/0x10

Reported-by: Wang Chen <wangchen@cn.fujitsu.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/lockd/svc.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -115,6 +115,16 @@ static void set_grace_period(void)
 	schedule_delayed_work(&grace_period_end, grace_period);
 }
 
+static void restart_grace(void)
+{
+	if (nlmsvc_ops) {
+		cancel_delayed_work_sync(&grace_period_end);
+		locks_end_grace(&lockd_manager);
+		nlmsvc_invalidate_all();
+		set_grace_period();
+	}
+}
+
 /*
  * This is the lockd kernel thread
  */
@@ -160,10 +170,7 @@ lockd(void *vrqstp)
 
 		if (signalled()) {
 			flush_signals(current);
-			if (nlmsvc_ops) {
-				nlmsvc_invalidate_all();
-				set_grace_period();
-			}
+			restart_grace();
 			continue;
 		}
 


