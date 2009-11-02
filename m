Return-Path: <linux-kernel-owner+w=401wt.eu-S1751378AbZKBFRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbZKBFRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 00:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbZKBFR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 00:17:28 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47077 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbZKBFR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 00:17:26 -0500
Date: Mon, 2 Nov 2009 16:17:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: percpu/kvm/tip tree build failure
Message-Id: <20091102161722.eea4358d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next build (x86_64 allmodconfig) failed like this:

kernel/user-return-notifier.c: In function 'fire_user_return_notifiers':
kernel/user-return-notifier.c:45: error: expected expression before ')' token

Introduced by commit 7c68af6e32c73992bad24107311f3433c89016e2 ("core,
x86: Add user return notifiers") from the tip and kvm trees but revealed
by commit e0fdb0e050eae331046385643618f12452aa7e73 ("percpu: add __percpu
for sparse") from the percpu tree.  Before that percpu tree commit,
"put_cpu_var()" would compile without error (even though it really needs
a parameter).

I have applied the following patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 2 Nov 2009 15:54:43 +1100
Subject: [PATCH] x86: fix put_cpu_var invocation in user return notifiers code

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 kernel/user-return-notifier.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/user-return-notifier.c b/kernel/user-return-notifier.c
index 530ccb8..03e2d6f 100644
--- a/kernel/user-return-notifier.c
+++ b/kernel/user-return-notifier.c
@@ -42,5 +42,5 @@ void fire_user_return_notifiers(void)
 	head = &get_cpu_var(return_notifier_list);
 	hlist_for_each_entry_safe(urn, tmp1, tmp2, head, link)
 		urn->on_user_return(urn);
-	put_cpu_var();
+	put_cpu_var(return_notifier_list);
 }
-- 
1.6.5.2


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
