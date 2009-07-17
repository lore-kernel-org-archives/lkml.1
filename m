Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbZGQUWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbZGQUWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbZGQUWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:22:46 -0400
Received: from kroah.org ([198.145.64.141]:43102 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320AbZGQUTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:19:45 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:12:31 2009
Message-Id: <20090717201231.389120722@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:09:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sonny Rao <sonnyrao@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       anton@samba.org, rajamony@us.ibm.com, speight@us.ibm.com,
       mstephen@us.ibm.com, grimm@us.ibm.com, mikey@ozlabs.au.ibm.com,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 10/24] futexes: Fix infinite loop in get_futex_key() on huge page
References: <20090717200851.907421303@mini.kroah.org>
Content-Disposition: inline; filename=futexes-fix-infinite-loop-in-get_futex_key-on-huge-page.patch
In-Reply-To: <20090717201639.GA14209@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sonny Rao <sonnyrao@us.ibm.com>

commit ce2ae53b750abfaa012ce408e93da131a5b5649b upstream.

get_futex_key() can infinitely loop if it is called on a
virtual address that is within a huge page but not aligned to
the beginning of that page.  The call to get_user_pages_fast
will return the struct page for a sub-page within the huge page
and the check for page->mapping will always fail.

The fix is to call compound_head on the page before checking
that it's mapped.

Signed-off-by: Sonny Rao <sonnyrao@us.ibm.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: anton@samba.org
Cc: rajamony@us.ibm.com
Cc: speight@us.ibm.com
Cc: mstephen@us.ibm.com
Cc: grimm@us.ibm.com
Cc: mikey@ozlabs.au.ibm.com
LKML-Reference: <20090710231313.GA23572@us.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/futex.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -241,6 +241,7 @@ again:
 	if (err < 0)
 		return err;
 
+	page = compound_head(page);
 	lock_page(page);
 	if (!page->mapping) {
 		unlock_page(page);


