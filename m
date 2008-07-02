Return-Path: <linux-kernel-owner+w=401wt.eu-S932526AbYGBMDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbYGBMDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 08:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbYGBMDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 08:03:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459AbYGBMDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 08:03:32 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH] [CIFS] fix wksidarr declaration to be big-endian friendly
To: smfrench@gmail.com
Cc: shirishpargaonkar@gmail.com, linux-cifs-client@lists.samba.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 02 Jul 2008 08:03:26 -0400
Message-ID: <20080702120325.6787.84003.stgit@dantu.usersys.redhat.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current definition of wksidarr works fine on little endian arches
(since cpu_to_le32 is a no-op there), but on big-endian arches, it
fails to compile with this error:

error: braced-group within expression allowed only inside a function

...the problem is that this static declaration has cpu_to_le32 embedded
within it, and that expands into a function macro. We need to use
__constant_cpu_to_le32() instead.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---

 fs/cifs/cifsacl.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 34902cf..0e9fc2b 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -34,11 +34,11 @@
 static struct cifs_wksid wksidarr[NUM_WK_SIDS] = {
 	{{1, 0, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0} }, "null user"},
 	{{1, 1, {0, 0, 0, 0, 0, 1}, {0, 0, 0, 0, 0} }, "nobody"},
-	{{1, 1, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(11), 0, 0, 0, 0} }, "net-users"},
-	{{1, 1, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(18), 0, 0, 0, 0} }, "sys"},
-	{{1, 2, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(32), cpu_to_le32(544), 0, 0, 0} }, "root"},
-	{{1, 2, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(32), cpu_to_le32(545), 0, 0, 0} }, "users"},
-	{{1, 2, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(32), cpu_to_le32(546), 0, 0, 0} }, "guest"} }
+	{{1, 1, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(11), 0, 0, 0, 0} }, "net-users"},
+	{{1, 1, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(18), 0, 0, 0, 0} }, "sys"},
+	{{1, 2, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(32), __constant_cpu_to_le32(544), 0, 0, 0} }, "root"},
+	{{1, 2, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(32), __constant_cpu_to_le32(545), 0, 0, 0} }, "users"},
+	{{1, 2, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(32), __constant_cpu_to_le32(546), 0, 0, 0} }, "guest"} }
 ;
 
 

