Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbZKSRWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbZKSRWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:22:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbZKSRWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:22:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753757AbZKSRWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:22:05 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 17/28] FS-Cache: Handle read request vs lookup,
	creation or other cache failure
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:22:01 +0000
Message-ID: <20091119172201.1679.93739.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FS-Cache doesn't correctly handle the netfs requesting a read from the cache
on an object that failed or was withdrawn by the cache.  A trace similar to
the following might be seen:

	CacheFiles: Lookup failed error -105
	[exe   ] unexpected submission OP165afe [OBJ6cac OBJECT_LC_DYING]
	[exe   ] objstate=OBJECT_LC_DYING [OBJECT_LC_DYING]
	[exe   ] objflags=0
	[exe   ] objevent=9 [fffffffffffffffb]
	[exe   ] ops=0 inp=0 exc=0
	Pid: 6970, comm: exe Not tainted 2.6.32-rc6-cachefs #50
	Call Trace:
	 [<ffffffffa0076477>] fscache_submit_op+0x3ff/0x45a [fscache]
	 [<ffffffffa0077997>] __fscache_read_or_alloc_pages+0x187/0x3c4 [fscache]
	 [<ffffffffa00b6480>] ? nfs_readpage_from_fscache_complete+0x0/0x66 [nfs]
	 [<ffffffffa00b6388>] __nfs_readpages_from_fscache+0x7e/0x176 [nfs]
	 [<ffffffff8108e483>] ? __alloc_pages_nodemask+0x11c/0x5cf
	 [<ffffffffa009d796>] nfs_readpages+0x114/0x1d7 [nfs]
	 [<ffffffff81090314>] __do_page_cache_readahead+0x15f/0x1ec
	 [<ffffffff81090228>] ? __do_page_cache_readahead+0x73/0x1ec
	 [<ffffffff810903bd>] ra_submit+0x1c/0x20
	 [<ffffffff810906bb>] ondemand_readahead+0x227/0x23a
	 [<ffffffff81090762>] page_cache_sync_readahead+0x17/0x19
	 [<ffffffff8108a99e>] generic_file_aio_read+0x236/0x5a0
	 [<ffffffffa00937bd>] nfs_file_read+0xe4/0xf3 [nfs]
	 [<ffffffff810b2fa2>] do_sync_read+0xe3/0x120
	 [<ffffffff81354cc3>] ? _spin_unlock_irq+0x2b/0x31
	 [<ffffffff8104c0f1>] ? autoremove_wake_function+0x0/0x34
	 [<ffffffff811848e5>] ? selinux_file_permission+0x5d/0x10f
	 [<ffffffff81352bdb>] ? thread_return+0x3e/0x101
	 [<ffffffff8117d7b0>] ? security_file_permission+0x11/0x13
	 [<ffffffff810b3b06>] vfs_read+0xaa/0x16f
	 [<ffffffff81058df0>] ? trace_hardirqs_on_caller+0x10c/0x130
	 [<ffffffff810b3c84>] sys_read+0x45/0x6c
	 [<ffffffff8100ae2b>] system_call_fastpath+0x16/0x1b

The object state might also be OBJECT_DYING or OBJECT_WITHDRAWING.

This should be handled by simply rejecting the new operation with ENOBUFS.
There's no need to log an error for it.  Events of this type now appear in the
stats file under Ops:rej.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/caching/fscache.txt |    1 +
 fs/fscache/internal.h                         |    1 +
 fs/fscache/operation.c                        |    5 +++++
 fs/fscache/stats.c                            |    6 ++++--
 4 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/caching/fscache.txt b/Documentation/filesystems/caching/fscache.txt
index cd2b4c9..8889d6a 100644
--- a/Documentation/filesystems/caching/fscache.txt
+++ b/Documentation/filesystems/caching/fscache.txt
@@ -276,6 +276,7 @@ proc files.
 		run=N	Number of times async ops given CPU time
 		enq=N	Number of times async ops queued for processing
 		can=N	Number of async ops cancelled
+		rej=N	Number of async ops rejected due to object lookup/create failure
 		dfr=N	Number of async ops queued for deferred release
 		rel=N	Number of async ops released
 		gc=N	Number of deferred-release async ops garbage collected
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index ba1853f..a076987 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -143,6 +143,7 @@ extern atomic_t fscache_n_op_deferred_release;
 extern atomic_t fscache_n_op_release;
 extern atomic_t fscache_n_op_gc;
 extern atomic_t fscache_n_op_cancelled;
+extern atomic_t fscache_n_op_rejected;
 
 extern atomic_t fscache_n_attr_changed;
 extern atomic_t fscache_n_attr_changed_ok;
diff --git a/fs/fscache/operation.c b/fs/fscache/operation.c
index 296492e..313e79a 100644
--- a/fs/fscache/operation.c
+++ b/fs/fscache/operation.c
@@ -232,6 +232,11 @@ int fscache_submit_op(struct fscache_object *object,
 		list_add_tail(&op->pend_link, &object->pending_ops);
 		fscache_stat(&fscache_n_op_pend);
 		ret = 0;
+	} else if (object->state == FSCACHE_OBJECT_DYING ||
+		   object->state == FSCACHE_OBJECT_LC_DYING ||
+		   object->state == FSCACHE_OBJECT_WITHDRAWING) {
+		fscache_stat(&fscache_n_op_rejected);
+		ret = -ENOBUFS;
 	} else if (!test_bit(FSCACHE_IOERROR, &object->cache->flags)) {
 		fscache_report_unexpected_submission(object, op, ostate);
 		ASSERT(!fscache_object_is_active(object));
diff --git a/fs/fscache/stats.c b/fs/fscache/stats.c
index 1d53ea6..045ba39 100644
--- a/fs/fscache/stats.c
+++ b/fs/fscache/stats.c
@@ -26,6 +26,7 @@ atomic_t fscache_n_op_deferred_release;
 atomic_t fscache_n_op_release;
 atomic_t fscache_n_op_gc;
 atomic_t fscache_n_op_cancelled;
+atomic_t fscache_n_op_rejected;
 
 atomic_t fscache_n_attr_changed;
 atomic_t fscache_n_attr_changed_ok;
@@ -210,11 +211,12 @@ static int fscache_stats_show(struct seq_file *m, void *v)
 		   atomic_read(&fscache_n_store_radix_deletes),
 		   atomic_read(&fscache_n_store_pages_over_limit));
 
-	seq_printf(m, "Ops    : pend=%u run=%u enq=%u can=%u\n",
+	seq_printf(m, "Ops    : pend=%u run=%u enq=%u can=%u rej=%u\n",
 		   atomic_read(&fscache_n_op_pend),
 		   atomic_read(&fscache_n_op_run),
 		   atomic_read(&fscache_n_op_enqueue),
-		   atomic_read(&fscache_n_op_cancelled));
+		   atomic_read(&fscache_n_op_cancelled),
+		   atomic_read(&fscache_n_op_rejected));
 	seq_printf(m, "Ops    : dfr=%u rel=%u gc=%u\n",
 		   atomic_read(&fscache_n_op_deferred_release),
 		   atomic_read(&fscache_n_op_release),

