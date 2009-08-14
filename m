Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbZHNL3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbZHNL3x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 07:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbZHNL3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 07:29:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39402 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876AbZHNL3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 07:29:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NOMMU: Check fd read permission in validate_mmap_request()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Graff Yang <graff.yang@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       David Howells <dhowells@redhat.com>
Date: Fri, 14 Aug 2009 12:29:32 +0100
Message-ID: <20090814112932.16091.15120.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graff Yang <graff.yang@gmail.com>

According to the POSIX (1003.1-2008), the file descriptor shall have been
opened with read permission, regardless of the protection options specified to
mmap().  The ltp test cases mmap06/07 need this.

Signed-off-by: Graff Yang <graff.yang@gmail.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 mm/nommu.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/mm/nommu.c b/mm/nommu.c
index 1b2b59b..fd1e2b5 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -919,6 +919,10 @@ static int validate_mmap_request(struct file *file,
 		if (!file->f_op->read)
 			capabilities &= ~BDI_CAP_MAP_COPY;
 
+		/* The file shall have been opened with read permission. */
+		if (!(file->f_mode & FMODE_READ))
+			return -EACCES;
+
 		if (flags & MAP_SHARED) {
 			/* do checks for writing, appending and locking */
 			if ((prot & PROT_WRITE) &&

