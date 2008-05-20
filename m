Return-Path: <linux-kernel-owner+w=401wt.eu-S1761576AbYETDbC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761576AbYETDbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 23:31:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757495AbYETDaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 23:30:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756568AbYETDav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 23:30:51 -0400
Date: Mon, 19 May 2008 23:24:48 -0400
From: Dave Jones <davej@redhat.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Arjan van de Ven <arjan@infradead.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Make
Message-ID: <20080520032448.GA19348@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Arjan van de Ven <arjan@infradead.org>,
	Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
	linux-kernel@vger.kernel.org
References: <20080502182745.GL14976@parisc-linux.org> <20080501133209.2c04dad0@infradead.org> <20080502184922.GM14976@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080502184922.GM14976@parisc-linux.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan noted that the list_head debugging is BUG'ing when it detects
corruption.  By causing the box to panic immediately, we're possibly
losing some bug reports.   Changing this to a WARN_ON should mean
we at the least start seeing reports collected at kerneloops.org

[ I chose to BUG() when I first added that code, because I was
  chasing a bug which caused a lockup anyway, so it made little difference
  to me. ]

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/lib/list_debug.c b/lib/list_debug.c
index 4350ba9..09f28bf 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -24,13 +24,13 @@ void __list_add(struct list_head *new,
 		printk(KERN_ERR "list_add corruption. next->prev should be "
 			"prev (%p), but was %p. (next=%p).\n",
 			prev, next->prev, next);
-		BUG();
+		WARN_ON(1);
 	}
 	if (unlikely(prev->next != next)) {
 		printk(KERN_ERR "list_add corruption. prev->next should be "
 			"next (%p), but was %p. (prev=%p).\n",
 			next, prev->next, prev);
-		BUG();
+		WARN_ON(1);
 	}
 	next->prev = new;
 	new->next = next;
@@ -64,12 +64,12 @@ void list_del(struct list_head *entry)
 	if (unlikely(entry->prev->next != entry)) {
 		printk(KERN_ERR "list_del corruption. prev->next should be %p, "
 				"but was %p\n", entry, entry->prev->next);
-		BUG();
+		WARN_ON(1);
 	}
 	if (unlikely(entry->next->prev != entry)) {
 		printk(KERN_ERR "list_del corruption. next->prev should be %p, "
 				"but was %p\n", entry, entry->next->prev);
-		BUG();
+		WARN_ON(1);
 	}
 	__list_del(entry->prev, entry->next);
 	entry->next = LIST_POISON1;

-- 
http://www.codemonkey.org.uk
