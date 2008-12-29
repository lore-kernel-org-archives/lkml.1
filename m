Return-Path: <linux-kernel-owner+w=401wt.eu-S1752327AbYL2Syl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbYL2Syl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 13:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYL2SyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 13:54:07 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:50556 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbYL2SyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 13:54:06 -0500
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 2/2] futex: correct futex_requeue futex key ref counting in
	requeue loop
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Darren Hart <dvhltc@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Rusty Russell <rusty@au1.ibm.com>
Date: Mon, 29 Dec 2008 10:54:02 -0800
Message-ID: <20081229185402.10342.77396.stgit@Aeon>
In-Reply-To: <20081229185238.10342.75651.stgit@Aeon>
References: <20081229185238.10342.75651.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The requeue loop takes multiple references to key2, but the corresponding
put loop decrements the refs for key1.  This patch corrects the accounting.

Build and boot tested on an x86_64 system.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@au1.ibm.com>
---

 kernel/futex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index cf363ce..3b66d91 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -919,7 +919,7 @@ out_unlock:
 
 	/* drop_futex_key_refs() must be called outside the spinlocks. */
 	while (--drop_count >= 0)
-		drop_futex_key_refs(&key1);
+		drop_futex_key_refs(&key2);
 
 	put_futex_key(fshared, &key2);
 out_put_key1:

