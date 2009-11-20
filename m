Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbZKTVyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbZKTVyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbZKTVyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:54:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755657AbZKTVym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:54:42 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/3] SLOW_WORK: Fix CIFS to pass THIS_MODULE to
	slow_work_register_user()
To: wilhelm.meier@fh-kl.de, linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Fri, 20 Nov 2009 21:54:42 +0000
Message-ID: <20091120215442.15448.62117.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091120215437.15448.26909.stgit@warthog.procyon.org.uk>
References: <20091120215437.15448.26909.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of the patch:

	SLOW_WORK: Wait for outstanding work items belonging to a module to clear

	Wait for outstanding slow work items belonging to a module to clear
	when unregistering that module as a user of the facility.  This
	prevents the put_ref code of a work item from being taken away before
	it returns.

slow_work_register_user() takes a module pointer as an argument.  CIFS must now
pass THIS_MODULE as that argument, lest the following error be observed:

	fs/cifs/cifsfs.c: In function 'init_cifs':
	fs/cifs/cifsfs.c:1040: error: too few arguments to function 'slow_work_register_user'

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cifs/cifsfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 9a5e4f5..29f1da7 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1037,7 +1037,7 @@ init_cifs(void)
 	if (rc)
 		goto out_unregister_key_type;
 #endif
-	rc = slow_work_register_user();
+	rc = slow_work_register_user(THIS_MODULE);
 	if (rc)
 		goto out_unregister_resolver_key;
 

