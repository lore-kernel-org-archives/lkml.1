Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117Ab0AETWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab0AETWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214Ab0AETWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:22:12 -0500
Received: from kroah.org ([198.145.64.141]:55827 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349Ab0AETWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:22:09 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Serge E. Hallyn" <serue@us.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 100/101] generic_permission: MAY_OPEN is not write access
Date: Tue,  5 Jan 2010 11:21:28 -0800
Message-Id: <1262719290-310-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262719290-310-2-git-send-email-gregkh@suse.de>
References: <20100105192014.GA23628@kroah.com>
 <1262719290-310-1-git-send-email-gregkh@suse.de>
 <1262719290-310-2-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serue@us.ibm.com>

commit 7ea6600148c265b1fd53e521022b1d7aec81d974 upstream.

generic_permission was refusing CAP_DAC_READ_SEARCH-enabled
processes from opening DAC-protected files read-only, because
do_filp_open adds MAY_OPEN to the open mask.

Ignore MAY_OPEN.  After this patch, CAP_DAC_READ_SEARCH is
again sufficient to open(fname, O_RDONLY) on a file to which
DAC otherwise refuses us read permission.

Reported-by: Mike Kazantsev <mk.fraggod@gmail.com>
Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Mike Kazantsev <mk.fraggod@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/namei.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index d11f404..a2b3c28 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -234,6 +234,7 @@ int generic_permission(struct inode *inode, int mask,
 	/*
 	 * Searching includes executable on directories, else just read.
 	 */
+	mask &= MAY_READ | MAY_WRITE | MAY_EXEC;
 	if (mask == MAY_READ || (S_ISDIR(inode->i_mode) && !(mask & MAY_WRITE)))
 		if (capable(CAP_DAC_READ_SEARCH))
 			return 0;
-- 
1.6.6

