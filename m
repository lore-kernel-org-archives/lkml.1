Return-Path: <linux-kernel-owner+w=401wt.eu-S935193AbZDJFgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935193AbZDJFgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 01:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757882AbZDJFd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 01:33:28 -0400
Received: from sh.osrg.net ([192.16.179.4]:58973 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759586AbZDJFdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 01:33:17 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 5/8] nilfs2: simplify handling of active state of segments fix
Date: Fri, 10 Apr 2009 14:27:58 +0900
Message-Id: <1239341281-20249-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1239341281-20249-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1239341281-20249-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 10 Apr 2009 14:33:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a bug of ("nilfs2: simplify handling of active state of
segments") patch.  The patch did not take account that a base index is
increased in nilfs_sufile_get_suinfo() function if requested entries
go across block boundary on sufile.

Due to this bug, the active flag sometimes appears on wrong segments
and has induced malfunction of garbage collection.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/sufile.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index c774cf3..1ef2b4d 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -625,7 +625,7 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum,
 			si[i + j].sui_nblocks = le32_to_cpu(su->su_nblocks);
 			si[i + j].sui_flags = le32_to_cpu(su->su_flags) &
 				~(1UL << NILFS_SEGMENT_USAGE_ACTIVE);
-			if (nilfs_segment_is_active(nilfs, segnum + i + j))
+			if (nilfs_segment_is_active(nilfs, segnum + j))
 				si[i + j].sui_flags |=
 					(1UL << NILFS_SEGMENT_USAGE_ACTIVE);
 		}
-- 
1.5.6.5

