Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbXJOXFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbXJOXFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbXJOXFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:05:40 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55288 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756903AbXJOXFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:05:39 -0400
Subject: Re: [PATCH 4/11] maps3: introduce a generic page walker
From: Dave Hansen <haveblue@us.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>,
       "ADAM G. LITKE [imap]" <agl@us.ibm.com>
In-Reply-To: <4713EC5B.7050000@goop.org>
References: <5.290135367@selenic.com>  <4713EC5B.7050000@goop.org>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 16:05:13 -0700
Message-Id: <1192489513.6118.111.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-15 at 15:40 -0700, Jeremy Fitzhardinge wrote:
> Can pte_hole be used to create new mappings while we're traversing the
> pagetable?  Apparently not, because it continues after calling it. 

For now, we should probably document that these functions assume that
the appropriate locks are held, and that there are no changes being made
to the pagetables as we walk.

However, I can see that people might want to use these in the future for
establishing ptes.  Perhaps a special code coming back from the
->pte_hole() function could indicate changes were made to the
pagetables.  I guess we could at least retry part of the loop where the
hole call was made, like:

+int walk_page_range(struct mm_struct *mm,...
+{
...
+       pgd = pgd_offset(mm, addr);
+       do {
+               next = pgd_addr_end(addr, end);
+               if (pgd_none_or_clear_bad(pgd)) {
+                       if (walk->pte_hole)
+                               err = walk->pte_hole(addr, next, private);
			if (err == -EAGAIN) { // or whatever we want
				pgd--;
				err = 0;
			}
+                       if (err)
+                               break;
+                       continue;
+               }

That wouldn't allow changes behind the walker, but it should allow them
in the range that was walked by the ->pte_hole() function.

-- Dave

