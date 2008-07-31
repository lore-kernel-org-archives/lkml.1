Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbYGaLF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbYGaLF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 07:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYGaLFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 07:05:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbYGaLFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 07:05:49 -0400
Subject: Potential fix to filemap_fault()
From: Steven Whitehouse <swhiteho@redhat.com>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Thu, 31 Jul 2008 12:04:25 +0100
Message-Id: <1217502265.3425.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We've spotted (with our cluster coherency tests) a couple of issues in
the current page fault path. One of those is fixed by the below patch,
so I'd like to know if anybody can spot any unwanted side effects if we
make this change. The patch prevents us from seeing bus errors when
accessing what should be valid data within a file. This can currently
happen when there is a race between invalidation and the page fault
path.

After applying this patch, we still see one remaining issue, which I
think is related to page_mkwrite but we've not finally tracked that one
down yet. The symptoms of the remaining issue are that we see a blank
page from time to time, when we should be seeing valid data.

Steve.

diff --git a/mm/filemap.c b/mm/filemap.c
index 42bbc69..9441759 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1563,7 +1563,7 @@ page_not_uptodate:
 	error = mapping->a_ops->readpage(file, page);
 	if (!error) {
 		wait_on_page_locked(page);
-		if (!PageUptodate(page))
+		if (PageError(page))
 			error = -EIO;
 	}
 	page_cache_release(page);


