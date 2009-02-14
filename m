Return-Path: <linux-kernel-owner+w=401wt.eu-S1765599AbZBNBeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765599AbZBNBeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764109AbZBNBQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:21 -0500
Received: from kroah.org ([198.145.64.141]:50311 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763351AbZBNBQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:14 -0500
Date: Fri, 13 Feb 2009 17:12:51 -0800
From: Greg KH <gregkh@suse.de>
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
       alan@lxorguk.ukuu.org.uk, Miklos Szeredi <mszeredi@suse.cz>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [patch 15/48] lockd: fix regression in lockds handling of blocked
	locks
Message-ID: <20090214011251.GP17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="lockd-fix-regression-in-lockd-s-handling-of-blocked-locks.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: J. Bruce Fields <bfields@citi.umich.edu>

commit 9d9b87c1218be78ddecbc85ec3bb91c79c1d56ab upstream.

If a client requests a blocking lock, is denied, then requests it again,
then here in nlmsvc_lock() we will call vfs_lock_file() without FL_SLEEP
set, because we've already queued a block and don't need the locks code
to do it again.

But that means vfs_lock_file() will return -EAGAIN instead of
FILE_LOCK_DENIED.  So we still need to translate that -EAGAIN return
into a nlm_lck_blocked error in this case, and put ourselves back on
lockd's block list.

The bug was introduced by bde74e4bc64415b1 "locks: add special return
value for asynchronous locks".

Thanks to Frank van Maarseveen for the report; his original test
case was essentially

	for i in `seq 30`; do flock /nfsmount/foo sleep 10 & done

Tested-by: Frank van Maarseveen <frankvm@frankvm.com>
Reported-by: Frank van Maarseveen <frankvm@frankvm.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/lockd/svclock.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -427,7 +427,7 @@ nlmsvc_lock(struct svc_rqst *rqstp, stru
 			goto out;
 		case -EAGAIN:
 			ret = nlm_lck_denied;
-			goto out;
+			break;
 		case FILE_LOCK_DEFERRED:
 			if (wait)
 				break;
@@ -443,6 +443,10 @@ nlmsvc_lock(struct svc_rqst *rqstp, stru
 			goto out;
 	}
 
+	ret = nlm_lck_denied;
+	if (!wait)
+		goto out;
+
 	ret = nlm_lck_blocked;
 
 	/* Append to list of blocked */

