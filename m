Return-Path: <linux-kernel-owner+w=401wt.eu-S1757726AbZGJXNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726AbZGJXNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 19:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbZGJXNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 19:13:16 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42362 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967AbZGJXNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 19:13:15 -0400
Date: Fri, 10 Jul 2009 18:13:13 -0500
From: Sonny Rao <sonnyrao@us.ibm.com>
To: tglx@linuxtronix.de
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       sonnyrao@us.ibm.com, stable@kernel.org, anton@samba.org,
       rajamony@us.ibm.com, speight@us.ibm.com, mstephen@us.ibm.com,
       grimm@us.ibm.com, mikey@ozlabs.au.ibm.com
Subject: [PATCH] futexs: fix infinite loop in get_futex_key on huge page
Message-ID: <20090710231313.GA23572@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_futex_key() can infinitely loop if it is called on a virtual address
that is within a huge page but not aligned to the beginning of that
page.  The call to get_user_pages_fast will return the struct page for
a sub-page within the huge page and the check for page->mapping will
always fail.

The fix is to call compound_head on the page before checking that it's mapped.

Signed-off-by: Sonny Rao <sonnyrao@us.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: stable@kernel.org

Index: linux-2.6.31-rc2/kernel/futex.c
===================================================================
--- linux-2.6.31-rc2.orig/kernel/futex.c	2009-07-10 17:45:46.181084475 -0500
+++ linux-2.6.31-rc2/kernel/futex.c	2009-07-10 17:46:47.345084062 -0500
@@ -247,6 +247,7 @@
 	if (err < 0)
 		return err;
 
+	page = compound_head(page);
 	lock_page(page);
 	if (!page->mapping) {
 		unlock_page(page);
