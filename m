Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbXEIMDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbXEIMDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757314AbXEIMCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:02:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757385AbXEIMCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:02:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix a bad bug in read_cache_page_async()
To: torvalds@linux-foundation.org, akpm@linux-foundation.org, npiggin@suse.de
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Wed, 09 May 2007 13:02:01 +0100
Message-ID: <20070509120201.6771.92968.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bad bug in read_cache_page_async() introduced in commit:

	6fe6900e1e5b6fa9e5c59aa5061f244fe3f467e2

This adds:

	mark_page_accessed(page)

into the error handling path in read_cache_page_async().  In such a case,
'page' holds the error code.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 mm/filemap.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 9e56fd1..10d4fcf 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1784,7 +1784,7 @@ struct page *read_cache_page_async(struct address_space *mapping,
 retry:
 	page = __read_cache_page(mapping, index, filler, data);
 	if (IS_ERR(page))
-		goto out;
+		goto error;
 	mark_page_accessed(page);
 	if (PageUptodate(page))
 		goto out;
@@ -1803,9 +1803,11 @@ retry:
 	if (err < 0) {
 		page_cache_release(page);
 		page = ERR_PTR(err);
+		goto error;
 	}
- out:
+out:
 	mark_page_accessed(page);
+error:
 	return page;
 }
 EXPORT_SYMBOL(read_cache_page_async);

