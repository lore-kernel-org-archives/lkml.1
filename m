Return-Path: <linux-kernel-owner+w=401wt.eu-S934423AbXEUTcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934423AbXEUTcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765346AbXEUTVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:21:53 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46424 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765441AbXEUTVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:21:50 -0400
Message-Id: <20070521191714.047127000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:29 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>, nfs@lists.sourceforge.net
Subject: [patch 17/69] knfsd: Avoid use of unitialised variables on error path when nfs exports.
Content-Disposition: inline; filename=knfsd-avoid-use-of-unitialised-variables-on-error-path-when-nfs-exports.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: NeilBrown <neilb@suse.de>

We need to zero various parts of 'exp' before any 'goto out', otherwise
when we go to free the contents... we die.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 fs/nfsd/export.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff .prev/fs/nfsd/export.c ./fs/nfsd/export.c
--- linux-2.6.21.1.orig/fs/nfsd/export.c
+++ linux-2.6.21.1/fs/nfsd/export.c
@@ -469,6 +469,13 @@ static int svc_export_parse(struct cache
 	nd.dentry = NULL;
 	exp.ex_path = NULL;
 
+	/* fs locations */
+	exp.ex_fslocs.locations = NULL;
+	exp.ex_fslocs.locations_count = 0;
+	exp.ex_fslocs.migrated = 0;
+
+	exp.ex_uuid = NULL;
+
 	if (mesg[mlen-1] != '\n')
 		return -EINVAL;
 	mesg[mlen-1] = 0;
@@ -509,13 +516,6 @@ static int svc_export_parse(struct cache
 	if (exp.h.expiry_time == 0)
 		goto out;
 
-	/* fs locations */
-	exp.ex_fslocs.locations = NULL;
-	exp.ex_fslocs.locations_count = 0;
-	exp.ex_fslocs.migrated = 0;
-
-	exp.ex_uuid = NULL;
-
 	/* flags */
 	err = get_int(&mesg, &an_int);
 	if (err == -ENOENT)

-- 
