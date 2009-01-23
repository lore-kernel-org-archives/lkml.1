Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbZAWT2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbZAWT2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 14:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbZAWT1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 14:27:52 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59830 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbZAWT1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 14:27:51 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Linux Mailing <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@liux-foundation.org>
Subject: [patch, rfc] do_generic_file_read: clear page errors when issuing a fresh read of the page
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 23 Jan 2009 14:27:48 -0500
Message-ID: <x49d4edesaz.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In testing older kernels, I've seen I/O errors set PG_error for the page
cache page (for a failure of the last path in a mulitpath setup).  Then,
when the device is back online, the page error is never cleared, so all
reads from the previously bad disk location fail.  You can actually get
around this by simply mmap()ing the file (the device node, in my case)
and accessing the page that way, as filemap_fault will clear the page
error bit.

So, hopefully this patch makes sense.  As implied above, I haven't
verified empirically that this is the case on newer kernels (though,
from code inspection, it looks to still be a problem).  I'll try to
reproduce the problem, but just in case I can't, I wanted to get this
rfc out there.

Cheers,
Jeff

diff --git a/mm/filemap.c b/mm/filemap.c
index 0e77f4a..3adafc8 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1139,6 +1139,12 @@ page_not_up_to_date_locked:
 		}
 
 readpage:
+		/*
+		 * If there was an I/O error flagged previously, clear it
+		 * here.  PG_error will be set again if the readpage fails.
+		 */
+		ClearPageError(page);
+
 		/* Start the actual read. The read will unlock the page. */
 		error = mapping->a_ops->readpage(filp, page);
 
