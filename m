Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbZL2UuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbZL2UuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 15:50:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbZL2UuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 15:50:16 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53759 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbZL2UuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 15:50:15 -0500
Date: Tue, 29 Dec 2009 14:50:19 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Mike Kazantsev <mk.fraggod@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH] generic_permission: MAY_OPEN is not write access
Message-ID: <20091229205019.GA18257@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

generic_permission was refusing CAP_DAC_READ_SEARCH-enabled
processes from opening DAC-protected files read-only, because
do_filp_open adds MAY_OPEN to the open mask.

Ignore MAY_OPEN.  After this patch, CAP_DAC_READ_SEARCH is
again sufficient to open(fname, O_RDONLY) on a file to which
DAC otherwise refuses us read permission.

Reported-by: Mike Kazantsev <mk.fraggod@gmail.com>
Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Mike Kazantsev <mk.fraggod@gmail.com>
---
 fs/namei.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 68921d9..b55440b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -232,6 +232,7 @@ int generic_permission(struct inode *inode, int mask,
 	/*
 	 * Searching includes executable on directories, else just read.
 	 */
+	mask &= MAY_READ | MAY_WRITE | MAY_EXEC;
 	if (mask == MAY_READ || (S_ISDIR(inode->i_mode) && !(mask & MAY_WRITE)))
 		if (capable(CAP_DAC_READ_SEARCH))
 			return 0;
-- 
1.6.0.4

