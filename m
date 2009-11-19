Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018AbZKSRXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbZKSRXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755013AbZKSRXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:23:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097AbZKSRXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:23:03 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 28/28] CacheFiles: Don't log lookup/create failing with ENOBUFS
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:22:57 +0000
Message-ID: <20091119172257.1679.3294.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't log the CacheFiles lookup/create object routined failing with ENOBUFS as
under high memory load or high cache load they can do this quite a lot.  This
error simply means that the requested object cannot be created on disk due to
lack of space, or due to failure of the backing filesystem to find sufficient
resources.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cachefiles/interface.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/cachefiles/interface.c b/fs/cachefiles/interface.c
index 9d3c426..2708931 100644
--- a/fs/cachefiles/interface.c
+++ b/fs/cachefiles/interface.c
@@ -147,8 +147,9 @@ static int cachefiles_lookup_object(struct fscache_object *_object)
 		cachefiles_attr_changed(&object->fscache);
 
 	if (ret < 0 && ret != -ETIMEDOUT) {
-		printk(KERN_WARNING "CacheFiles: Lookup failed error %d\n",
-		       ret);
+		if (ret != -ENOBUFS)
+			printk(KERN_WARNING
+			       "CacheFiles: Lookup failed error %d\n", ret);
 		fscache_object_lookup_error(&object->fscache);
 	}
 

