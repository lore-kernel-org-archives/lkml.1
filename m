Return-Path: <linux-kernel-owner+w=401wt.eu-S934296AbZJNW1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934296AbZJNW1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934247AbZJNW07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:26:59 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:44961 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933082AbZJNW0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:26:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Sne4ixnf2aeDBh+pZGMZ/bBGPHxdnS1aMieXjI1yduHr5SjIFaxCChitULFvpCQSEh
         laIGKClsaIfrBYYgMmK9sFrBTuLdlMb573U9DabvvINgxY07GIsWB1RJpQ6x1IW3DNrZ
         9iyf1TaAk71Q7ShETW5R/M5b5yxEpfDc1RVlA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
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
       Laurent Riffard <laurent.riffard@free.fr>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/3] kill-the-bkl/reiserfs: drop the fs race watchdog from _get_block_create_0()
Date: Thu, 15 Oct 2009 00:26:07 +0200
Message-Id: <1255559167-5554-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1255559167-5554-1-git-send-email-fweisbec@gmail.com>
References: <1255559167-5554-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had a watchdog in _get_block_create_0() that jumped to a fixup retry
path in case the bkl got relaxed while calling kmap().
This is not necessary anymore since we now have a reiserfs lock that is
not implicitly relaxed while sleeping.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Laurent Riffard <laurent.riffard@free.fr>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 fs/reiserfs/inode.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 965c8ea..0d493a3 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -251,7 +251,6 @@ static int _get_block_create_0(struct inode *inode, sector_t block,
 	struct cpu_key key;
 	struct buffer_head *bh;
 	struct item_head *ih, tmp_ih;
-	int fs_gen;
 	b_blocknr_t blocknr;
 	char *p = NULL;
 	int chars;
@@ -265,7 +264,6 @@ static int _get_block_create_0(struct inode *inode, sector_t block,
 		     (loff_t) block * inode->i_sb->s_blocksize + 1, TYPE_ANY,
 		     3);
 
-      research:
 	result = search_for_position_by_key(inode->i_sb, &key, &path);
 	if (result != POSITION_FOUND) {
 		pathrelse(&path);
@@ -340,7 +338,6 @@ static int _get_block_create_0(struct inode *inode, sector_t block,
 	}
 	// read file tail into part of page
 	offset = (cpu_key_k_offset(&key) - 1) & (PAGE_CACHE_SIZE - 1);
-	fs_gen = get_generation(inode->i_sb);
 	copy_item_head(&tmp_ih, ih);
 
 	/* we only want to kmap if we are reading the tail into the page.
@@ -348,13 +345,9 @@ static int _get_block_create_0(struct inode *inode, sector_t block,
 	 ** sure we need to.  But, this means the item might move if
 	 ** kmap schedules
 	 */
-	if (!p) {
+	if (!p)
 		p = (char *)kmap(bh_result->b_page);
-		if (fs_changed(fs_gen, inode->i_sb)
-		    && item_moved(&tmp_ih, &path)) {
-			goto research;
-		}
-	}
+
 	p += offset;
 	memset(p, 0, inode->i_sb->s_blocksize);
 	do {
-- 
1.6.2.3

