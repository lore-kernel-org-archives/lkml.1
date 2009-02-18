Return-Path: <linux-kernel-owner+w=401wt.eu-S1758003AbZBRVsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003AbZBRVsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757384AbZBRVgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:36:32 -0500
Received: from kroah.org ([198.145.64.141]:56453 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754270AbZBRVgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:36:05 -0500
Date: Wed, 18 Feb 2009 13:33:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org
Subject: [patch 38/39] ext4: Initialize the new group descriptor when
	resizing the filesystem
Message-ID: <20090218213326.GM19814@kroah.com>
References: <20090218212144.965748151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ext4-initialize-the-new-group-descriptor-when-resizing-the-filesystem.patch"
In-Reply-To: <20090218213021.GA19814@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit fdff73f094e7220602cc3f8959c7230517976412)

Make sure all of the fields of the group descriptor are properly
initialized.  Previously, we allowed bg_flags field to be contain
random garbage, which could trigger non-deterministic behavior,
including a kernel OOPS.

http://bugzilla.kernel.org/show_bug.cgi?id=12433

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/resize.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -860,11 +860,13 @@ int ext4_group_add(struct super_block *s
 	gdp = (struct ext4_group_desc *)((char *)primary->b_data +
 					 gdb_off * EXT4_DESC_SIZE(sb));
 
+	memset(gdp, 0, EXT4_DESC_SIZE(sb));
 	ext4_block_bitmap_set(sb, gdp, input->block_bitmap); /* LV FIXME */
 	ext4_inode_bitmap_set(sb, gdp, input->inode_bitmap); /* LV FIXME */
 	ext4_inode_table_set(sb, gdp, input->inode_table); /* LV FIXME */
 	gdp->bg_free_blocks_count = cpu_to_le16(input->free_blocks_count);
 	gdp->bg_free_inodes_count = cpu_to_le16(EXT4_INODES_PER_GROUP(sb));
+	gdp->bg_flags = cpu_to_le16(EXT4_BG_INODE_ZEROED);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, input->group, gdp);
 
 	/*

