Return-Path: <linux-kernel-owner+w=401wt.eu-S1752125AbZIXLdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbZIXLdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 07:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZIXLdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 07:33:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbZIXLds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 07:33:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/4] NOMMU: Ignore mmap() address param as it is a hint
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Thu, 24 Sep 2009 12:33:48 +0100
Message-ID: <20090924113348.6031.59825.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090924113332.6031.11718.stgit@warthog.procyon.org.uk>
References: <20090924113332.6031.11718.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignore the address parameter given to NOMMU mmap() as it is a hint, rather
than giving an error if it's non-zero.  MAP_FIXED still gets an error.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 mm/nommu.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/mm/nommu.c b/mm/nommu.c
index bd94b5a..62ac312 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -866,7 +866,7 @@ static int validate_mmap_request(struct file *file,
 	int ret;
 
 	/* do the simple checks first */
-	if (flags & MAP_FIXED || addr) {
+	if (flags & MAP_FIXED) {
 		printk(KERN_DEBUG
 		       "%d: Can't do fixed-address/overlay mmap of RAM\n",
 		       current->pid);
@@ -1223,9 +1223,6 @@ unsigned long do_mmap_pgoff(struct file *file,
 
 	kenter(",%lx,%lx,%lx,%lx,%lx", addr, len, prot, flags, pgoff);
 
-	if (!(flags & MAP_FIXED))
-		addr = round_hint_to_min(addr);
-
 	/* decide whether we should attempt the mapping, and if so what sort of
 	 * mapping */
 	ret = validate_mmap_request(file, addr, len, prot, flags, pgoff,
@@ -1235,6 +1232,9 @@ unsigned long do_mmap_pgoff(struct file *file,
 		return ret;
 	}
 
+	/* we ignore the address hint */
+	addr = 0;
+
 	/* we've determined that we can make the mapping, now translate what we
 	 * now know into VMA flags */
 	vm_flags = determine_vm_flags(file, prot, flags, capabilities);

