Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbZLNVsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbZLNVsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758384AbZLNVsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:48:09 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:47330 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758357AbZLNVsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:48:07 -0500
Date: Mon, 14 Dec 2009 21:45:19 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       akpm@linux-foundation.org
Cc: phillip@lougher.demon.co.uk, mingo@elte.hu,
       albin.tonnerre@free-electrons.com
Subject: [PATCH 1/3] bzip2/lzma/gzip: pre-boot malloc doesn't return NULL
 on failure
Message-ID: <4b26b1ef.hIInb2AYPMtImAJO%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The trivial malloc implementation used in the pre-boot environment by the
decompressors returns a bad pointer on failure (falling through after
calling error).  This is doubly wrong - the callers expect malloc to
return NULL on failure, second the error function is intended to be
used by the decompressors to propagate errors to *their* callers.  The
decompressors have no access to any state set by the error function.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 include/linux/decompress/mm.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/decompress/mm.h b/include/linux/decompress/mm.h
index 12ff8c3..5032b9a 100644
--- a/include/linux/decompress/mm.h
+++ b/include/linux/decompress/mm.h
@@ -25,7 +25,7 @@ static void *malloc(int size)
 	void *p;
 
 	if (size < 0)
-		error("Malloc error");
+		return NULL;
 	if (!malloc_ptr)
 		malloc_ptr = free_mem_ptr;
 
@@ -35,7 +35,7 @@ static void *malloc(int size)
 	malloc_ptr += size;
 
 	if (free_mem_end_ptr && malloc_ptr >= free_mem_end_ptr)
-		error("Out of memory");
+		return NULL;
 
 	malloc_count++;
 	return p;
-- 
1.6.3.3

