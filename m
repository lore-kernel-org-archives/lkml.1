Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbXJGT6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbXJGT6X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 15:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbXJGT6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 15:58:14 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35666 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524AbXJGT6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 15:58:13 -0400
Date: Sun, 7 Oct 2007 22:58:11 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Ryan Finnie <ryan@finnie.org>, Colin Watson <cjwatson@ubuntu.com>
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland
Message-ID: <Pine.LNX.4.64.0710072255280.688@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696229367-1159049550-1191787091=:688"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696229367-1159049550-1191787091=:688
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Hi Erez,

On 10/7/07, Erez Zadok <ezk@cs.sunysb.edu> wrote:
> Anyway, some Ubuntu users of Unionfs reported that msync(2) sometimes
> returns AOP_WRITEPAGE_ACTIVATE (decimal 524288) back to userland.
> Therefore, some user programs fail, esp. if they're written such as 
> this:

[snip]

On 10/7/07, Erez Zadok <ezk@cs.sunysb.edu> wrote:
> Is this a bug indeed, or are user programs supposed to handleÂ 
> AOP_WRITEPAGE_ACTIVATE (I hope not the latter). If it's a kernel bug, 
> what should the kernel return: a zero, or an -errno (and which one)?

It's a kernel bug. AOP_WRITEPAGE_ACTIVATE is a hint to the VM to avoid 
writeback of the page in the near future. I wonder if it's enough that we 
change the return value to zero from 
mm/page-writeback.c:write_cache_pages() in case we hit AOP_WRITEPAGE_ACTIVE...

				Pekka 

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 63512a9..717f341 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -672,8 +672,10 @@ retry:
 
 			ret = (*writepage)(page, wbc, data);
 
-			if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE))
+			if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE)) {
 				unlock_page(page);
+				ret = 0;
+			}
 			if (ret || (--(wbc->nr_to_write) <= 0))
 				done = 1;
 			if (wbc->nonblocking && bdi_write_congested(bdi)) {
---696229367-1159049550-1191787091=:688--
