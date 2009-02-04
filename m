Return-Path: <linux-kernel-owner+w=401wt.eu-S1760718AbZBDSs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbZBDSs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758230AbZBDSho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:37:44 -0500
Received: from kroah.org ([198.145.64.141]:51241 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755574AbZBDSh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:37:29 -0500
Date: Wed, 4 Feb 2009 10:35:16 -0800
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
       alan@lxorguk.ukuu.org.uk, Jeff Layton <jlayton@redhat.com>,
       David Teigland <teigland@redhat.com>
Subject: [patch 31/33] dlm: initialize file_lock struct in GETLK before
	copying conflicting lock
Message-ID: <20090204183516.GF13936@kroah.com>
References: <20090204182823.831027530@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dlm-initialize-file_lock-struct-in-getlk-before-copying-conflicting-lock.patch"
In-Reply-To: <20090204183403.GA13936@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 20d5a39929232a715f29e6cb7e3f0d0c790f41eb upstream.

dlm_posix_get fills out the relevant fields in the file_lock before
returning when there is a lock conflict, but doesn't clean out any of
the other fields in the file_lock.

When nfsd does a NFSv4 lockt call, it sets the fl_lmops to
nfsd_posix_mng_ops before calling the lower fs. When the lock comes back
after testing a lock on GFS2, it still has that field set. This confuses
nfsd into thinking that the file_lock is a nfsd4 lock.

Fix this by making DLM reinitialize the file_lock before copying the
fields from the conflicting lock.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/dlm/plock.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -304,7 +304,9 @@ int dlm_posix_get(dlm_lockspace_t *locks
 	if (rv == -ENOENT)
 		rv = 0;
 	else if (rv > 0) {
+		locks_init_lock(fl);
 		fl->fl_type = (op->info.ex) ? F_WRLCK : F_RDLCK;
+		fl->fl_flags = FL_POSIX;
 		fl->fl_pid = op->info.pid;
 		fl->fl_start = op->info.start;
 		fl->fl_end = op->info.end;

