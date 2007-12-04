Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbXLDLXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbXLDLXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 06:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbXLDLXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 06:23:30 -0500
Received: from ns2.suse.de ([195.135.220.15]:33516 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbXLDLX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 06:23:29 -0500
Date: Tue, 4 Dec 2007 12:23:28 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, rob@landley.net,
       Jens Axboe <axboe@kernel.dk>
Subject: [patch] ext2: xip check fix
Message-ID: <20071204112327.GB20420@wotan.suse.de>
References: <20071204042628.GA26636@wotan.suse.de> <200712041054.51599.borntraeger@de.ibm.com> <20071204101009.GB9618@wotan.suse.de> <20071204112100.GA20420@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204112100.GA20420@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am I missing something here? I wonder how s390 works without this change?

--
ext2 should not worry about checking sb->s_blocksize for XIP before the
sb's blocksize actually gets set.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/fs/ext2/super.c
===================================================================
--- linux-2.6.orig/fs/ext2/super.c
+++ linux-2.6/fs/ext2/super.c
@@ -844,8 +844,7 @@ static int ext2_fill_super(struct super_
 
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
 
-	if ((ext2_use_xip(sb)) && ((blocksize != PAGE_SIZE) ||
-				  (sb->s_blocksize != blocksize))) {
+	if (ext2_use_xip(sb) && blocksize != PAGE_SIZE) {
 		if (!silent)
 			printk("XIP: Unsupported blocksize\n");
 		goto failed_mount;
