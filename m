Return-Path: <linux-kernel-owner+w=401wt.eu-S932706AbYETOhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706AbYETOhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbYETOhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:37:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbYETOhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:37:03 -0400
Date: Tue, 20 May 2008 10:27:27 -0400
From: Dave Jones <davej@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make
Message-ID: <20080520142727.GC4843@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>, Linus Torvalds <torvalds@osdl.org>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
References: <20080502182745.GL14976@parisc-linux.org> <20080501133209.2c04dad0@infradead.org> <20080502184922.GM14976@parisc-linux.org> <20080520032448.GA19348@redhat.com> <20080520071458.707d6e90@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520071458.707d6e90@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 07:14:58AM -0700, Arjan van de Ven wrote:
 > On Mon, 19 May 2008 23:24:48 -0400
 > Dave Jones <davej@redhat.com> wrote:
 > 
 > >  		printk(KERN_ERR "list_add corruption. next->prev
 > > should be " "prev (%p), but was %p. (next=%p).\n",
 > >  			prev, next->prev, next);
 > > -		BUG();
 > > +		WARN_ON(1);
 > >  	}
 > 
 > 
 > now that -mm has a WARN(condition, printk arguments), could we make
 > this use it? The advantage (apart from smaller C code) is that it puts
 > the printk inside the ---[ cut here ]--- which makes it more likely that
 > reporters (and kerneloops.org) get the actual text....

Like this ?  (I don't have a -mm handy, so guessed based on mm-commits mail,
  patch uncompiled, but should dtrt if I understood your diff correctly)

	Dave

diff --git a/lib/list_debug.c b/lib/list_debug.c
index 4350ba9..d8dee53 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -21,16 +21,14 @@ void __list_add(struct list_head *new,
 			      struct list_head *next)
 {
 	if (unlikely(next->prev != prev)) {
-		printk(KERN_ERR "list_add corruption. next->prev should be "
+		WARN(1, "list_add corruption. next->prev should be "
 			"prev (%p), but was %p. (next=%p).\n",
 			prev, next->prev, next);
-		BUG();
 	}
 	if (unlikely(prev->next != next)) {
-		printk(KERN_ERR "list_add corruption. prev->next should be "
+		WARN(1, "list_add corruption. prev->next should be "
 			"next (%p), but was %p. (prev=%p).\n",
 			next, prev->next, prev);
-		BUG();
 	}
 	next->prev = new;
 	new->next = next;
@@ -62,14 +60,12 @@ EXPORT_SYMBOL(list_add);
 void list_del(struct list_head *entry)
 {
 	if (unlikely(entry->prev->next != entry)) {
-		printk(KERN_ERR "list_del corruption. prev->next should be %p, "
+		WARN(1, "list_del corruption. prev->next should be %p, "
 				"but was %p\n", entry, entry->prev->next);
-		BUG();
 	}
 	if (unlikely(entry->next->prev != entry)) {
-		printk(KERN_ERR "list_del corruption. next->prev should be %p, "
+		WARN(1, "list_del corruption. next->prev should be %p, "
 				"but was %p\n", entry, entry->next->prev);
-		BUG();
 	}
 	__list_del(entry->prev, entry->next);
 	entry->next = LIST_POISON1;
-- 
http://www.codemonkey.org.uk
