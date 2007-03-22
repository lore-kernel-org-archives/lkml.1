Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbXCVGx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbXCVGx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 02:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbXCVGx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 02:53:28 -0400
Received: from poczta.o2.pl ([193.17.41.142]:38426 "EHLO poczta.o2.pl"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753044AbXCVGx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 02:53:27 -0400
Date: Thu, 22 Mar 2007 07:57:59 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, "J\. Bruce Fields" <bfields@fieldses.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] lockdep: debug_show_all_locks &  debug_show_held_locks vs. debug_locks
Message-ID: <20070322065759.GB1466@ff.dom.local>
References: <17918.11420.155569.991473@notabene.brown> <20070320093753.GA1751@ff.dom.local> <20070320160759.GA107@tv-sign.ru> <20070321080510.GA1939@ff.dom.local> <20070321144620.GC78@tv-sign.ru> <20070321151651.GA4547@ff.dom.local> <20070321152935.GA215@tv-sign.ru> <20070321181635.GA570@tv-sign.ru> <20070322061119.GA1466@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322061119.GA1466@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


And here is some addition.

[PATCH] lockdep: debug_show_all_locks &  debug_show_held_locks vs. debug_locks
 
lockdep's data shouldn't be used when debug_locks == 0
because it's not updated after this, so it's more misleading
than helpful.

PS: probably lockdep's current-> fields should be reset after
it turns debug_locks off: so, after printing a bug report, but
before return from exported functions, but there are really
a lot of these possibilities (e.g. after DEBUG_LOCKS_WARN_ON),
so, something could be missed. (Of course direct use of this
fields isn't recommended either.)

Reported-by: Folkert van Heusden <folkert@vanheusden.com>
Inspired-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>

---

diff -Nurp 2.6.21-rc4-git4-/kernel/lockdep.c 2.6.21-rc4-git4/kernel/lockdep.c
--- 2.6.21-rc4-git4-/kernel/lockdep.c	2007-03-21 22:46:26.000000000 +0100
+++ 2.6.21-rc4-git4/kernel/lockdep.c	2007-03-21 23:05:17.000000000 +0100
@@ -2742,6 +2742,10 @@ void debug_show_all_locks(void)
 	int count = 10;
 	int unlock = 1;
 
+	if (unlikely(!debug_locks)) {
+		printk("INFO: lockdep is turned off.\n");
+		return;
+	}
 	printk("\nShowing all locks held in the system:\n");
 
 	/*
@@ -2785,6 +2789,10 @@ EXPORT_SYMBOL_GPL(debug_show_all_locks);
 
 void debug_show_held_locks(struct task_struct *task)
 {
+	if (unlikely(!debug_locks)) {
+		printk("INFO: lockdep is turned off.\n");
+		return;
+	}
 	lockdep_print_held_locks(task);
 }
 
