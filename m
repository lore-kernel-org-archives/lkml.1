Return-Path: <linux-kernel-owner+w=401wt.eu-S934556AbZIEAUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934556AbZIEAUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934499AbZIEAUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:20:30 -0400
Received: from kroah.org ([198.145.64.141]:42040 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934193AbZIEAU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:28 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:47 2009
Message-Id: <20090905001447.228488853@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:13:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Guillaume Knispel <gknispel@proformatique.com>,
       Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Subject: [patch 02/71] poll/select: initialize triggered field of struct poll_wqueues
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=poll-select-initialize-triggered-field-of-struct-poll_wqueues.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Guillaume Knispel <gknispel@proformatique.com>

commit b2add73dbf93fd50f00564d7abc3e2b9aa9dd20c upstream.

The triggered field of struct poll_wqueues introduced in commit
5f820f648c92a5ecc771a96b3c29aa6e90013bba ("poll: allow f_op->poll to
sleep").

It was first set to 1 in pollwake() (now __pollwake() ), tested and
later set to 0 in poll_schedule_timeout(), but not initialized before.

As a result when the process needs to sleep, triggered was likely to be
non-zero even if pollwake() is not called before the first
poll_schedule_timeout(), meaning schedule_hrtimeout_range() would not be
called and an extra loop calling all ->poll() would be done.

This patch initialize triggered to 0 in poll_initwait() so the ->poll()
are not called twice before the process goes to sleep when it needs to.

Signed-off-by: Guillaume Knispel <gknispel@proformatique.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/select.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/select.c
+++ b/fs/select.c
@@ -110,6 +110,7 @@ void poll_initwait(struct poll_wqueues *
 {
 	init_poll_funcptr(&pwq->pt, __pollwait);
 	pwq->polling_task = current;
+	pwq->triggered = 0;
 	pwq->error = 0;
 	pwq->table = NULL;
 	pwq->inline_index = 0;


