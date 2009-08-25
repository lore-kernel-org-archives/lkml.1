Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbZHYCdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbZHYCdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 22:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbZHYCdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 22:33:05 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41395 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbZHYCdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 22:33:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mrF0hJV2q914jcwF9Z3MMtgf9Jk94kF2lJZNxS6TW6FcRYojVklReS5hoR2P9zCLgX
         nwxb8DB+jKPoDYULK6A4DyQhRMDNZ9zbWD3lDwJE4YFzqSh8l2X49e4Vza4dhWeCJWTM
         ovaCG8bJ0jaqZ4kyYYDaOzCIxDbkbtbn8WeeE=
From: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Jeff Mahoney <jeffm@suse.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Bron Gondwana <brong@fastmail.fm>,
       Reiserfs <reiserfs-devel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrea Gelmini <andrea.gelmini@gmail.com>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Thomas Meyer <thomas@m3y3r.de>,
       Alessio Igor Bogani <abogani@texware.it>,
       Marcel Hilzinger <mhilzinger@linuxnewmedia.de>,
       Edward Shishkin <edward.shishkin@gmail.com>,
       Laurent Riffard <laurent.riffard@free.fr>
Subject: [PATCH 4/4] kill-the-bkl/reiserfs: panic in case of lock imbalance
Date: Tue, 25 Aug 2009 04:32:50 +0200
Message-Id: <1251167570-5233-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251167570-5233-1-git-send-email-fweisbec@gmail.com>
References: <1251167570-5233-1-git-send-email-fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now, trying to unlock the reiserfs write lock whereas the current
task doesn't hold it lead to a simple warning.
We should actually warn and panic in this case to avoid the user datas
to reach an unstable state.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Laurent Riffard <laurent.riffard@free.fr>
---
 fs/reiserfs/lock.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/reiserfs/lock.c b/fs/reiserfs/lock.c
index cb1bba3..ee2cfc0 100644
--- a/fs/reiserfs/lock.c
+++ b/fs/reiserfs/lock.c
@@ -37,11 +37,10 @@ void reiserfs_write_unlock(struct super_block *s)
 
 	/*
 	 * Are we unlocking without even holding the lock?
-	 * Such a situation could even raise a BUG() if we don't
-	 * want the data become corrupted
+	 * Such a situation must raise a BUG() if we don't want
+	 * to corrupt the data.
 	 */
-	WARN_ONCE(sb_i->lock_owner != current,
-		  "Superblock write lock imbalance");
+	BUG_ON(sb_i->lock_owner != current);
 
 	if (--sb_i->lock_depth == -1) {
 		sb_i->lock_owner = NULL;
-- 
1.6.2.3

