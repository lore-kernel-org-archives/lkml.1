Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbZLKF3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbZLKF3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbZLKF3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:29:49 -0500
Received: from kroah.org ([198.145.64.141]:53453 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbZLKF3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:29:43 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 21:25:43 2009
Message-Id: <20091211052543.277851362@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 21:23:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [06/34] ext4: avoid divide by zero when trying to mount a corrupted file system
References: <20091211052312.805428372@linux.site>
Content-Disposition: inline; filename=0002-ext4-avoid-divide-by-zero-when-trying-to-mount-a-cor.patch
In-Reply-To: <20091211052858.GA23229@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

(cherry picked from commit 503358ae01b70ce6909d19dd01287093f6b6271c)

If s_log_groups_per_flex is greater than 31, then groups_per_flex will
will overflow and cause a divide by zero error.  This can cause kernel
BUG if such a file system is mounted.

Thanks to Nageswara R Sastry for analyzing the failure and providing
an initial patch.

http://bugzilla.kernel.org/show_bug.cgi?id=14287

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/super.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1673,14 +1673,14 @@ static int ext4_fill_flex_info(struct su
 	size_t size;
 	int i;
 
-	if (!sbi->s_es->s_log_groups_per_flex) {
+	sbi->s_log_groups_per_flex = sbi->s_es->s_log_groups_per_flex;
+	groups_per_flex = 1 << sbi->s_log_groups_per_flex;
+
+	if (groups_per_flex < 2) {
 		sbi->s_log_groups_per_flex = 0;
 		return 1;
 	}
 
-	sbi->s_log_groups_per_flex = sbi->s_es->s_log_groups_per_flex;
-	groups_per_flex = 1 << sbi->s_log_groups_per_flex;
-
 	/* We allocate both existing and potentially added groups */
 	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
 			((le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks) + 1) <<


