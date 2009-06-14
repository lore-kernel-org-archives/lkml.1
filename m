Return-Path: <linux-kernel-owner+w=401wt.eu-S1764074AbZFNV5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764074AbZFNV5u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 17:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756412AbZFNV5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 17:57:41 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:23303 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755725AbZFNV5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 17:57:41 -0400
X-Trace: 214804769/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.42.252/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.42.252
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag4CAEcPNUpQKSr8/2dsb2JhbAAI0FSEDQU
X-IronPort-AV: E=Sophos;i="4.42,218,1243810800"; 
   d="scan'208";a="214804769"
Date: Sun, 14 Jun 2009 22:56:48 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Matt Mackall <mpm@selenic.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] ramfs: ignore unknown mount options
In-Reply-To: <1244995214.4496.234.camel@calx>
Message-ID: <Pine.LNX.4.64.0906142250590.6984@sister.anvils>
References: <1244872920-13511-1-git-send-email-vapier@gentoo.org> 
 <Pine.LNX.4.64.0906131456090.5069@sister.anvils>  <20090614100110.GA19875@localhost>
  <Pine.LNX.4.64.0906141119030.13473@sister.anvils> <1244995214.4496.234.camel@calx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

On systems where CONFIG_SHMEM is disabled, mounting tmpfs filesystems can
fail when tmpfs options are used.  This is because tmpfs creates a small
wrapper around ramfs which rejects unknown options, and ramfs itself only
supports a tiny subset of what tmpfs supports.  This makes it pretty hard
to use the same userspace systems across different configuration systems.
As such, ramfs should ignore the tmpfs options when tmpfs is merely a
wrapper around ramfs.

This used to work before commit c3b1b1cbf0 as previously, ramfs would
ignore all options.  But now, we get:
ramfs: bad mount option: size=10M
mount: mounting mdev on /dev failed: Invalid argument

Another option might be to restore the previous behavior, where ramfs
simply ignored all unknown mount options ... which is what Hugh prefers.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Matt Mackall <mpm@selenic.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: stable@kernel.org
---

 fs/ramfs/inode.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- 2.6.30/fs/ramfs/inode.c	2009-06-10 04:05:27.000000000 +0100
+++ linux/fs/ramfs/inode.c	2009-06-13 14:45:33.000000000 +0100
@@ -202,9 +202,12 @@ static int ramfs_parse_options(char *dat
 				return -EINVAL;
 			opts->mode = option & S_IALLUGO;
 			break;
-		default:
-			printk(KERN_ERR "ramfs: bad mount option: %s\n", p);
-			return -EINVAL;
+		/*
+		 * We might like to report bad mount options here;
+		 * but traditionally ramfs has ignored all mount options,
+		 * and as it is used as a !CONFIG_SHMEM simple substitute
+		 * for tmpfs, better continue to ignore other mount options.
+		 */
 		}
 	}
 
