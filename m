Return-Path: <linux-kernel-owner+w=401wt.eu-S1759036AbZBDSnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036AbZBDSnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758379AbZBDShV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:37:21 -0500
Received: from kroah.org ([198.145.64.141]:51073 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758509AbZBDShP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:37:15 -0500
Date: Wed, 4 Feb 2009 10:34:52 -0800
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
       "J. Bruce Fields" <bfields@pig.fieldses.org>
Subject: [patch 18/33] nfsd: only set file_lock.fl_lmops in nfsd4_lockt if
	a stateowner is found
Message-ID: <20090204183452.GS13936@kroah.com>
References: <20090204182823.831027530@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nfsd-only-set-file_lock.fl_lmops-in-nfsd4_lockt-if-a-stateowner-is-found.patch"
In-Reply-To: <20090204183403.GA13936@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit fa82a491275a613b15489aab4b99acecb00958d3 upstream.

nfsd4_lockt does a search for a lockstateowner when building the lock
struct to test. If one is found, it'll set fl_owner to it. Regardless of
whether that happens, it'll also set fl_lmops. Given that this lock is
basically a "lightweight" lock that's just used for checking conflicts,
setting fl_lmops is probably not appropriate for it.

This behavior exposed a bug in DLM's GETLK implementation where it
wasn't clearing out the fields in the file_lock before filling in
conflicting lock info. While we were able to fix this in DLM, it
still seems pointless and dangerous to set the fl_lmops this way
when we may have a NULL lockstateowner.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@pig.fieldses.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4state.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2824,7 +2824,6 @@ nfsd4_lockt(struct svc_rqst *rqstp, stru
 		file_lock.fl_owner = (fl_owner_t)lockt->lt_stateowner;
 	file_lock.fl_pid = current->tgid;
 	file_lock.fl_flags = FL_POSIX;
-	file_lock.fl_lmops = &nfsd_posix_mng_ops;
 
 	file_lock.fl_start = lockt->lt_offset;
 	if ((lockt->lt_length == ~(u64)0) || LOFF_OVERFLOW(lockt->lt_offset, lockt->lt_length))

