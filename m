Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbZBJJdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbZBJJdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 04:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbZBJJdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 04:33:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50303 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbZBJJdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 04:33:24 -0500
Message-ID: <499149C4.2040606@cn.fujitsu.com>
Date: Tue, 10 Feb 2009 17:32:52 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] vfs: add missing unlock in sget()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In sget(), destroy_super(s) is called with s->s_umount held, which makes
lockdep unhappy.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/super.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 61dce00..f849485 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -356,8 +356,10 @@ retry:
 				continue;
 			if (!grab_super(old))
 				goto retry;
-			if (s)
+			if (s) {
+				up_write(&s->s_umount);
 				destroy_super(s);
+			}
 			return old;
 		}
 	}
@@ -372,6 +374,7 @@ retry:
 	err = set(s, data);
 	if (err) {
 		spin_unlock(&sb_lock);
+		up_write(&s->s_umount);
 		destroy_super(s);
 		return ERR_PTR(err);
 	}
-- 
1.5.4.rc3

