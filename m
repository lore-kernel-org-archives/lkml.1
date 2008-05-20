Return-Path: <linux-kernel-owner+w=401wt.eu-S1764639AbYETQla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764639AbYETQla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765552AbYETQkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:40:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765469AbYETQky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:40:54 -0400
Date: Tue, 20 May 2008 11:20:26 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make
Message-ID: <20080520152026.GB542@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20080502182745.GL14976@parisc-linux.org> <20080501133209.2c04dad0@infradead.org> <20080502184922.GM14976@parisc-linux.org> <20080520032448.GA19348@redhat.com> <20080520071458.707d6e90@infradead.org> <20080520142727.GC4843@redhat.com> <alpine.LFD.1.10.0805200752580.32253@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805200752580.32253@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 07:54:10AM -0700, Linus Torvalds wrote:

 > I think Arjan meant like
 > 
 > 	WARN(next->prev != prev,
 > 		"list_add corruption. next->prev should be "
 > 		"prev (%p), but was %p. (next=%p).\n",
 > 		prev, next->prev, next);
 > 
 > without any "if()" statement at all.

Nice. I like that.


diff --git a/lib/list_debug.c b/lib/list_debug.c
index 4350ba9..311ffab 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -20,18 +20,14 @@ void __list_add(struct list_head *new,
 			      struct list_head *prev,
 			      struct list_head *next)
 {
-	if (unlikely(next->prev != prev)) {
-		printk(KERN_ERR "list_add corruption. next->prev should be "
-			"prev (%p), but was %p. (next=%p).\n",
-			prev, next->prev, next);
-		BUG();
-	}
-	if (unlikely(prev->next != next)) {
-		printk(KERN_ERR "list_add corruption. prev->next should be "
-			"next (%p), but was %p. (prev=%p).\n",
-			next, prev->next, prev);
-		BUG();
-	}
+	WARN(next->prev != prev,
+		"list_add corruption. next->prev should be "
+		"prev (%p), but was %p. (next=%p).\n",
+		prev, next->prev, next);
+	WARN(prev->next != next,
+		"list_add corruption. prev->next should be "
+		"next (%p), but was %p. (prev=%p).\n",
+		next, prev->next, prev);
 	next->prev = new;
 	new->next = next;
 	new->prev = prev;
@@ -61,16 +57,12 @@ EXPORT_SYMBOL(list_add);
  */
 void list_del(struct list_head *entry)
 {
-	if (unlikely(entry->prev->next != entry)) {
-		printk(KERN_ERR "list_del corruption. prev->next should be %p, "
-				"but was %p\n", entry, entry->prev->next);
-		BUG();
-	}
-	if (unlikely(entry->next->prev != entry)) {
-		printk(KERN_ERR "list_del corruption. next->prev should be %p, "
-				"but was %p\n", entry, entry->next->prev);
-		BUG();
-	}
+	WARN(entry->prev->next != entry,
+		"list_del corruption. prev->next should be %p, "
+		"but was %p\n", entry, entry->prev->next);
+	WARN(entry->next->prev != entry,
+		"list_del corruption. next->prev should be %p, "
+		"but was %p\n", entry, entry->next->prev);
 	__list_del(entry->prev, entry->next);
 	entry->next = LIST_POISON1;
 	entry->prev = LIST_POISON2;

-- 
http://www.codemonkey.org.uk
