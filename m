Return-Path: <linux-kernel-owner+w=401wt.eu-S1759102AbZDFXNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102AbZDFXNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 19:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbZDFXN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 19:13:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751966AbZDFXN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 19:13:29 -0400
Date: Mon, 6 Apr 2009 16:10:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ray Lee <ray-lk@madrabbit.org>
cc: Hua Zhong <hzhong@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
In-Reply-To: <alpine.LFD.2.00.0904061509020.7443@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904061604410.8214@localhost.localdomain>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>  <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain>  <20090406151054.GD5178@kernel.dk> <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain>  <20090406183157.GD7376@mit.edu>
 <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain>  <002501c9b6f3$f85b4910$e911db30$@com> <20090406211931.GB8586@mit.edu>  <003001c9b6ff$a9259ce0$fb70d6a0$@com> <2c0942db0904061504l6504934bi446f7425fcd38470@mail.gmail.com>
 <alpine.LFD.2.00.0904061509020.7443@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Apr 2009, Linus Torvalds wrote:
> thing that we think people would be happiest with.
> 
> I think "ordered" was a reasonable default, but that was at least partly 
> because _both_ ordered and writeback sucked (partly in different ways).
> 
> I do think we could make it a config option.

A patch _something_ like this.

A few notes:

 - This is UNTESTED (of course)

 - If I did this right, this _only_ overrides the data mode if it's not 
   explicitly specified on disk in the superblock mount options.

IOW, if you have done a 

	tune2fs -o journal_data_ordered

then this will _not_ override that. Only in the absense of any explicit 
flags should this trigger and then make the choice be 'writeback'.

And just to be _extra_ backwards compatible, if you really want the old 
behavior, and don't want to set the ordering flag explicitly, just answer 
'y' to the EXT3_DEFAULTS_TO_ORDERED Kconfig question. 

What do people think? Anybody want to test?

		Linus

---
 fs/ext3/Kconfig |   19 +++++++++++++++++++
 fs/ext3/super.c |    8 +++++++-
 2 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/Kconfig b/fs/ext3/Kconfig
index 8e0cfe4..fb3c1a2 100644
--- a/fs/ext3/Kconfig
+++ b/fs/ext3/Kconfig
@@ -28,6 +28,25 @@ config EXT3_FS
 	  To compile this file system support as a module, choose M here: the
 	  module will be called ext3.
 
+config EXT3_DEFAULTS_TO_ORDERED
+	bool "Default to 'data=ordered' in ext3 (legacy option)"
+	depends on EXT3_FS
+	help
+	  If a filesystem does not explicitly specify a data ordering
+	  mode, and the journal capability allowed it, ext3 used to
+	  historically default to 'data=ordered'.
+
+	  That was a rather unfortunate choice, because it leads to all
+	  kinds of latency problems, and the 'data=writeback' mode is more
+	  appropriate these days.
+
+	  You should probably always answer 'n' here, and if you really
+	  want to use 'data=ordered' mode, set it in the filesystem itself
+	  with 'tune2fs -o journal_data_ordered'.
+
+	  But if you really want to enable the legacy default, you can do
+	  so by answering 'y' to this question.
+
 config EXT3_FS_XATTR
 	bool "Ext3 extended attributes"
 	depends on EXT3_FS
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 9e5b8e3..599dbfe 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -44,6 +44,12 @@
 #include "acl.h"
 #include "namei.h"
 
+#ifdef CONFIG_EXT3_DEFAULTS_TO_ORDERED
+  #define EXT3_MOUNT_DEFAULT_DATA_MODE EXT3_MOUNT_ORDERED_DATA
+#else
+  #define EXT3_MOUNT_DEFAULT_DATA_MODE EXT3_MOUNT_WRITEBACK_DATA
+#endif
+
 static int ext3_load_journal(struct super_block *, struct ext3_super_block *,
 			     unsigned long journal_devnum);
 static int ext3_create_journal(struct super_block *, struct ext3_super_block *,
@@ -1919,7 +1925,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
                    cope, else JOURNAL_DATA */
 		if (journal_check_available_features
 		    (sbi->s_journal, 0, 0, JFS_FEATURE_INCOMPAT_REVOKE))
-			set_opt(sbi->s_mount_opt, ORDERED_DATA);
+			set_opt(sbi->s_mount_opt, DEFAULT_DATA_MODE);
 		else
 			set_opt(sbi->s_mount_opt, JOURNAL_DATA);
 		break;
