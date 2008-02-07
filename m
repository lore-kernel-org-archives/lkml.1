Return-Path: <linux-kernel-owner+w=401wt.eu-S932615AbYBGOhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615AbYBGOhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 09:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbYBGOhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 09:37:23 -0500
Received: from styx.suse.cz ([82.119.242.94]:43911 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753008AbYBGOhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 09:37:22 -0500
Date: Thu, 7 Feb 2008 15:37:21 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Michael Tokarev <mjt@tls.msk.ru>
Subject: [PATCH] quota: Turn quotas off when remounting read-only
Message-ID: <20080207143721.GH6140@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn off quotas before filesystem is remounted read only. Otherwise quota will
try to write to read-only filesystem which does no good... We could also just
refuse to remount ro when quota is enabled but turning quota off is consistent
with what we do on umount.

Signed-off-by: Jan Kara <jack@suse.cz>
---
Andrew, this should fix the hang reported... Please apply. Thanks.

diff --git a/fs/super.c b/fs/super.c
index ceaf2e3..945c322 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -603,6 +603,7 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 			mark_files_ro(sb);
 		else if (!fs_may_remount_ro(sb))
 			return -EBUSY;
+		DQUOT_OFF(sb);
 	}
 
 	if (sb->s_op->remount_fs) {
