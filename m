Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbZCHSz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbZCHSz6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 14:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbZCHSzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 14:55:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:33680 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbZCHSzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 14:55:31 -0400
Date: Sun, 8 Mar 2009 18:54:57 GMT
From: Stuart Bennett <stuart@freedesktop.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, pq@iki.fi,
       stuart@freedesktop.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       pq@iki.fi, stuart@freedesktop.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090308202135.34933feb@daedalus.pq.iki.fi>
References: <20090308202135.34933feb@daedalus.pq.iki.fi>
Subject: [tip:x86/urgent] x86 mmiotrace: fix remove_kmmio_fault_pages()
Message-ID: <tip-d0fc63f7bd07cb779a06dc1cdd0c5a14e7f5d562@git.kernel.org>
Git-Commit-ID: d0fc63f7bd07cb779a06dc1cdd0c5a14e7f5d562
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 08 Mar 2009 18:55:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d0fc63f7bd07cb779a06dc1cdd0c5a14e7f5d562
Gitweb:     http://git.kernel.org/tip/d0fc63f7bd07cb779a06dc1cdd0c5a14e7f5d562
Author:     "Stuart Bennett" <stuart@freedesktop.org>
AuthorDate: Sun, 8 Mar 2009 20:21:35 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Mar 2009 19:51:23 +0100

x86 mmiotrace: fix remove_kmmio_fault_pages()

Impact: fix race+crash in mmiotrace

The list manipulation in remove_kmmio_fault_pages() was broken. If more
than one consecutive kmmio_fault_page was re-added during the grace
period between unregister_kmmio_probe() and remove_kmmio_fault_pages(),
the list manipulation failed to remove pages from the release list.

After a second grace period the pages get into rcu_free_kmmio_fault_pages()
and raise a BUG_ON() kernel crash.

The list manipulation is fixed to properly remove pages from the release
list.

This bug has been present from the very beginning of mmiotrace in the
mainline kernel. It was introduced in 0fd0e3da ("x86: mmiotrace full
patch, preview 1");

An urgent fix for Linus. Tested by Stuart (on 32-bit) and Pekka
(on amd and intel 64-bit systems, nouveau and nvidia proprietary).

Signed-off-by: Stuart Bennett <stuart@freedesktop.org>
Signed-off-by: Pekka Paalanen <pq@iki.fi>
LKML-Reference: <20090308202135.34933feb@daedalus.pq.iki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/kmmio.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 9f20503..6a518dd 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -451,23 +451,24 @@ static void rcu_free_kmmio_fault_pages(struct rcu_head *head)
 
 static void remove_kmmio_fault_pages(struct rcu_head *head)
 {
-	struct kmmio_delayed_release *dr = container_of(
-						head,
-						struct kmmio_delayed_release,
-						rcu);
+	struct kmmio_delayed_release *dr =
+		container_of(head, struct kmmio_delayed_release, rcu);
 	struct kmmio_fault_page *p = dr->release_list;
 	struct kmmio_fault_page **prevp = &dr->release_list;
 	unsigned long flags;
+
 	spin_lock_irqsave(&kmmio_lock, flags);
 	while (p) {
-		if (!p->count)
+		if (!p->count) {
 			list_del_rcu(&p->list);
-		else
+			prevp = &p->release_next;
+		} else {
 			*prevp = p->release_next;
-		prevp = &p->release_next;
+		}
 		p = p->release_next;
 	}
 	spin_unlock_irqrestore(&kmmio_lock, flags);
+
 	/* This is the real RCU destroy call. */
 	call_rcu(&dr->rcu, rcu_free_kmmio_fault_pages);
 }
