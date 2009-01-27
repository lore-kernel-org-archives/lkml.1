Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbZA0X0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbZA0X0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZA0X0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:26:15 -0500
Received: from mail.fieldses.org ([141.211.133.115]:49143 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbZA0X0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:26:14 -0500
Date: Tue, 27 Jan 2009 18:26:14 -0500
To: stable@kernel.org
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>, Marc Eshel <eshel@almaden.ibm.com>
Subject: [PATCH] nfsd: only set file_lock.fl_lmops in nfsd4_lockt if a
	stateowner is found
Message-ID: <20090127232614.GB15170@fieldses.org>
References: <20090127232058.GC13854@fieldses.org> <20090127232304.GD13854@fieldses.org> <20090127232536.GA15170@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127232536.GA15170@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

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
---
 fs/nfsd/nfs4state.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 88db7d3..b6f60f4 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2871,7 +2871,6 @@ nfsd4_lockt(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		file_lock.fl_owner = (fl_owner_t)lockt->lt_stateowner;
 	file_lock.fl_pid = current->tgid;
 	file_lock.fl_flags = FL_POSIX;
-	file_lock.fl_lmops = &nfsd_posix_mng_ops;
 
 	file_lock.fl_start = lockt->lt_offset;
 	file_lock.fl_end = last_byte_offset(lockt->lt_offset, lockt->lt_length);
-- 
1.5.6.3

