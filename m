Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab0BSRAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:00:13 -0500
Received: from kroah.org ([198.145.64.141]:57316 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113Ab0BSRAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:03 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:30 2010
Message-Id: <20100219163230.079244504@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:28:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikael Pettersson <mikpe@it.uu.se>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [02/93] futex_lock_pi() key refcnt fix
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikael Pettersson <mikpe@it.uu.se>

commit 5ecb01cfdf96c5f465192bdb2a4fd4a61a24c6cc upstream.

This fixes a futex key reference count bug in futex_lock_pi(),
where a key's reference count is incremented twice but decremented
only once, causing the backing object to not be released.

If the futex is created in a temporary file in an ext3 file system,
this bug causes the file's inode to become an "undead" orphan,
which causes an oops from a BUG_ON() in ext3_put_super() when the
file system is unmounted. glibc's test suite is known to trigger this,
see <http://bugzilla.kernel.org/show_bug.cgi?id=14256>.

The bug is a regression from 2.6.28-git3, namely Peter Zijlstra's
38d47c1b7075bd7ec3881141bb3629da58f88dab "[PATCH] futex: rely on
get_user_pages() for shared futexes". That commit made get_futex_key()
also increment the reference count of the futex key, and updated its
callers to decrement the key's reference count before returning.
Unfortunately the normal exit path in futex_lock_pi() wasn't corrected:
the reference count is incremented by get_futex_key() and queue_lock(),
but the normal exit path only decrements once, via unqueue_me_pi().
The fix is to put_futex_key() after unqueue_me_pi(), since 2.6.31
this is easily done by 'goto out_put_key' rather than 'goto out'.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Darren Hart <dvhltc@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/futex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1971,7 +1971,7 @@ retry_private:
 	/* Unqueue and drop the lock */
 	unqueue_me_pi(&q);
 
-	goto out;
+	goto out_put_key;
 
 out_unlock_put_key:
 	queue_unlock(&q, hb);


