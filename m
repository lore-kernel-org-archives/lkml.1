Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbYKLAcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbYKLAcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:32:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbYKLA0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:21 -0500
Received: from kroah.org ([198.145.64.141]:42239 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753446AbYKLA0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:19 -0500
Date: Tue, 11 Nov 2008 16:23:27 -0800
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
       alan@lxorguk.ukuu.org.uk, David Woodhouse <David.Woodhouse@intel.com>
Subject: [patch 16/49] JFFS2: Fix lack of locking in thread_should_wake()
Message-ID: <20081112002327.GQ10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="jffs2-fix-lack-of-locking-in-thread_should_wake.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Woodhouse <David.Woodhouse@intel.com>

commit b27cf88e9592953ae292d05324887f2f44979433 upstream

The thread_should_wake() function trawls through the list of 'very
dirty' eraseblocks, determining whether the background GC thread should
wake. Doing this without holding the appropriate locks is a bad idea.

OLPC Trac #8615

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jffs2/background.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/jffs2/background.c
+++ b/fs/jffs2/background.c
@@ -85,15 +85,15 @@ static int jffs2_garbage_collect_thread(
 	for (;;) {
 		allow_signal(SIGHUP);
 	again:
+		spin_lock(&c->erase_completion_lock);
 		if (!jffs2_thread_should_wake(c)) {
 			set_current_state (TASK_INTERRUPTIBLE);
+			spin_unlock(&c->erase_completion_lock);
 			D1(printk(KERN_DEBUG "jffs2_garbage_collect_thread sleeping...\n"));
-			/* Yes, there's a race here; we checked jffs2_thread_should_wake()
-			   before setting current->state to TASK_INTERRUPTIBLE. But it doesn't
-			   matter - We don't care if we miss a wakeup, because the GC thread
-			   is only an optimisation anyway. */
 			schedule();
-		}
+		} else
+			spin_unlock(&c->erase_completion_lock);
+
 
 		/* This thread is purely an optimisation. But if it runs when
 		   other things could be running, it actually makes things a

-- 
