Return-Path: <linux-kernel-owner+w=401wt.eu-S1751399AbZHORko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbZHORko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 13:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbZHORko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 13:40:44 -0400
Received: from gon.proformatique.com ([91.194.178.5]:58475 "EHLO
	mx1.corp.proformatique.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806AbZHORkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 13:40:43 -0400
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Aug 2009 13:40:42 EDT
Date: Sat, 15 Aug 2009 19:30:24 +0200
From: Guillaume Knispel <gknispel@proformatique.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Miklos Szeredi <mszeredi@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org
Subject: [PATCH] poll/select: initialize triggered field of struct
 poll_wqueues
Message-ID: <20090815193024.121926e6@xilun.lan.proformatique.com>
Organization: Proformatique
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

That's only the second time I read fs/select.c so this has to be
reviewed carefully.
It has been quickly tested on my Debian Lenny x86_32 box and everything
seems to works fine on the surface.

Cheers,
Guillaume Knispel



poll/select: initialize triggered field of struct poll_wqueues

The triggered field of struct poll_wqueues introduced in commit
5f820f648c92a5ecc771a96b3c29aa6e90013bba "poll: allow f_op->poll to
sleep" was set to 1 in pollwake() (now __pollwake() ), tested and
later set to 0 in poll_schedule_timeout(), but not initialized before.
As a result when the process needs to sleep, triggered was likely to be
non-zero even if pollwake() is not called before the first
poll_schedule_timeout(), meaning schedule_hrtimeout_range() would not
be called and an extra loop calling all ->poll() would be done.

This patch initialize triggered to 0 in poll_initwait() so the ->poll()
are not called twice before the process goes to sleep when it needs to.

Signed-off-by: Guillaume Knispel <gknispel@proformatique.com>
---
 fs/select.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index d870237..8084834 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -110,6 +110,7 @@ void poll_initwait(struct poll_wqueues *pwq)
 {
        init_poll_funcptr(&pwq->pt, __pollwait);
        pwq->polling_task = current;
+       pwq->triggered = 0;
        pwq->error = 0;
        pwq->table = NULL;
        pwq->inline_index = 0;
