Return-Path: <linux-kernel-owner+w=401wt.eu-S933417AbYBGA1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417AbYBGA1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932640AbYBFX7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:59:52 -0500
Received: from ns2.suse.de ([195.135.220.15]:33102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932626AbYBFX7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:59:50 -0500
Date: Wed, 6 Feb 2008 15:54:15 -0800
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
       alan@lxorguk.ukuu.org.uk, nigel@nigel.suspend2.net, nigel@tuxonice.net
Subject: [patch 63/73] Fix unbalanced helper_lock in kernel/kmod.c
Message-ID: <20080206235415.GL13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-unbalanced-helper_lock-in-kernel-kmod.c.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Nigel Cunningham <nigel@nigel.suspend2.net>

patch 784680336b616dcc4c17cbd25add3b49c555cdeb in mainline.

call_usermodehelper_exec() has an exit path that can leave the
helper_lock() call at the top of the routine unbalanced.  The attached
patch fixes this issue.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/kmod.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -451,13 +451,11 @@ int call_usermodehelper_exec(struct subp
 			     enum umh_wait wait)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
-	int retval;
+	int retval = 0;
 
 	helper_lock();
-	if (sub_info->path[0] == '\0') {
-		retval = 0;
+	if (sub_info->path[0] == '\0')
 		goto out;
-	}
 
 	if (!khelper_wq || usermodehelper_disabled) {
 		retval = -EBUSY;
@@ -468,13 +466,14 @@ int call_usermodehelper_exec(struct subp
 	sub_info->wait = wait;
 
 	queue_work(khelper_wq, &sub_info->work);
-	if (wait == UMH_NO_WAIT) /* task has freed sub_info */
-		return 0;
+	if (wait == UMH_NO_WAIT)	/* task has freed sub_info */
+		goto unlock;
 	wait_for_completion(&done);
 	retval = sub_info->retval;
 
-  out:
+out:
 	call_usermodehelper_freeinfo(sub_info);
+unlock:
 	helper_unlock();
 	return retval;
 }

-- 
