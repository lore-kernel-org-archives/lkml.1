Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbZCIJNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbZCIJNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 05:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbZCIJNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 05:13:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61317 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbZCIJND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 05:13:03 -0400
Message-ID: <49B4DD9C.5030902@cn.fujitsu.com>
Date: Mon, 09 Mar 2009 17:13:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: fix memory leak in bio_clone()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If bio_integrity_clone() fails, bio_clone() returns NULL without freeing
the newly allocated bio.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/bio.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 124b95c..896330e 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -465,8 +465,10 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
 
 		ret = bio_integrity_clone(b, bio, fs_bio_set);
 
-		if (ret < 0)
+		if (ret < 0) {
+			bio_put(bio);
 			return NULL;
+		}
 	}
 
 	return b;
-- 1.5.4.rc3 
