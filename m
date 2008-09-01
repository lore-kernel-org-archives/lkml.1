Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbYIALkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbYIALkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbYIALkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:40:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:54577 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbYIALkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:40:22 -0400
Message-ID: <48BBD429.50907@kernel.org>
Date: Mon, 01 Sep 2008 13:38:17 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       dm-devel@redhat.com
Subject: Re: [PATCH #blk-for-2.8] init: DEBUG_BLOCK_EXT_DEVT requires explicit
   root= param
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <200808292123.07246.bzolnier@gmail.com> <48B90E81.5060905@kernel.org> <200808311538.38918.bzolnier@gmail.com> <48BBCB62.4040309@kernel.org> <20080901111635.GN20055@kernel.dk> <48BBD01A.7000603@kernel.org> <20080901113059.GO20055@kernel.dk>
In-Reply-To: <20080901113059.GO20055@kernel.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Sep 2008 11:39:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DEBUG_BLOCK_EXT_DEVT shuffles SCSI and IDE device numbers and root
device number set using rdev become meaningless.  Root devices should
be explicitly specified using textual names.  Warn about it if root
can't be found and DEBUG_BLOCK_EXT_DEVT is enabled.  Also, add warning
to the help text.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
I think distros should enable it for early alpha/betas to catch odd
problems.  Well, anyways, here's the updated version.  Thanks.

 init/do_mounts.c  |    4 ++++
 lib/Kconfig.debug |    6 ++++++
 2 files changed, 10 insertions(+)

Index: work/init/do_mounts.c
===================================================================
--- work.orig/init/do_mounts.c
+++ work/init/do_mounts.c
@@ -263,6 +263,10 @@ retry:
 		printk("Please append a correct \"root=\" boot option; here are the available partitions:\n");
 
 		printk_all_partitions();
+#ifdef CONFIG_DEBUG_BLOCK_EXT_DEVT
+		printk("DEBUG_BLOCK_EXT_DEVT is enabled, you need to specify "
+		       "explicit textual name for \"root=\" boot option.\n");
+#endif
 		panic("VFS: Unable to mount root fs on %s", b);
 	}
 
Index: work/lib/Kconfig.debug
===================================================================
--- work.orig/lib/Kconfig.debug
+++ work/lib/Kconfig.debug
@@ -638,6 +638,12 @@ config DEBUG_BLOCK_EXT_DEVT
 	  userland code paths which assume predetermined contiguous
 	  device number allocation.
 
+	  Note that turning on this debug option shuffles all the
+	  device numbers for all IDE and SCSI devices including libata
+	  ones, so root partition specified using device number
+	  directly (via rdev or root=MAJ:MIN) won't work anymore.
+	  Textual device names (root=/dev/sdXn) will continue to work.
+
 	  Say N if you are unsure.
 
 config LKDTM
