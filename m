Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab0BSRBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:01:24 -0500
Received: from kroah.org ([198.145.64.141]:57719 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920Ab0BSRA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:57 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:48 2010
Message-Id: <20100219163248.168615413@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [64/93] dst: call cond_resched() in dst_gc_task()
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit 2fc1b5dd99f66d93ffc23fd8df82d384c1a354c8 upstream.

Kernel bugzilla #15239

On some workloads, it is quite possible to get a huge dst list to
process in dst_gc_task(), and trigger soft lockup detection.

Fix is to call cond_resched(), as we run in process context.

Reported-by: Pawel Staszewski <pstaszewski@itcare.pl>
Tested-by: Pawel Staszewski <pstaszewski@itcare.pl>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/dst.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -17,6 +17,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <net/net_namespace.h>
+#include <linux/sched.h>
 
 #include <net/dst.h>
 
@@ -79,6 +80,7 @@ loop:
 	while ((dst = next) != NULL) {
 		next = dst->next;
 		prefetch(&next->next);
+		cond_resched();
 		if (likely(atomic_read(&dst->__refcnt))) {
 			last->next = dst;
 			last = dst;


