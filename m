Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbZLOW6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbZLOW6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757201AbZLOW6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:58:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:37571 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbZLOW6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:58:13 -0500
Date: Tue, 15 Dec 2009 22:57:38 GMT
From: tip-bot for Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: linux-kernel@vger.kernel.org, phillip@lougher.demon.co.uk, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, phillip@lougher.demon.co.uk,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <4b26b1ef.hIInb2AYPMtImAJO%phillip@lougher.demon.co.uk>
References: <4b26b1ef.hIInb2AYPMtImAJO%phillip@lougher.demon.co.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] bzip2/lzma/gzip: pre-boot malloc doesn't return NULL on failure
Message-ID: <tip-c1e7c3ae59b065bf7ff24a05cb609b2f9e314db6@git.kernel.org>
Git-Commit-ID: c1e7c3ae59b065bf7ff24a05cb609b2f9e314db6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c1e7c3ae59b065bf7ff24a05cb609b2f9e314db6
Gitweb:     http://git.kernel.org/tip/c1e7c3ae59b065bf7ff24a05cb609b2f9e314db6
Author:     Phillip Lougher <phillip@lougher.demon.co.uk>
AuthorDate: Mon, 14 Dec 2009 21:45:19 +0000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 15 Dec 2009 14:04:12 -0800

bzip2/lzma/gzip: pre-boot malloc doesn't return NULL on failure

The trivial malloc implementation used in the pre-boot environment by the
decompressors returns a bad pointer on failure (falling through after
calling error).  This is doubly wrong - the callers expect malloc to
return NULL on failure, second the error function is intended to be
used by the decompressors to propagate errors to *their* callers.  The
decompressors have no access to any state set by the error function.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
LKML-Reference: <4b26b1ef.hIInb2AYPMtImAJO%phillip@lougher.demon.co.uk>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
