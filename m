Return-Path: <linux-kernel-owner+w=401wt.eu-S1760543AbXIXQ0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760543AbXIXQ0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760376AbXIXQY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:24:57 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47189 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760349AbXIXQYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:24:55 -0400
Date: Mon, 24 Sep 2007 09:20:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, qrczak@knm.org.pl, oleg@tv-sign.ru,
       roland@redhat.com
Subject: [05/50] setpgid(child) fails if the child was forked by sub-thread
Message-ID: <20070924162001.GF13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="setpgid-fails-if-the-child-was-forked-by-sub-thread.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Oleg Nesterov <oleg@tv-sign.ru>

commit b07e35f94a7b6a059f889b904529ee907dc0634d in mainline tree

Spotted by Marcin Kowalczyk <qrczak@knm.org.pl>.

sys_setpgid(child) fails if the child was forked by sub-thread.

Fix the "is it our child" check. The previous commit
ee0acf90d320c29916ba8c5c1b2e908d81f5057d was not complete.

(this patch asks for the new same_thread_group() helper, but mainline doesn't
 have it yet).

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Tested-by: "Marcin 'Qrczak' Kowalczyk" <qrczak@knm.org.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 kernel/sys.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1428,7 +1428,6 @@ asmlinkage long sys_times(struct tms __u
  * Auch. Had to add the 'did_exec' flag to conform completely to POSIX.
  * LBT 04.03.94
  */
-
 asmlinkage long sys_setpgid(pid_t pid, pid_t pgid)
 {
 	struct task_struct *p;
@@ -1456,7 +1455,7 @@ asmlinkage long sys_setpgid(pid_t pid, p
 	if (!thread_group_leader(p))
 		goto out;
 
-	if (p->real_parent == group_leader) {
+	if (p->real_parent->tgid == group_leader->tgid) {
 		err = -EPERM;
 		if (task_session(p) != task_session(group_leader))
 			goto out;

-- 
