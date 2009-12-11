Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbZLKFcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbZLKFcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbZLKF37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:29:59 -0500
Received: from kroah.org ([198.145.64.141]:53501 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845AbZLKF3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:29:52 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 21:25:48 2009
Message-Id: <20091211052548.201782286@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 21:23:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [15/34] ext4: fix uninit block bitmap initialization when s_meta_first_bg is non-zero
References: <20091211052312.805428372@linux.site>
Content-Disposition: inline; filename=0011-ext4-fix-uninit-block-bitmap-initialization-when-s_m.patch
In-Reply-To: <20091211052858.GA23229@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

(cherry picked from commit 8dadb198cb70ef811916668fe67eeec82e8858dd)

The number of old-style block group descriptor blocks is
s_meta_first_bg when the meta_bg feature flag is set.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/balloc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -761,7 +761,13 @@ static unsigned long ext4_bg_num_gdb_met
 static unsigned long ext4_bg_num_gdb_nometa(struct super_block *sb,
 					ext4_group_t group)
 {
-	return ext4_bg_has_super(sb, group) ? EXT4_SB(sb)->s_gdb_count : 0;
+	if (!ext4_bg_has_super(sb, group))
+		return 0;
+
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb,EXT4_FEATURE_INCOMPAT_META_BG))
+		return le32_to_cpu(EXT4_SB(sb)->s_es->s_first_meta_bg);
+	else
+		return EXT4_SB(sb)->s_gdb_count;
 }
 
 /**


