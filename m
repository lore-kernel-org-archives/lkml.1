Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbZKSRW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbZKSRW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbZKSRWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:22:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbZKSRWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:22:16 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 19/28] FS-Cache: Add a retirement stat counter
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:22:11 +0000
Message-ID: <20091119172211.1679.18799.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a stat counter to count retirement events rather than ordinary release
events (the retire argument to fscache_relinquish_cookie()).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/cookie.c   |    2 ++
 fs/fscache/internal.h |    1 +
 fs/fscache/stats.c    |    6 ++++--
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index f979659..9905350 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -415,6 +415,8 @@ void __fscache_relinquish_cookie(struct fscache_cookie *cookie, int retire)
 	unsigned long event;
 
 	fscache_stat(&fscache_n_relinquishes);
+	if (retire)
+		fscache_stat(&fscache_n_relinquishes_retire);
 
 	if (!cookie) {
 		fscache_stat(&fscache_n_relinquishes_null);
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index e504651..2bf463d 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -202,6 +202,7 @@ extern atomic_t fscache_n_updates_run;
 extern atomic_t fscache_n_relinquishes;
 extern atomic_t fscache_n_relinquishes_null;
 extern atomic_t fscache_n_relinquishes_waitcrt;
+extern atomic_t fscache_n_relinquishes_retire;
 
 extern atomic_t fscache_n_cookie_index;
 extern atomic_t fscache_n_cookie_data;
diff --git a/fs/fscache/stats.c b/fs/fscache/stats.c
index cda6999..9e15289 100644
--- a/fs/fscache/stats.c
+++ b/fs/fscache/stats.c
@@ -85,6 +85,7 @@ atomic_t fscache_n_updates_run;
 atomic_t fscache_n_relinquishes;
 atomic_t fscache_n_relinquishes_null;
 atomic_t fscache_n_relinquishes_waitcrt;
+atomic_t fscache_n_relinquishes_retire;
 
 atomic_t fscache_n_cookie_index;
 atomic_t fscache_n_cookie_data;
@@ -168,10 +169,11 @@ static int fscache_stats_show(struct seq_file *m, void *v)
 		   atomic_read(&fscache_n_updates_null),
 		   atomic_read(&fscache_n_updates_run));
 
-	seq_printf(m, "Relinqs: n=%u nul=%u wcr=%u\n",
+	seq_printf(m, "Relinqs: n=%u nul=%u wcr=%u rtr=%u\n",
 		   atomic_read(&fscache_n_relinquishes),
 		   atomic_read(&fscache_n_relinquishes_null),
-		   atomic_read(&fscache_n_relinquishes_waitcrt));
+		   atomic_read(&fscache_n_relinquishes_waitcrt),
+		   atomic_read(&fscache_n_relinquishes_retire));
 
 	seq_printf(m, "AttrChg: n=%u ok=%u nbf=%u oom=%u run=%u\n",
 		   atomic_read(&fscache_n_attr_changed),

