Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbZIDPY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbZIDPY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 11:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbZIDPYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 11:24:54 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43488 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbZIDPYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 11:24:52 -0400
Subject: Re: 2.6.31-rc8 JFS inconsistent lock state
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: "Frank A. Kingswood" <frank@kingswood-consulting.co.uk>
Cc: linux-kernel@vger.kernel.org,
       JFS Discussion <jfs-discussion@lists.sourceforge.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <4A9F6DAB.5090603@kingswood-consulting.co.uk>
References: <h7jln4$mcn$1@ger.gmane.org>
	 <4A9F6DAB.5090603@kingswood-consulting.co.uk>
Content-Type: text/plain
Date: Fri, 04 Sep 2009 10:24:52 -0500
Message-Id: <1252077892.27587.9.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-03 at 08:18 +0100, Frank A. Kingswood wrote:
> Frank A. Kingswood wrote:
> 
> > I'm running jfs on md and got this error. The system is still usable 
> > afterwards (and has not been rebooted yet) so I could provide more 
> > information if needed.
> > 
> > The system has occasionally had hard crashes during file access (perhaps 
> > starting with about 2.6.29) and these may be related.
> 
> The same happens with 2.6.31-rc8
> 
> Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> ... MAX_LOCKDEP_SUBCLASSES:  8
> ... MAX_LOCK_DEPTH:          48
> ... MAX_LOCKDEP_KEYS:        8191
> ... CLASSHASH_SIZE:          4096
> ... MAX_LOCKDEP_ENTRIES:     16384
> ... MAX_LOCKDEP_CHAINS:      32768
> ... CHAINHASH_SIZE:          16384
>   memory used by lock dependency info: 6207 kB
>   per task-struct memory footprint: 2688 bytes
> 
> ...a while later...

I looked at this a while back:

http://lkml.org/lkml/2009/5/18/358

I didn't get a response to that, and I didn't follow up.  I guess it's
time to get back on it.  I'll try to recreate the warning and see if
this patch helps:

diff --git a/mm/filemap.c b/mm/filemap.c
index ccea3b6..59f5406 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1702,7 +1702,8 @@ repeat:
 		page = page_cache_alloc_cold(mapping);
 		if (!page)
 			return ERR_PTR(-ENOMEM);
-		err = add_to_page_cache_lru(page, mapping, index, GFP_KERNEL);
+		err = add_to_page_cache_lru(page, mapping, index,
+					    mapping_gfp_mask(mapping));
 		if (unlikely(err)) {
 			page_cache_release(page);
 			if (err == -EEXIST)

-- 
David Kleikamp
IBM Linux Technology Center

