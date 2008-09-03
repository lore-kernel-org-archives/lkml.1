Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYICJop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYICJop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 05:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYICJog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 05:44:36 -0400
Received: from smtp.nokia.com ([192.100.122.233]:35097 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbYICJof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 05:44:35 -0400
Subject: Re: [PATCH] UBIFS: fill f_fsid
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
In-Reply-To: <1220262187.2982.58.camel@pmac.infradead.org>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
	 <1220194366-12731-13-git-send-email-dedekind@infradead.org>
	 <1220262187.2982.58.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Wed, 03 Sep 2008 12:44:33 +0300
Message-Id: <1220435073.4036.41.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2008 09:44:04.0159 (UTC) FILETIME=[9A078CF0:01C90DA9]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-01 at 10:43 +0100, David Woodhouse wrote:
> For btrfs I xor the first 64 bits with the second 64 bits, and put
> _that_ into f_fsid. You're just putting the first 64 bits in and
> ignoring the second 64 bits. Neither is really _better_ than the other;
> you just alter the circumstances in which you get collisions. But I
> suppose we might as well be consistent about how we do it?
Like this?

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Wed, 3 Sep 2008 14:16:42 +0300
Subject: [PATCH] UBIFS: amend f_fsid

David Woodhouse suggested to be consistent with other FSes
and xor the beginning and the end of the UUID.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/super.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index ab9b5cb..83fe0a5 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -370,6 +370,7 @@ static int ubifs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct ubifs_info *c = dentry->d_sb->s_fs_info;
 	unsigned long long free;
+	__le32 *uuid = (__le32 *)c->uuid;
 
 	free = ubifs_get_free_space(c);
 	dbg_gen("free space %lld bytes (%lld blocks)",
@@ -386,8 +387,8 @@ static int ubifs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_files = 0;
 	buf->f_ffree = 0;
 	buf->f_namelen = UBIFS_MAX_NLEN;
-	memcpy(&buf->f_fsid, c->uuid, sizeof(__kernel_fsid_t));
-
+	buf->f_fsid.val[0] = le32_to_cpu(uuid[0]) ^ le32_to_cpu(uuid[2]);
+	buf->f_fsid.val[1] = le32_to_cpu(uuid[1]) ^ le32_to_cpu(uuid[3]);
 	return 0;
 }
 
-- 
1.5.4.1


