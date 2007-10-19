Return-Path: <linux-kernel-owner+w=401wt.eu-S933418AbXJSOFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933418AbXJSOFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 10:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966323AbXJSOFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 10:05:03 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38548 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966292AbXJSOFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 10:05:01 -0400
Date: Fri, 19 Oct 2007 16:05:30 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Latchesar Ionkov <lucho@ionkov.net>,
       Eric Van Hensbergen <ericvh@gmail.com>
Cc: v9fs-developer@lists.sourceforge.net, rminnich@sandia.gov,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/9p/v9fs.c: memleak fix
Message-ID: <20071019140530.GF3778@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a memory leak introduced by
commit ba17674fe02909fef049fd4b620a2805bdb8c693.

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- linux-2.6/fs/9p/v9fs.c.old	2007-10-19 15:56:06.000000000 +0200
+++ linux-2.6/fs/9p/v9fs.c	2007-10-19 15:57:00.000000000 +0200
@@ -152,26 +152,27 @@ static void v9fs_parse_options(struct v9
 		case Opt_access:
 			s = match_strdup(&args[0]);
 			v9ses->flags &= ~V9FS_ACCESS_MASK;
 			if (strcmp(s, "user") == 0)
 				v9ses->flags |= V9FS_ACCESS_USER;
 			else if (strcmp(s, "any") == 0)
 				v9ses->flags |= V9FS_ACCESS_ANY;
 			else {
 				v9ses->flags |= V9FS_ACCESS_SINGLE;
 				v9ses->uid = simple_strtol(s, &e, 10);
 				if (*e != '\0')
 					v9ses->uid = ~0;
 			}
+			kfree(s);
 			break;
 
 		default:
 			continue;
 		}
 	}
 }
 
 /**
  * v9fs_session_init - initialize session
  * @v9ses: session information structure
  * @dev_name: device being mounted
  * @data: options

