Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbZCJS0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbZCJS0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 14:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbZCJS0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 14:26:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50689 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754532AbZCJS0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 14:26:12 -0400
Date: Tue, 10 Mar 2009 19:25:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] x86 fix
Message-ID: <20090310182550.GA19222@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Stuart Bennett (1):
      x86 mmiotrace: fix remove_kmmio_fault_pages()


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
