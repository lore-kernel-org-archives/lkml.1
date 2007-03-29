Return-Path: <linux-kernel-owner+w=401wt.eu-S1030735AbXC2VMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030735AbXC2VMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 17:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030734AbXC2VMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 17:12:13 -0400
Received: from dsl017-049-130.sfo4.dsl.speakeasy.net ([69.17.49.130]:52611
	"EHLO piratehaven.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030735AbXC2VMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 17:12:12 -0400
X-Greylist: delayed 1978 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Mar 2007 17:12:12 EDT
Date: Thu, 29 Mar 2007 13:39:13 -0700
From: Brian Pomerantz <bapper@piratehaven.org>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix page leak during core dump
Message-ID: <20070329203913.GA5190@skull.piratehaven.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-homepage: http://www.piratehaven.org/~bapper/
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When the dump cannot occur most likely because of a full file system
and the page to be written is the zero page, the call to
page_cache_release() is missed.

Signed-off-by: Brian Pomerantz <bapper@mvista.com>

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index a2fceba..9cc4f0a 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1704,7 +1704,10 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file)
 				DUMP_SEEK(PAGE_SIZE);
 			} else {
 				if (page == ZERO_PAGE(addr)) {
-					DUMP_SEEK(PAGE_SIZE);
+					if (!dump_seek(file, PAGE_SIZE)) {
+						page_cache_release(page);
+						goto end_coredump;
+					}
 				} else {
 					void *kaddr;
 					flush_cache_page(vma, addr,
