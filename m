Return-Path: <linux-kernel-owner+w=401wt.eu-S936699AbYBWAmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936699AbYBWAmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764936AbYBWAey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:34:54 -0500
Received: from mail.suse.de ([195.135.220.2]:44823 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934936AbYBWAew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:34:52 -0500
Date: Fri, 22 Feb 2008 16:30:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 19/38] INET_DIAG: Fix inet_diag_lock_handler error path.
Message-ID: <20080223003042.GT7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="inet_diag-fix-inet_diag_lock_handler-error-path.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
Upstream commit: 8cf8e5a67fb07f583aac94482ba51a7930dab493

Fixes: http://bugzilla.kernel.org/show_bug.cgi?id=9825

The inet_diag_lock_handler function uses ERR_PTR to encode errors but
its callers were testing against NULL.

This only happens when the only inet_diag modular user, DCCP, is not
built into the kernel or available as a module.

Also there was a problem with not dropping the mutex lock when a handler
was not found, also fixed in this patch.

This caused an OOPS and ss would then hang on subsequent calls, as
&inet_diag_table_mutex was being left locked.

Thanks to spike at ml.yaroslavl.ru for report it after trying 'ss -d'
on a kernel that doesn't have DCCP available.

This bug was introduced in cset
d523a328fb0271e1a763e985a21f2488fd816e7e ("Fix inet_diag dead-lock
regression"), after 2.6.24-rc3, so just 2.6.24 seems to be affected.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/inet_diag.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -259,8 +259,10 @@ static int inet_diag_get_exact(struct sk
 	const struct inet_diag_handler *handler;
 
 	handler = inet_diag_lock_handler(nlh->nlmsg_type);
-	if (!handler)
-		return -ENOENT;
+	if (IS_ERR(handler)) {
+		err = PTR_ERR(handler);
+		goto unlock;
+	}
 
 	hashinfo = handler->idiag_hashinfo;
 	err = -EINVAL;
@@ -708,8 +710,8 @@ static int inet_diag_dump(struct sk_buff
 	struct inet_hashinfo *hashinfo;
 
 	handler = inet_diag_lock_handler(cb->nlh->nlmsg_type);
-	if (!handler)
-		goto no_handler;
+	if (IS_ERR(handler))
+		goto unlock;
 
 	hashinfo = handler->idiag_hashinfo;
 
@@ -838,7 +840,6 @@ done:
 	cb->args[2] = num;
 unlock:
 	inet_diag_unlock_handler(handler);
-no_handler:
 	return skb->len;
 }
 

-- 
