Return-Path: <linux-kernel-owner+w=401wt.eu-S1765245AbZCaXgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765245AbZCaXgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763760AbZCaXWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:22:11 -0400
Received: from sous-sol.org ([216.99.217.87]:33314 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762687AbZCaXWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:22:09 -0400
Message-Id: <20090331231713.224492566@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:19 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, Dan Carpenter <error27@gmail.com>,
       Miklos Szeredi <mszeredi@suse.cz>
Subject: [patch 34/45] fuse: fix fuse_file_lseek returning with lock held
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=fuse-fix-fuse_file_lseek-returning-with-lock-held.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Dan Carpenter <error27@gmail.com>

upstream commit: 5291658d87ac1ae60418e79e7b6bad7d5f595e0c

This bug was found with smatch (http://repo.or.cz/w/smatch.git/).  If
we return directly the inode->i_mutex lock doesn't get released.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: stable@kernel.org
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/fuse/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1465,7 +1465,7 @@ static loff_t fuse_file_llseek(struct fi
 	case SEEK_END:
 		retval = fuse_update_attributes(inode, NULL, file, NULL);
 		if (retval)
-			return retval;
+			goto exit;
 		offset += i_size_read(inode);
 		break;
 	case SEEK_CUR:
@@ -1479,6 +1479,7 @@ static loff_t fuse_file_llseek(struct fi
 		}
 		retval = offset;
 	}
+exit:
 	mutex_unlock(&inode->i_mutex);
 	return retval;
 }

