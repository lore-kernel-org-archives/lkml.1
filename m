Return-Path: <linux-kernel-owner+w=401wt.eu-S1761851AbXHNPT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761851AbXHNPT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 11:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbXHNPTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 11:19:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755564AbXHNPTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 11:19:15 -0400
Date: Tue, 14 Aug 2007 11:22:56 -0400
From: Josef Bacik <jbacik@redhat.com>
To: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix panic in jbd by adding locks
Message-ID: <20070814152255.GB24127@dhcp-243-37.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

It is possible to panic the box by a race condition that exists in the
journalling code where we do not take the j_revoke_lock when traversing the
journal's revoked record list.  This patch has been tested and we haven't seen
the issue yet, its a rather straightforward and correct (at least I think so :)
fix.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>


diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index 62e13c8..317f598 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -518,6 +518,7 @@ void journal_write_revoke_records(journal_t *journal,
 	for (i = 0; i < revoke->hash_size; i++) {
 		hash_list = &revoke->hash_table[i];
 
+		spin_lock(&journal->j_revoke_lock);
 		while (!list_empty(hash_list)) {
 			record = (struct jbd_revoke_record_s *)
 				hash_list->next;
@@ -528,6 +529,7 @@ void journal_write_revoke_records(journal_t *journal,
 			list_del(&record->hash);
 			kmem_cache_free(revoke_record_cache, record);
 		}
+		spin_unlock(&journal->j_revoke_lock);
 	}
 	if (descriptor)
 		flush_descriptor(journal, descriptor, offset);
@@ -694,10 +696,12 @@ void journal_clear_revoke(journal_t *journal)
 
 	for (i = 0; i < revoke->hash_size; i++) {
 		hash_list = &revoke->hash_table[i];
+		spin_lock(&journal->j_revoke_lock);
 		while (!list_empty(hash_list)) {
 			record = (struct jbd_revoke_record_s*) hash_list->next;
 			list_del(&record->hash);
 			kmem_cache_free(revoke_record_cache, record);
 		}
+		spin_unlock(&journal->j_revoke_lock);
 	}
 }
