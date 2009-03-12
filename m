Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbZCLNZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbZCLNZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZCLNZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:25:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39849 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790AbZCLNZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:25:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0903102329020.8584@blonde.anvils>
References: <Pine.LNX.4.64.0903102329020.8584@blonde.anvils> <Pine.LNX.4.64.0903102105590.21727@blonde.anvils> <20090310180740.29065.10735.stgit@warthog.procyon.org.uk> <6503.1236726067@redhat.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: dhowells@redhat.com, jmalicki@metacarta.com, chrisw@sous-sol.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix check_unsafe_exec()
Date: Thu, 12 Mar 2009 13:23:41 +0000
Message-ID: <27000.1236864221@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins <hugh@veritas.com> wrote:

> We do.  See the original thread.  It's here at
> http://lkml.org/lkml/2009/2/26/233
> and appended below for convenience.  We do know that patch did not
> fix Joe's problem, and we don't yet know whether addressing the
> files->count issue will actually fix it, but I'm hopeful.

Looks reasonable.  One thing that should be added, though, is a comment in
struct fs_struct to give a warning about the consequences of incrementing the
usage count for anything other than CLONE_FS.

David
---
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Annotate struct fs_struct's usage count to indicate the restrictions upon it

Annotate struct fs_struct's usage count to indicate the restrictions upon it.
It may not be incremented, except by clone(CLONE_FS), as this affects the
check in check_unsafe_exec() in fs/exec.c.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/fs_struct.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)


diff --git a/include/linux/fs_struct.h b/include/linux/fs_struct.h
index a97c053..b12ede4 100644
--- a/include/linux/fs_struct.h
+++ b/include/linux/fs_struct.h
@@ -4,7 +4,11 @@
 #include <linux/path.h>
 
 struct fs_struct {
-	atomic_t count;
+	atomic_t count;	/* This usage count is used by check_unsafe_exec() for
+			 * security checking purposes - therefore it may not be
+			 * incremented, except by clone(CLONE_FS).
+			 */
+
 	rwlock_t lock;
 	int umask;
 	struct path root, pwd;
