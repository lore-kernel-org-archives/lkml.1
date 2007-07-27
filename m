Return-Path: <linux-kernel-owner+w=401wt.eu-S935359AbXG0GeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935359AbXG0GeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 02:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762949AbXG0Gd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 02:33:57 -0400
Received: from canuck.infradead.org ([209.217.80.40]:49833 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762865AbXG0Gd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 02:33:56 -0400
Subject: Re: [PATCH] Don't needlessly dirty mlocked pages when initially
	faulting them in.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suleiman Souhlal <ssouhlal@FreeBSD.org>, linux-kernel@vger.kernel.org,
       Suleiman Souhlal <suleiman@google.com>
In-Reply-To: <20070726172330.d3409b57.akpm@linux-foundation.org>
References: <11854939641916-git-send-email-ssouhlal@FreeBSD.org>
	 <20070726172330.d3409b57.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 08:33:30 +0200
Message-Id: <1185518010.15205.36.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-26 at 17:23 -0700, Andrew Morton wrote:
> On Thu, 26 Jul 2007 16:52:44 -0700 Suleiman Souhlal <ssouhlal@FreeBSD.org> wrote:
> 
> > make_pages_present() is dirtying mlocked pages if the VMA is writable, even
> > though it shouldn't, by telling get_user_pages() to simulate a write fault.
> > 
> > A simple way to test this is to mlock a multi-GB file, and then sync.
> > The sync will take a long time.
> 
> ugh, how bad of us.
> 
> > As far as I can see, it should be safe to just not simulate a write fault.
> 
> We pass in "write=1" to force a COW.  This is because we want to do all
> that memory allocation at mlock()-time, not later on, when the app writes
> to the page.

<snip patch>

> So something sterner will need to be done.  I guess the write_access arg to
> handle_mm_fault() would need to become a three-value thing.

That would be most painfull. Can't we simply set write=0 for shared
mappings? Those won't have COW to break and are the onces that do
requires writeback. Anonymous and private mappings do COW but will never
writeback and are thus save to touch with write=1.

How about something like this:

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/memory.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c
+++ linux-2.6/mm/memory.c
@@ -2716,7 +2716,12 @@ int make_pages_present(unsigned long add
 	vma = find_vma(current->mm, addr);
 	if (!vma)
 		return -1;
-	write = (vma->vm_flags & VM_WRITE) != 0;
+	/*
+	 * We want to touch writable mappings with a write fault in otder
+	 * to break COW, except for shared mappings because these don't COW
+	 * and we would not want to dirty them for nothing.
+	 */
+	write = (vma->vm_flags & VM_WRITE|VM_SHARED) == VM_WRITE;
 	BUG_ON(addr >= end);
 	BUG_ON(end > vma->vm_end);
 	len = DIV_ROUND_UP(end, PAGE_SIZE) - addr/PAGE_SIZE;


